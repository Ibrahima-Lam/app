import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  int notificationId = 1;

  static Future<void> init() async {
    // Initialize native android notification
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_notif');

    // Initialize native Ios Notifications
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  NotificationDetails getNotificationDetailsAndroid(
      String title, String value) {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channel_id', 'Channel Name',
            channelDescription: 'Channel Description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    return notificationDetails;
  }

  NotificationDetails getNotificationDetailsIos(String title, String value) {
    final DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert:
          true, // Present an alert when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
      presentBadge:
          true, // Present the badge number when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
      presentSound:
          true, // Play a sound when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
      // sound: String?,  // Specifics the file path to play (only from iOS 10 onwards)
      // badgeNumber: int?, // The application's icon badge number
      // attachments: List<IOSNotificationAttachment>?, // (only from iOS 10 onwards)
      subtitle: value, //Secondary description  (only from iOS 10 onwards)
      threadIdentifier: title, // (only from iOS 10 onwards)
    );

    final NotificationDetails notificationDetails =
        NotificationDetails(iOS: iOSPlatformChannelSpecifics);

    return notificationDetails;
  }

  Future<void> showNotification(
      {required String title,
      required String description,
      required Map data}) async {
    final notificationDetails = Platform.isAndroid
        ? getNotificationDetailsAndroid(title, description)
        : getNotificationDetailsIos(title, description);
    await flutterLocalNotificationsPlugin.show(
      notificationId,
      title,
      description,
      notificationDetails,
      payload: 'Not present',
    );
  }

  Future onMessage(RemoteMessage message) async {
    await showNotification(
      title: message.notification?.title ?? 'Notification',
      description: message.notification?.body ?? 'Corps de la notification',
      data: message.data,
    );
  }
}
