import 'package:cloud_firestore/cloud_firestore.dart';

enum PromoRedeemStatus { success, emptyCode, invalidCode, alreadyUsed, failed }

enum PromoStorePlatform { appStore, googlePlay }

extension PromoStorePlatformX on PromoStorePlatform {
  String get value {
    switch (this) {
      case PromoStorePlatform.appStore:
        return 'app_store';
      case PromoStorePlatform.googlePlay:
        return 'google_play';
    }
  }

  String get displayName {
    switch (this) {
      case PromoStorePlatform.appStore:
        return 'App Store';
      case PromoStorePlatform.googlePlay:
        return 'Google Play';
    }
  }
}

class PromoOffer {
  const PromoOffer({
    required this.code,
    this.discountPercent = 0,
    this.grantsPremium = false,
    this.premiumDays = 365,
  });

  final String code;
  final int discountPercent;
  final bool grantsPremium;
  final int premiumDays;
}

class PromoRedeemResult {
  const PromoRedeemResult({
    required this.status,
    required this.message,
    this.offer,
  });

  final PromoRedeemStatus status;
  final String message;
  final PromoOffer? offer;

  bool get isSuccess => status == PromoRedeemStatus.success;
}

class PromoCodeService {
  PromoCodeService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  // İndirim kodları
  // Premium tam erişim kodları (grantsPremium: true)
  static const Map<String, PromoOffer> _promoCatalog = {
    // Mevcut indirim kodları
    'ASTOPIA10': PromoOffer(code: 'ASTOPIA10', discountPercent: 10),
    'ASTOPIA20': PromoOffer(code: 'ASTOPIA20', discountPercent: 20),
    'PREMIUM30': PromoOffer(code: 'PREMIUM30', discountPercent: 30),
    // 20 adet tam erişim premium kodu
    'YILDIZ001': PromoOffer(
      code: 'YILDIZ001',
      grantsPremium: true,
      premiumDays: 365,
    ),
    'YILDIZ002': PromoOffer(
      code: 'YILDIZ002',
      grantsPremium: true,
      premiumDays: 365,
    ),
    'YILDIZ003': PromoOffer(
      code: 'YILDIZ003',
      grantsPremium: true,
      premiumDays: 365,
    ),
    'YILDIZ004': PromoOffer(
      code: 'YILDIZ004',
      grantsPremium: true,
      premiumDays: 365,
    ),
    'YILDIZ005': PromoOffer(
      code: 'YILDIZ005',
      grantsPremium: true,
      premiumDays: 365,
    ),
    'YILDIZ006': PromoOffer(
      code: 'YILDIZ006',
      grantsPremium: true,
      premiumDays: 365,
    ),
    'YILDIZ007': PromoOffer(
      code: 'YILDIZ007',
      grantsPremium: true,
      premiumDays: 365,
    ),
    'YILDIZ008': PromoOffer(
      code: 'YILDIZ008',
      grantsPremium: true,
      premiumDays: 365,
    ),
    'YILDIZ009': PromoOffer(
      code: 'YILDIZ009',
      grantsPremium: true,
      premiumDays: 365,
    ),
    'YILDIZ010': PromoOffer(
      code: 'YILDIZ010',
      grantsPremium: true,
      premiumDays: 365,
    ),
    'ZODPRM001': PromoOffer(
      code: 'ZODPRM001',
      grantsPremium: true,
      premiumDays: 365,
    ),
    'ZODPRM002': PromoOffer(
      code: 'ZODPRM002',
      grantsPremium: true,
      premiumDays: 365,
    ),
    'ZODPRM003': PromoOffer(
      code: 'ZODPRM003',
      grantsPremium: true,
      premiumDays: 365,
    ),
    'ZODPRM004': PromoOffer(
      code: 'ZODPRM004',
      grantsPremium: true,
      premiumDays: 365,
    ),
    'ZODPRM005': PromoOffer(
      code: 'ZODPRM005',
      grantsPremium: true,
      premiumDays: 365,
    ),
    'ZODPRM006': PromoOffer(
      code: 'ZODPRM006',
      grantsPremium: true,
      premiumDays: 365,
    ),
    'ZODPRM007': PromoOffer(
      code: 'ZODPRM007',
      grantsPremium: true,
      premiumDays: 365,
    ),
    'ZODPRM008': PromoOffer(
      code: 'ZODPRM008',
      grantsPremium: true,
      premiumDays: 365,
    ),
    'ZODPRM009': PromoOffer(
      code: 'ZODPRM009',
      grantsPremium: true,
      premiumDays: 365,
    ),
    'ZODPRM010': PromoOffer(
      code: 'ZODPRM010',
      grantsPremium: true,
      premiumDays: 365,
    ),
  };

