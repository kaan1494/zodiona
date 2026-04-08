from __future__ import annotations

import json
import math
import os
from datetime import datetime
from typing import Optional
from zoneinfo import ZoneInfo

import firebase_admin
from firebase_admin import credentials
from firebase_admin import messaging as admin_messaging
from google.cloud import firestore as gc_firestore
from google.oauth2 import service_account as gcp_sa
from fastapi import FastAPI, Header, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from skyfield.api import load
from timezonefinder import TimezoneFinder

app = FastAPI(title="Zodiona Astro API", version="1.0.0")

def _resolve_allowed_origins() -> list[str]:
    raw = os.getenv("CORS_ALLOW_ORIGINS", "*").strip()
    if not raw:
        return ["*"]
    if raw == "*":
        return ["*"]

    origins = [part.strip() for part in raw.split(",") if part.strip()]
    return origins if origins else ["*"]


_allowed_origins = _resolve_allowed_origins()
app.add_middleware(
    CORSMiddleware,
    allow_origins=_allowed_origins,
    allow_credentials=False,
    allow_methods=["GET", "POST", "OPTIONS"],
    allow_headers=["*"],
)

# ── Firebase Admin ────────────────────────────────────────────────────────────

_firebase_app: Optional[firebase_admin.App] = None
_sa_dict: Optional[dict] = None


def _init_firebase() -> None:
    global _firebase_app, _sa_dict
    if _firebase_app is not None:
        return
    sa_json = os.getenv("FIREBASE_SERVICE_ACCOUNT")
    if not sa_json:
        raise HTTPException(
            status_code=503,
            detail="Firebase yapılandırması eksik (FIREBASE_SERVICE_ACCOUNT env var)",
        )
    try:
        _sa_dict = json.loads(sa_json)
        cred = credentials.Certificate(_sa_dict)
        _firebase_app = firebase_admin.initialize_app(cred)
    except Exception as exc:
        raise HTTPException(
            status_code=503, detail=f"Firebase init hatası: {exc}"
        ) from exc


def _get_firestore_client() -> gc_firestore.Client:
    _init_firebase()
    assert _sa_dict is not None
    gcp_creds = gcp_sa.Credentials.from_service_account_info(
        _sa_dict,
        scopes=[
            "https://www.googleapis.com/auth/cloud-platform",
            "https://www.googleapis.com/auth/datastore",
        ],
    )
    return gc_firestore.Client(project=_sa_dict["project_id"], credentials=gcp_creds)

_tf = TimezoneFinder()
_ts = load.timescale()
_planets = load("de440s.bsp")
_earth = _planets["earth"]
_sun = _planets["sun"]
_moon = _planets["moon"]

SIGNS_TR = [
    "Koç",
    "Boğa",
    "İkizler",
    "Yengeç",
    "Aslan",
    "Başak",
    "Terazi",
    "Akrep",
    "Yay",
    "Oğlak",
    "Kova",
    "Balık",
]


class AstroResponse(BaseModel):
    timezone: str
    utcDateTime: str
    sunSign: str
    moonSign: str
    ascendant: str


def sign_from_longitude(deg: float) -> str:
    normalized = deg % 360.0
    idx = int(normalized // 30) % 12
    return SIGNS_TR[idx]


def julian_day(dt_utc: datetime) -> float:
    y = dt_utc.year
    m = dt_utc.month
    d = dt_utc.day + (dt_utc.hour + (dt_utc.minute + dt_utc.second / 60.0) / 60.0) / 24.0

    if m <= 2:
        y -= 1
        m += 12

    a = y // 100
    b = 2 - a + a // 4

    return int(365.25 * (y + 4716)) + int(30.6001 * (m + 1)) + d + b - 1524.5


def normalize_deg(x: float) -> float:
    r = x % 360.0
    return r + 360.0 if r < 0 else r


def normalize_hour_angle(x: float) -> float:
    n = normalize_deg(x)
    return n - 360.0 if n > 180.0 else n


def ascendant_longitude(utc_dt: datetime, latitude: float, longitude: float) -> float:
    jd = julian_day(utc_dt)
    t = (jd - 2451545.0) / 36525.0

    gmst = normalize_deg(
        280.46061837
        + 360.98564736629 * (jd - 2451545.0)
        + 0.000387933 * (t**2)
        - (t**3) / 38710000.0
    )
    lst = normalize_deg(gmst + longitude)

    phi = math.radians(latitude)
    eps = math.radians(23.439291111)

    def ecliptic_altitude_and_rising(lambda_deg: float) -> tuple[float, bool]:
        lam = math.radians(normalize_deg(lambda_deg))
        alpha = math.atan2(math.sin(lam) * math.cos(eps), math.cos(lam))
        alpha_deg = normalize_deg(math.degrees(alpha))
        delta = math.asin(math.sin(eps) * math.sin(lam))
        h_deg = normalize_hour_angle(lst - alpha_deg)
        h = math.radians(h_deg)

        sin_alt = math.sin(phi) * math.sin(delta) + math.cos(phi) * math.cos(delta) * math.cos(h)
        sin_alt = max(-1.0, min(1.0, sin_alt))
        alt = math.asin(sin_alt)
        return alt, h_deg < 0

    best_longitude = 0.0
    best_abs_alt = float("inf")
    crossing = None

    prev_alt = None
    prev_rising = None
    step = 0.5
    lam = 0.0

    while lam <= 360.0:
        alt, rising = ecliptic_altitude_and_rising(lam)
        if rising and abs(alt) < best_abs_alt:
            best_abs_alt = abs(alt)
            best_longitude = lam

        if (
            prev_alt is not None
            and prev_rising is True
            and rising is True
            and ((prev_alt <= 0 <= alt) or (prev_alt >= 0 >= alt))
        ):
            crossing = (lam - step, lam)
            break

        prev_alt = alt
        prev_rising = rising
        lam += step

    if crossing:
        a, b = crossing
        for _ in range(24):
            mid = (a + b) / 2.0
            alt_a, _ = ecliptic_altitude_and_rising(a)
            alt_m, _ = ecliptic_altitude_and_rising(mid)
            if (alt_a >= 0 and alt_m >= 0) or (alt_a <= 0 and alt_m <= 0):
                a = mid
            else:
                b = mid
        best_longitude = (a + b) / 2.0

    return normalize_deg(best_longitude)


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}


