import 'package:flutter/material.dart';

class PremiumMembershipScreen extends StatelessWidget {
  const PremiumMembershipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  colors: [Color(0x99051025), Color(0xE6051025)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
              child: Column(
                children: [
                  _PremiumTopBar(onBack: () => Navigator.of(context).pop()),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: const [
                                _IntroText(),
                                SizedBox(height: 18),
                                _MembershipPlanCard(),
                                SizedBox(height: 14),
                                _EclipseOfferCard(),
                                SizedBox(height: 16),
                                _PersuasivePoints(),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        _JoinPremiumButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Premium satın alma ekranı yakında aktif olacak.',
                                ),
                              ),
                            );
                          },
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

class _PremiumTopBar extends StatelessWidget {
  const _PremiumTopBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back, color: Color(0xFFF2E9CF)),
        ),
        Expanded(
          child: Text(
            'Premium Üyelik',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: const Color(0xFFF2D28E),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 48),
      ],
    );
  }
}

class _IntroText extends StatelessWidget {
  const _IntroText();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Gökyüzü bu ay hızlı değişiyor. Premium ile yorumlarını herkesten önce al, kritik günlerde neye odaklanman gerektiğini net gör ve kararsız kaldığın anlarda adım adım rehberlik kazan.',
      textAlign: TextAlign.center,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(color: Colors.white, height: 1.4),
    );
  }
}

class _MembershipPlanCard extends StatelessWidget {
  const _MembershipPlanCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF3E3A62),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Text(
            'Premium Paketin',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            'Standart',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _EclipseOfferCard extends StatelessWidget {
  const _EclipseOfferCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF3E3A62),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF0DDAE),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'PREMIUM',
                style: TextStyle(
                  color: Color(0xFF2A184A),
                  fontSize: 10,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Ay Tutulması Geliyor',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Önümüzdeki günler duyguları hızlandıracak. Premium ile bu dönemi şansa bırakmadan, sadece sana özel yorumlar ve zamanlama önerileriyle yönet.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white70,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF2A184A),
                  Color(0xFF4D4369),
                  Color(0xFF2A184A),
                ],
              ),
            ),
            child: Text(
              'Şimdi Keşfet',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: const Color(0xFFF2D28E),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PersuasivePoints extends StatelessWidget {
  const _PersuasivePoints();

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(
      context,
    ).textTheme.bodyLarge?.copyWith(color: Colors.white, height: 1.35);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: const Color(0x2BFFFFFF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Neden şimdi premium?',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: const Color(0xFFF2D28E),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '• Günlük kişisel yorumlarınla belirsizliği azaltırsın.',
            style: style,
          ),
          const SizedBox(height: 6),
          Text(
            '• Önemli karar günlerinde net aksiyon planı alırsın.',
            style: style,
          ),
          const SizedBox(height: 6),
          Text(
            '• Erteledikçe kaçırdığın fırsatlar yerine güveni seçersin.',
            style: style,
          ),
        ],
      ),
    );
  }
}

class _JoinPremiumButton extends StatelessWidget {
  const _JoinPremiumButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF0DDAE),
          foregroundColor: const Color(0xFF1E1B3D),
          minimumSize: const Size.fromHeight(56),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Text(
          "Premium'a Katıl",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: const Color(0xFF1E1B3D),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
