import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:delivery_basket/data/local/shared_pref.dart';
import 'package:delivery_basket/screens/component/android_firebase_message_manager.dart';
import 'package:delivery_basket/screens/home/home_screen.dart';
import 'package:delivery_basket/screens/intro/intro_screen.dart';
import 'package:delivery_basket/screens/language_screen/language_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AppUpdateInfo? _updateInfo;

  FirebaseMessaging? messaging;
  String firebaseToken = "";

  accessDeviceFirebaseToken() {
    messaging = FirebaseMessaging.instance;
    messaging!.subscribeToTopic("messaging");
    messaging!.getToken().then((value) {
      print("firebase token-- " + value!);
      firebaseToken = value;
      saveFirebaseToken(firebaseToken);
      setState(() {
        firebaseToken = value;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    //checkForUpdateInit();
    //checkUserLogin();
    accessDeviceFirebaseToken();
    AndroidFirebaseMessageManager().init();
    checkForUpdate();
  }

  Future<void> checkForUpdateInit() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
      });
      print("update check ${_updateInfo}");
    });
  }

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
      });
      print("update check ${_updateInfo?.availableVersionCode}");
      if (_updateInfo?.updateAvailability ==
          UpdateAvailability.updateAvailable) {
        print("update dialog show");
        InAppUpdate.performImmediateUpdate();
      } else {
        print("update dialog not show");
        checkUserLogin();
      }
    }).catchError((e) {
      checkUserLogin();
    });
  }

  void checkUserLogin() async {
    Timer(Duration(seconds: 2), () async {
      bool? showIntro = await getIntroShow();
      String language = await getI18n("language");
      if (showIntro == true || language == "") {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => LanguageScreen(hideBackButton: true)));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Image.asset("assets/images/logo.png"))
        ],
      ),
    );
  }
}
