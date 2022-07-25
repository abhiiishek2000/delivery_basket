import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:delivery_basket/data/local/shared_pref.dart';
import 'package:delivery_basket/data/remote/model/forgot_password/reset_password_response.dart';
import 'package:delivery_basket/data/remote/repository.dart';
import 'package:delivery_basket/generated/l10n.dart';
import 'package:delivery_basket/screens/home/home_screen.dart';
import 'package:delivery_basket/screens/login/login_screen.dart';

import '../../constants.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String mobile;

  const ResetPasswordScreen({Key? key, required this.mobile}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool _passwordVisible = false;
  bool _passwordReVisible = false;
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordReController = TextEditingController();
  bool isLoading = false;
  Repository? _repository;

  String passwordChanged = "";
  String passwordChangeFailed = "";
  String strresetPassword = "";
  String pleaseEnterNewPassword = "";
  String password = "";
  String rePassword = "";
  String enterPassword = "";
  String passwordLengthInvalid = "";
  String pleaseEnterRepeatPassword = "";
  String passwordNotMatched = "";
  String send = "";

  @override
  void initState() {
    init();
    super.initState();
    _repository = Repository();
  }

  init() async {
    passwordChanged = await getI18n("passwordChanged");
    passwordChangeFailed = await getI18n("passwordChangeFailed");
    strresetPassword = await getI18n("resetPassword");
    pleaseEnterNewPassword = await getI18n("pleaseEnterNewPassword");
    password = await getI18n("password");
    rePassword = await getI18n("rePassword");
    enterPassword = await getI18n("enterPassword");
    passwordLengthInvalid = await getI18n("passwordLengthInvalid");
    pleaseEnterRepeatPassword = await getI18n("pleaseEnterRepeatPassword");
    passwordNotMatched = await getI18n("passwordNotMatched");
    send = await getI18n("send");
    setState(() {});
  }

  resetPassword(String mobile, String password, String rPassword) async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    map['mobile_number'] = mobile;
    map['new_password'] = password;
    map['c_password'] = rPassword;
    try {
      ResetPasswordResponse? response =
          await _repository?.fetchResetPassword(context, map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        Fluttertoast.showToast(msg: passwordChanged);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false);
      } else {
        Fluttertoast.showToast(msg: passwordChangeFailed);
      }
    } catch (e) {
      print("error: ${e.toString()}");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffCECECE)),
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.fromLTRB(12, 8, 6, 3),
                        hintText: password,
                      ),
                    ))
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffCECECE)),
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                      obscureText: true,
                      controller: passwordReController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.fromLTRB(12, 8, 6, 3),
                        hintText: rePassword,
                      ),
                    ))
                  ],
                ),
              ),
              SizedBox(
                height: 32,
              ),
              InkWell(
                onTap: () {
                  if (passwordController.text.isEmpty) {
                    Fluttertoast.showToast(msg: enterPassword);
                  } else if (passwordController.text.length < 3 ||
                      passwordController.text.length > 15) {
                    Fluttertoast.showToast(msg: passwordLengthInvalid);
                  } else if (passwordReController.text.isEmpty) {
                    Fluttertoast.showToast(msg: pleaseEnterRepeatPassword);
                  } else if (passwordReController.text !=
                      passwordController.text) {
                    Fluttertoast.showToast(msg: passwordNotMatched);
                  } else {
                    resetPassword(widget.mobile, passwordController.text,
                        passwordReController.text);
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(
                      child: Text(
                    send,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        ?.copyWith(color: Colors.white),
                  )),
                ),
              ),
            ],
          ),
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
                  color: Color(0xff0000ffff),
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
