import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AndroidFirebaseMessageManager{
  FirebaseMessaging? messaging;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  init(){
    var initializationSettingsAndroid = new AndroidInitializationSettings('@mipmap/ic_logo');
    //var initializationSettingsIOS = new IOSInitializationSettings(onDidReceiveLocalNotification: onDidRecieveLocalNotification() );
    var initializationSettings = new InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    _firebaseMessaging.sendMessage(to: "");
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      displayNotification(event);
      print(event.notification!.body);
      print(event.data.values);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
    messaging = FirebaseMessaging.instance;
    messaging!.subscribeToTopic("messaging");
    messaging!.getToken().then((value) {
      print("firebase token-- "+value!);
      return value;
    });
  }

  Future displayNotification(RemoteMessage message) async{
    var initializationSettingsAndroid = new AndroidInitializationSettings('@mipmap/ic_logo',);
    //var initializationSettingsIOS = new IOSInitializationSettings(onDidReceiveLocalNotification: onDidRecieveLocalNotification() );
    var initializationSettings = new InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'channelid', 'flutterfcm', 'your channel description',
        importance: Importance.max, priority: Priority.high);
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