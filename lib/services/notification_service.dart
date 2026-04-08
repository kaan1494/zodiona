import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Uygulama başladığında çağrılır; bildirim izni alır ve FCM tokenini Firestore'a kaydeder.
class NotificationService {
  static final _messaging = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    if (kIsWeb) return;

    // Android 8+ için bildirim kanalını oluştur
    await _createNotificationChannel();

    // İzin iste
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) return;

    // Token al ve kaydet
    await _saveFcmToken();

    // Token yenilendiğinde tekrar kaydet
    FirebaseMessaging.instance.onTokenRefresh.listen((_) => _saveFcmToken());

    // Ön planda gelen bildirimleri işle (opsiyonel — banner zaten görünür)
    FirebaseMessaging.onMessage.listen((message) {
      // Gerekirse buraya snackbar/dialog eklenebilir
      debugPrint('FCM ön plan: ${message.notification?.title}');
    });
  }

  static Future<void> _createNotificationChannel() async {
    // Android 8+ için varsayılan FCM kanalını ayarla
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static Future<void> _saveFcmToken() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final token = await _messaging.getToken();
      if (token == null) return;
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'fcmToken': token,
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('FCM token kayıt hatası: $e');
    }
  }
}
