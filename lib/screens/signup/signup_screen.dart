//import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info/package_info.dart';
import 'package:delivery_basket/data/local/DBProvider.dart';
import 'package:delivery_basket/data/local/model/CartModel.dart';
import 'package:delivery_basket/data/local/shared_pref.dart';
import 'package:delivery_basket/data/remote/model/cart/cart_local_post_response.dart';
import 'package:delivery_basket/data/remote/model/login/firebase_token_push_response.dart';
import 'package:delivery_basket/data/remote/model/signup/signup_fail_response.dart';
import 'package:delivery_basket/data/remote/model/signup/signup_response.dart';
import 'package:delivery_basket/data/remote/repository.dart';
import 'package:delivery_basket/generated/l10n.dart';
import 'package:delivery_basket/screens/home/home_screen.dart';
import 'package:delivery_basket/screens/login/login_screen.dart';

import '../../constants.dart';
import 'mobile_fill_screen.dart';

class SignupScreen extends StatefulWidget {
  final String mobile;

  const SignupScreen({Key? key, required this.mobile}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  //static final facebookAppEvents = FacebookAppEvents();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  bool isLoading = false;
  Repository? _repository;
  bool _passwordVisible = false;
  bool _rePasswordVisible = false;

  FirebaseMessaging? messaging;
  String firebaseToken = "";

  String registrationSuccessfully = "";
  String registrationFailed = "";
  String signUp = "";
  String pleaseTypeYourInformationBelow = "";
  String fullName = "";
  String email = "";
  String optional = "";
  String password = "";
  String rePassword = "";
  String iAgreeTermConditions = "";
  String pleaseEnterName = "";
  String enterPassword = "";
  String passwordLengthInvalid = "";
  String passwordNotMatched = "";
  String alreadyHaveAnAccount = "";
  String loginpage = "";

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
    registrationSuccessfully = await getI18n("registrationSuccessfully");
    registrationFailed = await getI18n("registrationFailed");
    signUp = await getI18n("signUp");
    pleaseTypeYourInformationBelow =
        await getI18n("pleaseTypeYourInformationBelow");
    fullName = await getI18n("fullName");
    email = await getI18n("email");
    optional = await getI18n("optional");
    password = await getI18n("password");
    rePassword = await getI18n("rePassword");
    iAgreeTermConditions = await getI18n("iAgreeTermConditions");
    pleaseEnterName = await getI18n("pleaseEnterName");
    enterPassword = await getI18n("enterPassword");
    passwordLengthInvalid = await getI18n("passwordLengthInvalid");
    passwordNotMatched = await getI18n("passwordNotMatched");
    alreadyHaveAnAccount = await getI18n("alreadyHaveAnAccount");
    loginpage = await getI18n("loginpage");
    setState(() {});
  }

  @override
  void initState() {
    init();
    super.initState();
    _repository = Repository();
    // facebookAppEvents.logEvent(
    //   name: 'signup',
    //   parameters: {
    //     'signup_screen_open': 'signup_screen_open',
    //   },
    // );
    setState(() {
      mobileController.text = widget.mobile;
    });
    accessDeviceFirebaseToken();
  }

