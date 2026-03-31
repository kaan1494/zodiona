import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../utils/zodiac.dart';
import '../../domain/periodic_horoscope_generator.dart';

class PeriodicHoroscopeSection extends StatefulWidget {
  const PeriodicHoroscopeSection({super.key});

  @override
  State<PeriodicHoroscopeSection> createState() =>
      _PeriodicHoroscopeSectionState();
}

class _PeriodicHoroscopeSectionState extends State<PeriodicHoroscopeSection> {
  HoroscopePeriod _selectedPeriod = HoroscopePeriod.weekly;
  static const double _cardHeight = 292;

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
        final now = DateTime.now();
        final name = _resolveName(data);
        final sign = _resolveSunSign(data);

        final personal = PeriodicHoroscopeGenerator.personalized(
          userKey: uid,
          userName: name,
          sunSign: sign,
          period: _selectedPeriod,
          now: now,
        );

        final general = PeriodicHoroscopeGenerator.general(
          sunSign: sign,
          period: _selectedPeriod,
          now: now,
        );

        final dateLabel = _periodDateLabel(_selectedPeriod, now);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _PeriodTabButton(
                    label: 'Haftalık Yorumlar',
                    selected: _selectedPeriod == HoroscopePeriod.weekly,
                    onTap: () {
                      setState(() => _selectedPeriod = HoroscopePeriod.weekly);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _PeriodTabButton(
                    label: 'Aylık Yorumlar',
                    selected: _selectedPeriod == HoroscopePeriod.monthly,
                    onTap: () {
                      setState(() => _selectedPeriod = HoroscopePeriod.monthly);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _PeriodTabButton(
                    label: 'Yıllık Yorumlar',
                    selected: _selectedPeriod == HoroscopePeriod.yearly,
                    onTap: () {
                      setState(() => _selectedPeriod = HoroscopePeriod.yearly);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = constraints.maxWidth * 0.86;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Row(
                    children: [
                      if (_selectedPeriod == HoroscopePeriod.weekly)
                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection('weekly_horoscopes_general')
                              .doc(sign)
                              .snapshots(),
                          builder: (ctx, adminSnap) {
                            final adminData = adminSnap.data?.data();
                            final adminTitle = adminData?['title'] as String?;
                            final adminBody = adminData?['body'] as String?;
                            final hasAdminContent =
                                (adminTitle?.isNotEmpty ?? false) &&
                                (adminBody?.isNotEmpty ?? false);
                            final displayTitle = hasAdminContent
                                ? adminTitle!
                                : general.title;
                            final displayBody = hasAdminContent
                                ? adminBody!
                                : general.body;
                            return _PeriodCommentCard(
                              width: cardWidth,
                              height: _cardHeight,
                              chipText: 'Genel',
                              dateText: dateLabel,
                              title: displayTitle,
                              body: displayBody,
                              trailingIcon: Icons.public,
                              onTap: () => _openFullCommentSheet(
                                title: displayTitle,
                                body: displayBody,
                                chipText: 'Genel',
                                dateText: dateLabel,
                              ),
                            );
                          },
                        )
                      else
                        _PeriodCommentCard(
                          width: cardWidth,
                          height: _cardHeight,
                          chipText: 'Genel',
                          dateText: dateLabel,
                          title: general.title,
                          body: general.body,
                          trailingIcon: Icons.public,
                          onTap: () => _openFullCommentSheet(
                            title: general.title,
                            body: general.body,
                            chipText: 'Genel',
                            dateText: dateLabel,
                          ),
                        ),
                      const SizedBox(width: 12),
                      _PeriodCommentCard(
                        width: cardWidth,
                        height: _cardHeight,
                        chipText: 'Sana Özel',
                        dateText: dateLabel,
                        title: personal.title,
                        body: personal.body,
                        trailingIcon: Icons.auto_awesome,
                        onTap: () => _openFullCommentSheet(
                          title: personal.title,
                          body: personal.body,
                          chipText: 'Sana Özel',
                          dateText: dateLabel,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                );
              },
            ),
          ],
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
      return 'Koç';
    }
    return _displaySign(calculateZodiac(birthDate));
  }

  String _displaySign(String value) {
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

  String _periodDateLabel(HoroscopePeriod period, DateTime now) {
    final date = DateTime(now.year, now.month, now.day);

    switch (period) {
      case HoroscopePeriod.weekly:
        final start = date.subtract(
          Duration(days: date.weekday - DateTime.monday),
        );
        final end = start.add(const Duration(days: 6));
        return '${start.day} ${_monthName(start.month)} - ${end.day} ${_monthName(end.month)}';
      case HoroscopePeriod.monthly:
        final start = DateTime(date.year, date.month, 1);
        final next = DateTime(date.year, date.month + 1, 1);
        return '${start.day} ${_monthName(start.month)} - ${next.day} ${_monthName(next.month)}';
      case HoroscopePeriod.yearly:
        final start = DateTime(date.year, 1, 1);
        final next = DateTime(date.year + 1, 1, 1);
        return '${start.day} ${_monthNameShort(start.month)} ${start.year} - ${next.day} ${_monthNameShort(next.month)} ${next.year}';
    }
  }

  String _monthName(int month) {
    const months = [
      'Ocak',
      'Şubat',
      'Mart',
      'Nisan',
      'Mayıs',
      'Haziran',
      'Temmuz',
      'Ağustos',
      'Eylül',
      'Ekim',
      'Kasım',
      'Aralık',
    ];
    return months[(month - 1) % 12];
  }

  String _monthNameShort(int month) {
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
    return months[(month - 1) % 12];
  }

  void _openFullCommentSheet({
    required String title,
    required String body,
    required String chipText,
    required String dateText,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return FractionallySizedBox(
          heightFactor: 0.86,
          child: Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF2E1870), Color(0xFF221258)],
              ),
              border: Border.all(color: Colors.white24),
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
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _TopChip(text: chipText),
                              _TopChip(text: dateText, compact: true),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Text(
                            title,
                            style: Theme.of(sheetContext).textTheme.titleLarge
                                ?.copyWith(
                                  color: const Color(0xFFF2D293),
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            body,
                            style: Theme.of(sheetContext).textTheme.bodyLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  height: 1.45,
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
}

class _PeriodTabButton extends StatelessWidget {
  const _PeriodTabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: selected ? const Color(0xFFF1D395) : Colors.transparent,
            border: Border.all(color: const Color(0xFFD9BC81)),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: selected ? const Color(0xFF1F2344) : Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _PeriodCommentCard extends StatelessWidget {
  const _PeriodCommentCard({
    required this.width,
    required this.height,
    required this.chipText,
    required this.dateText,
    required this.title,
    required this.body,
    required this.trailingIcon,
    required this.onTap,
  });

  final double width;
  final double height;
  final String chipText;
  final String dateText;
  final String title;
  final String body;
  final IconData trailingIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final baseTitleStyle = Theme.of(context).textTheme.titleLarge;
    final titleStyle = baseTitleStyle?.copyWith(
      color: const Color(0xFFF2D293),
      fontWeight: FontWeight.w500,
      fontSize: title.length > 28
          ? ((baseTitleStyle.fontSize ?? 30) - 3)
          : baseTitleStyle.fontSize,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: width,
          height: height,
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _TopChip(text: chipText),
                        _TopChip(text: dateText, compact: true),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.86),
                    ),
                    child: Icon(
                      trailingIcon,
                      color: const Color(0xFF3B4663),
                      size: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: titleStyle,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  body,
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    height: 1.32,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFFEADDB1),
                  size: 26,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopChip extends StatelessWidget {
  const _TopChip({required this.text, this.compact = false});

  final String text;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 5 : 6,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: const Color(0xFFF2E6FF),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: const Color(0xFF2A2E4A),
          fontWeight: FontWeight.w600,
          fontSize: compact
              ? ((Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14) - 1)
              : Theme.of(context).textTheme.bodyMedium?.fontSize,
        ),
      ),
    );
  }
}
