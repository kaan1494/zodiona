import 'dart:async';

import 'package:flutter/material.dart';

import '../../../services/iap_service.dart';

class PremiumMembershipScreen extends StatefulWidget {
  const PremiumMembershipScreen({super.key});

  @override
  State<PremiumMembershipScreen> createState() =>
      _PremiumMembershipScreenState();
}

class _PremiumMembershipScreenState extends State<PremiumMembershipScreen> {
  int _selectedPlan = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080520),
      body: Stack(
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
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xBB040212), Color(0xF0050118)],
                  stops: [0.0, 0.55],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, color: Color(0xFFD4C5F0)),
                      ),
                      const Expanded(
                        child: Text(
                          'Zodiona Premium',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFF2D28E),
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const _HeroSection(),
                        const SizedBox(height: 28),
                        const _BenefitsList(),
                        const SizedBox(height: 28),
                        _PlanSelector(
                          selected: _selectedPlan,
                          onSelect: (i) => setState(() => _selectedPlan = i),
                        ),
                        const SizedBox(height: 20),
                        _CtaButton(planIndex: _selectedPlan),
                        const SizedBox(height: 12),
                        const _LegalNote(),
                      ],
                    ),
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

// ── Hero ─────────────────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(
              colors: [Color(0xFFFFD700), Color(0xFFA855F7), Color(0xFF3B0764)],
              stops: [0.0, 0.55, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFA855F7).withValues(alpha: 0.5),
                blurRadius: 28,
                spreadRadius: 4,
              ),
            ],
          ),
          child: const Center(
            child: Text(
              '✦',
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Gökyüzünün Tüm Sırları\nSeninle',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Her doğanın kendine özgü bir haritası var. Zodiona Premium ile senin haritanı tam anlamıyla oku, her günü bilinçli yönet ve evrenin sana sunduğu fırsatları kaçırma.',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.white60, height: 1.5),
        ),
      ],
    );
  }
}

// ── Özellik listesi ──────────────────────────────────────────────────────────

class _BenefitsList extends StatelessWidget {
  const _BenefitsList();

