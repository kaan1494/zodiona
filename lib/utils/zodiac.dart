import 'dart:math' as math;

String calculateZodiac(DateTime birthDate) {
  final month = birthDate.month;
  final day = birthDate.day;

  if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) {
    return 'Koc';
  }
  if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) {
    return 'Boga';
  }
  if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) {
    return 'Ikizler';
  }
  if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) {
    return 'Yengec';
  }
  if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) {
    return 'Aslan';
  }
  if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) {
    return 'Basak';
  }
  if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) {
    return 'Terazi';
  }
  if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) {
    return 'Akrep';
  }
  if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) {
    return 'Yay';
  }
  if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) {
    return 'Oglak';
  }
  if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) {
    return 'Kova';
  }
  return 'Balik';
}

const List<String> _zodiacOrder = <String>[
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

String calculateSunSignPrecise(DateTime utcDateTime) {
  final jd = _julianDay(utcDateTime);
  final longitude = _sunEclipticLongitude(jd);
  return _signFromLongitude(longitude);
}

String calculateMoonSignPrecise(DateTime utcDateTime) {
  final jd = _julianDay(utcDateTime);
  final longitude = _moonEclipticLongitude(jd);
  return _signFromLongitude(longitude);
}

String calculateRisingSignPrecise({
  required DateTime utcDateTime,
  required double latitude,
  required double longitude,
}) {
  final jd = _julianDay(utcDateTime);
  final ascendantLongitude = _ascendantLongitude(
    jd: jd,
    latitudeDeg: latitude,
    longitudeDeg: longitude,
  );
  return _signFromLongitude(ascendantLongitude);
}

String _signFromLongitude(double longitudeDeg) {
  final normalized = _normalizeDegrees(longitudeDeg);
  final index = (normalized / 30).floor() % 12;
  return _zodiacOrder[index];
}

double _julianDay(DateTime utcDateTime) {
  final dt = utcDateTime.toUtc();
  var year = dt.year;
  var month = dt.month;
  final day = dt.day +
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

double _sunEclipticLongitude(double julianDay) {
  final n = julianDay - 2451545.0;
  final l = _normalizeDegrees(280.460 + 0.9856474 * n);
  final g = _normalizeDegrees(357.528 + 0.9856003 * n);
  final lambda =
      l + 1.915 * _sinDeg(g) + 0.020 * _sinDeg(2 * g);
  return _normalizeDegrees(lambda);
}

double _moonEclipticLongitude(double julianDay) {
  final d = julianDay - 2451543.5;

  final n = _normalizeDegrees(125.1228 - 0.0529538083 * d);
  const i = 5.1454;
  final w = _normalizeDegrees(318.0634 + 0.1643573223 * d);
  const a = 60.2666;
  const e = 0.054900;
  final m = _normalizeDegrees(115.3654 + 13.0649929509 * d);

  final eAnomaly = m + (180 / math.pi) * e * _sinDeg(m) * (1 + e * _cosDeg(m));

  final xv = a * (_cosDeg(eAnomaly) - e);
  final yv = a * (math.sqrt(1 - e * e) * _sinDeg(eAnomaly));

  final v = _radToDeg(math.atan2(yv, xv));
  final r = math.sqrt(xv * xv + yv * yv);

  final xh =
      r * (_cosDeg(n) * _cosDeg(v + w) - _sinDeg(n) * _sinDeg(v + w) * _cosDeg(i));
  final yh =
      r * (_sinDeg(n) * _cosDeg(v + w) + _cosDeg(n) * _sinDeg(v + w) * _cosDeg(i));

  return _normalizeDegrees(_radToDeg(math.atan2(yh, xh)));
}

double _ascendantLongitude({
  required double jd,
  required double latitudeDeg,
  required double longitudeDeg,
}) {
  final t = (jd - 2451545.0) / 36525.0;
  final gmst = _normalizeDegrees(
    280.46061837 +
        360.98564736629 * (jd - 2451545.0) +
        0.000387933 * t * t -
        t * t * t / 38710000.0,
  );
  final lst = _normalizeDegrees(gmst + longitudeDeg);

  final phi = _degToRad(latitudeDeg);
  const eps = 23.439291111;
  final epsilon = _degToRad(eps);

  double bestLongitude = 0;
  double bestAltitudeAbs = double.infinity;
  double? crossingStart;
  double? crossingEnd;
  double? prevAltitude;
  bool? prevIsRising;

  for (double lambdaDeg = 0; lambdaDeg <= 360; lambdaDeg += 0.5) {
    final state = _eclipticState(
      lambdaDeg: lambdaDeg,
      lstDeg: lst,
      phi: phi,
      epsilon: epsilon,
    );

    if (state.isRising) {
      final altitudeAbs = state.altitudeRad.abs();
      if (altitudeAbs < bestAltitudeAbs) {
        bestAltitudeAbs = altitudeAbs;
        bestLongitude = lambdaDeg;
      }
    }

    if (prevAltitude != null &&
        prevIsRising == true &&
        state.isRising &&
        ((prevAltitude! <= 0 && state.altitudeRad >= 0) ||
            (prevAltitude! >= 0 && state.altitudeRad <= 0))) {
      crossingStart = lambdaDeg - 0.5;
      crossingEnd = lambdaDeg;
      break;
    }

    prevAltitude = state.altitudeRad;
    prevIsRising = state.isRising;
  }

  if (crossingStart != null && crossingEnd != null) {
    var a = crossingStart;
    var b = crossingEnd;

    for (int i = 0; i < 20; i++) {
      final mid = (a + b) / 2;
      final aState = _eclipticState(
        lambdaDeg: a,
        lstDeg: lst,
        phi: phi,
        epsilon: epsilon,
      );
      final midState = _eclipticState(
        lambdaDeg: mid,
        lstDeg: lst,
        phi: phi,
        epsilon: epsilon,
      );

      final sameSign = (aState.altitudeRad >= 0 && midState.altitudeRad >= 0) ||
          (aState.altitudeRad <= 0 && midState.altitudeRad <= 0);

      if (sameSign) {
        a = mid;
      } else {
        b = mid;
      }
    }

    bestLongitude = (a + b) / 2;
  }

  return _normalizeDegrees(bestLongitude);
}

_EclipticState _eclipticState({
  required double lambdaDeg,
  required double lstDeg,
  required double phi,
  required double epsilon,
}) {
  final lambda = _degToRad(_normalizeDegrees(lambdaDeg));

  final alpha = math.atan2(
    math.sin(lambda) * math.cos(epsilon),
    math.cos(lambda),
  );
  final alphaDeg = _normalizeDegrees(_radToDeg(alpha));

  final delta = math.asin(math.sin(epsilon) * math.sin(lambda));
  final hourAngleDeg = _normalizeHourAngle(lstDeg - alphaDeg);
  final hourAngle = _degToRad(hourAngleDeg);

  final sinAltitude =
      math.sin(phi) * math.sin(delta) +
      math.cos(phi) * math.cos(delta) * math.cos(hourAngle);
  final altitude = math.asin(sinAltitude.clamp(-1.0, 1.0));

  return _EclipticState(
    altitudeRad: altitude,
    isRising: hourAngleDeg < 0,
  );
}

class _EclipticState {
  const _EclipticState({required this.altitudeRad, required this.isRising});

  final double altitudeRad;
  final bool isRising;
}

double _normalizeDegrees(double value) {
  final result = value % 360;
  return result < 0 ? result + 360 : result;
}

double _normalizeHourAngle(double value) {
  final normalized = _normalizeDegrees(value);
  return normalized > 180 ? normalized - 360 : normalized;
}

double _sinDeg(double value) => math.sin(_degToRad(value));
double _cosDeg(double value) => math.cos(_degToRad(value));
double _degToRad(double value) => value * math.pi / 180.0;
double _radToDeg(double value) => value * 180.0 / math.pi;

@Deprecated('Bunun yerine calculateMoonSignPrecise kullanin')
String calculateMoonSign(DateTime birthDate, {String? birthTime}) {
  final hourMinute = (birthTime ?? '12:00').split(':');
  final hour = int.tryParse(hourMinute.firstOrNull ?? '') ?? 12;
  final minute = int.tryParse(hourMinute.length > 1 ? hourMinute[1] : '') ?? 0;
  final utc = DateTime.utc(
    birthDate.year,
    birthDate.month,
    birthDate.day,
    hour,
    minute,
  );
  return calculateMoonSignPrecise(utc);
}

@Deprecated('Bunun yerine calculateRisingSignPrecise kullanin')
String calculateRisingSign({
  required DateTime birthDate,
  String? birthTime,
  bool birthTimeUnknown = false,
}) {
  if (birthTimeUnknown) {
    return 'Bilinmiyor';
  }

  final hourMinute = (birthTime ?? '').split(':');
  final hour = int.tryParse(hourMinute.firstOrNull ?? '');
  final minute = int.tryParse(hourMinute.length > 1 ? hourMinute[1] : '');
  if (hour == null || minute == null) {
    return 'Bilinmiyor';
  }

  final utc = DateTime.utc(
    birthDate.year,
    birthDate.month,
    birthDate.day,
    hour,
    minute,
  );
  return calculateRisingSignPrecise(
    utcDateTime: utc,
    latitude: 0,
    longitude: 0,
  );
}
