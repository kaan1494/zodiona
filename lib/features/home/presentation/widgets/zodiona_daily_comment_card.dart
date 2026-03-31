import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../utils/zodiac.dart';
import '../../domain/zodiona_daily_comment_generator.dart';

class ZodionaDailyCommentCard extends StatelessWidget {
  const ZodionaDailyCommentCard({super.key});

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
        final name = _resolveName(data);
        final sun = _resolveSunSign(data);
        final moon = _displaySign((data['moonSign'] as String?)?.trim());
        final rising = _displaySign((data['risingSign'] as String?)?.trim());

        final comment = ZodionaDailyCommentGenerator.generate(
          userName: name,
          sunSign: sun,
          moonSign: moon,
          risingSign: rising,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              comment.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
              ),
            ),
            const SizedBox(height: 10),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => _openFullComment(context, comment),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xCC3D1E7A), Color(0xB12E1568)],
                    ),
                    border: Border.all(color: Colors.white24),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x44000000),
                        blurRadius: 16,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${comment.focusTypeLabel} odağı: ${comment.focusSign}',
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(
                                    color: const Color(0xFFF7D57A),
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              comment.body,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    height: 1.35,
                                    fontWeight: FontWeight.w500,
                                  ),
                              maxLines: 8,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Icon(
                          Icons.chevron_right_rounded,
                          color: Color(0xFFEADDB1),
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _openFullComment(BuildContext context, ZodionaDailyComment comment) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return FractionallySizedBox(
          heightFactor: 0.86,
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF2E1870), Color(0xFF1E1058)],
              ),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white30,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 26),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comment.title,
                            style: Theme.of(sheetContext).textTheme.titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${comment.focusTypeLabel} odağı: ${comment.focusSign}',
                            style: Theme.of(sheetContext).textTheme.labelLarge
                                ?.copyWith(
                                  color: const Color(0xFFF7D57A),
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            comment.body,
                            style: Theme.of(sheetContext).textTheme.bodyLarge
                                ?.copyWith(
                                  color: Colors.white,
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
          ),
        );
      },
    );
  }

  String _resolveName(Map<String, dynamic> data) {
    final name = (data['name'] as String?)?.trim();
    final fallback = FirebaseAuth.instance.currentUser?.displayName?.trim();
    if (name != null && name.isNotEmpty) {
      return name;
    }
    if (fallback != null && fallback.isNotEmpty) {
      return fallback;
    }
    return 'Kullanıcı';
  }

  String _resolveSunSign(Map<String, dynamic> data) {
    final rawSun = (data['zodiacSign'] as String?)?.trim();
    if (rawSun != null && rawSun.isNotEmpty && rawSun != 'Bilinmiyor') {
      return _displaySign(rawSun);
    }
    final timestamp = data['birthDate'];
    final birthDate = timestamp is Timestamp ? timestamp.toDate() : null;
    if (birthDate == null) {
      return 'Bilinmiyor';
    }
    return _displaySign(calculateZodiac(birthDate));
  }

  String _displaySign(String? value) {
    if (value == null || value.trim().isEmpty || value == 'Yukleniyor...') {
      return 'Bilinmiyor';
    }
    switch (value) {
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
      default:
        return value;
    }
  }
}
