import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:delivery_basket/data/local/shared_pref.dart';
import 'package:delivery_basket/generated/l10n.dart';
import 'package:delivery_basket/screens/otp/otp_screen.dart';

import '../../constants.dart';

class MobileFillScreen extends StatefulWidget {
  @override
  _MobileFillScreenState createState() => _MobileFillScreenState();
}

class _MobileFillScreenState extends State<MobileFillScreen> {
  TextEditingController mobileController = TextEditingController();
  String forSignUp = "";
  String pleaseEnterNumberBelow = "";
  String enterMobileNumber = "";
  String enterValidMobileNumber = "";
  String sendOtp = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async {
    forSignUp = await getI18n("forSignUp");
    pleaseEnterNumberBelow = await getI18n("pleaseEnterNumberBelow");
    enterMobileNumber = await getI18n("enterMobileNumber");
    enterValidMobileNumber = await getI18n("enterValidMobileNumber");
    sendOtp = await getI18n("sendOtp");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
                        forSignUp,
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: Colors.black, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        pleaseEnterNumberBelow,
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Image.asset("assets/images/ic_india_flag_circle.png"),
                          SizedBox(
                            width: 8,
                          ),
                          Text("+91"),
                          SizedBox(
                            width: 8,
                          ),
                          Container(
                            width: 1,
                            height: MediaQuery.of(context).size.height * 0.04,
                            decoration: BoxDecoration(
                              color: Color(0xFFB8B8B8),
                            ),
                          ),
                          Expanded(
                              child: TextFormField(
                            controller: mobileController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              new LengthLimitingTextInputFormatter(10),
                            ],
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.fromLTRB(6, 6, 6, 6),
                                hintText: "0000 000 0000"),
                          ))
                        ],
                      ),
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
                                    )));
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                          child: Text(
                        sendOtp,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            ?.copyWith(color: Color(0xff323232)),
                      )),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