  registerUser(String name, String email, String password, String mobile,
      String firebaseToken) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    map['name'] = name;
    map['mobile_number'] = mobile;
    map['password'] = password;
    map['c_password'] = password;
    map['email'] = email;
    map['version'] = packageInfo.version;
    map['device_key'] = firebaseToken;
    try {
      SignupResponse? response = await _repository?.signUpUser(context, map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        Fluttertoast.showToast(msg: registrationSuccessfully);
        saveLogin(true);
        // facebookAppEvents.logEvent(
        //   name: 'signup',
        //   parameters: {
        //     'signup_register_success': 'signup_register_success',
        //   },
        // );
        saveToken("Bearer ${response?.data?.token}");
        //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomeScreen()), (route) => false);
        cartLocalPost();
        apiFirebaseTokenUpdate();
      } else {
        // facebookAppEvents.logEvent(
        //   name: 'signup',
        //   parameters: {
        //     'signup_register_failed': 'signup_register_failed',
        //   },
        // );
        Fluttertoast.showToast(msg: registrationFailed);
      }
    } catch (e) {
      print("error: ${e.toString()}");
      // facebookAppEvents.logEvent(
      //   name: 'signup',
      //   parameters: {
      //     'signup_register_failed': 'signup_register_failed',
      //   },
      // );
      Fluttertoast.showToast(msg: registrationFailed);
      if (e.runtimeType == SignupFailResponse) {
        SignupFailResponse? data = e as SignupFailResponse;
        Fluttertoast.showToast(msg: data.data?.mobileNumber.toString() ?? "");
      }

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
        setState(() {
          isLoading = false;
        });
        if (response?.success ?? false) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
              (route) => false);
        } else {}
      } catch (e) {
        print("error: ${e.toString()}");
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  signUp,
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: Colors.black, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  pleaseTypeYourInformationBelow,
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
              // child: Row(
              //   children: [
              //     SvgPicture.asset("assets/images/ic_phone_group.svg"),
              //     SizedBox(
              //       width: 8,
              //     ),
              //     Expanded(
              //         child: TextFormField(
              //       controller: nameController,
              //       decoration: InputDecoration(
              //           border: InputBorder.none,
              //           isDense: true,
              //           contentPadding: EdgeInsets.fromLTRB(6, 3, 6, 3),
              //           hintText: fullName),
              //     ))
              //   ],
              // ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: MediaQuery.of(context).size.height * 0.06,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/user1.svg',
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
                    controller: nameController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.fromLTRB(6, 3, 6, 3),
                      hintText: fullName,
                    ),
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
              // child: Row(
              //   children: [
              //     SvgPicture.asset("assets/images/ic_phone_group.svg"),
              //     SizedBox(
              //       width: 8,
              //     ),
              //     Expanded(
              //         child: TextFormField(
              //       controller: emailController,
              //       decoration: InputDecoration(
              //           border: InputBorder.none,
              //           isDense: true,
              //           contentPadding: EdgeInsets.fromLTRB(6, 3, 6, 3),
              //           hintText: "${email} (${optional})"),
              //     ))
              //   ],
              // ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: MediaQuery.of(context).size.height * 0.06,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/email1.svg',
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
                    controller: emailController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.fromLTRB(6, 3, 6, 3),
                      hintText: '${email} (${optional})',
                    ),
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
              // child: Row(
              //   children: [
              //     SvgPicture.asset("assets/images/ic_lock_group.svg"),
              //     SizedBox(
              //       width: 8,
              //     ),
              //     Expanded(
              //         child: TextFormField(
              //       obscureText: !_passwordVisible,
              //       //This will obscure text dynamically
              //       controller: passwordController,
              //       decoration: InputDecoration(
              //         border: InputBorder.none,
              //         isDense: true,
              //         contentPadding: EdgeInsets.fromLTRB(6, 13, 6, 3),
              //         hintText: password,
              //         suffixIcon: IconButton(
              //           icon: Icon(
              //             // Based on passwordVisible state choose the icon
              //             _passwordVisible
              //                 ? Icons.visibility
              //                 : Icons.visibility_off,
              //             color: kPrimaryColor,
              //           ),
              //           onPressed: () {
              //             // Update the state i.e. toogle the state of passwordVisible variable
              //             setState(() {
              //               _passwordVisible = !_passwordVisible;
              //             });
              //           },
              //         ),
              //       ),
              //     ))
              //   ],
              // ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: MediaQuery.of(context).size.height * 0.06,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(5)),
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
                      hintText: password,
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
            SizedBox(
              height: 16,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xffCECECE)),
                  borderRadius: BorderRadius.circular(5)),
              child: Row(
                children: [
                  SizedBox(
                    width: 8,
                  ),
                  Image.asset("assets/images/ic_india_flag_circle.png"),
                  SizedBox(
                    width: 8,
                  ),
                  Text("+91"),
                  Expanded(
                      child: TextFormField(
                    enabled: false,
                    controller: mobileController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.fromLTRB(6, 12, 6, 12),
                        hintText: "0000 000 0000"),
                  ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    iAgreeTermConditions,
                    style: TextStyle(decoration: TextDecoration.underline),
                  )),
            ),
            SizedBox(
              height: 16,
            ),
            InkWell(
              onTap: () {
                if (nameController.text.isEmpty) {
                  Fluttertoast.showToast(msg: pleaseEnterName);
                } else if (passwordController.text.isEmpty) {
                  Fluttertoast.showToast(msg: enterPassword);
                } else if (passwordController.text.length < 3 ||
                    passwordController.text.length > 15) {
                  Fluttertoast.showToast(msg: passwordLengthInvalid);
                } else {
                  registerUser(nameController.text, emailController.text,
                      passwordController.text, widget.mobile, firebaseToken);
                }
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                    child: Text(
                  signUp,
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
              onTap: () {},
              child: RichText(
                text: TextSpan(
                  text: alreadyHaveAnAccount,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(color: Color(0xff3F3F3F)),
                  children: [
                    TextSpan(
                      text: loginpage,
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
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
    ));
  }
}
