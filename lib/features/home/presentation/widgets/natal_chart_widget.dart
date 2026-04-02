import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../utils/zodiac.dart';

// ---------------------------------------------------------------------------
// Public widget — kullanıcının natal haritasını çizer (wheel + signs header)
// ---------------------------------------------------------------------------

class NatalChartDisplayWidget extends StatelessWidget {
  const NatalChartDisplayWidget({super.key, this.chartSize = 300});

  final double chartSize;

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .snapshots(),
      builder: (context, snapshot) {
        final data = snapshot.data?.data() ?? <String, dynamic>{};
        final birthData = NatalBirthData.fromMap(data);
        final chart = NatalChartBuilder.build(birthData);

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _SignChip(icon: '☉', sign: _displaySign(chart.sunSign)),
                const SizedBox(width: 12),
                _SignChip(icon: '☾', sign: _displaySign(chart.moonSign)),
                const SizedBox(width: 12),
                _SignChip(icon: '↑', sign: _displaySign(chart.risingSign)),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: chartSize,
              height: chartSize,
              child: CustomPaint(painter: NatalChartPainter(chart: chart)),
            ),
          ],
        );
      },
    );
  }
}

class _SignChip extends StatelessWidget {
  const _SignChip({required this.icon, required this.sign});
  final String icon;
  final String sign;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$icon $sign',
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: const Color(0xFFECD6A8),
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Data models
// ---------------------------------------------------------------------------

class NatalBirthData {
  const NatalBirthData({
    required this.birthDate,
    required this.birthTime,
    required this.latitude,
    required this.longitude,
    required this.sunSign,
    required this.moonSign,
    required this.risingSign,
  });

  final DateTime? birthDate;
  final String? birthTime;
  final double? latitude;
  final double? longitude;
  final String sunSign;
  final String moonSign;
  final String risingSign;

  factory NatalBirthData.fromMap(Map<String, dynamic> map) {
    final timestamp = map['birthDate'];
    final birthDate = timestamp is Timestamp ? timestamp.toDate() : null;

    final sunRaw = (map['zodiacSign'] as String?)?.trim();
    final moonRaw = (map['moonSign'] as String?)?.trim();
    final risingRaw = (map['risingSign'] as String?)?.trim();

    final fallbackSun = birthDate != null
        ? calculateZodiac(birthDate)
        : 'Bilinmiyor';

    return NatalBirthData(
      birthDate: birthDate,
      birthTime: (map['birthTime'] as String?)?.trim(),
      latitude: _asDouble(map['birthPlaceLat']),
      longitude: _asDouble(map['birthPlaceLon']),
      sunSign: _sanitize(sunRaw, fallback: fallbackSun),
      moonSign: _sanitize(moonRaw, fallback: 'Bilinmiyor'),
      risingSign: _sanitize(risingRaw, fallback: 'Bilinmiyor'),
    );
  }
}

class NatalChart {
  const NatalChart({
    required this.seed,
    required this.sunSign,
    required this.moonSign,
    required this.risingSign,
    required this.ascendantLongitude,
    required this.placements,
    required this.aspects,
  });

  final double seed;
  final String sunSign;
  final String moonSign;
  final String risingSign;
  final double ascendantLongitude;
  final List<NatalPlanetPlacement> placements;
  final List<NatalAspect> aspects;
}

class NatalPlanetPlacement {
  const NatalPlanetPlacement({
    required this.glyph,
    required this.color,
    required this.longitude,
  });

  final String glyph;
  final Color color;
  final double longitude;
}

enum NatalAspectType { conjunction, sextile, square, trine, opposition }

class NatalAspect {
  const NatalAspect({required this.from, required this.to, required this.type});

