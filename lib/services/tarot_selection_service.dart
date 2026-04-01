import 'dart:convert';

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

  static String _uid() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    // Misafir kullanıcı veya oturum açılmamışsa cihaz geneli key kullan
    return uid ?? 'guest';
  }

  static String get _keyCards => 'tarot_selected_cards_${_uid()}';
  static String get _keyTimestamp => 'tarot_selection_timestamp_${_uid()}';

  static Future<void> saveSelection(List<TarotSelectedCard> cards) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(cards.map((c) => c.toJson()).toList());
    await prefs.setString(_keyCards, encoded);
    await prefs.setInt(_keyTimestamp, DateTime.now().millisecondsSinceEpoch);
  }

  static Future<List<TarotSelectedCard>> getPreviousSelection() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyCards);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => TarotSelectedCard.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<bool> isOnCooldown() async {
    final prefs = await SharedPreferences.getInstance();
    final ts = prefs.getInt(_keyTimestamp);
    if (ts == null) return false;
    final elapsed = DateTime.now().millisecondsSinceEpoch - ts;
    return elapsed < _cooldownHours * 60 * 60 * 1000;
  }

  static Future<Duration> cooldownRemaining() async {
    final prefs = await SharedPreferences.getInstance();
    final ts = prefs.getInt(_keyTimestamp);
    if (ts == null) return Duration.zero;
    final elapsed = DateTime.now().millisecondsSinceEpoch - ts;
    final cooldownMs = _cooldownHours * 60 * 60 * 1000;
    final remaining = cooldownMs - elapsed;
    if (remaining <= 0) return Duration.zero;
    return Duration(milliseconds: remaining);
  }
}
