import 'dart:async';
import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

/// Google Play Console → Uygulamanız → Para kazanma → Ürünler'de
/// bu ID'leri "Consumable" (tüketilebilir) ürün olarak oluştur.
/// Fiyatları TL cinsinden ayarla (Play Console'da yapılır, burada sadece ID).
const Map<String, int> kIapProductJetonlar = {
  'zodiona_jetons_010': 10,
  'zodiona_jetons_025': 25,
  'zodiona_jetons_050': 50,
  'zodiona_jetons_100': 100,
  'zodiona_jetons_250': 250,
};

/// Google Play Console → Para kazanma → Ürünler'de
/// bu ID'leri "Yönetilen ürün" (consumable) olarak oluştur.
const Map<String, String> kIapProductDanismanlik = {
  'zodiona_danisman_yillik': 'Yıllık Öngörü',
  'zodiona_danisman_iliski': 'İlişki Uyumu',
  'zodiona_danisman_horary': 'Danışmana Sor - Horary',
  'zodiona_danisman_dogum': 'Doğum Haritası Analizi',
  'zodiona_danisman_elektion': 'Eleksiyon Astrolojisi',
  'zodiona_danisman_astrokart': 'Astrokartografi',
};

/// Google Play Billing (in_app_purchase) yönetim servisi.
class IapService {
  IapService._();

  static final IapService instance = IapService._();

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSub;

  List<ProductDetails> _products = [];
  List<ProductDetails> get products => _products;

  List<ProductDetails> _consultantProducts = [];
  List<ProductDetails> get consultantProducts => _consultantProducts;

  String? _pendingAdvisorName;
  String? get pendingAdvisorName => _pendingAdvisorName;

  bool _isAvailable = false;
  bool get isAvailable => _isAvailable;

  bool _initialized = false;

  final StreamController<IapResult> _resultController =
      StreamController<IapResult>.broadcast();

  /// Satın alma sonuçlarını dinlemek için bu stream'i kullan.
  Stream<IapResult> get resultStream => _resultController.stream;

  /// Uygulama başlarken bir kez çağır (main.dart'ta Firebase init'ten sonra).
  Future<void> init() async {
    if (kIsWeb || _initialized) return;
    _initialized = true;

    _isAvailable = await _iap.isAvailable();
    if (!_isAvailable) {
      debugPrint('[IAP] Google Play Billing kullanılamıyor.');
      return;
    }

    await _loadProducts();

    _purchaseSub = _iap.purchaseStream.listen(
      _handlePurchaseUpdate,
      onError: (Object e) => debugPrint('[IAP] Stream hatası: $e'),
    );
  }

  Future<void> _loadProducts() async {
    final allIds = {
      ...kIapProductJetonlar.keys,
      ...kIapProductDanismanlik.keys,
    };
    final response = await _iap.queryProductDetails(allIds);

    if (response.error != null) {
      debugPrint('[IAP] Ürün yükleme hatası: ${response.error}');
    }

    _products =
        response.productDetails
            .where((p) => kIapProductJetonlar.containsKey(p.id))
            .toList()
          ..sort((a, b) {
            final jetonA = kIapProductJetonlar[a.id] ?? 0;
            final jetonB = kIapProductJetonlar[b.id] ?? 0;
            return jetonA.compareTo(jetonB);
          });

    _consultantProducts = response.productDetails
        .where((p) => kIapProductDanismanlik.containsKey(p.id))
        .toList();

    debugPrint(
      '[IAP] ${_products.length} jeton ürünü, '
      '${_consultantProducts.length} danışmanlık ürünü yüklendi.',
    );
  }

