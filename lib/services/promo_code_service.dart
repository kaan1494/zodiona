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
  const PromoOffer({required this.code, required this.discountPercent});

  final String code;
  final int discountPercent;
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

  // Bu listeyi daha sonra kesin kampanya kodlarinizla guncelleyebilirsiniz.
  static const Map<String, PromoOffer> _promoCatalog = {
    'ASTOPIA10': PromoOffer(code: 'ASTOPIA10', discountPercent: 10),
    'ASTOPIA20': PromoOffer(code: 'ASTOPIA20', discountPercent: 20),
    'PREMIUM30': PromoOffer(code: 'PREMIUM30', discountPercent: 30),
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
    final redemptionRef = userRef
        .collection('promoCodeRedemptions')
        .doc(normalizedCode);

    try {
      final existingRedemption = await redemptionRef.get();
      if (existingRedemption.exists) {
        return PromoRedeemResult(
          status: PromoRedeemStatus.alreadyUsed,
          message: '$normalizedCode kodu daha once kullanilmis.',
          offer: offer,
        );
      }

      final now = FieldValue.serverTimestamp();

      await userRef.set({
        'promoState.activeCode': offer.code,
        'promoState.discountPercent': offer.discountPercent,
        'promoState.store': storePlatform.value,
        'promoState.status': 'ready_for_checkout',
        'promoState.redeemedAt': now,
        'updatedAt': now,
      }, SetOptions(merge: true));

      await redemptionRef.set({
        'code': offer.code,
        'discountPercent': offer.discountPercent,
        'store': storePlatform.value,
        'status': 'ready_for_checkout',
        'createdAt': now,
        'updatedAt': now,
      });

      return PromoRedeemResult(
        status: PromoRedeemStatus.success,
        message:
            '${offer.discountPercent}% indirim hesabina tanimlandi. Satin alma ekraninda uygulanacak.',
        offer: offer,
      );
    } catch (_) {
      return const PromoRedeemResult(
        status: PromoRedeemStatus.failed,
        message: 'Promosyon kodu su an uygulanamadi. Lutfen tekrar dene.',
      );
    }
  }

  String _normalizeCode(String value) {
    return value.trim().toUpperCase().replaceAll(RegExp(r'\s+'), '');
  }
}