@app.get("/astro", response_model=AstroResponse)
def astro(
    date: str = Query(..., description="Yerel doğum tarihi-saati, ISO format. Örn: 1994-04-14T05:20"),
    lat: float = Query(..., ge=-90, le=90),
    lon: float = Query(..., ge=-180, le=180),
) -> AstroResponse:
    try:
        local_dt = datetime.fromisoformat(date)
    except ValueError as exc:
        raise HTTPException(status_code=400, detail="date ISO formatında olmalı") from exc

    timezone_name = _tf.timezone_at(lng=lon, lat=lat) or _tf.closest_timezone_at(lng=lon, lat=lat)
    if not timezone_name:
        raise HTTPException(status_code=400, detail="Koordinattan timezone bulunamadı")

    local_zoned = local_dt.replace(tzinfo=ZoneInfo(timezone_name))
    utc_dt = local_zoned.astimezone(ZoneInfo("UTC")).replace(tzinfo=None)

    t = _ts.utc(
        utc_dt.year,
        utc_dt.month,
        utc_dt.day,
        utc_dt.hour,
        utc_dt.minute,
        utc_dt.second,
    )

    e = _earth.at(t)

    _, sun_lon, _ = e.observe(_sun).apparent().ecliptic_latlon()
    _, moon_lon, _ = e.observe(_moon).apparent().ecliptic_latlon()

    asc_lon = ascendant_longitude(utc_dt, latitude=lat, longitude=lon)

    return AstroResponse(
        timezone=timezone_name,
        utcDateTime=utc_dt.isoformat(),
        sunSign=sign_from_longitude(sun_lon.degrees),
        moonSign=sign_from_longitude(moon_lon.degrees),
        ascendant=sign_from_longitude(asc_lon),
    )


# ── Burç bildirimi ────────────────────────────────────────────────────────────


class NotifyRequest(BaseModel):
    sign: str
    title: str
    body: str


@app.post("/notify-horoscope")
def notify_horoscope(
    req: NotifyRequest,
    x_api_key: str = Header(..., alias="X-API-Key"),
) -> dict:
    """Belirtilen burca sahip kullanıcılara FCM push bildirimi gönderir."""
    expected_key = os.getenv("NOTIFY_API_KEY", "")
    if not expected_key or x_api_key != expected_key:
        raise HTTPException(status_code=403, detail="Yetkisiz erişim")

    _init_firebase()
    db = _get_firestore_client()

    docs = list(
        db.collection("users").where("zodiacSign", "==", req.sign).stream()
    )

    tokens: list[str] = []
    for doc in docs:
        token = doc.to_dict().get("fcmToken")
        if token and isinstance(token, str):
            tokens.append(token)

    if not tokens:
        return {"sent": 0, "failed": 0, "message": f"{req.sign} için kayıtlı token bulunamadı"}

    preview = req.body[:80] + "\u2026" if len(req.body) > 80 else req.body
    total_sent = 0
    total_failed = 0

    for i in range(0, len(tokens), 500):
        chunk = tokens[i : i + 500]
        message = admin_messaging.MulticastMessage(
            notification=admin_messaging.Notification(
                title=f"\u2728 {req.title}",
                body=preview,
            ),
            android=admin_messaging.AndroidConfig(
                priority="high",
                notification=admin_messaging.AndroidNotification(
                    sound="default",
                    channel_id="horoscope_weekly",
                ),
            ),
            apns=admin_messaging.APNSConfig(
                payload=admin_messaging.APNSPayload(
                    aps=admin_messaging.Aps(sound="default"),
                ),
            ),
            tokens=chunk,
        )
        response = admin_messaging.send_each_for_multicast(message)
        total_sent += response.success_count
        total_failed += response.failure_count

    return {"sent": total_sent, "failed": total_failed}