  final NatalPlanetPlacement from;
  final NatalPlanetPlacement to;
  final NatalAspectType type;
}

// ---------------------------------------------------------------------------
// Chart builder
// ---------------------------------------------------------------------------

class NatalChartBuilder {
  static NatalChart build(NatalBirthData userData) {
    final local = _buildLocalBirthDateTime(
      birthDate: userData.birthDate,
      birthTime: userData.birthTime,
    );
    final base = local ?? DateTime(2000, 1, 1, 12);
    final utc = DateTime.utc(
      base.year,
      base.month,
      base.day,
      base.hour,
      base.minute,
    );

    final lat = userData.latitude ?? 39.9255;
    final lon = userData.longitude ?? 32.8663;

    var sunL = _sunLongitude(utc);
    var moonL = _moonLongitude(utc);
    var ascL = _ascendantLongitude(
      utcDateTime: utc,
      latitudeDeg: lat,
      longitudeDeg: lon,
    );

    sunL = _coerceLongitudeToSign(sunL, userData.sunSign);
    moonL = _coerceLongitudeToSign(moonL, userData.moonSign);
    ascL = _coerceLongitudeToSign(ascL, userData.risingSign);

    final d = utc.difference(DateTime.utc(2000, 1, 1, 12)).inMinutes / 1440.0;
    final seed = _norm(
      (utc.millisecondsSinceEpoch / 60000) + lat * 11.2 + lon * 7.4,
    );

    double gen(String key, double l0, double speed) {
      final wobble = 1.8 * math.sin(_rad(seed + key.codeUnitAt(0) * 17.0));
      return _norm(l0 + speed * d + wobble);
    }

    final northNodeL = gen('NorthNode', 125.0, -0.0529538);

    final placements = [
      NatalPlanetPlacement(
        glyph: '☉',
        color: const Color(0xFFFFC361),
        longitude: sunL,
      ),
      NatalPlanetPlacement(
        glyph: '☾',
        color: const Color(0xFFBFD6FF),
        longitude: moonL,
      ),
      NatalPlanetPlacement(
        glyph: '↑',
        color: const Color(0xFFF1E3A6),
        longitude: ascL,
      ),
      NatalPlanetPlacement(
        glyph: '☿',
        color: const Color(0xFFAFD8FF),
        longitude: gen('Mercury', 252.25, 4.09233445),
      ),
      NatalPlanetPlacement(
        glyph: '♀',
        color: const Color(0xFFFFA9C7),
        longitude: gen('Venus', 181.98, 1.60213034),
      ),
      NatalPlanetPlacement(
        glyph: '♂',
        color: const Color(0xFFFF867C),
        longitude: gen('Mars', 355.43, 0.52402068),
      ),
      NatalPlanetPlacement(
        glyph: '♃',
        color: const Color(0xFFEBC18A),
        longitude: gen('Jupiter', 34.35, 0.08308529),
      ),
      NatalPlanetPlacement(
        glyph: '♄',
        color: const Color(0xFFCFBC9A),
        longitude: gen('Saturn', 50.08, 0.03344414),
      ),
      NatalPlanetPlacement(
        glyph: '♅',
        color: const Color(0xFF87CEFF),
        longitude: gen('Uranus', 314.05, 0.01172834),
      ),
      NatalPlanetPlacement(
        glyph: '♆',
        color: const Color(0xFF7BB5FF),
        longitude: gen('Neptune', 304.35, 0.00598103),
      ),
      NatalPlanetPlacement(
        glyph: '♇',
        color: const Color(0xFFC4E2FF),
        longitude: gen('Pluto', 238.95, 0.00396400),
      ),
      NatalPlanetPlacement(
        glyph: '☊',
        color: const Color(0xFFF0DA97),
        longitude: northNodeL,
      ),
      NatalPlanetPlacement(
        glyph: '⚷',
        color: const Color(0xFFD3D3E8),
        longitude: gen('Chiron', 209.2, 0.02),
      ),
      NatalPlanetPlacement(
        glyph: '☋',
        color: const Color(0xFFEFD294),
        longitude: _norm(northNodeL + 180),
      ),
      NatalPlanetPlacement(
        glyph: '⊗',
        color: const Color(0xFFF7E0A7),
        longitude: _norm(ascL + moonL - sunL),
      ),
      NatalPlanetPlacement(
        glyph: '✶',
        color: const Color(0xFFE4D9B4),
        longitude: gen('Juno', 169.2, 0.09),
      ),
      NatalPlanetPlacement(
        glyph: 'MC',
        color: const Color(0xFFEAD7A0),
        longitude: _norm(ascL + 90),
      ),
    ];

    final aspects = _buildAspects(placements);

    return NatalChart(
      seed: seed,
      sunSign: userData.sunSign,
      moonSign: userData.moonSign,
      risingSign: userData.risingSign,
      ascendantLongitude: ascL,
      placements: placements,
      aspects: aspects,
    );
  }
}

List<NatalAspect> _buildAspects(List<NatalPlanetPlacement> placements) {
  final result = <NatalAspect>[];
  for (int i = 0; i < placements.length; i++) {
    for (int j = i + 1; j < placements.length; j++) {
      final a = placements[i];
      final b = placements[j];
      final diff = _angleDist(a.longitude, b.longitude);
      NatalAspectType? type;
      if ((diff - 0).abs() <= 7) {
        type = NatalAspectType.conjunction;
      } else if ((diff - 60).abs() <= 4) {
        type = NatalAspectType.sextile;
      } else if ((diff - 90).abs() <= 5) {
        type = NatalAspectType.square;
      } else if ((diff - 120).abs() <= 5) {
        type = NatalAspectType.trine;
      } else if ((diff - 180).abs() <= 6) {
        type = NatalAspectType.opposition;
      }
      if (type != null) {
        result.add(NatalAspect(from: a, to: b, type: type));
      }
    }
  }
  return result;
}

// ---------------------------------------------------------------------------
// CustomPainter
// ---------------------------------------------------------------------------

class NatalChartPainter extends CustomPainter {
  const NatalChartPainter({required this.chart});
  final NatalChart chart;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 8;

