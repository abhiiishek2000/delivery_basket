import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:delivery_basket/data/local/shared_pref.dart';
import 'package:delivery_basket/data/remote/model/login/firebase_token_push_response.dart';
import 'package:delivery_basket/data/remote/repository.dart';
import 'package:delivery_basket/generated/l10n.dart';
import 'package:delivery_basket/screens/component/android_firebase_message_manager.dart';
import 'package:delivery_basket/screens/component/basket_button.dart';
import 'package:delivery_basket/screens/home/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';

class Intro {
  final String image;
  final String header;
  final String desc;

  Intro(this.image, this.header, this.desc);
}

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  int currentIndex = 0;
  bool isLoading = false;
  Repository? _repository;
  FirebaseMessaging? messaging;
  String firebaseToken = "";

  String strintroFirstHeadline = "";
  String strintroFirst = "";
  String strintroSecondHeadline = "";
  String strintroSecond = "";
  String strintroThirdHeadline = "";
  String strintroThird = "";

  init() async {
    strintroFirstHeadline = await getI18n("introFirstHeadline");
    strintroFirst = await getI18n("introFirst");
    strintroSecondHeadline = await getI18n("introSecondHeadline");
    strintroSecond = await getI18n("introSecond");
    strintroThirdHeadline = await getI18n("introThirdHeadline");
    strintroThird = await getI18n("introThird");
    setState(() {});
  }

  @override
  void initState() {
    init();
    _repository = Repository();
    super.initState();
    accessDeviceFirebaseToken();
    AndroidFirebaseMessageManager().init();
  }

  apiFirebaseTokenUpdate() async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    map['device_key'] = firebaseToken;
    try {
      FirebaseTokenPushResponse? response =
          await _repository?.apiFirebaseTokenPush(context, map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
      } else {}
    } catch (e) {
      print("error: ${e.toString()}");
      print(e);
    }
  }

  accessDeviceFirebaseToken() {
    messaging = FirebaseMessaging.instance;
    messaging!.subscribeToTopic("messaging");
    messaging!.getToken().then((value) {
      print("firebase token-- " + value!);
      firebaseToken = value;
      setState(() {
        firebaseToken = value;
      });
      apiFirebaseTokenUpdate();
    });
  }

  @override
  Widget build(BuildContext context) {
    var listIntros = <Widget>[
      IntroItem(
          data: Intro("assets/images/ic_intro_1.png", strintroFirstHeadline,
              strintroFirst)),
      IntroItem(
          data: Intro("assets/images/ic_intro_2.png", strintroSecondHeadline,
              strintroSecond)),
      IntroItem(
          data: Intro("assets/images/ic_intro_3.png", strintroThirdHeadline,
              strintroThird))
    ];
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: listIntros.length,
              onPageChanged: (value) {
                setState(() {
                  currentIndex = value;
                });
              },
              itemBuilder: (BuildContext context, int index) {
                return listIntros[currentIndex];
              },
            ),
          ),
          Positioned(
            bottom: 26,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      for (int i = 0; i < listIntros.length; i++)
                        if (i == currentIndex) ...[circleBar(true)] else
                          circleBar(false),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  BasketButton(
                      title: "${currentIndex == 2 ? "Get started" : "Skip"}",
                      onClick: () {
                        if (currentIndex != 2) {
                          setState(() {
                            currentIndex++;
                          });
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                        }
                      }),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 12 : 8,
      width: isActive ? 12 : 8,
      decoration: BoxDecoration(
          color: isActive ? kPrimaryColor : kColorGrey,
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }
}

class IntroItem extends StatefulWidget {
  final Intro data;

  const IntroItem({Key? key, required this.data}) : super(key: key);

  @override
  _IntroItemState createState() => _IntroItemState();
}

class _IntroItemState extends State<IntroItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: 318,
              height: 279,
              child: Stack(
                children: [
                  Align(
                    alignment: AlignmentDirectional(0.4, -1.0),
                    child: Image.asset(
                      'assets/images/introbg.png',
                      height: 240,
                    ),
                  ),
                  Image.asset(
                    widget.data.image,
                  )
                ],
              )),
          SizedBox(
            height: 24,
          ),
          Row(
            children: [
              Text(widget.data.header,
                  style: GoogleFonts.getFont(
                    'Lato',
                    color: Color(0xFF323232),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Text(widget.data.desc,
              textAlign: TextAlign.left,
              style: GoogleFonts.getFont(
                'Open Sans',
                color: Color(0xFF000000),
                fontSize: 14,
              )),
        ],
      ),
    );
  }
}
