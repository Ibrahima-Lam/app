import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fscore/models/notification.dart';
import 'package:fscore/providers/notification_provider.dart';
import 'package:fscore/service/notif_sqlite_service.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  int notificationId = 1;

  // Définition du channel Android
  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel2', // id unique
    'High Importance Notifications', // nom visible dans paramètres
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
    playSound: true,
  );

  /// Initialisation du service de notifications
  static Future<void> init() async {
    // Paramètres Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Paramètres iOS
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    // Configuration générale
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // Initialiser plugin
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Créer le channel Android (obligatoire pour Android 8+)
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Demander permissions iOS
    if (Platform.isIOS) {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    // Listener : notification reçue quand app est en foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LocalNotificationService().onMessage(message);
    });
  }

  /// Détails Android
  NotificationDetails getNotificationDetailsAndroid(
      String title, String value) {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'high_importance_channel2', // doit correspondre au channel créé
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
      ticker: 'ticker',
    );

    return const NotificationDetails(android: androidNotificationDetails);
  }

  /// Détails iOS
  NotificationDetails getNotificationDetailsIos(String title, String value) {
    final DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      subtitle: value,
      threadIdentifier: title,
    );

    return NotificationDetails(iOS: iOSPlatformChannelSpecifics);
  }

  /// Afficher une notification locale
  Future<void> showNotification({
    required String title,
    required String description,
    required Map data,
  }) async {
    final notificationDetails = Platform.isAndroid
        ? getNotificationDetailsAndroid(title, description)
        : getNotificationDetailsIos(title, description);

    await flutterLocalNotificationsPlugin.show(
      notificationId++,
      title,
      description,
      notificationDetails,
      payload: data['idGame'],
    );

    // Incrémenter compteur non lus
    unreadCountNotifier.value++;

    // Sauvegarde SQLite
    final Notif notif = Notif(
      idNotif: notificationId.toString(),
      title: title,
      content: description,
      date: DateTime.now().toString(),
      idGame: data['idGame'] ?? '',
    );
    await NotifSqliteService().insertNotif(notif);
  }

  /// Quand message FCM reçu en foreground
  Future<void> onMessage(RemoteMessage message) async {
    await showNotification(
      title: message.notification?.title ?? 'Notification',
      description: message.notification?.body ?? 'Corps de la notification',
      data: message.data,
    );
  }
}
