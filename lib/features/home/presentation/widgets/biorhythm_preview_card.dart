import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../domain/biorhythm_engine.dart';
import '../pages/biorhythm_detail_page.dart';

class BiorhythmPreviewCard extends StatelessWidget {
  const BiorhythmPreviewCard({super.key});

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
        final birthDateRaw = data['birthDate'];
        final birthDate = birthDateRaw is Timestamp
            ? birthDateRaw.toDate()
            : null;

        final today = birthDate == null
            ? null
            : BiorhythmEngine.forDate(
                birthDate: birthDate,
                targetDate: DateTime.now(),
              );

        final emotional = today?.emotional ?? 0;
        final physical = today?.physical ?? 0;
        final intellectual = today?.intellectual ?? 0;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () {
              if (birthDate == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Biyoritim için doğum tarihi bilgisi gerekli.',
                    ),
                  ),
                );
                return;
              }

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      BiorhythmDetailPage(birthDate: birthDate, userKey: uid),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xCC3D1E7A), Color(0xB32E1568)],
                ),
                border: Border.all(color: Colors.white24),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      Text(
                        'Biyoritim',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: const Color(0xFFF2D293),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFFEADDB1),
                        size: 24,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _MiniCycle(
                          label: 'Duygusal',
                          value: emotional,
                          color: const Color(0xFFFFB68E),
                        ),
                      ),
                      Expanded(
                        child: _MiniCycle(
                          label: 'Fiziksel',
                          value: physical,
                          color: const Color(0xFF7BD6E8),
                        ),
                      ),
                      Expanded(
                        child: _MiniCycle(
                          label: 'Zihinsel',
                          value: intellectual,
                          color: const Color(0xFF7FB3FF),
                        ),
                      ),
                    ],
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

class _MiniCycle extends StatelessWidget {
  const _MiniCycle({
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
        Container(
          width: 62,
          height: 62,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(
              value >= 0 ? '%$value' : '%$value',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.92),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
