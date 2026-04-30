import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../services/iap_service.dart';
import '../../../../services/jeton_service.dart';
import '../widgets/cosmic_orb_icon.dart';
import '../widgets/jeton_widgets.dart';
import 'kozmik_rehber_chat_page.dart';
import 'kozmik_rehber_history_page.dart';
import 'kozmik_rehber_ruya_chat_page.dart';
import 'kozmik_rehber_tarot_chat_page.dart';
import 'kozmik_rehber_uyum_chat_page.dart';

class KozmikRehberPage extends StatefulWidget {
  const KozmikRehberPage({super.key});

  @override
  State<KozmikRehberPage> createState() => _KozmikRehberPageState();
}

class _KozmikRehberPageState extends State<KozmikRehberPage> {
  int _adCount = 0;
  bool _adLoading = false;
  StreamSubscription<int>? _balanceSub;
  StreamSubscription<IapResult>? _iapSub;
  int _balance = 0;

  @override
  void initState() {
    super.initState();
    _loadAdCount();
    _listenBalance();
    if (!kIsWeb) JetonService.preloadAd();
    _ensureBalance();
    _initIap();
  }

  @override
  void dispose() {
    _balanceSub?.cancel();
    _iapSub?.cancel();
    super.dispose();
  }

  Future<void> _initIap() async {
    if (kIsWeb) return;
    // init() artık main.dart'ta çağrılıyor; burada sadece stream'i dinle.
    _iapSub = IapService.instance.resultStream.listen((result) {
      if (!mounted) return;
      if (result.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🎉 ${result.addedTokens} jeton hesabına eklendi!'),
            backgroundColor: const Color(0xFF1E7A3D),
          ),
        );
      } else if (result.isError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.errorMessage ?? 'Satın alma başarısız.'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    });
  }

  // Mevcut kullanıcıda jetonBakiye yoksa 5 ile başlat
  Future<void> _ensureBalance() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    if (doc.data()?['jetonBakiye'] == null) {
      await JetonService.initializeForNewUser();
    }
  }

  Future<void> _loadAdCount() async {
    final count = await JetonService.getAdCount();
    if (mounted) setState(() => _adCount = count);
  }

  void _listenBalance() {
    _balanceSub = JetonService.balanceStream().listen((b) {
      if (mounted) setState(() => _balance = b);
    });
  }

  // â”€â”€ Jeton satÄ±n alma dialog â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  void _showPurchaseDialog() {
    showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFF130A35),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(ctx).size.height * 0.80,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 8),
                      const Text(
                        '✨ Jeton Satın Al',
                        style: TextStyle(
                          color: Color(0xFFF2D293),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Ne kadar çok alırsan o kadar avantajlı!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white60, fontSize: 13),
                      ),
                      const SizedBox(height: 18),
                      ...JetonService.paketler.map(
                        (p) => JetonPaketSatiri(
                          paket: p,
                          storePrice: IapService.instance
                              .productForJeton(p.jeton)
                              ?.price,
                          onTap: () {
                            Navigator.of(ctx).pop();
                            _onPaketSatinAl(p);
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white70,
                            side: const BorderSide(
                              color: Colors.white24,
                              width: 1,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Vazgeç',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () => Navigator.of(ctx).pop(),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white70,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onPaketSatinAl(JetonPaketi paket) async {
    if (kIsWeb) {
      _showUnavailableSnack();
      return;
    }

    final iap = IapService.instance;
    final product = iap.productForJeton(paket.jeton);

    if (product == null || !iap.isAvailable) {
      // Play Store ürünleri henüz tanımlı değil veya erişilemiyor
      _showUnavailableSnack();
      return;
    }

    try {
      await iap.buy(product);
      // Sonuç _iapSub üzerinden asenkron gelir
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Satın alma başlatılamadı: $e'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  void _showUnavailableSnack() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Satın alma şu an kullanılamıyor. Yakında aktif olacak!'),
        backgroundColor: Color(0xFF3D1E7A),
      ),
    );
  }

  // â”€â”€ Reklam izle â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Future<void> _watchAd() async {
    if (_adLoading) return;
    setState(() => _adLoading = true);

    await JetonService.showAd(
      onAdCount: (adCount) {
        if (!mounted) return;
        setState(() {
          _adCount = adCount;
          _adLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '1 reklam izlendi ($adCount/2). 1 reklam daha izle, jeton kazan!',
            ),
            backgroundColor: const Color(0xFF3D1E7A),
          ),
        );
      },
      onToken: () {
        if (!mounted) return;
        setState(() {
          _adCount = 0;
          _adLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎉 1 jeton kazandın! Bakiyene eklendi.'),
            backgroundColor: Color(0xFF1E7A3D),
          ),
        );
      },
      onError: (err) {
        if (!mounted) return;
        setState(() => _adLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err), backgroundColor: Colors.red.shade700),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1026),
      body: Stack(
        children: [
          // Arka plan gÃ¶rseli
          Positioned.fill(
            child: Image.asset(
              'assets/onboarding/home_page.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          // Karartma katmanÄ±
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xCC0B1026), Color(0xEE0B1026)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // â”€â”€ Ãœst baÅŸlÄ±k â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            'Kozmik Rehber',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFF2D293),
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        // ── Jeton bakiye + artı butonu ──────────────────
                        JetonBadge(
                          balance: _balance,
                          onAddTap: _showPurchaseDialog,
                        ),
                      ],
                    ),
                  ),

                  // â”€â”€ Logo (baÅŸlÄ±ÄŸa yakÄ±n, 120x120) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                  const SizedBox(height: 6),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFF2D293),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFFF2D293,
                              ).withValues(alpha: 0.3),
                              blurRadius: 28,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/kozmik/kozmik.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const Positioned(
                        right: -75,
                        top: 52,
                        child: CosmicOrbIcon(size: 46),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // â”€â”€ KarÅŸÄ±lama metni (kÃ¼Ã§Ã¼ltÃ¼lmÃ¼ÅŸ) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      'Merhaba Canım!\nBen senin Kozmik Rehberinim. '
                      'Gezegen geçişleri, burç yorumları, doğum haritası '
                      've daha fazlası hakkında sorularını benimle '
                      'paylaşabilirsin. Yıldızların fısıltılarını birlikte '
                      'keşfedelim.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        height: 1.55,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // -- Jeton bilgi cubuğu --
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0x553D1E7A), Color(0x442E1568)],
                        ),
                        border: Border.all(
                          color: const Color(
                            0xFFF2D293,
                          ).withValues(alpha: 0.25),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Text('✨', style: TextStyle(fontSize: 18)),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Her soru 1 jeton · Reklam izleyerek ücretsiz kazan veya sağ üstten uygun fiyata satın al 🛒',
                              style: TextStyle(
                                color: Color(0xFFF2D293),
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // -- Menü butonları --
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        _MenuButton(
                          label: 'Doğum Haritası',
                          icon: Icons.hub_rounded,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const KozmikRehberChatPage(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        _MenuButton(
                          label: 'Tarot Yorumu',
                          icon: Icons.style_rounded,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const KozmikRehberTarotChatPage(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        _MenuButton(
                          label: 'Uyum Analizi',
                          icon: Icons.favorite_border_rounded,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const KozmikRehberUyumChatPage(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        _MenuButton(
                          label: 'Rüya Tabiri',
                          icon: Icons.bedtime_rounded,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const KozmikRehberRuyaChatPage(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // â”€â”€ Alt butonlar: GeÃ§miÅŸ + Reklam izle â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: _SmallButton(
                              label: 'Geçmiş',
                              icon: Icons.history_rounded,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) =>
                                      const KozmikRehberHistoryPage(),
                                ),
                              ),
                            ),
                          ),
                          if (!kIsWeb) ...[
                            const SizedBox(width: 14),
                            Expanded(
                              child: _AdButton(
                                adCount: _adCount,
                                loading: _adLoading,
                                onTap: _watchAd,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xCC3D1E7A), Color(0xB32E1568)],
            ),
            border: Border.all(color: Colors.white24),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: const Color(0xFFF2D293), size: 20),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFFF2D293),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// â”€â”€â”€ KÃ¼Ã§Ã¼k Buton â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _SmallButton extends StatelessWidget {
  const _SmallButton({required this.label, required this.icon, this.onTap});

  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xCC3D1E7A), Color(0xB32E1568)],
          ),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFFF2D293), size: 24),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// â”€â”€â”€ Reklam Ä°zle Butonu â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _AdButton extends StatelessWidget {
  const _AdButton({
    required this.adCount,
    required this.loading,
    required this.onTap,
  });

  final int adCount;
  final bool loading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xCC1E5A3D), Color(0xB31E4530)],
          ),
          border: Border.all(
            color: const Color(0xFF4CAF50).withValues(alpha: 0.5),
          ),
        ),
        child: Column(
          children: [
            loading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFF81C784),
                    ),
                  )
                : const Icon(
                    Icons.play_circle_outline_rounded,
                    color: Color(0xFF81C784),
                    size: 24,
                  ),
            const SizedBox(height: 6),
            const Text(
              'Reklam İzle,\nJeton Kazan',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFF4CAF50).withValues(alpha: 0.2),
              ),
              child: Text(
                '$adCount/2',
                style: const TextStyle(
                  color: Color(0xFF81C784),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
