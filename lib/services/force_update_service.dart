import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Firestore'daki `app_config/version` dokümanındaki `minVersion` alanıyla
/// karşılaştırarak zorunlu güncelleme gerekip gerekmediğini belirler.
///
/// Firestore yapısı:
/// app_config/version { minVersion: "2.0.2" }
class ForceUpdateService {
  ForceUpdateService._();
  static final ForceUpdateService instance = ForceUpdateService._();

  /// Uygulamanın mevcut sürümü (pubspec.yaml ile senkron tutulmalı).
  static const String currentVersion = '2.0.2';

  /// Güncelleme gerekiyorsa `true` döner.
  Future<bool> isUpdateRequired() async {
    if (kIsWeb) return false;
    try {
      final doc = await FirebaseFirestore.instance
          .collection('app_config')
          .doc('version')
          .get();
      final minVersion = doc.data()?['minVersion'] as String?;
      if (minVersion == null) return false;
      return _isOlderThan(currentVersion, minVersion);
    } catch (e) {
      debugPrint('[ForceUpdate] Kontrol hatası: $e');
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
