import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../services/promo_code_service.dart';

class PromoCodeRedeemScreen extends StatefulWidget {
  const PromoCodeRedeemScreen({super.key});

  @override
  State<PromoCodeRedeemScreen> createState() => _PromoCodeRedeemScreenState();
}

class _PromoCodeRedeemScreenState extends State<PromoCodeRedeemScreen> {
  final _codeController = TextEditingController();
  final _promoService = PromoCodeService();

  bool _isSubmitting = false;
  String? _message;
  bool _isError = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  PromoStorePlatform get _storePlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return PromoStorePlatform.appStore;
      case TargetPlatform.android:
        return PromoStorePlatform.googlePlay;
      default:
        return PromoStorePlatform.googlePlay;
    }
  }

  @override
  Widget build(BuildContext context) {
    final storeLabel = _storePlatform.displayName;
    final isAppStore = _storePlatform == PromoStorePlatform.appStore;
    final storeIcon = isAppStore ? Icons.apple : Icons.play_arrow_rounded;

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
                  colors: [Color(0xAA070B1F), Color(0xEE12131D)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(14, 20, 14, 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xEE171922),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: isAppStore
                                      ? const Color(0xFF1577FF)
                                      : const Color(0xFF2EA44F),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: Icon(
                                  storeIcon,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                storeLabel,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () => Navigator.of(context).pop(),
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: Container(
                              width: 84,
                              height: 84,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: Colors.white24),
                                color: const Color(0xFF151B2F),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.asset(
                                'assets/images/zodiona_logo_menu.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(
                                      Icons.apps,
                                      color: Colors.white70,
                                      size: 34,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'Astopia: Astroloji Günlük Burç',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Özel Teklifi Kullanın',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _codeController,
                            textCapitalization: TextCapitalization.characters,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Kod',
                              hintStyle: const TextStyle(color: Colors.white54),
                              filled: true,
                              fillColor: const Color(0xFF242733),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isSubmitting ? null : _applyCode,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(50),
                                backgroundColor: isAppStore
                                    ? const Color(0xFF1577FF)
                                    : const Color(0xFF2EA44F),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: _isSubmitting
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'Kodu Uygula',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (_message != null)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(
                                12,
                                10,
                                12,
                                10,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: _isError
                                    ? const Color(0xFF662C2C)
                                    : const Color(0xFF1F4E35),
                                border: Border.all(
                                  color: _isError
                                      ? const Color(0xFFB76D6D)
                                      : const Color(0xFF4AB583),
                                ),
                              ),
                              child: Text(
                                _message!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          const SizedBox(height: 10),
                          Text(
                            '$storeLabel odeme ekraninda indirim otomatik uygulanir.',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.white54),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _applyCode() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      setState(() {
        _isError = true;
        _message = 'Kullanıcı oturumu bulunamadı.';
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _message = null;
      _isError = false;
    });

    final result = await _promoService.redeemCode(
      uid: uid,
      rawCode: _codeController.text,
      storePlatform: _storePlatform,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isSubmitting = false;
      _isError = !result.isSuccess;
      _message = result.message;
    });

    if (result.isSuccess) {
      FocusScope.of(context).unfocus();
    }
  }
}
