import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CustomLocalNotification {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late AndroidNotificationChannel channel;

  CustomLocalNotification() {
    channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notificacion Channel',
      description: 'Use for High Importance Notificacion Channel',
      importance: Importance.max,
    );

    _configureAndroid().then((value) {
      flutterLocalNotificationsPlugin = value;
      _requestPermissions();
      inicialiceNotifications();
    });
  }

  Future<FlutterLocalNotificationsPlugin> _configureAndroid() async {
    var flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    return flutterLocalNotificationPlugin;
  }

  void inicialiceNotifications() {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    flutterLocalNotificationsPlugin
        .initialize(const InitializationSettings(android: android, iOS: ios));
  }

  void androidNotification(
      RemoteNotification notification, AndroidNotification andoid) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: andoid.smallIcon,
        ),
      ),
    );
  }

  Future<void> _requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }
}
