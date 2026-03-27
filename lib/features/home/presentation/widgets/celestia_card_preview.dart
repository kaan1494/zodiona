import 'package:flutter/material.dart';

import '../pages/tarot_card_page.dart';

class CelestiaCardPreview extends StatelessWidget {
  const CelestiaCardPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const TarotCardPage()));
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xFF0A0D2E).withValues(alpha: 0.55),
            border: Border.all(
              color: const Color(0xFFF2D9A6).withValues(alpha: 0.25),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              children: [
                // Başlık
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
                  child: Text(
                    'Gökyüzünün Fısıltısı',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFF2D9A6),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      shadows: [Shadow(color: Colors.black54, blurRadius: 8)],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Görsel tam boyutlu
                Image.asset(
                  'assets/tarot/tarotanasayfagörsel.png',
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
                const SizedBox(height: 10),
                // Alt yazı
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Aradığın cevapları yıldızlardan öğren',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.65),
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                // Buton
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 36,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2D9A6),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    'Yıldızlara Sor',
                    style: TextStyle(
                      color: Color(0xFF2A1A00),
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
