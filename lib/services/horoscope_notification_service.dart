import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HoroscopeNotificationData {
  final String title;
  final String body;
  final String zodiacSign;

  const HoroscopeNotificationData({
    required this.title,
    required this.body,
    required this.zodiacSign,
  });
}

class HoroscopeNotificationService {
  static const String _prefKeyPrefix = 'lastSeenHoroscope_';

  /// Bu yöntemi çağır: kullanıcının burcuna ait haftalık yorum
  /// son görülenden daha yeni ise [HoroscopeNotificationData] döner,
  /// aksi hâlde null döner.
  static Future<HoroscopeNotificationData?> checkNewHoroscope() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;

      // Kullanıcının burcunu Firestore'dan oku
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (!userDoc.exists) return null;

      final zodiacSign = userDoc.data()?['zodiacSign'] as String?;
      if (zodiacSign == null || zodiacSign.isEmpty) return null;

      // Haftalık yorumu oku
      final horoDoc = await FirebaseFirestore.instance
          .collection('weekly_horoscopes_general')
          .doc(zodiacSign)
          .get();
      if (!horoDoc.exists) return null;

      final data = horoDoc.data()!;
      final updatedAtRaw = data['updatedAt'];
      if (updatedAtRaw == null) return null;

      final DateTime updatedAt;
      if (updatedAtRaw is Timestamp) {
        updatedAt = updatedAtRaw.toDate();
      } else if (updatedAtRaw is int) {
        updatedAt = DateTime.fromMillisecondsSinceEpoch(updatedAtRaw);
      } else {
        return null;
      }

      // Son görülme zamanını SharedPreferences'tan oku
      final prefs = await SharedPreferences.getInstance();
      final key = '$_prefKeyPrefix$zodiacSign';
      final lastSeenMillis = prefs.getInt(key) ?? 0;
      final lastSeen = DateTime.fromMillisecondsSinceEpoch(lastSeenMillis);

      if (!updatedAt.isAfter(lastSeen)) return null;

      // Yeni içerik var
      final title = data['title'] as String? ?? '$zodiacSign Haftalık Yorumu';
      final body = data['body'] as String? ?? '';

      return HoroscopeNotificationData(
        title: title,
        body: body,
        zodiacSign: zodiacSign,
      );
    } catch (_) {
      return null;
    }
  }

  /// Kullanıcı bildirimi gördü; şu anki zamanı kaydet.
  static Future<void> markAsSeen(String zodiacSign) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_prefKeyPrefix$zodiacSign';
    await prefs.setInt(key, DateTime.now().millisecondsSinceEpoch);
  }
}
