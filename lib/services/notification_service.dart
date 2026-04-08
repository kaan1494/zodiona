import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Uygulama başladığında çağrılır; bildirim izni alır ve FCM tokenini Firestore'a kaydeder.
class NotificationService {
  static final _messaging = FirebaseMessaging.instance;

  static final _localNotifications = FlutterLocalNotificationsPlugin();

  static const _androidChannel = AndroidNotificationChannel(
    'horoscope_weekly',
    'Haftalık Burç Yorumları',
    description: 'Haftalık burç yorum bildirimleri',
    importance: Importance.high,
  );

  static Future<void> initialize() async {
    if (kIsWeb) return;

    await _initLocalNotifications();

    // iOS ön plan bildirimleri için
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

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

    // Ön planda gelen FCM mesajlarını yerel bildirim olarak göster (Android)
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('FCM ön plan: ${message.notification?.title}');
      final notification = message.notification;
      if (notification == null) return;

      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );
    });
  }

  static Future<void> _initLocalNotifications() async {
    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('ic_notification'),
      iOS: DarwinInitializationSettings(),
    );
    await _localNotifications.initialize(initSettings);

    // Android kanalını oluştur / güncelle
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_androidChannel);
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
