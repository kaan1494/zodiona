import 'package:flutter/material.dart';

import '../../../../services/jeton_service.dart';

// ─── Jeton Bakiye Badge ────────────────────────────────────────────────────────

class JetonBadge extends StatelessWidget {
  const JetonBadge({super.key, required this.balance, required this.onAddTap});

  final int balance;
  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onAddTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xFF1A0848),
              border: Border.all(
                color: const Color(0xFFF2D293).withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CoinIcon(size: 22),
                const SizedBox(width: 8),
                Text(
                  '$balance',
                  style: const TextStyle(
                    color: Color(0xFFF2D293),
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: onAddTap,
          child: Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFF2D293),
            ),
            child: const Icon(Icons.add, color: Color(0xFF0B1026), size: 18),
          ),
        ),
      ],
    );
  }
}

// ─── Jeton Paketi Satır ───────────────────────────────────────────────────────

class JetonPaketSatiri extends StatelessWidget {
  const JetonPaketSatiri({
    super.key,
    required this.paket,
    required this.onTap,
    this.storePrice,
  });

  final JetonPaketi paket;
  final VoidCallback onTap;

  /// Play Store'dan gelen gerçek fiyat (KDV dahil). Null ise fiyatTL gösterilir.
  final String? storePrice;

  @override
  Widget build(BuildContext context) {
    final isPopular = paket.jeton == 50;
    final tasarruf = paket.tasarrufYuzdesi;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: isPopular
              ? const LinearGradient(
                  colors: [Color(0xFF3D1E7A), Color(0xFF2E1568)],
                )
              : null,
          color: isPopular ? null : const Color(0xFF1E1045),
          border: Border.all(
            color: isPopular
                ? const Color(0xFFF2D293)
                : Colors.white.withValues(alpha: 0.15),
            width: isPopular ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            const CoinIcon(size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    children: [
                      Text(
                        '${paket.jeton} Jeton',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (isPopular)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: const Color(0xFFF2D293),
                          ),
                          child: const Text(
                            'POPÜLER',
                            style: TextStyle(
                              color: Color(0xFF0B1026),
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (tasarruf > 0)
                    Text(
                      '%$tasarruf tasarruf',
                      style: const TextStyle(
                        color: Color(0xFF81C784),
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
            ),
            Text(
              storePrice ?? paket.fiyatGoster,
              style: const TextStyle(
                color: Color(0xFFF2D293),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.white38,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Altın Coin İkonu ─────────────────────────────────────────────────────────

class CoinIcon extends StatelessWidget {
  const CoinIcon({super.key, this.size = 24});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: CoinPainter()),
    );
  }
}

class CoinPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final center = Offset(cx, cy);
    final r = size.width / 2;

    final outerPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.3, -0.4),
        radius: 1.0,
        colors: [Color(0xFFFFE566), Color(0xFFE8A000)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawCircle(center, r, outerPaint);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: r - r * 0.05),
      0.4,
      2.0,
      false,
      Paint()
        ..color = const Color(0xFFB87200)
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.10,
    );

    final ir = r * 0.72;
    final innerPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.2, -0.3),
        radius: 1.0,
        colors: const [Color(0xFFFFB830), Color(0xFFE07800)],
      ).createShader(Rect.fromCircle(center: center, radius: ir));
    canvas.drawCircle(center, ir, innerPaint);

    _drawStar(canvas, center, ir * 0.58, ir * 0.28, const Color(0xFFFFD966));
  }

  void _drawStar(
    Canvas canvas,
    Offset c,
    double outerR,
    double innerR,
    Color color,
  ) {
    const n = 5;
    final path = Path();
    for (int i = 0; i < n * 2; i++) {
      final rad = (i * 3.141592653589793 / n) - 3.141592653589793 / 2;
      final rr = i.isEven ? outerR : innerR;
      final x = c.dx + rr * _cos(rad);
      final y = c.dy + rr * _sin(rad);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, Paint()..color = color);
  }

  static double _cos(double x) {
    x = x % (2 * 3.141592653589793);
    double r = 1, t = 1;
    for (int i = 1; i <= 6; i++) {
      t *= -x * x / ((2 * i - 1) * (2 * i));
      r += t;
    }
    return r;
  }

  static double _sin(double x) {
    x = x % (2 * 3.141592653589793);
    double r = x, t = x;
    for (int i = 1; i <= 6; i++) {
      t *= -x * x / ((2 * i) * (2 * i + 1));
      r += t;
    }
    return r;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
