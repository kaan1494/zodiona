import 'package:flutter/material.dart';

import '../pages/ruhsal_bag_analizi_page.dart';

class RuhsalBagCard extends StatelessWidget {
  const RuhsalBagCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const RuhsalBagAnaliziPage(),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xCC4A1A88), Color(0xB32A0E60)],
            ),
            border: Border.all(color: Colors.white24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Ruhsal Bağ Analizi',
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
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Sevdiklerinle arandaki ruhsal bağı keşfet. Numeroloji, doğum haritası ve karmik enerji analizi ile yüzde skoru ve kategori hesapla.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.82),
                  height: 1.45,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _etiket(context, '🔥 İkiz Alev'),
                  const SizedBox(width: 6),
                  _etiket(context, '💞 Ruh Eşi'),
                  const SizedBox(width: 6),
                  _etiket(context, '⚡ Karmik Bağ'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _etiket(BuildContext context, String metin) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withValues(alpha: 0.1),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        metin,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: Colors.white70, fontSize: 11),
      ),
    );
  }
}
