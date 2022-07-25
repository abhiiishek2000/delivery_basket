import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:delivery_basket/constants.dart';
import 'package:delivery_basket/data/local/shared_pref.dart';
import 'package:delivery_basket/data/remote/model/forgot_password/forgot_password_response.dart';
import 'package:delivery_basket/data/remote/model/otp/otp_response.dart';
import 'package:delivery_basket/data/remote/repository.dart';
import 'package:delivery_basket/generated/l10n.dart';
import 'package:delivery_basket/screens/login/login_screen.dart';
import 'package:delivery_basket/screens/reset_password/reset_password_screen.dart';
import 'package:delivery_basket/screens/signup/mobile_fill_screen.dart';
import 'package:delivery_basket/screens/signup/signup_screen.dart';

class OtpScreen extends StatefulWidget {
  final String mobile;
  final bool? isForgotPassword;

  const OtpScreen(
      {Key? key, required this.mobile, this.isForgotPassword = false})
      : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otpController = TextEditingController();
  bool isLoading = false;
  Repository? _repository;
  String otp = "";
  String enterdOtp = "";

  String otpSendSuccessfully = "";
  String numberAlreadyExist = "";
  String verification = "";
  String enterOtpBelow = "";
  String strresendOtp = "";
  String resendOtpIn = "";
  String sec = "";
  String verify = "";
  String enterOtp = "";
  String otpNotMatched = "";
  String otpMatched = "";

  Timer? _timer;
  int _start = 60;

  @override
  void initState() {
    init();
    super.initState();
    _repository = Repository();

    if (widget.isForgotPassword ?? false) {
      forgotPassword(widget.mobile);
    } else {
      sendOtp(widget.mobile);
    }
    startTimer();
  }

  init() async {
    otpSendSuccessfully = await getI18n("otpSendSuccessfully");
    numberAlreadyExist = await getI18n("numberAlreadyExist");
    verification = await getI18n("verification");
    enterOtpBelow = await getI18n("enterOtpBelow");
    strresendOtp = await getI18n("resendOtp");
    resendOtpIn = await getI18n("resendOtpIn");
    sec = await getI18n("sec");
    verify = await getI18n("verify");
    enterOtp = await getI18n("enterOtp");
    otpNotMatched = await getI18n("otpNotMatched");
    otpMatched = await getI18n("otpMatched");
    setState(() {});
  }

  void onEnd() {
    print("Resending otp");
  }

  String generateOtp() {
    var rndnumber = "";
    var rnd = new Random();
    for (var i = 0; i < 6; i++) {
      rndnumber = rndnumber + rnd.nextInt(9).toString();
    }
    print(rndnumber);
    setState(() {
      otp = rndnumber;
    });
    return rndnumber;
  }

  sendOtp(String mobile) async {
    generateOtp();
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    map['otp'] = otp;
    map['mobile_number'] = mobile;
    try {
      OtpResponse? response = await _repository?.sendOtp(context, map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        Fluttertoast.showToast(msg: otpSendSuccessfully);
      } else {
        if (response?.message == "Alredy Exits") {
          Fluttertoast.showToast(msg: "already exists");
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false);
        }
      }
    } catch (e) {
      print("error: ${e.toString()}");
      Fluttertoast.showToast(msg: numberAlreadyExist);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MobileFillScreen()),
          (route) => false);
      print(e);
    }
  }

  forgotPassword(String mobile) async {
    generateOtp();
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    map['otp'] = otp;
    map['mobile_number'] = mobile;
    try {
      ForgotPasswordResponse? response =
          await _repository?.fetchForgotPassword(context, map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        Fluttertoast.showToast(msg: otpSendSuccessfully);
      } else {
        if (response?.message == "Alredy Exits") {
          Fluttertoast.showToast(msg: numberAlreadyExist);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false);
        }
      }
    } catch (e) {
      print("error: ${e.toString()}");
      Fluttertoast.showToast(msg: numberAlreadyExist);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false);
      print(e);
    }
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar(),
        body: Column(
          children: [
            SizedBox(
              height: 16,
            ),
            Center(
                child: Text(
              verification,
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  ?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Center(
                  child: Text(
                enterOtpBelow,
                textAlign: TextAlign.center,
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: PinCodeTextField(
                length: 6,
                obscureText: false,
                animationType: AnimationType.fade,
                keyboardType: TextInputType.number,
                animationDuration: Duration(milliseconds: 300),
                onChanged: (value) {
                  setState(() {
                    enterdOtp = value;
                  });
                },
                appContext: context,
              ),
            ),
            _start != 0
                ? Text('${resendOtpIn} ${_start} ${sec}')
                : TextButton(
                    onPressed: () {
                      setState(() {
                        _start = 60;
                      });
                      startTimer();
                      if (widget.isForgotPassword ?? false) {
                        forgotPassword(widget.mobile);
                      } else {
                        sendOtp(widget.mobile);
                      }
                    },
                    child: Text(strresendOtp)),
            SizedBox(
              height: 16,
            ),
            CupertinoButton(
              child: Text(
                verify,
                style: TextStyle(color: Color(0xff323232)),
              ),
              onPressed: () {
                if (enterdOtp.isEmpty) {
                  Fluttertoast.showToast(msg: enterOtp);
                } else if (enterdOtp != otp) {
                  Fluttertoast.showToast(msg: otpNotMatched);
                } else if (enterdOtp == otp) {
                  Fluttertoast.showToast(msg: otpMatched);
                  if (widget.isForgotPassword ?? false) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResetPasswordScreen(
                                  mobile: widget.mobile,
                                )));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignupScreen(
                                  mobile: widget.mobile,
                                )));
                  }
                }
              },
              color: kPrimaryColor,
            )
          ],
        ),
      ),
    );
  }

  PreferredSize appBar() {
    return PreferredSize(
      preferredSize: Size(MediaQuery.of(context).size.width, 56),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: SvgPicture.asset("assets/images/ic_back.svg"),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Text(
                "",
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
