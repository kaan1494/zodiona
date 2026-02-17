import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../services/astro_api_service.dart';
import '../../../utils/zodiac.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 2;

  void _onTabSelected(int index) {
    if (_currentIndex == index) {
      return;
    }
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const _SectionPage(title: 'Takvim', icon: Icons.calendar_today_outlined),
      const _SectionPage(title: 'Kesfet', icon: Icons.explore_outlined),
      const _MainHomePage(),
      const _SectionPage(title: 'Uyum', icon: Icons.auto_awesome_outlined),
      const _SectionPage(title: 'Danisman', icon: Icons.support_agent_outlined),
    ];

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: _CosmicBackground()),
          Positioned.fill(
            child: IndexedStack(index: _currentIndex, children: pages),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                const Spacer(),
                Padding(
                  padding: EdgeInsets.zero,
                  child: _HomeBottomNav(
                    currentIndex: _currentIndex,
                    onTabSelected: _onTabSelected,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeBottomNav extends StatelessWidget {
  const _HomeBottomNav({
    required this.currentIndex,
    required this.onTabSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  @override
  Widget build(BuildContext context) {
    final inactiveStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: const Color(0xFF303644),
      fontWeight: FontWeight.w600,
      fontSize: 11.5,
    );
    final activeStyle = inactiveStyle?.copyWith(
      color: const Color(0xFF1B1F3B),
      fontWeight: FontWeight.w700,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final centerButtonSize = (constraints.maxWidth * 0.23).clamp(
          80.0,
          96.0,
        );
        final centerGap = centerButtonSize + 2;
        final barHeight = 74.0;
        final overlap = centerButtonSize * 0.36;

        return SizedBox(
          height: barHeight + overlap,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: barHeight,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.96),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 18,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: _NavItem(
                                icon: Icons.calendar_today_outlined,
                                label: 'Takvim',
                                textStyle: currentIndex == 0
                                    ? activeStyle
                                    : inactiveStyle,
                                iconColor: currentIndex == 0
                                    ? const Color(0xFF1B1F3B)
                                    : const Color(0xFF2D3142),
                                onTap: () => onTabSelected(0),
                              ),
                            ),
                            Expanded(
                              child: _NavItem(
                                icon: Icons.explore_outlined,
                                label: 'Kesfet',
                                textStyle: currentIndex == 1
                                    ? activeStyle
                                    : inactiveStyle,
                                iconColor: currentIndex == 1
                                    ? const Color(0xFF1B1F3B)
                                    : const Color(0xFF2D3142),
                                onTap: () => onTabSelected(1),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: centerGap),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: _NavItem(
                                icon: Icons.auto_awesome_outlined,
                                label: 'Uyum',
                                textStyle: currentIndex == 3
                                    ? activeStyle
                                    : inactiveStyle,
                                iconColor: currentIndex == 3
                                    ? const Color(0xFF1B1F3B)
                                    : const Color(0xFF2D3142),
                                onTap: () => onTabSelected(3),
                              ),
                            ),
                            Expanded(
                              child: _NavItem(
                                icon: Icons.support_agent_outlined,
                                label: 'Danisman',
                                textStyle: currentIndex == 4
                                    ? activeStyle
                                    : inactiveStyle,
                                iconColor: currentIndex == 4
                                    ? const Color(0xFF1B1F3B)
                                    : const Color(0xFF2D3142),
                                onTap: () => onTabSelected(4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 0,
                child: IgnorePointer(
                  child: SizedBox(
                    height: barHeight,
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: _ActiveItemShadow(
                                  visible: currentIndex == 0,
                                ),
                              ),
                              Expanded(
                                child: _ActiveItemShadow(
                                  visible: currentIndex == 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: centerGap),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: _ActiveItemShadow(
                                  visible: currentIndex == 3,
                                ),
                              ),
                              Expanded(
                                child: _ActiveItemShadow(
                                  visible: currentIndex == 4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: centerButtonSize * 0.24,
                child: _ActiveCenterShadow(
                  visible: currentIndex == 2,
                  width: centerButtonSize * 0.56,
                  height: barHeight * 0.9,
                ),
              ),
              Positioned(
                top: 0,
                child: _CenterNavButton(
                  size: centerButtonSize,
                  isActive: currentIndex == 2,
                  onTap: () => onTabSelected(2),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CenterNavButton extends StatelessWidget {
  const _CenterNavButton({
    required this.size,
    required this.onTap,
    required this.isActive,
  });

  final double size;
  final VoidCallback onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            const BoxShadow(
              color: Color(0x33000000),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
            if (isActive)
              const BoxShadow(
                color: Color(0x401B1F3B),
                blurRadius: 14,
                spreadRadius: 1,
              ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(size * 0.012),
          child: ClipOval(
            child: Image.asset(
              'assets/onboarding/home_page_logo.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.textStyle,
    required this.iconColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final TextStyle? textStyle;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(height: 3),
          Text(
            label,
            style: textStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ActiveItemShadow extends StatelessWidget {
  const _ActiveItemShadow({required this.visible});

  final bool visible;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      opacity: visible ? 1 : 0,
      child: Container(
        margin: const EdgeInsets.fromLTRB(2, 4, 2, 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0x4A1B1F3B), Color(0x001B1F3B)],
          ),
        ),
      ),
    );
  }
}

class _ActiveCenterShadow extends StatelessWidget {
  const _ActiveCenterShadow({
    required this.visible,
    required this.width,
    required this.height,
  });

  final bool visible;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      opacity: visible ? 1 : 0,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0x441B1F3B), Color(0x001B1F3B)],
          ),
        ),
      ),
    );
  }
}

class _MainHomePage extends StatelessWidget {
  const _MainHomePage();

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: _HomeUserHeader(),
      ),
    );
  }
}

class _HomeUserHeader extends StatefulWidget {
  const _HomeUserHeader();

  @override
  State<_HomeUserHeader> createState() => _HomeUserHeaderState();
}

class _HomeUserHeaderState extends State<_HomeUserHeader> {
  final _astroApiService = const AstroApiService();
  bool _isRefreshingAstro = false;
  String? _lastAstroRequestKey;

  DateTime? _buildLocalBirthDateTime({
    required DateTime? birthDate,
    required String? birthTime,
  }) {
    if (birthDate == null || birthTime == null || birthTime.trim().isEmpty) {
      return null;
    }

    final parts = birthTime.trim().split(':');
    if (parts.length != 2) {
      return null;
    }

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) {
      return null;
    }
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      return null;
    }

    return DateTime(
      birthDate.year,
      birthDate.month,
      birthDate.day,
      hour,
      minute,
    );
  }

  double? _asDouble(dynamic value) {
    if (value is double) {
      return value;
    }
    if (value is int) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  Future<void> _refreshAstro({
    required String uid,
    required String requestKey,
    required DateTime localBirthDateTime,
    required double latitude,
    required double longitude,
  }) async {
    if (_isRefreshingAstro) {
      return;
    }

    setState(() {
      _isRefreshingAstro = true;
      _lastAstroRequestKey = requestKey;
    });

    try {
      final astro = await _astroApiService.calculate(
        localBirthDateTime: localBirthDateTime,
        latitude: latitude,
        longitude: longitude,
      );

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'zodiacSign': astro.sunSign,
        'moonSign': astro.moonSign,
        'risingSign': astro.ascendant,
        'birthTimezone': astro.timezone,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {
      // Sessiz gec: ekranda yukleniyor bilgisi kalir, sonraki acilista tekrar dener.
    } finally {
      if (mounted) {
        setState(() => _isRefreshingAstro = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final stream = uid == null
        ? null
        : FirebaseFirestore.instance.collection('users').doc(uid).snapshots();

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snapshot) {
        final data = snapshot.data?.data() ?? <String, dynamic>{};

        final name = (data['name'] as String?)?.trim();
        final fallbackName = FirebaseAuth.instance.currentUser?.displayName
            ?.trim();
        final resolvedName = (name?.isNotEmpty ?? false)
            ? name!
            : ((fallbackName?.isNotEmpty ?? false)
                  ? fallbackName!
                  : 'Kullanici');

        final timestamp = data['birthDate'];
        final birthDate = timestamp is Timestamp ? timestamp.toDate() : null;
        final sunSignRaw = (data['zodiacSign'] as String?)?.trim();
        final sunSign = (sunSignRaw?.isNotEmpty ?? false)
            ? sunSignRaw!
            : (birthDate != null ? calculateZodiac(birthDate) : 'Bilinmiyor');

        final moonSignRaw = (data['moonSign'] as String?)?.trim();
        final hasMoonSign = moonSignRaw?.isNotEmpty ?? false;
        final moonSign = hasMoonSign ? moonSignRaw! : 'Bilinmiyor';

        final risingSignRaw = (data['risingSign'] as String?)?.trim();
        final hasRisingSign = risingSignRaw?.isNotEmpty ?? false;
        final risingSign = hasRisingSign ? risingSignRaw! : 'Bilinmiyor';

        final birthTime = (data['birthTime'] as String?)?.trim();
        final lat = _asDouble(data['birthPlaceLat']);
        final lon = _asDouble(data['birthPlaceLon']);
        final localBirthDateTime = _buildLocalBirthDateTime(
          birthDate: birthDate,
          birthTime: birthTime,
        );

        final canRefreshAstro =
            uid != null &&
            localBirthDateTime != null &&
            lat != null &&
            lon != null;
        final needsAstroRefresh = canRefreshAstro && (!hasMoonSign || !hasRisingSign);
        final requestKey = canRefreshAstro
            ? '${localBirthDateTime!.toIso8601String()}|$lat|$lon'
            : null;

        if (needsAstroRefresh &&
            !_isRefreshingAstro &&
            requestKey != null &&
            requestKey != _lastAstroRequestKey) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _refreshAstro(
              uid: uid!,
              requestKey: requestKey,
              localBirthDateTime: localBirthDateTime!,
              latitude: lat!,
              longitude: lon!,
            );
          });
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Merhaba, $resolvedName',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _SignChip(icon: '☉', text: _displaySign(sunSign)),
                      _SignChip(
                        icon: '☾',
                        text: _displaySign(
                          hasMoonSign
                              ? moonSign
                              : (needsAstroRefresh || _isRefreshingAstro
                                    ? 'Yukleniyor...'
                                    : moonSign),
                        ),
                      ),
                      _SignChip(
                        icon: '↑',
                        text: _displaySign(
                          hasRisingSign
                              ? risingSign
                              : (needsAstroRefresh || _isRefreshingAstro
                                    ? 'Yukleniyor...'
                                    : risingSign),
                        ),
                      ),
                    ],
                  ),
                  if (needsAstroRefresh || _isRefreshingAstro) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Astro bilgileri yukleniyor...',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white60,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white70),
              ),
              child: const Icon(Icons.person_outline, color: Colors.white70),
            ),
          ],
        );
      },
    );
  }
}

class _SignChip extends StatelessWidget {
  const _SignChip({required this.icon, required this.text});

  final String icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$icon $text',
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Colors.white70,
        fontWeight: FontWeight.w600,
      ),
    );
  }
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
    case 'Bilinmiyor':
      return 'Bilinmiyor';
    default:
      return value;
  }
}

class _SectionPage extends StatelessWidget {
  const _SectionPage({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: Colors.white70),
            const SizedBox(height: 12),
            Text(
              '$title Sayfasi',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CosmicBackground extends StatelessWidget {
  const _CosmicBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/onboarding/home_page.png',
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            repeat: ImageRepeat.repeatY,
          ),
        ),
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0x020B1026), Color(0x080B1026), Color(0x101B1F3B)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.6, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
