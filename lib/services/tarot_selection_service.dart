import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TarotSelectedCard {
  final String asset;
  final String name;
  final String description;

  const TarotSelectedCard({
    required this.asset,
    required this.name,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
    'asset': asset,
    'name': name,
    'description': description,
  };

  factory TarotSelectedCard.fromJson(Map<String, dynamic> json) =>
      TarotSelectedCard(
        asset: json['asset'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
      );
}

class TarotSelectionService {
  static const _cooldownHours = 8;
  static const _reductionPerAd = 2; // saat
  static const _maxAdsPerSession = 4;
  static const _adCountKey = 'tarot_cooldown_ad_count';

  static String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  static DocumentReference<Map<String, dynamic>>? get _doc {
    final uid = _uid;
    if (uid == null) return null;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tarotData')
        .doc('current');
  }

  static Future<void> saveSelection(List<TarotSelectedCard> cards) async {
    final doc = _doc;
    if (doc == null) return;
    await doc.set({
      'cards': cards.map((c) => c.toJson()).toList(),
      'timestamp': FieldValue.serverTimestamp(),
    });
    // Yeni seçim = reklam sayacı sıfırla
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_adCountKey, 0);
  }

  static Future<List<TarotSelectedCard>> getPreviousSelection() async {
    final doc = _doc;
    if (doc == null) return [];
    final snap = await doc.get();
    if (!snap.exists) return [];
    final data = snap.data();
    if (data == null) return [];
    final list = data['cards'] as List<dynamic>?;
    if (list == null) return [];
    try {
      return list
          .map((e) => TarotSelectedCard.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<bool> isOnCooldown() async {
    final remaining = await cooldownRemaining();
    return remaining > Duration.zero;
  }

  static Future<Duration> cooldownRemaining() async {
    final doc = _doc;
    if (doc == null) return Duration.zero;
    final snap = await doc.get();
    if (!snap.exists) return Duration.zero;
    final data = snap.data();
    if (data == null) return Duration.zero;
    final ts = data['timestamp'];
    DateTime? savedAt;
    if (ts is Timestamp) {
      savedAt = ts.toDate();
    }
    if (savedAt == null) return Duration.zero;
    final elapsed = DateTime.now().difference(savedAt);
    const cooldown = Duration(hours: _cooldownHours);
    final remaining = cooldown - elapsed;
    if (remaining.isNegative) return Duration.zero;
    return remaining;
  }

  // ── Reklam ile süre kısaltma ─────────────────────────────────────────────

  /// Bu oturumda kaç reklam izlendiğini döner.
  static Future<int> getCooldownAdCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_adCountKey) ?? 0;
  }

  /// Kalan reklam hakkını döner (max 4).
  static Future<int> remainingAdSlots() async {
    final count = await getCooldownAdCount();
    return (_maxAdsPerSession - count).clamp(0, _maxAdsPerSession);
  }

  /// Reklam izlendi: sayacı artırır ve timestamp'i 2 saat geri çeker.
  /// Başarıyla azaltıldıysa yeni kalan süreyi döner.
  static Future<Duration> applyAdReduction() async {
    final doc = _doc;
    if (doc == null) return Duration.zero;
    final prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt(_adCountKey) ?? 0;
    if (count >= _maxAdsPerSession) return await cooldownRemaining();

    // Firestore'daki timestamp'i 2 saat öne al
    final snap = await doc.get();
    final data = snap.data();
    if (data == null) return Duration.zero;
    final ts = data['timestamp'];
    if (ts is! Timestamp) return Duration.zero;
    final current = ts.toDate();
    final newTime = current.subtract(Duration(hours: _reductionPerAd));
    await doc.update({'timestamp': Timestamp.fromDate(newTime)});
    await prefs.setInt(_adCountKey, count + 1);

    return await cooldownRemaining();
  }
}