  Future<void> _handlePurchaseUpdate(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          await _deliverPurchase(purchase);
        case PurchaseStatus.error:
          debugPrint('[IAP] Hata: ${purchase.error?.message}');
          _resultController.add(
            IapResult.error(
              purchase.error?.message ?? 'Satın alma başarısız oldu.',
            ),
          );
        case PurchaseStatus.canceled:
          _resultController.add(IapResult.cancelled());
        case PurchaseStatus.pending:
          // Kullanıcının ödeme onayı bekleniyor (nakit vb.)
          break;
      }

      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    }
  }

  /// Satın alma türüne göre uygun teslim fonksiyonunu çağırır.
  Future<void> _deliverPurchase(PurchaseDetails purchase) async {
    if (kIapProductDanismanlik.containsKey(purchase.productID)) {
      await _deliverConsultation(purchase);
    } else {
      await _deliverJeton(purchase);
    }
  }

  /// Cloud Function ile sunucu tarafında doğrular, onaylanırsa jeton ekler.
  Future<void> _deliverJeton(PurchaseDetails purchase) async {
    try {
      final callable = FirebaseFunctions.instance.httpsCallable(
        'verifyAndAddTokens',
      );

      final result = await callable.call<Map<String, dynamic>>({
        'productId': purchase.productID,
        'purchaseToken': purchase.verificationData.serverVerificationData,
        'platform': Platform.isAndroid ? 'android' : 'ios',
      });

      final addedTokens = (result.data['addedTokens'] as int?) ?? 0;
      _resultController.add(
        IapResult.success(
          productId: purchase.productID,
          addedTokens: addedTokens,
        ),
      );
    } catch (e) {
      debugPrint('[IAP] Token teslimi hatası: $e');
      _resultController.add(
        IapResult.error(
          'Jeton eklenirken bir hata oluştu. Lütfen tekrar dene.',
        ),
      );
    }
  }

  /// Cloud Function ile doğrular, danışmanlık sohbet belgesi oluşturur.
  Future<void> _deliverConsultation(PurchaseDetails purchase) async {
    try {
      final callable = FirebaseFunctions.instance.httpsCallable(
        'verifyAndCreateConsultation',
      );

      final result = await callable.call<Map<String, dynamic>>({
        'productId': purchase.productID,
        'purchaseToken': purchase.verificationData.serverVerificationData,
        'platform': Platform.isAndroid ? 'android' : 'ios',
        'advisorName': _pendingAdvisorName ?? '',
      });

      final chatId = result.data['chatId'] as String? ?? '';
      _resultController.add(
        IapResult.consultationSuccess(
          chatId: chatId,
          consultationType: kIapProductDanismanlik[purchase.productID] ?? '',
        ),
      );
    } catch (e) {
      debugPrint('[IAP] Danışmanlık teslimi hatası: $e');
      _resultController.add(
        IapResult.error(
          'Danışmanlık satın alımında hata oluştu. Lütfen tekrar dene.',
        ),
      );
    }
  }

  /// Belirtilen ürünü satın alma akışını başlatır.
  Future<bool> buy(ProductDetails product) async {
    if (!_isAvailable || kIsWeb) return false;
    final param = PurchaseParam(productDetails: product);
    return _iap.buyConsumable(purchaseParam: param);
  }

  /// Danışmanlık satın alma akışını başlatır.
  Future<bool> buyConsultation({
    required ProductDetails product,
    required String advisorName,
  }) async {
    if (!_isAvailable || kIsWeb) return false;
    _pendingAdvisorName = advisorName;
    final param = PurchaseParam(productDetails: product);
    return _iap.buyConsumable(purchaseParam: param);
  }

  /// Jeton miktarına göre ilgili [ProductDetails]'i döner.
  ProductDetails? productForJeton(int jeton) {
    final key = kIapProductJetonlar.entries
        .where((e) => e.value == jeton)
        .map((e) => e.key)
        .firstOrNull;
    if (key == null) return null;
    return _products.where((p) => p.id == key).firstOrNull;
  }

  /// Product ID'ye göre danışmanlık [ProductDetails]'ini döner.
  ProductDetails? productForConsultation(String productId) {
    return _consultantProducts.where((p) => p.id == productId).firstOrNull;
  }

  void dispose() {
    _purchaseSub?.cancel();
    _resultController.close();
  }
}

/// Satın alma işleminin sonucunu temsil eder.
class IapResult {
  const IapResult._({
    required this.status,
    this.productId,
    this.addedTokens,
    this.errorMessage,
    this.chatId,
    this.consultationType,
  });

  factory IapResult.success({
    required String productId,
    required int addedTokens,
  }) => IapResult._(
    status: IapStatus.success,
    productId: productId,
    addedTokens: addedTokens,
  );

  factory IapResult.consultationSuccess({
    required String chatId,
    required String consultationType,
  }) => IapResult._(
    status: IapStatus.consultationSuccess,
    chatId: chatId,
    consultationType: consultationType,
  );

  factory IapResult.error(String message) =>
      IapResult._(status: IapStatus.error, errorMessage: message);

  factory IapResult.cancelled() =>
      const IapResult._(status: IapStatus.cancelled);

  final IapStatus status;
  final String? productId;
  final int? addedTokens;
  final String? errorMessage;
  final String? chatId;
  final String? consultationType;

  bool get isSuccess => status == IapStatus.success;
  bool get isConsultationSuccess => status == IapStatus.consultationSuccess;
  bool get isCancelled => status == IapStatus.cancelled;
  bool get isError => status == IapStatus.error;
}

enum IapStatus { success, consultationSuccess, error, cancelled }
