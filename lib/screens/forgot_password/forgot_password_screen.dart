import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:delivery_basket/data/local/shared_pref.dart';
import 'package:delivery_basket/generated/l10n.dart';
import 'package:delivery_basket/screens/otp/otp_screen.dart';

import '../../constants.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController mobileController = TextEditingController();
  String forgotPassword = "";
  String forgotPasswordDesc = "";
  String enterMobileNumber = "";
  String enterValidMobileNumber = "";
  String send = "";

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    forgotPassword = await getI18n("forgotPassword");
    forgotPasswordDesc = await getI18n("forgotPasswordDesc");
    enterMobileNumber = await getI18n("enterMobileNumber");
    enterValidMobileNumber = await getI18n("enterValidMobileNumber");
    send = await getI18n("send");
    setState(() {});
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
              Text(
                forgotPassword,
                style: Theme.of(context).textTheme.headline5?.copyWith(
                    color: Color(0xff000000),
                    fontSize: 22,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                forgotPasswordDesc,
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.center,
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
                    Expanded(
                        child: TextFormField(
                      controller: mobileController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.fromLTRB(24, 12, 6, 12),
                          hintText: "Enter email or phone number",
                          hintStyle: TextStyle(
                              fontSize: 14, color: Color(0xffB8B8B8))),
                    ))
                  ],
                ),
              ),
              SizedBox(
                height: 32,
              ),
              InkWell(
                onTap: () {
                  if (mobileController.text.isEmpty) {
                    Fluttertoast.showToast(msg: enterMobileNumber);
                  } else if (mobileController.text.length != 10) {
                    Fluttertoast.showToast(msg: enterValidMobileNumber);
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OtpScreen(
                                  mobile: mobileController.text,
                                  isForgotPassword: true,
                                )));
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