    canvas.drawCircle(center, radius, Paint()..color = const Color(0xFF1A0848));
    canvas.drawCircle(
      center,
      radius * 0.82,
      Paint()..color = const Color(0xFFF2F3F7),
    );

    final border = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = const Color(0xFF6D798B);
    canvas.drawCircle(center, radius, border);
    canvas.drawCircle(center, radius * 0.82, border);

    _drawSigns(canvas, center, radius);
    _drawHouses(canvas, center, radius);
    _drawAspects(canvas, center, radius * 0.52);
    _drawPlanets(canvas, center, radius);
  }

  void _drawSigns(Canvas canvas, Offset center, double radius) {
    const glyphs = ['♈', '♉', '♊', '♋', '♌', '♍', '♎', '♏', '♐', '♑', '♒', '♓'];
    for (int i = 0; i < 12; i++) {
      final angle = _rad(-90 + i * 30.0);
      final start = Offset(
        center.dx + math.cos(angle) * radius * 0.82,
        center.dy + math.sin(angle) * radius * 0.82,
      );
      final end = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );
      canvas.drawLine(
        start,
        end,
        Paint()
          ..color = const Color(0xFFADB9CA)
          ..strokeWidth = 1,
      );
      _paintGlyph(
        canvas,
        glyphs[i],
        Offset(
          center.dx + math.cos(_rad(-90 + i * 30 + 15)) * radius * 0.9,
          center.dy + math.sin(_rad(-90 + i * 30 + 15)) * radius * 0.9,
        ),
        const TextStyle(
          color: Color(0xFFD9E4F1),
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      );
    }
  }

