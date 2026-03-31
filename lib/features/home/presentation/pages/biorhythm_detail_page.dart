import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../domain/biorhythm_daily_comment_generator.dart';
import '../../domain/biorhythm_engine.dart';

class BiorhythmDetailPage extends StatelessWidget {
  const BiorhythmDetailPage({
    super.key,
    required this.birthDate,
    required this.userKey,
  });

  final DateTime birthDate;
  final String userKey;

  @override
  Widget build(BuildContext context) {
    final points = BiorhythmEngine.lastSevenDays(birthDate: birthDate);
    final today = points.last;
    final comment = BiorhythmDailyCommentGenerator.generate(
      userKey: userKey,
      date: today.date,
      physical: today.physical,
      emotional: today.emotional,
      intellectual: today.intellectual,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0A0520),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/onboarding/home_page.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              repeat: ImageRepeat.repeatY,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xAA1A0848), Color(0xCC130535)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, color: Color(0xE8FFFFFF)),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 26),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Biyoritim',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    color: const Color(0xFFF2D293),
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(width: 6),
                            InkWell(
                              onTap: () => _openInfo(context),
                              borderRadius: BorderRadius.circular(20),
                              child: const Padding(
                                padding: EdgeInsets.all(4),
                                child: Icon(
                                  Icons.info_outline,
                                  color: Color(0xE8FFFFFF),
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _LegendRow(),
                        const SizedBox(height: 8),
                        _SevenDayChart(points: points),
                        const SizedBox(height: 16),
                        _TodayCycleCard(snapshot: today),
                        const SizedBox(height: 18),
                        Center(
                          child: Text(
                            comment.title,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: const Color(0xFFF2D293),
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          comment.body,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: Colors.white.withValues(alpha: 0.93),
                                height: 1.5,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openInfo(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return FractionallySizedBox(
          heightFactor: 0.88,
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF1E1058),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 12, 8, 6),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Biyoritim Nedir?',
                            textAlign: TextAlign.center,
                            style: Theme.of(sheetContext)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: const Color(0xFFF2D293),
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(sheetContext).pop(),
                          icon: const Icon(
                            Icons.close,
                            color: Color(0xE8FFFFFF),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
                      child: Text(
                        _infoText,
                        style: Theme.of(sheetContext).textTheme.bodyLarge
                            ?.copyWith(
                              color: Colors.white.withValues(alpha: 0.93),
                              height: 1.55,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LegendRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        _LegendDot(color: Color(0xFFC59BFF), label: 'Fiziksel'),
        SizedBox(width: 14),
        _LegendDot(color: Color(0xFFFFC9B3), label: 'Duygusal'),
        SizedBox(width: 14),
        _LegendDot(color: Color(0xFF62CFFF), label: 'Zihinsel'),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _SevenDayChart extends StatelessWidget {
  const _SevenDayChart({required this.points});

  final List<BiorhythmSnapshot> points;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 6, 10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 190,
            child: Stack(
              children: [
                Positioned.fill(
                  right: 26,
                  child: CustomPaint(
                    painter: _BiorhythmChartPainter(points: points),
                  ),
                ),
                const Positioned(
                  top: 4,
                  right: 0,
                  child: _AxisValue(value: '100'),
                ),
                const Positioned(
                  top: 86,
                  right: 0,
                  child: _AxisValue(value: '0'),
                ),
                const Positioned(
                  bottom: 20,
                  right: 0,
                  child: _AxisValue(value: '-100'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: points
                .map(
                  (item) => Expanded(
                    child: Text(
                      _formatDay(item.date),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                .toList(growable: false),
          ),
        ],
      ),
    );
  }

  String _formatDay(DateTime date) {
    const months = [
      'Oca',
      'Şub',
      'Mar',
      'Nis',
      'May',
      'Haz',
      'Tem',
      'Ağu',
      'Eyl',
      'Eki',
      'Kas',
      'Ara',
    ];
    return '${date.day} ${months[date.month - 1]}';
  }
}

class _AxisValue extends StatelessWidget {
  const _AxisValue({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Colors.white.withValues(alpha: 0.85),
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _BiorhythmChartPainter extends CustomPainter {
  const _BiorhythmChartPainter({required this.points});

  final List<BiorhythmSnapshot> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) {
      return;
    }

    final gridPaint = Paint()
      ..color = const Color(0x66FFFFFF)
      ..strokeWidth = 1;

    const horizontalSteps = 4;
    for (var i = 0; i <= horizontalSteps; i++) {
      final y = (size.height / horizontalSteps) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final xStep = points.length > 1
        ? size.width / (points.length - 1)
        : size.width;
    for (var i = 0; i < points.length; i++) {
      final x = xStep * i;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    final todayIndex = points.length - 1;
    final markerPaint = Paint()
      ..color = const Color(0xCCF68EA6)
      ..strokeWidth = 1.3;
    final markerX = xStep * todayIndex;
    canvas.drawLine(
      Offset(markerX, 0),
      Offset(markerX, size.height),
      markerPaint,
    );

    _drawLine(
      canvas,
      size,
      color: const Color(0xFFC59BFF),
      values: points.map((e) => e.physical).toList(growable: false),
    );
    _drawLine(
      canvas,
      size,
      color: const Color(0xFFFFC9B3),
      values: points.map((e) => e.emotional).toList(growable: false),
    );
    _drawLine(
      canvas,
      size,
      color: const Color(0xFF62CFFF),
      values: points.map((e) => e.intellectual).toList(growable: false),
    );
  }

  void _drawLine(
    Canvas canvas,
    Size size, {
    required Color color,
    required List<int> values,
  }) {
    if (values.isEmpty) {
      return;
    }

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.6
      ..style = PaintingStyle.stroke;

    final path = Path();
    final xStep = values.length > 1
        ? size.width / (values.length - 1)
        : size.width;

    for (var i = 0; i < values.length; i++) {
      final x = i * xStep;
      final y = _mapY(values[i], size.height);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  double _mapY(int value, double height) {
    return ((100 - value) / 200) * height;
  }

  @override
  bool shouldRepaint(covariant _BiorhythmChartPainter oldDelegate) {
    if (oldDelegate.points.length != points.length) {
      return true;
    }
    for (var i = 0; i < points.length; i++) {
      final a = oldDelegate.points[i];
      final b = points[i];
      if (a.physical != b.physical ||
          a.emotional != b.emotional ||
          a.intellectual != b.intellectual ||
          a.date != b.date) {
        return true;
      }
    }
    return false;
  }
}

class _TodayCycleCard extends StatelessWidget {
  const _TodayCycleCard({required this.snapshot});

  final BiorhythmSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          Expanded(
            child: _CycleRing(
              label: 'Duygusal',
              value: snapshot.emotional,
              color: const Color(0xFFFF8A72),
            ),
          ),
          Expanded(
            child: _CycleRing(
              label: 'Fiziksel',
              value: snapshot.physical,
              color: const Color(0xFFC588FF),
            ),
          ),
          Expanded(
            child: _CycleRing(
              label: 'Zihinsel',
              value: snapshot.intellectual,
              color: const Color(0xFF4CC7FF),
            ),
          ),
        ],
      ),
    );
  }
}

class _CycleRing extends StatelessWidget {
  const _CycleRing({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 94,
          height: 94,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(94, 94),
                painter: _RingPainter(color: color, value: value),
              ),
              Text(
                value >= 0 ? '$value%' : '$value%',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 31 / 2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({required this.color, required this.value});

  final Color color;
  final int value;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.06;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - stroke) / 2;

    final basePaint = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;

    final arcPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, basePaint);

    final sweep = (value.abs() / 100) * (2 * math.pi);
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect, -math.pi / 2, sweep, false, arcPaint);
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.color != color;
  }
}

const _infoText =
    '''Biyoritim, doğduğun günle bugünün arasındaki zaman farkına göre hesaplanan üç temel döngünün toplamıdır: fiziksel, duygusal ve zihinsel ritim.

Bu döngüler sabit bir çizgide ilerlemez; dönem dönem yükselir, dengede kalır ve düşer. Amaç “iyi-kötü” etiketlemek değil, hangi gün hangi alanda daha destekli olduğunu fark etmektir.

Döngü Fazları
- Nötr Bölge (0 çevresi): Enerji geçiş halindedir. Büyük sıçrama yerine düzen kurmak daha kolay olur.
- Yüksek Bölge (+): O alanda performans, dayanıklılık ve akış artar.
- Düşük Bölge (-): Tempo düşebilir. Bu dönemler toparlanma, gözden geçirme ve sadeleşme için değerlidir.

Fiziksel Döngü (23 gün)
Vücut enerjisi, dayanıklılık ve hareket kapasitesiyle ilgilidir. Yüksek günlerde tempo ve üretim artabilir; düşük günlerde dinlenme ve ritmi koruma daha doğru olabilir.

Duygusal Döngü (28 gün)
Duygu yönetimi, ilişkiler, hassasiyet ve motivasyon dalgalanmalarını etkiler. Yüksek günlerde iletişim daha akıcı olabilir; düşük günlerde iç dengeyi korumak öncelikli olur.

Zihinsel Döngü (33 gün)
Odak, öğrenme, analiz ve karar kalitesiyle ilişkilidir. Yüksek fazda zihinsel netlik artar; düşük fazda bilgi yükünü sadeleştirip kısa molalar vermek daha verimli olabilir.

Biyoritim, geleceği kesin olarak belirleyen bir sistem değildir; gününü daha bilinçli planlamak için yardımcı bir ritim göstergesidir.''';
