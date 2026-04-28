import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../pages/kozmik_rehber_page.dart';
import 'cosmic_orb_icon.dart';

class KozmikRehberCard extends StatefulWidget {
  const KozmikRehberCard({super.key});

  @override
  State<KozmikRehberCard> createState() => _KozmikRehberCardState();
}

class _KozmikRehberCardState extends State<KozmikRehberCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) => CustomPaint(
        painter: _SpinningBorderPainter(rotation: _ctrl.value),
        child: child,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const KozmikRehberPage()),
            );
          },
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(2),
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xCC3D1E7A), Color(0xB32E1568)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      color: Color(0xFFF2D293),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Kozmik Rehber',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: const Color(0xFFF2D293),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFFEADDB1),
                      size: 24,
                    ),
                    const SizedBox(width: 4),
                    const CosmicOrbIcon(size: 38),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Yıldızlara sor, evrenden cevap al. Astrolojik sorularını yapay zeka destekli rehberinle keşfet.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    height: 1.45,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Dönen altın kenarlık – CustomPainter
// ──────────────────────────────────────────────────────────────

class _SpinningBorderPainter extends CustomPainter {
  const _SpinningBorderPainter({required this.rotation});

  final double rotation; // 0.0 – 1.0

  @override
  void paint(Canvas canvas, Size size) {
    const radius = Radius.circular(18);
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rRect = RRect.fromRectAndRadius(rect, radius);

    // Sabit ince altın kenarlık
    canvas.drawRRect(
      rRect,
      Paint()
        ..color = const Color(0x55F2D293)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    // Dönen parlak spot
    final sweepGradient = SweepGradient(
      colors: const [
        Colors.transparent,
        Colors.transparent,
        Color(0x00FFE97A),
        Color(0xCCFFE97A),
        Color(0xFFFFFFCC),
        Color(0xCCFFE97A),
        Color(0x00FFE97A),
        Colors.transparent,
        Colors.transparent,
      ],
      stops: const [0.0, 0.25, 0.38, 0.46, 0.50, 0.54, 0.62, 0.75, 1.0],
      transform: GradientRotation(rotation * math.pi * 2),
    );

    canvas.drawRRect(
      rRect,
      Paint()
        ..shader = sweepGradient.createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
  }

  @override
  bool shouldRepaint(_SpinningBorderPainter old) => old.rotation != rotation;
}
