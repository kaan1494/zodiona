import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Kendi animasyon controller'larını yöneten, bağımsız kozmik gezegen ikonu.
/// Hem [KozmikRehberCard] hem [KozmikRehberPage] tarafından kullanılır.
class CosmicOrbIcon extends StatefulWidget {
  const CosmicOrbIcon({super.key, this.size = 38});

  final double size;

  @override
  State<CosmicOrbIcon> createState() => _CosmicOrbIconState();
}

class _CosmicOrbIconState extends State<CosmicOrbIcon>
    with TickerProviderStateMixin {
  late final AnimationController _orbitCtrl;
  late final AnimationController _glowCtrl;
  late final Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();
    _orbitCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _glowAnim = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _orbitCtrl.dispose();
    _glowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_orbitCtrl, _glowCtrl]),
      builder: (_, _) => SizedBox(
        width: widget.size,
        height: widget.size,
        child: CustomPaint(
          painter: _CosmicOrbPainter(
            rotation: _orbitCtrl.value,
            glowOpacity: _glowAnim.value,
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// CustomPainter
// ──────────────────────────────────────────────────────────────

class _CosmicOrbPainter extends CustomPainter {
  const _CosmicOrbPainter({required this.rotation, required this.glowOpacity});

  final double rotation;
  final double glowOpacity;

  static const double _tilt = -0.40;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.36;

    // 1 ─ Dış nabız parlaması
    canvas.drawCircle(
      Offset(cx, cy),
      r * 1.35,
      Paint()
        ..color = const Color(0xFFB388FF).withValues(alpha: glowOpacity * 0.38)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7),
    );

    // 2 ─ Yörünge halkası (gezegen arkasında)
    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(_tilt);
    final orbitW = r * 1.78;
    final orbitH = r * 0.58;
    final backPath = Path();
    backPath.addArc(
      Rect.fromCenter(
        center: Offset.zero,
        width: orbitW * 2,
        height: orbitH * 2,
      ),
      0,
      math.pi,
    );
    canvas.drawPath(
      backPath,
      Paint()
        ..color = const Color(0xFFF2D293).withValues(alpha: 0.22)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
    canvas.restore();

    // 3 ─ Gezegen gövdesi
    canvas.drawCircle(
      Offset(cx, cy),
      r,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.38, -0.42),
          radius: 1.0,
          colors: const [
            Color(0xFFBE8FFF),
            Color(0xFF6B28D4),
            Color(0xFF1E0754),
          ],
          stops: const [0.0, 0.55, 1.0],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r)),
    );

    // 4 ─ Gezegen kenar çizgisi
    canvas.drawCircle(
      Offset(cx, cy),
      r,
      Paint()
        ..color = const Color(0xFFF2D293).withValues(alpha: 0.40)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );

    // 5 ─ Sol üst parlak yansıma
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx - r * 0.26, cy - r * 0.30),
        width: r * 0.52,
        height: r * 0.26,
      ),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.26)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5),
    );

    // 6 ─ Gezegen yüzeyi: iki ince band
    final clipPath = Path()
      ..addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r - 0.5));
    canvas.save();
    canvas.clipPath(clipPath);
    canvas.drawRect(
      Rect.fromLTWH(cx - r, cy - r * 0.18, r * 2, r * 0.14),
      Paint()..color = const Color(0xFF9B6FE0).withValues(alpha: 0.45),
    );
    canvas.drawRect(
      Rect.fromLTWH(cx - r, cy + r * 0.22, r * 2, r * 0.10),
      Paint()..color = const Color(0xFF9B6FE0).withValues(alpha: 0.30),
    );
    canvas.restore();

    // 7 ─ Yörünge halkası (gezegen önünde) + dönen ay
    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(_tilt);
    final frontPath = Path();
    frontPath.addArc(
      Rect.fromCenter(
        center: Offset.zero,
        width: orbitW * 2,
        height: orbitH * 2,
      ),
      math.pi,
      math.pi,
    );
    canvas.drawPath(
      frontPath,
      Paint()
        ..color = const Color(0xFFF2D293).withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    // 8 ─ Dönen ay
    final moonAngle = rotation * math.pi * 2;
    final moonX = orbitW * math.cos(moonAngle);
    final moonY = orbitH * math.sin(moonAngle);
    canvas.drawCircle(
      Offset(moonX, moonY),
      3.8,
      Paint()
        ..color = const Color(0xFFFFF5CC).withValues(alpha: glowOpacity * 0.65)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0),
    );
    canvas.drawCircle(
      Offset(moonX, moonY),
      2.2,
      Paint()..color = const Color(0xFFFFF8DC),
    );
    canvas.restore();

    // 9 ─ Merkez 4-köşeli yıldız
    _drawSparkle(canvas, Offset(cx, cy), r * 0.20, glowOpacity);
  }

  void _drawSparkle(Canvas canvas, Offset c, double s, double glow) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.45 + 0.55 * glow)
      ..style = PaintingStyle.fill;
    final path = Path();
    for (int i = 0; i < 8; i++) {
      final angle = i * math.pi / 4 - math.pi / 2;
      final dist = i.isEven ? s : s * 0.38;
      final x = c.dx + dist * math.cos(angle);
      final y = c.dy + dist * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CosmicOrbPainter old) =>
      old.rotation != rotation || old.glowOpacity != glowOpacity;
}