  void _drawHouses(Canvas canvas, Offset center, double radius) {
    for (int i = 0; i < 12; i++) {
      final cusp = _norm(chart.ascendantLongitude + i * 30);
      final angle = _rad(-90 + cusp);
      canvas.drawLine(
        center,
        Offset(
          center.dx + math.cos(angle) * radius * 0.82,
          center.dy + math.sin(angle) * radius * 0.82,
        ),
        Paint()
          ..color = Colors.black.withValues(alpha: 0.17)
          ..strokeWidth = 0.9,
      );
      final houseMid = _norm(chart.ascendantLongitude + i * 30 + 15);
      _paintGlyph(
        canvas,
        '${i + 1}',
        Offset(
          center.dx + math.cos(_rad(-90 + houseMid)) * radius * 0.57,
          center.dy + math.sin(_rad(-90 + houseMid)) * radius * 0.57,
        ),
        const TextStyle(
          color: Color(0xFF4B5361),
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      );
    }
  }

  void _drawPlanets(Canvas canvas, Offset center, double radius) {
    for (final p in chart.placements) {
      final angle = _rad(-90 + p.longitude);
      final point = Offset(
        center.dx + math.cos(angle) * radius * 0.72,
        center.dy + math.sin(angle) * radius * 0.72,
      );
      canvas.drawCircle(
        point,
        7,
        Paint()..color = p.color.withValues(alpha: 0.95),
      );
      canvas.drawCircle(
        point,
        7,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.7,
      );
      _paintGlyph(
        canvas,
        p.glyph,
        point,
        const TextStyle(
          color: Color(0xFF031136),
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      );
    }
  }

  void _drawAspects(Canvas canvas, Offset center, double radius) {
    for (final aspect in chart.aspects) {
      final angleA = _rad(-90 + aspect.from.longitude);
      final angleB = _rad(-90 + aspect.to.longitude);
      final color = switch (aspect.type) {
        NatalAspectType.square ||
        NatalAspectType.opposition => const Color(0xFFCD5A77),
        NatalAspectType.trine => const Color(0xFF4E9EE8),
        NatalAspectType.sextile => const Color(0xFF67C8BC),
        NatalAspectType.conjunction => const Color(0xFFD7A451),
      };
      canvas.drawLine(
        Offset(
          center.dx + math.cos(angleA) * radius,
          center.dy + math.sin(angleA) * radius,
        ),
        Offset(
          center.dx + math.cos(angleB) * radius,
          center.dy + math.sin(angleB) * radius,
        ),
        Paint()
          ..color = color.withValues(alpha: 0.7)
          ..strokeWidth = 1,
      );
    }
  }

  void _paintGlyph(Canvas canvas, String text, Offset center, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      Offset(center.dx - painter.width / 2, center.dy - painter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant NatalChartPainter old) =>
      old.chart.seed != chart.seed;
}

// ---------------------------------------------------------------------------
// Math helpers
// ---------------------------------------------------------------------------

double _norm(double v) {
  final r = v % 360;
  return r < 0 ? r + 360 : r;
}

double _normHour(double v) {
  final n = _norm(v);
  return n > 180 ? n - 360 : n;
}

double _rad(double v) => v * math.pi / 180;
double _deg(double v) => v * 180 / math.pi;
double _sinD(double v) => math.sin(_rad(v));
double _cosD(double v) => math.cos(_rad(v));

double _sunLongitude(DateTime utc) {
  final jd = _julianDay(utc);
  final n = jd - 2451545.0;
  final l = _norm(280.460 + 0.9856474 * n);
  final g = _norm(357.528 + 0.9856003 * n);
  return _norm(l + 1.915 * _sinD(g) + 0.020 * _sinD(2 * g));
}

double _moonLongitude(DateTime utc) {
  final jd = _julianDay(utc);
  final d = jd - 2451543.5;
  final n = _norm(125.1228 - 0.0529538083 * d);
  const i = 5.1454;
  final w = _norm(318.0634 + 0.1643573223 * d);
  const a = 60.2666;
  const e = 0.054900;
  final m = _norm(115.3654 + 13.0649929509 * d);
  final eAnom = m + (180 / math.pi) * e * _sinD(m) * (1 + e * _cosD(m));
  final xv = a * (_cosD(eAnom) - e);
  final yv = a * (math.sqrt(1 - e * e) * _sinD(eAnom));
  final v = _deg(math.atan2(yv, xv));
  final r = math.sqrt(xv * xv + yv * yv);
  final xh = r * (_cosD(n) * _cosD(v + w) - _sinD(n) * _sinD(v + w) * _cosD(i));
  final yh = r * (_sinD(n) * _cosD(v + w) + _cosD(n) * _sinD(v + w) * _cosD(i));
  return _norm(_deg(math.atan2(yh, xh)));
}

double _ascendantLongitude({
  required DateTime utcDateTime,
  required double latitudeDeg,
  required double longitudeDeg,
}) {
  final jd = _julianDay(utcDateTime);
  final t = (jd - 2451545.0) / 36525.0;
  final gmst = _norm(
    280.46061837 +
        360.98564736629 * (jd - 2451545.0) +
        0.000387933 * t * t -
        t * t * t / 38710000.0,
  );
  final lst = _norm(gmst + longitudeDeg);
  final phi = _rad(latitudeDeg);
  final epsilon = _rad(23.439291111);

  double bestLon = 0;
  double bestAbs = double.infinity;
  double? csStart, csEnd, prevAlt;
  bool? prevRising;

  for (double lDeg = 0; lDeg <= 360; lDeg += 0.5) {
    final st = _eclipState(lDeg, lst, phi, epsilon);
    if (st.isRising) {
      final abs = st.altitude.abs();
      if (abs < bestAbs) {
        bestAbs = abs;
        bestLon = lDeg;
      }
    }
    if (prevAlt != null &&
        prevRising == true &&
        st.isRising &&
        ((prevAlt <= 0 && st.altitude >= 0) ||
            (prevAlt >= 0 && st.altitude <= 0))) {
      csStart = lDeg - 0.5;
      csEnd = lDeg;
      break;
    }
    prevAlt = st.altitude;
    prevRising = st.isRising;
  }

  if (csStart != null && csEnd != null) {
    var lo = csStart, hi = csEnd;
    for (int i = 0; i < 20; i++) {
      final mid = (lo + hi) / 2;
      final loSt = _eclipState(lo, lst, phi, epsilon);
      final midSt = _eclipState(mid, lst, phi, epsilon);
      final sameSign =
          (loSt.altitude >= 0 && midSt.altitude >= 0) ||
          (loSt.altitude <= 0 && midSt.altitude <= 0);
      if (sameSign) {
        lo = mid;
      } else {
        hi = mid;
      }
    }
    bestLon = (lo + hi) / 2;
  }
  return _norm(bestLon);
}

({double altitude, bool isRising}) _eclipState(
  double lDeg,
  double lst,
  double phi,
  double epsilon,
) {
  final lambda = _rad(_norm(lDeg));
  final alpha = _deg(
    math.atan2(math.sin(lambda) * math.cos(epsilon), math.cos(lambda)),
  );
  final alphaNorm = _norm(alpha);
  final delta = math.asin(math.sin(epsilon) * math.sin(lambda));
  final haDeg = _normHour(lst - alphaNorm);
  final ha = _rad(haDeg);
  final sinAlt =
      math.sin(phi) * math.sin(delta) +
      math.cos(phi) * math.cos(delta) * math.cos(ha);
  return (altitude: math.asin(sinAlt.clamp(-1.0, 1.0)), isRising: haDeg < 0);
}

double _julianDay(DateTime utc) {
  final dt = utc.toUtc();
  var year = dt.year;
  var month = dt.month;
  final day =
      dt.day +
      (dt.hour + (dt.minute + (dt.second + dt.millisecond / 1000) / 60) / 60) /
          24;
  if (month <= 2) {
    year -= 1;
    month += 12;
  }
  final a = (year / 100).floor();
  final b = 2 - a + (a / 4).floor();
  return (365.25 * (year + 4716)).floorToDouble() +
      (30.6001 * (month + 1)).floorToDouble() +
      day +
      b -
      1524.5;
}

double _angleDist(double a, double b) {
  final d = (_norm(a) - _norm(b)).abs();
  return d > 180 ? 360 - d : d;
}

double _coerceLongitudeToSign(double longitude, String sign) {
  const zodiacOrder = [
    'Koc',
    'Boga',
    'Ikizler',
    'Yengec',
    'Aslan',
    'Basak',
    'Terazi',
    'Akrep',
    'Yay',
    'Oglak',
    'Kova',
    'Balik',
  ];
  final idx = zodiacOrder.indexOf(sign);
  if (idx == -1 || sign == 'Bilinmiyor') return _norm(longitude);
  final degIn = _norm(longitude) % 30;
  return _norm(idx * 30.0 + degIn);
}

String _displaySign(String v) {
  switch (v) {
    case 'Koc':
      return 'Koç';
    case 'Boga':
      return 'Boğa';
    case 'Ikizler':
      return 'İkizler';
    case 'Yengec':
      return 'Yengeç';
    case 'Basak':
      return 'Başak';
    case 'Oglak':
      return 'Oğlak';
    case 'Balik':
      return 'Balık';
    case 'Bilinmiyor':
      return '?';
    default:
      return v;
  }
}

String _sanitize(String? v, {required String fallback}) {
  final t = v?.trim();
  if (t == null || t.isEmpty || t == 'Bilinmiyor' || t == 'Yukleniyor...') {
    return fallback;
  }
  return t;
}

double? _asDouble(dynamic v) {
  if (v is double) return v;
  if (v is int) return v.toDouble();
  if (v is String) return double.tryParse(v);
  return null;
}

DateTime? _buildLocalBirthDateTime({
  required DateTime? birthDate,
  required String? birthTime,
}) {
  if (birthDate == null) return null;
  final raw = birthTime?.trim();
  if (raw == null || raw.isEmpty || raw == 'Bilinmiyor') {
    return DateTime(birthDate.year, birthDate.month, birthDate.day, 12);
  }
  final parts = raw.split(':');
  if (parts.length != 2) {
    return DateTime(birthDate.year, birthDate.month, birthDate.day, 12);
  }
  final h = int.tryParse(parts[0]);
  final min = int.tryParse(parts[1]);
  if (h == null || min == null || h < 0 || h > 23 || min < 0 || min > 59) {
    return DateTime(birthDate.year, birthDate.month, birthDate.day, 12);
  }
  return DateTime(birthDate.year, birthDate.month, birthDate.day, h, min);
}
