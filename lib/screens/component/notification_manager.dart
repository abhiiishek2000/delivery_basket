
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationManager{

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  Future<void> messageHandler(RemoteMessage message) async {
    print("notification received ${message.notification!.body}");
    displayNotification(message);
  }

  Future displayNotification(RemoteMessage message) async{
    var initializationSettingsAndroid = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = new InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'vidarbha_basket', 'notification', 'description',
        importance: Importance.max, priority: Priority.high,autoCancel: true,visibility: NotificationVisibility.public,ongoing: true);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var macPlatformChannelSpecifics = new MacOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(android: androidPlatformChannelSpecifics,iOS: iOSPlatformChannelSpecifics,macOS: macPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification!.title,
      message.notification!.body,
      platformChannelSpecifics,
      payload: 'hello',);
  }

}