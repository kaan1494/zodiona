import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../admin/presentation/admin_access_gate_screen.dart';
import '../../auth/presentation/auth_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _onMenuTap(BuildContext context, String title) async {
    if (title == 'Admin Paneli') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const AdminAccessGateScreen()),
      );
      return;
    }

    if (title == 'Cikis Yap') {
      await FirebaseAuth.instance.signOut();
      if (!context.mounted) {
        return;
      }
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AuthScreen()),
        (route) => false,
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$title yakinda eklenecek.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final userStream = uid == null
        ? null
        : FirebaseFirestore.instance.collection('users').doc(uid).snapshots();

    return Scaffold(
      body: Stack(
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
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x11000000), Color(0x440B1026), Color(0xCC0B1026)],
                ),
              ),
            ),
          ),
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: userStream,
            builder: (context, snapshot) {
              final raw = snapshot.data?.data() ?? <String, dynamic>{};
              final model = _ProfileModel.fromMap(raw);

              return SafeArea(
                child: MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: const TextScaler.linear(0.88)),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(14, 4, 18, 20),
                    children: [
                      _TopHeader(model: model),
                      const SizedBox(height: 10),
                      _AstroInfoCard(model: model),
                      const SizedBox(height: 12),
                      const _ThreeShortcutRow(),
                      const SizedBox(height: 12),
                      _MenuCard(onTap: (title) => _onMenuTap(context, title)),
                      const SizedBox(height: 12),
                      const _CreamActionCard(
                        title: 'Arkadas Davet Et',
                        icon: Icons.auto_awesome,
                      ),
                      const SizedBox(height: 10),
                      const _CreamActionCard(
                        title: 'Yorum Yap',
                        icon: Icons.bubble_chart,
                      ),
                      const SizedBox(height: 10),
                      const _CreamActionCard(
                        title: 'Widget',
                        icon: Icons.dashboard,
                      ),
                      const SizedBox(height: 12),
                      const _PremiumCard(),
                      const SizedBox(height: 14),
                      const _ContactCard(),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProfileModel {
  const _ProfileModel({
    required this.name,
    required this.birthInfo,
    required this.sunSign,
    required this.moonSign,
    required this.risingSign,
    required this.risingRuler,
    required this.luckyDay,
    required this.luckyColor,
    required this.luckyStone,
    required this.luckyNumber,
  });

  final String name;
  final String birthInfo;
  final String sunSign;
  final String moonSign;
  final String risingSign;
  final String risingRuler;
  final String luckyDay;
  final String luckyColor;
  final String luckyStone;
  final String luckyNumber;

  factory _ProfileModel.fromMap(Map<String, dynamic> data) {
    String normalizeSign(String? sign) {
      final value = (sign ?? '').trim();
      if (value.isEmpty || value == 'Bilinmiyor') {
        return 'Yukleniyor...';
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
        default:
          return value;
      }
    }

    final name = ((data['name'] as String?)?.trim().isNotEmpty ?? false)
        ? (data['name'] as String).trim()
        : ((FirebaseAuth.instance.currentUser?.displayName?.trim().isNotEmpty ?? false)
              ? FirebaseAuth.instance.currentUser!.displayName!.trim()
              : 'Kullanici');

    final ts = data['birthDate'];
    final birthDate = ts is Timestamp ? ts.toDate() : null;
    final birthTime = (data['birthTime'] as String?)?.trim();
    final birthPlace = ((data['birthPlaceName'] as String?)?.trim().isNotEmpty ?? false)
        ? (data['birthPlaceName'] as String).trim()
        : ((data['birthPlace'] as String?)?.trim() ?? 'Konum Bilinmiyor');

    final dateText = birthDate == null
        ? 'Tarih Bilinmiyor'
        : '${birthDate.day.toString().padLeft(2, '0')} ${_monthName(birthDate.month)} ${birthDate.year}';
    final timeText = (birthTime?.isNotEmpty ?? false) ? birthTime! : '--:--';
    final birthInfo = '$dateText - $timeText - $birthPlace';

    final sun = normalizeSign((data['zodiacSign'] as String?)?.trim());
    final moon = normalizeSign((data['moonSign'] as String?)?.trim());
    final rising = normalizeSign((data['risingSign'] as String?)?.trim());

    final details = _signDetailsFor(sun);
    final ruler = _risingRulerFor(rising);

    return _ProfileModel(
      name: name,
      birthInfo: birthInfo,
      sunSign: sun,
      moonSign: moon,
      risingSign: rising,
      risingRuler: ruler,
      luckyDay: details.luckyDay,
      luckyColor: details.luckyColor,
      luckyStone: details.luckyStone,
      luckyNumber: details.luckyNumber,
    );
  }

  static String _monthName(int month) {
    const months = <int, String>{
      1: 'Ocak',
      2: 'Subat',
      3: 'Mart',
      4: 'Nisan',
      5: 'Mayis',
      6: 'Haziran',
      7: 'Temmuz',
      8: 'Agustos',
      9: 'Eylul',
      10: 'Ekim',
      11: 'Kasim',
      12: 'Aralik',
    };
    return months[month] ?? '-';
  }

  static _SignDetails _signDetailsFor(String sign) {
    const map = <String, _SignDetails>{
      'Koç': _SignDetails('Sali', 'Kirmizi', 'Yakut', '9'),
      'Boğa': _SignDetails('Cuma', 'Yesil', 'Zumrut', '6'),
      'İkizler': _SignDetails('Carsamba', 'Sari', 'Akik', '5'),
      'Yengeç': _SignDetails('Pazartesi', 'Gumus', 'Inci', '2'),
      'Aslan': _SignDetails('Pazar', 'Altin', 'Kehribar', '1'),
      'Başak': _SignDetails('Carsamba', 'Toprak', 'Safir', '5'),
      'Terazi': _SignDetails('Cuma', 'Pembe', 'Opal', '7'),
      'Akrep': _SignDetails('Sali', 'Bordo', 'Obsidyen', '8'),
      'Yay': _SignDetails('Persembe', 'Mor', 'Turkuaz', '3'),
      'Oğlak': _SignDetails('Cumartesi', 'Lacivert', 'Oniks', '4'),
      'Kova': _SignDetails('Cumartesi', 'Mavi', 'Ametist', '11'),
      'Balık': _SignDetails('Persembe', 'Deniz Yesili', 'Akuamarin', '12'),
    };
    return map[sign] ?? const _SignDetails('Persembe', 'Yesil', 'Kan Tasi', '5');
  }

  static String _risingRulerFor(String rising) {
    const map = <String, String>{
      'Koç': 'Mars',
      'Boğa': 'Venus',
      'İkizler': 'Merkur',
      'Yengeç': 'Ay',
      'Aslan': 'Gunes',
      'Başak': 'Merkur',
      'Terazi': 'Venus',
      'Akrep': 'Pluton',
      'Yay': 'Jupiter',
      'Oğlak': 'Saturn',
      'Kova': 'Uranus',
      'Balık': 'Neptun',
    };
    return map[rising] ?? 'Jupiter';
  }
}

class _SignDetails {
  const _SignDetails(this.luckyDay, this.luckyColor, this.luckyStone, this.luckyNumber);

  final String luckyDay;
  final String luckyColor;
  final String luckyStone;
  final String luckyNumber;
}

class _TopHeader extends StatelessWidget {
  const _TopHeader({required this.model});

  final _ProfileModel model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 2, 2, 0),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back, color: Color(0xFFF2E9CF)),
              ),
              Expanded(
                child: Text(
                  model.name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: const Color(0xFFF2D28E),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white54),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.ios_share_outlined, color: Colors.white70, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            model.birthInfo,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _AstroInfoCard extends StatelessWidget {
  const _AstroInfoCard({required this.model});

  final _ProfileModel model;

  @override
  Widget build(BuildContext context) {
    Widget info(String label, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Column(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: const Color(0xFFE9EEF9),
                fontWeight: FontWeight.w500,
                fontSize: 34 / 2,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xBB111C4A), Color(0xBB3A325E)],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                info('Gunes Burcu', model.sunSign),
                info('Ay Burcu', model.moonSign),
                info('Yukselen', model.risingSign),
                info('Yukselen Yoneticisi', model.risingRuler),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 58),
            child: Container(
              height: 104,
              width: 104,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE9C77E), width: 3),
                image: const DecorationImage(
                  image: AssetImage('assets/onboarding/home_page.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: const Icon(Icons.balance, color: Color(0xFF9FB4D8), size: 58),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                info('Sansli Gunun', model.luckyDay),
                info('Sansli Rengin', model.luckyColor),
                info('Sansli Tasin', model.luckyStone),
                info('Sansli Sayin', model.luckyNumber),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ThreeShortcutRow extends StatelessWidget {
  const _ThreeShortcutRow();

  @override
  Widget build(BuildContext context) {
    Widget item(IconData icon, String title) {
      return Expanded(
        child: Container(
          height: 112,
          decoration: BoxDecoration(
            color: const Color(0xFF3E3A62),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: const Color(0xFFF2D28E), size: 44),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        item(Icons.brightness_medium, 'Dogum Haritasi'),
        const SizedBox(width: 8),
        item(Icons.spa_outlined, 'Danismanliklar'),
        const SizedBox(width: 8),
        item(Icons.favorite_border, 'Favoriler'),
      ],
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({required this.onTap});

  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    const items = <String>[
      'Profilim',
      'Hesap Ayarlari',
      'Admin Paneli',
      'Premium Uyelik',
      'Promosyon Kodu Kullan',
      'Astopia Hakkinda',
      'Ne Uzerine Calisiyoruz',
      'Cikis Yap',
    ];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3E3A62),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            ListTile(
              title: Text(
                items[i],
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 34 / 2,
                ),
              ),
              trailing: const Icon(Icons.chevron_right, color: Colors.white70),
              onTap: () => onTap(items[i]),
            ),
            if (i != items.length - 1)
              Divider(
                color: Colors.white.withValues(alpha: 0.65),
                indent: 18,
                endIndent: 18,
                height: 1,
              ),
          ],
        ],
      ),
    );
  }
}

