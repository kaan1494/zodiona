import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../profile/presentation/profile_screen.dart';
import 'pages/advisor_page.dart';
import 'pages/birth_chart_detail_page.dart';
import 'pages/calendar_page.dart';
import 'pages/compatibility_page.dart';
import 'pages/explore_page.dart';
import 'widgets/astro_story_strip.dart';
import 'widgets/biorhythm_preview_card.dart';
import 'widgets/birth_chart_preview_card.dart';
import 'widgets/daily_affirmation_card.dart';
import 'widgets/kozmik_rehber_card.dart';
import 'widgets/periodic_horoscope_section.dart';
import 'widgets/ruhsal_bag_card.dart';
import 'widgets/celestia_card_preview.dart';
import 'widgets/zodiona_daily_comment_card.dart';
import '../../../services/astro_api_service.dart';
import '../../../services/notification_service.dart';
import '../../../utils/zodiac.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 2;
  int _advisorInitialTabIndex = 0;
  int _advisorPageSeed = 0;

  @override
  void initState() {
    super.initState();
    NotificationService.initialize();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _openProfile() async {
    final result = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ProfileScreen()));

    if (!mounted) {
      return;
    }

    if (result == ProfileScreen.advisorCommentsRouteResult) {
      setState(() {
        _advisorInitialTabIndex = 2;
        _advisorPageSeed++;
        _currentIndex = 4;
      });
    }
  }

  void _onTabSelected(int index) {
    if (_currentIndex == index) {
      return;
    }
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const CalendarPage(header: _HomeUserHeader()),
      const ExplorePage(header: _HomeUserHeader()),
      const _MainHomePage(),
      const CompatibilityPage(),
      AdvisorPage(
        key: ValueKey('advisor-$_advisorPageSeed'),
        header: const _HomeUserHeader(),
        initialTabIndex: _advisorInitialTabIndex,
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: _CosmicBackground()),
          Positioned.fill(
            child: IndexedStack(index: _currentIndex, children: pages),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 12, right: 16),
                child: _TopRightProfileButton(onTap: _openProfile),
              ),
            ),
          ),
          SafeArea(
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
                                label: 'Keşfet',
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
                                label: 'Danışman',
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

  void _openBirthChart(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const BirthChartDetailPage()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 132),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _HomeUserHeader(),
              const SizedBox(height: 14),
              const AstroStoryStrip(),
              const SizedBox(height: 24),
              const ZodionaDailyCommentCard(),
              const SizedBox(height: 18),
              const KozmikRehberCard(),
              const SizedBox(height: 18),
              const RuhsalBagCard(),
              const SizedBox(height: 18),
              const DailyAffirmationCard(),
              const SizedBox(height: 18),
              BirthChartPreviewCard(onTap: () => _openBirthChart(context)),
              const SizedBox(height: 18),
              const PeriodicHoroscopeSection(),
              const SizedBox(height: 18),
              const BiorhythmPreviewCard(),
              const SizedBox(height: 18),
              const CelestiaCardPreview(),
            ],
          ),
        ),
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
  static const _astroRetryInterval = Duration(seconds: 15);
  bool _isRefreshingAstro = false;
  String? _lastAstroRequestKey;
  DateTime? _lastAstroAttemptAt;
  String? _lastAstroError;
  Timer? _astroRetryTicker;

  @override
  void initState() {
    super.initState();
    _astroRetryTicker = Timer.periodic(_astroRetryInterval, (_) {
      if (!mounted || _isRefreshingAstro) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _astroRetryTicker?.cancel();
    super.dispose();
  }

  bool _isKnownAstroValue(String? value) {
    final normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) {
      return false;
    }
    return normalized != 'Bilinmiyor' && normalized != 'Yukleniyor...';
  }

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

  String _capitalizeNameInitial(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return trimmed;
    }
    const trUpperMap = {
      'i': 'İ',
      'ı': 'I',
      'ş': 'Ş',
      'ğ': 'Ğ',
      'ü': 'Ü',
      'ö': 'Ö',
      'ç': 'Ç',
    };
    final first = trimmed[0];
    final upperFirst = trUpperMap[first] ?? first.toUpperCase();
    return '$upperFirst${trimmed.substring(1)}';
  }

  String _astroRetryStatusMessage() {
    final error = (_lastAstroError ?? '').toLowerCase();
    if (error.contains('xmlhttprequest') ||
        error.contains('cors') ||
        error.contains('failed host lookup') ||
        error.contains('clientexception')) {
      return 'Astro servisine ulasilamadi. Baglanti/izin kontrol edilerek tekrar deneniyor...';
    }
    return 'Astro bilgileri alinamadi. 15 sn sonra tekrar denenecek...';
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
      _lastAstroAttemptAt = DateTime.now();
      _lastAstroError = null;
    });

    String? refreshError;

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
        'venusSign': astro.venusSign,
        'birthTimezone': astro.timezone,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      refreshError = e.toString();
    } finally {
      if (mounted) {
        setState(() {
          _isRefreshingAstro = false;
          _lastAstroError = refreshError;
        });
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
        final resolvedName = _capitalizeNameInitial(
          (name?.isNotEmpty ?? false)
              ? name!
              : ((fallbackName?.isNotEmpty ?? false)
                    ? fallbackName!
                    : 'Kullanici'),
        );

        final timestamp = data['birthDate'];
        final birthDate = timestamp is Timestamp ? timestamp.toDate() : null;
        final sunSignRaw = (data['zodiacSign'] as String?)?.trim();
        final sunSign = (sunSignRaw?.isNotEmpty ?? false)
            ? sunSignRaw!
            : (birthDate != null ? calculateZodiac(birthDate) : 'Bilinmiyor');

        final moonSignRaw = (data['moonSign'] as String?)?.trim();
        final hasMoonSign = _isKnownAstroValue(moonSignRaw);
        final moonSign = hasMoonSign ? moonSignRaw! : 'Bilinmiyor';

        final risingSignRaw = (data['risingSign'] as String?)?.trim();
        final hasRisingSign = _isKnownAstroValue(risingSignRaw);
        final risingSign = hasRisingSign ? risingSignRaw! : 'Bilinmiyor';

        final venusSignRaw = (data['venusSign'] as String?)?.trim();
        final hasVenusSign = _isKnownAstroValue(venusSignRaw);

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
        final needsAstroRefresh =
            canRefreshAstro &&
            (!hasMoonSign || !hasRisingSign || !hasVenusSign);
        final requestKey = canRefreshAstro
            ? '${localBirthDateTime.toIso8601String()}|$lat|$lon'
            : null;
        final canRetryNow =
            _lastAstroAttemptAt == null ||
            DateTime.now().difference(_lastAstroAttemptAt!) >=
                _astroRetryInterval;

        if (needsAstroRefresh &&
            !_isRefreshingAstro &&
            requestKey != null &&
            (requestKey != _lastAstroRequestKey || canRetryNow)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _refreshAstro(
              uid: uid,
              requestKey: requestKey,
              localBirthDateTime: localBirthDateTime,
              latitude: lat,
              longitude: lon,
            );
          });
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.3,
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
                      _isRefreshingAstro
                          ? 'Astro bilgileri yukleniyor...'
                          : _astroRetryStatusMessage(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white60,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TopRightProfileButton extends StatelessWidget {
  const _TopRightProfileButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 36,
        width: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white70),
          color: Colors.black.withValues(alpha: 0.12),
        ),
        child: const Icon(Icons.person_outline, color: Colors.white70),
      ),
    );
  }
}

class _SignChip extends StatelessWidget {
  const _SignChip({required this.icon, required this.text});

  final String icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          icon,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: const Color(0xFFF2D28E),
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
        const SizedBox(width: 3),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.85),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
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
          ),
        ),
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0x550B1026),
                  Color(0xAA1B1F3B),
                  Color(0xFF0B0D1E),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.55, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
