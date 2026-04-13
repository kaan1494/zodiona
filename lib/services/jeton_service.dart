import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Jeton (token) yönetimi ve reklam izleme servisi.
class JetonService {
  JetonService._();

  // ── Reklam ayarları ──────────────────────────────────────────────────────
  // Gerçek ID'ler (production)
  static const String _androidRewardedAdUnitId =
      'ca-app-pub-5539194987555265/4309529299';
  static const String _iosRewardedAdUnitId =
      'ca-app-pub-5539194987555265/4309529299';

  // Google resmi test ID'leri
  static const String _testAndroidRewardedAdUnitId =
      'ca-app-pub-3940256099942544/5224354917';
  static const String _testIosRewardedAdUnitId =
      'ca-app-pub-3940256099942544/1712485313';

  // Alpha test aşamasında test reklamları kullanılır.
  // Production'a geçince bu değeri false yap.
  static const bool _useTestAds = true;

  static String get _rewardedAdUnitId {
    if (kDebugMode || _useTestAds) {
      return defaultTargetPlatform == TargetPlatform.iOS
          ? _testIosRewardedAdUnitId
          : _testAndroidRewardedAdUnitId;
    }
    return defaultTargetPlatform == TargetPlatform.iOS
        ? _iosRewardedAdUnitId
        : _androidRewardedAdUnitId;
  }

  static const int _adsPerToken = 2;
  static const String _adCountKey = 'jeton_reklam_sayaci';

