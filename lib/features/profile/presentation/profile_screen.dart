import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../admin/presentation/admin_access_gate_screen.dart';
import '../../auth/presentation/auth_screen.dart';
import '../../home/presentation/pages/birth_chart_detail_page.dart';
import 'account_settings_screen.dart';
import 'contact_support_screen.dart';
import 'friend_invite_screen.dart';
import 'ne_uzerine_calisiyoruz_screen.dart';
import 'premium_membership_screen.dart';
import 'promo_code_redeem_screen.dart';
import 'profile_edit_screen.dart';
import 'zodiona_about_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String advisorCommentsRouteResult = 'advisor_comments';

  Future<void> _onAvatarTap(
    BuildContext context, {
    required String? uid,
    required String currentAvatarId,
  }) async {
    if (uid == null || uid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kullanıcı oturumu bulunamadı.')),
      );
      return;
    }

    final selectedAvatarId = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AvatarPickerSheet(initialAvatarId: currentAvatarId),
    );

    if (selectedAvatarId == null || selectedAvatarId == currentAvatarId) {
      return;
    }

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'avatarId': selectedAvatarId,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> _onMenuTap(BuildContext context, String title) async {
    if (title == 'Profilim') {
      await Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const ProfileEditScreen()));
      return;
    }

    if (title == 'Hesap Ayarları') {
      await Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const AccountSettingsScreen()));
      return;
    }

    if (title == 'Admin Paneli') {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const AdminAccessGateScreen()));
      return;
    }

    if (title == 'Premium Üyelik') {
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const PremiumMembershipScreen()),
      );
      return;
    }

    if (title == 'Promosyon Kodu Kullan') {
      await Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const PromoCodeRedeemScreen()));
      return;
    }

    if (title == 'Zodiona Hakkında') {
      await Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const ZodionaAboutScreen()));
      return;
    }

    if (title == 'Ne Üzerine Çalışıyoruz') {
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const NeUzerineCalisiyoruzScreen()),
      );
      return;
    }

    if (title == 'Çıkış Yap') {
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

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$title yakında eklenecek.')));
  }

  void _onShortcutTap(BuildContext context, String title) {
    if (title == 'Doğum Haritası') {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const BirthChartDetailPage()));
      return;
    }

    if (title == 'Danışmanlıklar') {
      Navigator.of(context).pop(advisorCommentsRouteResult);
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$title yakında eklenecek.')));
  }

  void _onCreamActionTap(BuildContext context, String title) {
    if (title == 'Arkadaş Davet Et') {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const FriendInviteScreen()));
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$title yakında eklenecek.')));
  }

  Future<void> _onContactTap(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ContactSupportScreen(entryPoint: 'profile_card'),
      ),
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
                  colors: [
                    Color(0x11000000),
                    Color(0x440B1026),
                    Color(0xCC0B1026),
                  ],
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
                      _AstroInfoCard(
                        model: model,
                        onAvatarTap: () => _onAvatarTap(
                          context,
                          uid: uid,
                          currentAvatarId: model.avatarId,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _ThreeShortcutRow(
                        onTap: (title) => _onShortcutTap(context, title),
                      ),
                      const SizedBox(height: 12),
                      _MenuCard(onTap: (title) => _onMenuTap(context, title)),
                      const SizedBox(height: 12),
                      _CreamActionCard(
                        title: 'Arkadaş Davet Et',
                        icon: Icons.auto_awesome,
                        onTap: () =>
                            _onCreamActionTap(context, 'Arkadaş Davet Et'),
                      ),
                      const SizedBox(height: 10),
                      _CreamActionCard(
                        title: 'Yorum Yap',
                        icon: Icons.bubble_chart,
                        onTap: () => _onCreamActionTap(context, 'Yorum Yap'),
                      ),
                      const SizedBox(height: 10),
                      _CreamActionCard(
                        title: 'Widget',
                        icon: Icons.dashboard,
                        onTap: () => _onCreamActionTap(context, 'Widget'),
                      ),
                      const SizedBox(height: 14),
                      _ContactCard(onContactTap: () => _onContactTap(context)),
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
    required this.avatarId,
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
  final String avatarId;

  factory _ProfileModel.fromMap(Map<String, dynamic> data) {
    String normalizeSign(String? sign) {
      final value = (sign ?? '').trim();
      if (value.isEmpty || value == 'Bilinmiyor') {
        return 'Yükleniyor...';
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

    final rawName = ((data['name'] as String?)?.trim().isNotEmpty ?? false)
        ? (data['name'] as String).trim()
        : ((FirebaseAuth.instance.currentUser?.displayName?.trim().isNotEmpty ??
                  false)
              ? FirebaseAuth.instance.currentUser!.displayName!.trim()
              : 'Kullanıcı');
    final name = _capitalizeFirstLetter(rawName);

    final ts = data['birthDate'];
    final birthDate = ts is Timestamp ? ts.toDate() : null;
    final birthTime = (data['birthTime'] as String?)?.trim();
    final birthPlace =
        ((data['birthPlaceName'] as String?)?.trim().isNotEmpty ?? false)
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
    final rawAvatarId = (data['avatarId'] as String?)?.trim();
    final avatarId = _isValidAvatarId(rawAvatarId)
        ? rawAvatarId!
        : _defaultAvatarIdForSign(sun);

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
      avatarId: avatarId,
    );
  }

  static String _monthName(int month) {
    const months = <int, String>{
      1: 'Ocak',
      2: 'Şubat',
      3: 'Mart',
      4: 'Nisan',
      5: 'Mayıs',
      6: 'Haziran',
      7: 'Temmuz',
      8: 'Ağustos',
      9: 'Eylül',
      10: 'Ekim',
      11: 'Kasım',
      12: 'Aralık',
    };
    return months[month] ?? '-';
  }

  static String _capitalizeFirstLetter(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return 'Kullanıcı';
    }

    final first = trimmed[0];
    final upperFirst = switch (first) {
      'i' => 'İ',
      'ı' => 'I',
      'ç' => 'Ç',
      'ğ' => 'Ğ',
      'ö' => 'Ö',
      'ş' => 'Ş',
      'ü' => 'Ü',
      _ => first.toUpperCase(),
    };

    return '$upperFirst${trimmed.substring(1)}';
  }

  static _SignDetails _signDetailsFor(String sign) {
    const map = <String, _SignDetails>{
      'Koç': _SignDetails('Salı', 'Kırmızı', 'Yakut', '9'),
      'Boğa': _SignDetails('Cuma', 'Yeşil', 'Zümrüt', '6'),
      'İkizler': _SignDetails('Çarşamba', 'Sarı', 'Akik', '5'),
      'Yengeç': _SignDetails('Pazartesi', 'Gümüş', 'İnci', '2'),
      'Aslan': _SignDetails('Pazar', 'Altın', 'Kehribar', '1'),
      'Başak': _SignDetails('Çarşamba', 'Toprak', 'Safir', '5'),
      'Terazi': _SignDetails('Cuma', 'Pembe', 'Opal', '7'),
      'Akrep': _SignDetails('Salı', 'Bordo', 'Obsidyen', '8'),
      'Yay': _SignDetails('Perşembe', 'Mor', 'Turkuaz', '3'),
      'Oğlak': _SignDetails('Cumartesi', 'Lacivert', 'Oniks', '4'),
      'Kova': _SignDetails('Cumartesi', 'Mavi', 'Ametist', '11'),
      'Balık': _SignDetails('Perşembe', 'Deniz Yeşili', 'Akuamarin', '12'),
    };
    return map[sign] ??
        const _SignDetails('Perşembe', 'Yeşil', 'Kan Taşı', '5');
  }

  static String _risingRulerFor(String rising) {
    const map = <String, String>{
      'Koç': 'Mars',
      'Boğa': 'Venus',
      'İkizler': 'Merkur',
      'Yengeç': 'Ay',
      'Aslan': 'Güneş',
      'Başak': 'Merkur',
      'Terazi': 'Venus',
      'Akrep': 'Pluton',
      'Yay': 'Jupiter',
      'Oğlak': 'Saturn',
      'Kova': 'Uranus',
      'Balık': 'Neptün',
    };
    return map[rising] ?? 'Jüpiter';
  }

  static bool _isValidAvatarId(String? id) {
    if (id == null || id.isEmpty) {
      return false;
    }
    return _avatarOptions.any((option) => option.id == id);
  }

  static String _defaultAvatarIdForSign(String sign) {
    const signToAvatar = <String, String>{
      'Koç': 'koc',
      'Boğa': 'boga',
      'İkizler': 'ikizler',
      'Yengeç': 'yengec',
      'Aslan': 'aslan',
      'Başak': 'basak',
      'Terazi': 'terazi',
      'Akrep': 'akrep',
      'Yay': 'yay',
      'Oğlak': 'oglak',
      'Kova': 'kova',
      'Balık': 'balik',
    };
    return signToAvatar[sign] ?? 'terazi';
  }
}

class _SignDetails {
  const _SignDetails(
    this.luckyDay,
    this.luckyColor,
    this.luckyStone,
    this.luckyNumber,
  );

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
                child: const Icon(
                  Icons.ios_share_outlined,
                  color: Colors.white70,
                  size: 18,
                ),
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
  const _AstroInfoCard({required this.model, required this.onAvatarTap});

  final _ProfileModel model;
  final VoidCallback onAvatarTap;

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
                info('Güneş Burcu', model.sunSign),
                info('Ay Burcu', model.moonSign),
                info('Yükselen', model.risingSign),
                info('Yükselen Yöneticisi', model.risingRuler),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 58),
            child: GestureDetector(
              onTap: onAvatarTap,
              child: Container(
                height: 104,
                width: 104,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE9C77E), width: 3),
                ),
                child: ClipOval(
                  child: _ProfileAvatarBadge(
                    avatarId: model.avatarId,
                    size: 98,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                info('Şanslı Günün', model.luckyDay),
                info('Şanslı Rengin', model.luckyColor),
                info('Şanslı Taşın', model.luckyStone),
                info('Şanslı Sayın', model.luckyNumber),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarPickerSheet extends StatefulWidget {
  const _AvatarPickerSheet({required this.initialAvatarId});

  final String initialAvatarId;

  @override
  State<_AvatarPickerSheet> createState() => _AvatarPickerSheetState();
}

class _AvatarPickerSheetState extends State<_AvatarPickerSheet> {
  late String _selectedAvatarId;

  @override
  void initState() {
    super.initState();
    _selectedAvatarId =
        _avatarOptions.any((option) => option.id == widget.initialAvatarId)
        ? widget.initialAvatarId
        : _avatarOptions.first.id;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(8, 8, 8, 8 + bottomInset),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 760),
          decoration: BoxDecoration(
            color: const Color(0xFFE8E8EC),
            borderRadius: BorderRadius.circular(26),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              children: [
                Row(
                  children: [
                    const Spacer(),
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pop(_selectedAvatarId),
                      child: Text(
                        'Tamam',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: const Color(0xFF161616),
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                SizedBox(
                  height: 124,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      _ProfileAvatarBadge(
                        avatarId: _selectedAvatarId,
                        size: 92,
                      ),
                      Positioned(
                        top: 10,
                        right: 8,
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.withValues(alpha: 0.75),
                          ),
                          child: IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white70,
                            ),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDFDFE2),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Avatarını Seç',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: const Color(0xFF232323),
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: GridView.builder(
                            itemCount: _avatarOptions.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 1,
                                ),
                            itemBuilder: (context, index) {
                              final option = _avatarOptions[index];
                              final selected = option.id == _selectedAvatarId;
                              return GestureDetector(
                                onTap: () {
                                  setState(() => _selectedAvatarId = option.id);
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: selected
                                          ? const Color(0xFFE2C27D)
                                          : Colors.transparent,
                                      width: 3,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(2),
                                  child: _ProfileAvatarBadge(
                                    avatarId: option.id,
                                    size: 88,
                                  ),
                                ),
                              );
                            },
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
      ),
    );
  }
}

class _ProfileAvatarBadge extends StatelessWidget {
  const _ProfileAvatarBadge({required this.avatarId, required this.size});

  final String avatarId;
  final double size;

  @override
  Widget build(BuildContext context) {
    final option = _avatarOptions.firstWhere(
      (item) => item.id == avatarId,
      orElse: () => _avatarOptions.first,
    );

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF08193F),
      ),
      child: ClipOval(
        child: Image.asset(
          option.assetPath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: const Color(0xFF0E2152),
              alignment: Alignment.center,
              child: Icon(
                Icons.person,
                color: Colors.white70,
                size: size * 0.5,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AvatarOption {
  const _AvatarOption(this.id, this.assetPath);

  final String id;
  final String assetPath;
}

const List<_AvatarOption> _avatarOptions = <_AvatarOption>[
  _AvatarOption('kova', 'assets/burclar/kova.png'),
  _AvatarOption('balik', 'assets/burclar/balık.png'),
  _AvatarOption('terazi', 'assets/burclar/terazi.png'),
  _AvatarOption('aslan', 'assets/burclar/aslan.png'),
  _AvatarOption('ikizler', 'assets/burclar/ikizler.png'),
  _AvatarOption('oglak', 'assets/burclar/oglak.png'),
  _AvatarOption('yengec', 'assets/burclar/yengec.png'),
  _AvatarOption('koc', 'assets/burclar/koc.png'),
  _AvatarOption('yay', 'assets/burclar/yay.png'),
  _AvatarOption('akrep', 'assets/burclar/akrep.png'),
  _AvatarOption('boga', 'assets/burclar/boga.png'),
  _AvatarOption('basak', 'assets/burclar/basak.png'),
];

class _ThreeShortcutRow extends StatelessWidget {
  const _ThreeShortcutRow({required this.onTap});

  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    Widget item(IconData icon, String title) {
      return Expanded(
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => onTap(title),
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
        ),
      );
    }

    return Row(
      children: [
        item(Icons.brightness_medium, 'Doğum Haritası'),
        const SizedBox(width: 8),
        item(Icons.spa_outlined, 'Danışmanlıklar'),
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
      'Hesap Ayarları',
      'Premium Üyelik',
      'Promosyon Kodu Kullan',
      'Zodiona Hakkında',
      'Ne Üzerine Çalışıyoruz',
      'Çıkış Yap',
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
  const _CreamActionCard({required this.title, required this.icon, this.onTap});

  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final child = Container(
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

    if (onTap == null) {
      return child;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: child,
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({required this.onContactTap});

  final VoidCallback onContactTap;

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
            child: const Icon(
              Icons.rocket_launch_outlined,
              color: Color(0xFF1E1B3D),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Bizimle Bağlantı Kur',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: const Color(0xFFF2D28E),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Soruların, geri bildirimlerin veya karşılaştığın her türlü sorunu buradan bizimle paylaşabilirsin. Kozmik bilgisiyle donanmış ekibimiz, mesajını bekliyor ve mesajını en kısa sürede yanıtlayacaktır.',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.white70, height: 1.4),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),
          InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: onContactTap,
            child: Container(
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
                'Bize Ulaş',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: const Color(0xFFF2D28E),
                  fontWeight: FontWeight.w700,
                ),
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
