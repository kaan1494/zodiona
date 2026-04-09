import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../services/jeton_service.dart';
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
  int _balance = 0;

  @override
  void initState() {
    super.initState();
    _loadAdCount();
    _listenBalance();
    JetonService.preloadAd();
    _ensureBalance();
  }

  @override
  void dispose() {
    _balanceSub?.cancel();
    super.dispose();
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                (p) => _PaketSatiri(
                  paket: p,
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _onPaketSatinAl(p);
                  },
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text(
                  'Vazgeç',
                  style: TextStyle(color: Colors.white38),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onPaketSatinAl(JetonPaketi paket) async {
    // Gerçek ödeme entegrasyonu (Stripe / IAP) buraya eklenecek.
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A0848),
        title: Text(
          '${paket.jeton} Jeton Satın Al',
          style: const TextStyle(color: Color(0xFFF2D293)),
        ),
        content: Text(
          '${paket.fiyatTL} ₺ ödeme yapılacak.\n\nÖdeme sistemi yakında aktif olacak.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('İptal', style: TextStyle(color: Colors.white38)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Tamam',
              style: TextStyle(color: Color(0xFFF2D293)),
            ),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (ok == true) {
      await JetonService.addTokens(paket.jeton);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${paket.jeton} jeton eklendi!'),
          backgroundColor: const Color(0xFF3D1E7A),
        ),
      );
    }
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
                        // â”€â”€ Jeton bakiye + artÄ± butonu â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                        _JetonBadge(
                          balance: _balance,
                          onAddTap: _showPurchaseDialog,
                        ),
                      ],
                    ),
                  ),

                  // â”€â”€ Logo (baÅŸlÄ±ÄŸa yakÄ±n, 120x120) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                  const SizedBox(height: 6),
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
                          color: const Color(0xFFF2D293).withValues(alpha: 0.3),
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

                  const SizedBox(height: 28),

                  // â”€â”€ MenÃ¼ butonlarÄ± â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
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
                          const SizedBox(width: 14),
                          Expanded(
                            child: _AdButton(
                              adCount: _adCount,
                              loading: _adLoading,
                              onTap: _watchAd,
                            ),
                          ),
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

// â”€â”€â”€ Jeton Bakiye Badge â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _JetonBadge extends StatelessWidget {
  const _JetonBadge({required this.balance, required this.onAddTap});

  final int balance;
  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xFF1A0848),
            border: Border.all(
              color: const Color(0xFFF2D293).withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _CoinIcon(size: 22),
              const SizedBox(width: 5),
              Text(
                '$balance',
                style: const TextStyle(
                  color: Color(0xFFF2D293),
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: onAddTap,
          child: Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFF2D293),
            ),
            child: const Icon(Icons.add, color: Color(0xFF0B1026), size: 18),
          ),
        ),
      ],
    );
  }
}

// â”€â”€â”€ MenÃ¼ Butonu â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

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

// â”€â”€â”€ Jeton Paketi SatÄ±r Widget'Ä± â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _PaketSatiri extends StatelessWidget {
  const _PaketSatiri({required this.paket, required this.onTap});

  final JetonPaketi paket;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isPopular = paket.jeton == 50;
    final tasarruf = paket.tasarrufYuzdesi;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: isPopular
              ? const LinearGradient(
                  colors: [Color(0xFF3D1E7A), Color(0xFF2E1568)],
                )
              : null,
          color: isPopular ? null : const Color(0xFF1E1045),
          border: Border.all(
            color: isPopular
                ? const Color(0xFFF2D293)
                : Colors.white.withValues(alpha: 0.15),
            width: isPopular ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.toll_rounded, color: Color(0xFFF2D293), size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${paket.jeton} Jeton',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (isPopular) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: const Color(0xFFF2D293),
                          ),
                          child: const Text(
                            'POPÜLER',
                            style: TextStyle(
                              color: Color(0xFF0B1026),
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (tasarruf > 0)
                    Text(
                      '%$tasarruf tasarruf',
                      style: const TextStyle(
                        color: Color(0xFF81C784),
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
            ),
            Text(
              '${paket.fiyatTL} ₺',
              style: const TextStyle(
                color: Color(0xFFF2D293),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.white38,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Altın Coin İkonu ──────────────────────────────────────────────────────

class _CoinIcon extends StatelessWidget {
  const _CoinIcon({this.size = 24});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _CoinPainter()),
    );
  }
}

class _CoinPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final center = Offset(cx, cy);
    final r = size.width / 2;

    // Dış parlak halka — gradient
    final outerPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.3, -0.4),
        radius: 1.0,
        colors: [Color(0xFFFFE566), Color(0xFFE8A000)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawCircle(center, r, outerPaint);

    // Alt-sağ kenar gölgesi (3D efekt)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: r - r * 0.05),
      0.4,
      2.0,
      false,
      Paint()
        ..color = const Color(0xFFB87200)
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.10,
    );

    // İç daire (turuncu)
    final ir = r * 0.72;
    final innerPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.2, -0.3),
        radius: 1.0,
        colors: const [Color(0xFFFFB830), Color(0xFFE07800)],
      ).createShader(Rect.fromCircle(center: center, radius: ir));
    canvas.drawCircle(center, ir, innerPaint);

    // Yıldız
    _drawStar(canvas, center, ir * 0.58, ir * 0.28, const Color(0xFFFFD966));
  }

  void _drawStar(
    Canvas canvas,
    Offset c,
    double outerR,
    double innerR,
    Color color,
  ) {
    const n = 5;
    final path = Path();
    for (int i = 0; i < n * 2; i++) {
      final rad = (i * 3.141592653589793 / n) - 3.141592653589793 / 2;
      final rr = i.isEven ? outerR : innerR;
      // cos/sin via Taylor (dart:math import olmadan)
      final x = c.dx + rr * _cos(rad);
      final y = c.dy + rr * _sin(rad);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, Paint()..color = color);
  }

  // Basit Taylor serisi cos/sin (küçük widget için yeterince hassas)
  static double _cos(double x) {
    x = x % (2 * 3.141592653589793);
    double r = 1, t = 1;
    for (int i = 1; i <= 6; i++) {
      t *= -x * x / ((2 * i - 1) * (2 * i));
      r += t;
    }
    return r;
  }

  static double _sin(double x) {
    x = x % (2 * 3.141592653589793);
    double r = x, t = x;
    for (int i = 1; i <= 6; i++) {
      t *= -x * x / ((2 * i) * (2 * i + 1));
      r += t;
    }
    return r;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