  Future<PromoRedeemResult> redeemCode({
    required String uid,
    required String rawCode,
    required PromoStorePlatform storePlatform,
  }) async {
    final normalizedCode = _normalizeCode(rawCode);

    if (normalizedCode.isEmpty) {
      return const PromoRedeemResult(
        status: PromoRedeemStatus.emptyCode,
        message: 'Lutfen bir promosyon kodu gir.',
      );
    }

    final offer = _promoCatalog[normalizedCode];
    if (offer == null) {
      return const PromoRedeemResult(
        status: PromoRedeemStatus.invalidCode,
        message: 'Kod gecersiz veya suresi dolmus.',
      );
    }

    final userRef = _firestore.collection('users').doc(uid);

    try {
      // Kullanıcı dokümanını oku — subcollection izni gerekmez
      final userSnap = await userRef.get();
      final userData = userSnap.data() ?? {};
      final redeemedCodes =
          (userData['redeemedCodes'] as Map<String, dynamic>?) ?? {};

      if (redeemedCodes.containsKey(normalizedCode)) {
        return PromoRedeemResult(
          status: PromoRedeemStatus.alreadyUsed,
          message: '$normalizedCode kodu daha önce kullanılmış.',
          offer: offer,
        );
      }

      final now = FieldValue.serverTimestamp();

      if (offer.grantsPremium) {
        final premiumExpireDate = DateTime.now()
            .add(Duration(days: offer.premiumDays))
            .toUtc();
        await userRef.set({
          'isPremium': true,
          'premiumExpireDate': Timestamp.fromDate(premiumExpireDate),
          'redeemedCodes': {
            ...redeemedCodes,
            normalizedCode: {
              'grantsPremium': true,
              'store': storePlatform.value,
              'redeemedAt': DateTime.now().toIso8601String(),
            },
          },
          'updatedAt': now,
        }, SetOptions(merge: true));

        return PromoRedeemResult(
          status: PromoRedeemStatus.success,
          message:
              'Premium üyeliğiniz aktif edildi! '
              '${offer.premiumDays} gün boyunca tüm özelliklere erişebilirsiniz.',
          offer: offer,
        );
      }

      await userRef.set({
        'promoState': {
          'activeCode': offer.code,
          'discountPercent': offer.discountPercent,
          'store': storePlatform.value,
          'status': 'ready_for_checkout',
          'redeemedAt': DateTime.now().toIso8601String(),
        },
        'redeemedCodes': {
          ...redeemedCodes,
          normalizedCode: {
            'discountPercent': offer.discountPercent,
            'store': storePlatform.value,
            'redeemedAt': DateTime.now().toIso8601String(),
          },
        },
        'updatedAt': now,
      }, SetOptions(merge: true));

      return PromoRedeemResult(
        status: PromoRedeemStatus.success,
        message:
            '%${offer.discountPercent} indirim hesabına tanımlandı. Satın alma ekranında uygulanacak.',
        offer: offer,
      );
    } catch (_) {
      return const PromoRedeemResult(
        status: PromoRedeemStatus.failed,
        message: 'Promosyon kodu şu an uygulanamadı. Lütfen tekrar dene.',
      );
    }
  }

  String _normalizeCode(String value) {
    return value.trim().toUpperCase().replaceAll(RegExp(r'\s+'), '');
  }
}