  static const _benefits = [
    (
      icon: '🪐',
      title: 'Doğum Haritasına Tam Erişim',
      sub:
          'Gezegenler, evler, açılar ve kişilik yorumlarının tamamını gör. Kendini tek bir bakışta daha derin tanı.',
    ),
    (
      icon: '📅',
      title: 'Takvimde Sınırsız Kişisel İçerik',
      sub:
          'Her güne özel astroloji rehberliği. Hangi günü enerjik, hangisini sakin geçireceğini önceden bil.',
    ),
    (
      icon: '💞',
      title: 'Sınırsız Uyumluluk Analizi',
      sub:
          'Sevgili, arkadaş, iş ortağı… Dilediğin kadar kişiyi ekle, tüm ilişkilerinin haritasını çıkar.',
    ),
    (
      icon: '🌟',
      title: 'Tarot Kartlarını Sınırsız Kullan',
      sub:
          'Bekleme süresi olmadan istediğin zaman kart çek. Her seansı ayrı bir içgörüye dönüştür.',
    ),
    (
      icon: '🔮',
      title: 'Kozmik Rehber Öncelikli Erişim',
      sub:
          'Yapay zeka destekli danışmanın her zaman yanında. Günlük soruların için anlık, kişisel yanıtlar al.',
    ),
    (
      icon: '✨',
      title: 'Tüm Premium İçerikler',
      sub:
          'Derin makaleler, rüya yorumları, ruhsal analizler ve daha fazlası — hepsi sınırsız.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF3D1E7A).withValues(alpha: 0.55),
            const Color(0xFF1E0850).withValues(alpha: 0.55),
          ],
        ),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Premium'da seni neler bekliyor?",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFFF2D28E),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          ..._benefits.map(
            (b) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(b.icon, style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          b.title,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          b.sub,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.white54, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Plan seçici ──────────────────────────────────────────────────────────────

class _PlanInfo {
  const _PlanInfo({
    required this.label,
    required this.price,
    required this.sub,
    this.badge,
    this.monthlyEquiv,
  });
  final String label;
  final String price;
  final String sub;
  final String? badge;
  final String? monthlyEquiv;
}

const _plans = [
  _PlanInfo(label: 'Aylık', price: '₺75', sub: 'ay', monthlyEquiv: '₺75 / ay'),
  _PlanInfo(
    label: '6 Aylık',
    price: '₺390',
    sub: '6 ay',
    badge: '%13 tasarruf',
    monthlyEquiv: '₺65 / ay',
  ),
  _PlanInfo(
    label: 'Yıllık',
    price: '₺550',
    sub: 'yıl',
    badge: '%39 tasarruf',
    monthlyEquiv: '₺46 / ay',
  ),
];

class _PlanSelector extends StatelessWidget {
  const _PlanSelector({required this.selected, required this.onSelect});

  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Plan Seç',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: const Color(0xFFF2D28E),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(_plans.length, (i) {
          final plan = _plans[i];
          final isSelected = selected == i;
          return GestureDetector(
            onTap: () => onSelect(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [Color(0xFF7C3AED), Color(0xFF4C1D95)],
                      )
                    : null,
                color: isSelected ? null : const Color(0xFF1E1040),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFA78BFA)
                      : Colors.white.withValues(alpha: 0.1),
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.white38,
                        width: 2,
                      ),
                      color: isSelected ? Colors.white : Colors.transparent,
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            size: 12,
                            color: Color(0xFF7C3AED),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              plan.label,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                            if (plan.badge != null) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.white.withValues(alpha: 0.2)
                                      : const Color(
                                          0xFF7C3AED,
                                        ).withValues(alpha: 0.35),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  plan.badge!,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFFD8B4FE),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (plan.monthlyEquiv != null)
                          Text(
                            plan.monthlyEquiv!,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white60
                                  : Colors.white38,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        plan.price,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFFD8B4FE),
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '/ ${plan.sub}',
                        style: TextStyle(
                          color: isSelected ? Colors.white54 : Colors.white30,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

// ── CTA butonu ───────────────────────────────────────────────────────────────

class _CtaButton extends StatefulWidget {
  const _CtaButton({required this.planIndex});

  final int planIndex;

  @override
  State<_CtaButton> createState() => _CtaButtonState();
}

class _CtaButtonState extends State<_CtaButton> {
  bool _loading = false;
  StreamSubscription<IapResult>? _iapSub;

  static const _planKeys = ['monthly', '6months', 'yearly'];

  String get _label => switch (widget.planIndex) {
    0 => '₺75 ile Başla',
    1 => '₺390 ile 6 Aylık Al',
    _ => '₺550 ile Yıllık Al',
  };

  @override
  void dispose() {
    _iapSub?.cancel();
    super.dispose();
  }

  Future<void> _onTap() async {
    final iap = IapService.instance;

    if (!iap.isAvailable) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Mağaza şu an kullanılamıyor. Lütfen daha sonra tekrar dene.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xFF3D1E7A),
        ),
      );
      return;
    }

    final planKey = _planKeys[widget.planIndex];
    final product = iap.productForPremium(planKey);

    if (product == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Ürün bilgisi yüklenemedi. Lütfen tekrar dene.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xFF3D1E7A),
        ),
      );
      return;
    }

    setState(() => _loading = true);

    _iapSub?.cancel();
    _iapSub = iap.resultStream.listen((result) {
      if (!mounted) return;
      setState(() => _loading = false);

      if (result.isPremiumActivated) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              '🎉 Premium üyeliğin aktifleştirildi! Tüm özelliklere erişebilirsin.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Color(0xFF2D7A45),
            duration: Duration(seconds: 4),
          ),
        );
        Navigator.of(context).pop();
      } else if (result.isError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result.errorMessage ?? 'Bir hata oluştu.',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    });

    try {
      await iap.buyPremium(product);
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Satın alma başlatılamadı: $e',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _loading ? null : _onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: _loading
                ? [const Color(0xFF9E7A00), const Color(0xFF7A5500)]
                : [
                    const Color(0xFFFFD700),
                    const Color(0xFFF59E0B),
                    const Color(0xFFD97706),
                  ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFD700).withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: _loading
            ? const Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF1C0A00),
                    ),
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '✦',
                    style: TextStyle(fontSize: 16, color: Color(0xFF1C0A00)),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _label,
                    style: const TextStyle(
                      color: Color(0xFF1C0A00),
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ── Yasal not ────────────────────────────────────────────────────────────────

class _LegalNote extends StatelessWidget {
  const _LegalNote();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Abonelik otomatik yenilenir. İstediğin zaman iptal edebilirsin.',
      textAlign: TextAlign.center,
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: Colors.white24),
    );
  }
}

// ── Upsell bottom sheet ──────────────────────────────────────────────────────

class PremiumUpsellSheet extends StatelessWidget {
  const PremiumUpsellSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const PremiumUpsellSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A0848), Color(0xFF080520)],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    colors: [Color(0xFFFFD700), Color(0xFF7C3AED)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7C3AED).withValues(alpha: 0.5),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    '✦',
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Zodiona Premium',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color(0xFFF2D28E),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Evrenin tüm mesajlarını al',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.white54),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...[
            ('🪐', 'Doğum haritasına tam erişim'),
            ('📅', 'Her gün kişisel astroloji içeriği'),
            ('💞', 'Sınırsız uyumluluk analizi'),
            ('🌟', 'Tarot kartlarını sınırsız kullan'),
          ].map(
            (b) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Text(b.$1, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 10),
                  Text(
                    b.$2,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFF7C3AED).withValues(alpha: 0.2),
              border: Border.all(
                color: const Color(0xFF7C3AED).withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Aylık yalnızca ',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white54),
                ),
                Text(
                  '₺75',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: const Color(0xFFF2D28E),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '  ·  Yıllıkta ₺550',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white38),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const PremiumMembershipScreen(),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFD97706)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFD700).withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Text(
                  '✦  Premium\'u Keşfet',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF1C0A00),
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Daha sonra',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.white30),
            ),
          ),
        ],
      ),
    );
  }
}
