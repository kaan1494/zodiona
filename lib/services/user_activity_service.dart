import 'package:cloud_firestore/cloud_firestore.dart';

/// Kullanıcının hangi bölümde ne kadar vakit geçirdiğini Firestore'a kaydeder.
/// Tüm metodlar fire-and-forget — asla ana iş akışını engellemez.
class UserActivityService {
  static const String _activityCollection = 'user_activity';
  static const String _analyticsCollection = 'analytics';
  static const String _statsDoc = 'page_stats';

  /// Alt ekran sekme adları (bottom nav indeksiyle eşleşir)
  static const List<String> tabNames = [
    'Takvim',
    'Keşfet',
    'Ana Sayfa',
    'Uyumluluk',
    'Danışman',
  ];

  static String tabName(int index) =>
      index >= 0 && index < tabNames.length ? tabNames[index] : 'Bilinmiyor';

  /// [pageName] ekranında [durationSeconds] saniyelik bir ziyareti kaydeder.
  static void logPageView({
    required String uid,
    required String pageName,
    required int durationSeconds,
  }) {
    if (uid.isEmpty || pageName.isEmpty) return;
    _doLog(uid: uid, pageName: pageName, durationSeconds: durationSeconds);
  }

  static Future<void> _doLog({
    required String uid,
    required String pageName,
    required int durationSeconds,
  }) async {
    try {
      final db = FirebaseFirestore.instance;
      final now = Timestamp.now();

      // 1. Bireysel olay kaydı
      db.collection(_activityCollection).doc(uid).collection('events').add({
        'page': pageName,
        'startedAt': now,
        'durationSeconds': durationSeconds,
      });

      // 2. Kullanıcı bazlı özet güncelleme (ilk yazımda set ile oluştur)
      final userRef = db.collection(_activityCollection).doc(uid);
      userRef
          .update({
            'lastActive': now,
            'pageCounts.$pageName': FieldValue.increment(1),
            'totalDuration.$pageName': FieldValue.increment(durationSeconds),
          })
          .catchError((_) {
            userRef.set({
              'lastActive': now,
              'pageCounts': {pageName: 1},
              'totalDuration': {pageName: durationSeconds},
            });
          });

      // 3. Global bölüm kullanım sayaçları
      final statsRef = db.collection(_analyticsCollection).doc(_statsDoc);
      statsRef
          .update({
            'pages.$pageName': FieldValue.increment(1),
            'updatedAt': now,
          })
          .catchError((_) {
            statsRef.set({
              'pages': {pageName: 1},
              'updatedAt': now,
            });
          });
    } catch (_) {
      // Activity logging asla hata fırlatmamalı
    }
  }
}
