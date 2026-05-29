import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Firestore'daki `app_config/version` dokümanındaki `minVersion` alanıyla
/// karşılaştırarak zorunlu güncelleme gerekip gerekmediğini belirler.
///
/// Firestore yapısı:
/// app_config/version { minVersion: "2.0.5" }
class ForceUpdateService {
  ForceUpdateService._();
  static final ForceUpdateService instance = ForceUpdateService._();

  /// Güncelleme gerekiyorsa `true` döner.
  /// Sürüm bilgisi paketten dinamik olarak okunur — hardcoded değer yok.
  Future<bool> isUpdateRequired() async {
    if (kIsWeb) return false;
    try {
      final info = await PackageInfo.fromPlatform();
      final currentVersion = info.version;

      final doc = await FirebaseFirestore.instance
          .collection('app_config')
          .doc('version')
          .get();
      return isUpdateRequiredFromData(
        doc.data(),
        currentVersion: currentVersion,
      );
    } catch (e) {
      debugPrint('[ForceUpdate] Kontrol hatası: $e');
      return false;
    }
  }

  /// Firestore snapshot verisiyle güncelleme gerekip gerekmediğini kontrol eder.
  /// Stream dinleyicilerinde kullanmak için ayrılmıştır.
  Future<bool> isUpdateRequiredFromData(
    Map<String, dynamic>? data, {
    String? currentVersion,
  }) async {
    if (kIsWeb) return false;
    try {
      final minVersion = data?['minVersion'] as String?;
      if (minVersion == null) return false;
      final version =
          currentVersion ?? (await PackageInfo.fromPlatform()).version;
      return _isOlderThan(version, minVersion);
    } catch (e) {
      debugPrint('[ForceUpdate] Veri kontrol hatası: $e');
      return false;
    }
  }

  /// `current` sürümü `minimum`dan küçükse true döner.
  bool _isOlderThan(String current, String minimum) {
    final c = _parse(current);
    final m = _parse(minimum);
    for (int i = 0; i < 3; i++) {
      if (c[i] < m[i]) return true;
      if (c[i] > m[i]) return false;
    }
    return false;
  }

  List<int> _parse(String v) {
    final parts = v.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    while (parts.length < 3) {
      parts.add(0);
    }
    return parts;
  }
}

/// Zorunlu güncelleme ekranı — hem bootstrap hem HomeScreen tarafından kullanılır.
class ForceUpdateScreen extends StatelessWidget {
  const ForceUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/onboarding/home_page.png', fit: BoxFit.cover),
          Container(color: Colors.black.withValues(alpha: 0.6)),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('✨', style: TextStyle(fontSize: 56)),
                  const SizedBox(height: 20),
                  const Text(
                    'Güncelleme Gerekli',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFF2D293),
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Zodiona\'nın yeni sürümü çıktı! Uygulamayı kullanmaya devam edebilmek için lütfen güncelle.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF2D293),
                        foregroundColor: const Color(0xFF0B1026),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () async {
                        const url =
                            'https://play.google.com/store/apps/details?id=com.zodiona.app';
                        final uri = Uri.parse(url);
                        try {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        } catch (_) {}
                      },
                      child: const Text(
                        'Şimdi Güncelle',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
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
