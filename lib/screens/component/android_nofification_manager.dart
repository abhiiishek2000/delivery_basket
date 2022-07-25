import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'notification_manager.dart';



class AndroidNotificationManager{
  init()async{
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(NotificationManager().messageHandler);
  }

}