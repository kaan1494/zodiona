# Zodiona Astro Backend (NASA/JPL)

Bu servis, `Skyfield + NASA JPL ephemeris` ile `Güneş`, `Ay` ve `Yükselen` burcunu hesaplar.

## 1) Kurulum

1. Python 3.11+ kurulu olmalı.
2. Backend klasörüne girin.
3. Sanal ortam oluşturun ve aktif edin.
4. Paketleri kurun:

```bash
pip install -r requirements.txt
```

## 2) Çalıştırma

```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

İlk çalıştırmada `de440s.bsp` otomatik indirilir.

## 3) Test

Sağlık kontrolü:

`GET http://127.0.0.1:8000/health`

Hesap:

`GET http://127.0.0.1:8000/astro?date=1994-04-14T05:20&lat=41.0082&lon=28.9784`

Örnek cevap:

```json
{
  "timezone": "Europe/Istanbul",
  "utcDateTime": "1994-04-14T02:20:00",
  "sunSign": "Koç",
  "moonSign": "Boğa",
  "ascendant": "Balık"
}
```

## Not

Android emulator içinden backend'e erişim için Flutter tarafında base URL:

- `http://10.0.2.2:8000`
