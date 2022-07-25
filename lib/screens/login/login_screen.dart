//import 'package:facebook_app_events/facebook_app_events.dart';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
//import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:package_info/package_info.dart';
import 'package:delivery_basket/data/local/DBProvider.dart';
import 'package:delivery_basket/data/local/model/CartModel.dart';
import 'package:delivery_basket/data/local/shared_pref.dart';
import 'package:delivery_basket/data/remote/model/cart/cart_local_post_response.dart';
import 'package:delivery_basket/data/remote/model/login/firebase_token_push_response.dart';
import 'package:delivery_basket/data/remote/model/login/login_response.dart';
import 'package:delivery_basket/data/remote/repository.dart';
import 'package:delivery_basket/generated/l10n.dart';
import 'package:delivery_basket/screens/forgot_password/forgot_password_screen.dart';
import 'package:delivery_basket/screens/home/home_screen.dart';
import 'package:delivery_basket/screens/signup/mobile_fill_screen.dart';

import '../../constants.dart';

class LoginScreen extends StatefulWidget {
  final bool isShowBack;

  const LoginScreen({Key? key, this.isShowBack = false}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //static final facebookAppEvents = FacebookAppEvents();
  bool isLoading = false;
  Repository? _repository;
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _passwordVisible = false;
  FirebaseMessaging? messaging;
  String firebaseToken = "";
  String strLoginSuccessfull = "";
  String strLoginFailed = "";
  String strHelloUser = "";
  String strLoginToContinue = "";
  String strMobile = "";
  String strPassword = "";
  String strForgotPassword = "";
  String strLogin = "";
  String strDontHaveAnAccount = "";
  String strSignup = "";
  String strEnterMobileNumber = "";
  String strEnterValidMobileNumber = "";
  String strEnterPassword = "";
  String strPasswordLengthInvalid = "";

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

  init() async {
    strLoginSuccessfull = await getI18n("loginSuccess");
    strLoginFailed = await getI18n("loginFailed");
    strHelloUser = await getI18n("helloUser");
    strLoginToContinue = await getI18n("loginToContinue");
    strMobile = await getI18n("mobile");
    strPassword = await getI18n("password");
    strForgotPassword = await getI18n("forgotPassword");
    strLogin = await getI18n("loginpage");
    strDontHaveAnAccount = await getI18n("dontHaveAnAccount");
    strSignup = await getI18n("signUp");
    strEnterMobileNumber = await getI18n("enterMobileNumber");
    strEnterValidMobileNumber = await getI18n("enterValidMobileNumber");
    strEnterPassword = await getI18n("enterPassword");
    strPasswordLengthInvalid = await getI18n("passwordLengthInvalid");
    setState(() {});
  }

  @override
  void initState() {
    init();
    super.initState();
    _repository = Repository();
    //facebookAppEvents.logEvent(name: 'login', parameters: {'status': 'login_screen_open',},);
    if (Platform.isIOS) {
      appTrackingTransparency();
    }
    accessDeviceFirebaseToken();
  }

  void appTrackingTransparency() async {
    final status = await AppTrackingTransparency.requestTrackingAuthorization();
    try {
      if (await AppTrackingTransparency.trackingAuthorizationStatus ==
          TrackingStatus.notDetermined) {
        Navigator.pop(context);
        if (await showCustomTrackingDialog(context)) {
          await Future.delayed(const Duration(milliseconds: 200));
          await AppTrackingTransparency.requestTrackingAuthorization();
        }
      }
    } on PlatformException {
      // Unexpected exception was thrown
    }
  }

  Future<bool> showCustomTrackingDialog(BuildContext context) async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Dear User'),
          content: const Text(
            'We care about your privacy and data security. We keep this app free by showing ads. '
            'Can we continue to use your data to tailor ads for you?\n\nYou can change your choice anytime in the app settings. '
            'Our partners will collect data and use a unique identifier on your device to show you ads.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("I'll decide later"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Allow tracking'),
            ),
          ],
        ),
      ) ??
      false;

  void loginUser(String mobile, String password, String firebaseToken) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    map['mobile_number'] = mobile;
    map['password'] = password;
    map['version'] = packageInfo.version;
    map['device_key'] = firebaseToken;
    try {
      LoginResponse? response = await _repository?.loginUser(context, map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        Fluttertoast.showToast(msg: strLoginSuccessfull);
        saveLogin(true);
        saveToken("Bearer ${response?.data?.token}");
        //facebookAppEvents.logEvent(name: 'login', parameters: {'status': 'login_success',},);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false);
        cartLocalPost();
        apiFirebaseTokenUpdate();
      } else {
        Fluttertoast.showToast(msg: strLoginFailed);
      }
    } catch (e) {
      print("error: ${e.toString()}");
      Fluttertoast.showToast(msg: strLoginFailed);
      print(e);
    }
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

  cartLocalPost() async {
    setState(() {
      isLoading = true;
    });
    List<Cart> carts = await DBProvider.db.getAllCart();
    var map = Map<String, String>();
    carts.forEach((element) {
      map['product_id[${element.id}]'] = "${element.quantity}";
    });
    if (carts.length == 0) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false);
    } else {
      try {
        CartLocalPostResponse? response =
            await _repository?.cartLocalPost(context, map);
        await DBProvider.db.deleteAllCart();
        response?.data?.card?.forEach((element) async {
          await DBProvider.db.newCart(Cart(
              id: element?.productId ?? 0,
              prodId: element?.productId ?? 0,
              name: "",
              quantity: double.parse(element?.quantity ?? "0").toInt()));
        });
        setState(() {
          isLoading = false;
        });
        if (response?.success ?? false) {
          //facebookAppEvents.logEvent(name: 'cart_local_post', parameters: {'status': 'cart_successfully_push_to_server',},);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
              (route) => false);
        } else {
          //facebookAppEvents.logEvent(name: 'cart_local_post', parameters: {'status': 'cart_failed_push_to_server',},);
        }
      } catch (e) {
        print("error: ${e.toString()}");
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (widget.isShowBack) ...[
            Positioned(
                left: 0,
                top: 16,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                        (route) => false);
                  },
                )),
          ],
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        strHelloUser,
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: Colors.black, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        strLoginToContinue,
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            color: Colors.black, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffCECECE)),
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: MediaQuery.of(context).size.height * 0.06,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5)),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/Icon material-call.svg',
                                width: 15,
                                height: 15,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: MediaQuery.of(context).size.height * 0.05,
                          decoration: BoxDecoration(
                            color: Color(0xFFB8B8B8),
                          ),
                        ),
                        Expanded(
                            child: TextFormField(
                          controller: mobileController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.fromLTRB(6, 3, 6, 3),
                              hintText: strMobile),
                        ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffCECECE)),
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: MediaQuery.of(context).size.height * 0.06,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5)),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/Icon material-lock.svg',
                                width: 15,
                                height: 15,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: MediaQuery.of(context).size.height * 0.05,
                          decoration: BoxDecoration(
                            color: Color(0xFFB8B8B8),
                          ),
                        ),
                        Expanded(
                            child: TextFormField(
                          obscureText: !_passwordVisible,
                          controller: passwordController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.fromLTRB(6, 13, 6, 3),
                            hintText: strPassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                // Update the state i.e. toogle the state of passwordVisible variable
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ),
                        ))
                      ],
                    ),
                  ),
                  Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ForgotPasswordScreen()));
                          },
                          child: Text(
                            strForgotPassword,
                            style: TextStyle(color: Color(0xff323232)),
                          ))),
                  SizedBox(
                    height: 16,
                  ),
                  InkWell(
                    onTap: () {
                      if (mobileController.text.isEmpty) {
                        Fluttertoast.showToast(msg: strEnterMobileNumber);
                      } else if (mobileController.text.length != 10) {
                        Fluttertoast.showToast(msg: strEnterValidMobileNumber);
                      } else if (passwordController.text.isEmpty) {
                        Fluttertoast.showToast(msg: strEnterPassword);
                      } else if (passwordController.text.length < 3 ||
                          passwordController.text.length > 15) {
                        Fluttertoast.showToast(msg: strPasswordLengthInvalid);
                      } else {
                        loginUser(mobileController.text,
                            passwordController.text, firebaseToken);
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.06,
                      decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                          child: Text(
                        strLogin,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            ?.copyWith(color: Color(0xff323232)),
                      )),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MobileFillScreen()));
                    },
                    child: RichText(
                      text: TextSpan(
                        text: strDontHaveAnAccount,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            ?.copyWith(color: Color(0xff3F3F3F)),
                        children: [
                          TextSpan(
                            text: strSignup,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                ?.copyWith(
                                    color: Color(0xffA3CC39),
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.underline),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