class _CreamActionCard extends StatelessWidget {
  const _CreamActionCard({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFFF2E8CF), Color(0xFFF0DDAE)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: const Color(0xFF113E6E),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Icon(icon, color: const Color(0xFF4E476D), size: 34),
        ],
      ),
    );
  }
}

class _PremiumCard extends StatelessWidget {
  const _PremiumCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF3E3A62),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFF0DDAE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text('PREMIUM', style: TextStyle(fontSize: 10, letterSpacing: 2)),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'Yeni Yil Geliyor',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Yeni firsatlar, yeni baslangiclar... 2026 senin icin neler getiriyor?',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [Color(0xFF2A184A), Color(0xFF4D4369), Color(0xFF2A184A)],
              ),
            ),
            child: Text(
              'Simdi Kesfet',
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

class _ContactCard extends StatelessWidget {
  const _ContactCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF4B0D68), Color(0xFF071E52)],
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFF0DDAE),
            ),
            child: const Icon(Icons.rocket_launch_outlined, color: Color(0xFF1E1B3D)),
          ),
          const SizedBox(height: 10),
          Text(
            'Bizimle Baglanti Kur',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: const Color(0xFFF2D28E),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sorularin, geri bildirimlerin veya karsilastigin her turlu sorunu buradan bizimle paylasabilirsin. Kozmik bilgisiyle donanmis ekibimiz, mesajini bekliyor ve mesajini en kisa surede yanitlayacaktir.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white70,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [Color(0xFF2A184A), Color(0xFF4D4369), Color(0xFF2A184A)],
              ),
            ),
            child: Text(
              'Bize Ulas',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: const Color(0xFFF2D28E),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              _SocialIcon(icon: Icons.camera_alt_outlined),
              SizedBox(width: 10),
              _SocialIcon(icon: Icons.close),
              SizedBox(width: 10),
              _SocialIcon(icon: Icons.music_note),
              SizedBox(width: 10),
              _SocialIcon(icon: Icons.play_arrow),
            ],
          ),
        ],
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  const _SocialIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.65),
      ),
      padding: const EdgeInsets.all(12),
      child: Icon(icon, color: const Color(0xFF1E1B3D)),
    );
  }
}
