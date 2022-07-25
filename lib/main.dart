import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:delivery_basket/data/AppNotifer.dart';
import 'package:delivery_basket/screens/maintenance/app_update_view.dart';
import 'package:delivery_basket/screens/splash/splash_screen.dart';
import 'LanguageChangeProvider.dart';
import 'generated/l10n.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    new FlutterLocalNotificationsPlugin();

Future<void> _messageHandler(RemoteMessage message) async {
  print("notification received ${message.notification!.body}");
  displayNotification(message);
}

Future displayNotification(RemoteMessage message) async {
  var initializationSettingsAndroid =
      new AndroidInitializationSettings('@mipmap/ic_logo');
  //var initializationSettingsIOS = new IOSInitializationSettings(onDidReceiveLocalNotification: onDidRecieveLocalNotification() );
  var initializationSettings =
      new InitializationSettings(android: initializationSettingsAndroid);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'channelid', 'flutterfcm', 'your channel description',
      importance: Importance.max, priority: Priority.high);
  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
  var macPlatformChannelSpecifics = new MacOSNotificationDetails();
  var platformChannelSpecifics = new NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
      macOS: macPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    message.notification!.title,
    message.notification!.body,
    platformChannelSpecifics,
    payload: 'hello',
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (isWebPlatform()) {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_messageHandler);
  } else if (Platform.isIOS) {}

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CheckOutNotifier()),
        ChangeNotifierProvider(create: (_) => LanguageChangeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  static GlobalKey mtAppKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: MyApp.mtAppKey,
      locale: Provider.of<LanguageChangeProvider>(context, listen: true).currentLocale,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      //supportedLocales: S.delegate.supportedLocales,
      title: 'Flutter Demo',
      home: SplashScreen(),
    );
  }
}

showErrorAlertDialog(BuildContext context, String header, String message) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(header),
    content: Text(message),
    actions: [
      okButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

bool isWebPlatform() {
  bool kisweb = false;
  try {
    if (Platform.isAndroid || Platform.isIOS) {
      kisweb = false;
    } else {
      kisweb = true;
    }
  } catch (e) {
    kisweb = true;
  }
  return kisweb;
}
