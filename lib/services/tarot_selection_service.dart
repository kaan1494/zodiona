import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
}
