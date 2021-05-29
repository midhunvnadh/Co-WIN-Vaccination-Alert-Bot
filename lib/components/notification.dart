import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class Notifications {
  BuildContext context;

  Future notificationSelected(String? payload) async {
    if (payload != null) {}
    return await Navigator.pushNamed(context, '/');
  }

  FlutterLocalNotificationsPlugin fltrNotf =
      new FlutterLocalNotificationsPlugin();

  setContext(BuildContext cx) {
    this.context = cx;
  }

  Notifications(this.context) {
    var androidInitialize = new AndroidInitializationSettings('app_icon');
    var iOS = new IOSInitializationSettings();
    var initializationSettings =
        new InitializationSettings(android: androidInitialize, iOS: iOS);
    fltrNotf.initialize(initializationSettings,
        onSelectNotification: notificationSelected);
  }

  Future showNtf(title, desc) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description',
            importance: Importance.low,
            priority: Priority.min,
            vibrationPattern: null,
            enableVibration: false,
            enableLights: false,
            playSound: false,
            showWhen: true);
    var iosDetails = new IOSNotificationDetails();
    var generalNotificationDetails = new NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iosDetails);
    await fltrNotf.show(0, title, desc, generalNotificationDetails);
  }
}
