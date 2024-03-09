import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'custom_local_notification.dart';

class CustomFirebaseMessaging {
  final CustomLocalNotification _customLocalNotification;

  CustomFirebaseMessaging._internal(this._customLocalNotification);
  static final CustomFirebaseMessaging _singleton =
      CustomFirebaseMessaging._internal(CustomLocalNotification());
  factory CustomFirebaseMessaging() => _singleton;

  Future<void> inicializeApp() async {
    
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(badge: true, sound: true);

    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? andoid = notification?.android;

      if (notification != null && andoid != null) {
        _customLocalNotification.androidNotification(notification, andoid);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      log("Message $message");
    });
  }

  getFirebaseToken() async {
    debugPrint(await FirebaseMessaging.instance.getToken());
  }

}
