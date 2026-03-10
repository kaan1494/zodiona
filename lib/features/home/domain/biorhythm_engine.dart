import 'dart:math' as math;

class BiorhythmSnapshot {
  const BiorhythmSnapshot({
    required this.date,
    required this.physical,
    required this.emotional,
    required this.intellectual,
  });

  final DateTime date;
  final int physical;
  final int emotional;
  final int intellectual;
}

class BiorhythmEngine {
  const BiorhythmEngine._();

  static BiorhythmSnapshot forDate({
    required DateTime birthDate,
    required DateTime targetDate,
  }) {
    final birth = DateTime(birthDate.year, birthDate.month, birthDate.day);
    final target = DateTime(targetDate.year, targetDate.month, targetDate.day);
    final days = target.difference(birth).inDays;

    return BiorhythmSnapshot(
      date: target,
      physical: _cyclePercent(days, 23),
      emotional: _cyclePercent(days, 28),
      intellectual: _cyclePercent(days, 33),
    );
  }

  static List<BiorhythmSnapshot> lastSevenDays({
    required DateTime birthDate,
    DateTime? now,
  }) {
    final today = now ?? DateTime.now();
    return List.generate(7, (index) {
      final day = today.subtract(Duration(days: 6 - index));
      return forDate(birthDate: birthDate, targetDate: day);
    });
  }

  static int _cyclePercent(int dayCount, int cycleDays) {
    final value = math.sin((2 * math.pi * dayCount) / cycleDays) * 100;
    return value.round().clamp(-100, 100);
  }
}