  // ── Firestore yardımcıları ───────────────────────────────────────────────
  static DocumentReference<Map<String, dynamic>>? _userDoc() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;
    return FirebaseFirestore.instance.collection('users').doc(uid);
  }

  // ── Bakiye ──────────────────────────────────────────────────────────────
  /// Anlık bakiyeyi döner.
  static Future<int> getBalance() async {
    final doc = _userDoc();
    if (doc == null) return 0;
    final snap = await doc.get();
    return (snap.data()?['jetonBakiye'] as int?) ?? 0;
  }

  /// Bakiyeyi gerçek zamanlı dinler.
  static Stream<int> balanceStream() {
    final doc = _userDoc();
    if (doc == null) return const Stream.empty();
    return doc.snapshots().map((s) => (s.data()?['jetonBakiye'] as int?) ?? 0);
  }

  /// Yeni kullanıcıya başlangıç jetonu verir (sadece `jetonBakiye` alanı yoksa).
  static Future<void> initializeForNewUser() async {
    final doc = _userDoc();
    if (doc == null) return;
    await doc.set({'jetonBakiye': 5}, SetOptions(merge: true));
  }

  /// 1 jeton harcar. Yetersiz bakiyede `false` döner.
  static Future<bool> spend() async {
    final doc = _userDoc();
    if (doc == null) return false;

    bool success = false;
    try {
      await FirebaseFirestore.instance.runTransaction((tx) async {
        final snap = await tx.get(doc);
        final balance = (snap.data()?['jetonBakiye'] as int?) ?? 0;
        if (balance <= 0) throw Exception('Yetersiz jeton');
        tx.update(doc, {'jetonBakiye': balance - 1});
        success = true;
      });
    } catch (_) {
      success = false;
    }
    return success;
  }

  /// Belirtilen miktarda jeton ekler.
  static Future<void> addTokens(int amount) async {
    final doc = _userDoc();
    if (doc == null) return;
    await doc.update({'jetonBakiye': FieldValue.increment(amount)});
  }

  // ── Reklam sayacı ────────────────────────────────────────────────────────
  /// Kaç reklam izlendiğini döner (0 veya 1).
  static Future<int> getAdCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_adCountKey) ?? 0;
  }

  /// Bir reklam izlendiğinde çağrılır.
  /// 2 reklamı tamamlayanlar 1 jeton kazanır; sayaç sıfırlanır ve yeni sayaç döner.
  static Future<int> _incrementAdCount() async {
    final prefs = await SharedPreferences.getInstance();
    final current = (prefs.getInt(_adCountKey) ?? 0) + 1;
    if (current >= _adsPerToken) {
      await addTokens(1);
      await prefs.setInt(_adCountKey, 0);
      return 0;
    }
    await prefs.setInt(_adCountKey, current);
    return current;
  }

  // ── Ödüllü reklam göster ─────────────────────────────────────────────────
  static RewardedAd? _rewardedAd;
  static bool _isAdLoading = false;
  static Completer<bool>? _loadCompleter;

  /// Reklamı ön bellekler.
  static Future<void> preloadAd() async {
    if (kIsWeb) return; // Web'de AdMob desteklenmiyor
    if (_rewardedAd != null) return;
    if (_isAdLoading) return; // zaten yükleniyor
    _isAdLoading = true;
    _loadCompleter = Completer<bool>();
    RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isAdLoading = false;
          if (!(_loadCompleter?.isCompleted ?? true)) {
            _loadCompleter!.complete(true);
          }
        },
        onAdFailedToLoad: (error) {
          _rewardedAd = null;
          _isAdLoading = false;
          if (!(_loadCompleter?.isCompleted ?? true)) {
            _loadCompleter!.complete(false);
          }
        },
      ),
    );
  }

  /// Reklamı gösterir.
  /// [onAdCount] — güncel reklam sayacı ile çağrılır (0 veya 1).
  /// [onToken] — 2. reklam sonrası 1 jeton eklendikten sonra çağrılır.
  /// [onError] — reklam yüklenemediğinde çağrılır.
  static Future<void> showAd({
    required void Function(int adCount) onAdCount,
    required void Function() onToken,
    required void Function(String error) onError,
  }) async {
    if (kIsWeb) {
      onError('Reklam özelliği yalnızca mobil uygulamada kullanılabilir.');
      return;
    }
    if (_rewardedAd == null) {
      if (!_isAdLoading) await preloadAd();
      // Yükleme callback'ini bekle (en fazla 12 saniye)
      try {
        await _loadCompleter?.future.timeout(const Duration(seconds: 12));
      } catch (_) {
        // timeout
      }
    }

    // İlk denemede başarısız olduysa 1 kez daha yükleyip bekle
    if (_rewardedAd == null && !_isAdLoading) {
      await preloadAd();
      try {
        await _loadCompleter?.future.timeout(const Duration(seconds: 8));
      } catch (_) {
        // timeout
      }
    }

    if (_rewardedAd == null) {
      onError('Reklam şu an yüklenemedi. Lütfen biraz sonra tekrar dene.');
      preloadAd();
      return;
    }

    final ad = _rewardedAd!;
    _rewardedAd = null; // sıfırla, bir sonraki için yeniden yüklenecek

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (a) {
        a.dispose();
        // AdMob'un hazır olması için kısa gecikme sonra ön yükle
        Future.delayed(const Duration(seconds: 2), preloadAd);
      },
      onAdFailedToShowFullScreenContent: (a, error) {
        a.dispose();
        onError('Reklam gösterilemedi: ${error.message}');
        preloadAd();
      },
    );

    await ad.show(
      onUserEarnedReward: (_, reward) async {
        final newCount = await _incrementAdCount();
        if (newCount == 0) {
          // 2 reklam tamamlandı, jeton eklendi
          onToken();
        } else {
          onAdCount(newCount);
        }
      },
    );
  }

  // ── Jeton paketi tanımları ────────────────────────────────────────────────
  static const List<JetonPaketi> paketler = [
    JetonPaketi(jeton: 10, fiyatTL: 95),
    JetonPaketi(jeton: 25, fiyatTL: 199),
    JetonPaketi(jeton: 50, fiyatTL: 349),
    JetonPaketi(jeton: 100, fiyatTL: 599),
    JetonPaketi(jeton: 250, fiyatTL: 1249),
  ];
}

class JetonPaketi {
  const JetonPaketi({required this.jeton, required this.fiyatTL});

  final int jeton;
  final int fiyatTL;

  /// Jeton başına düşen fiyat (ne kadar düşükse o kadar avantajlı).
  double get birimFiyat => fiyatTL / jeton;

  /// Temel pakete (10 jeton) göre tasarruf yüzdesi.
  int get tasarrufYuzdesi {
    const double bazFiyat = 95 / 10; // 9.5 TL/jeton
    final tasarruf = ((bazFiyat - birimFiyat) / bazFiyat * 100).round();
    return tasarruf < 0 ? 0 : tasarruf;
  }
}
