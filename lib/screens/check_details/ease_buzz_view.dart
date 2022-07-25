import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:crypto/crypto.dart';
import 'package:delivery_basket/data/local/shared_pref.dart';
import 'package:delivery_basket/data/remote/model/setting/user_profile_response.dart';
import 'dart:convert';

import 'package:delivery_basket/data/remote/repository.dart';

class EaseBuzzPaymentView extends StatefulWidget {
  final double? amount;
  const EaseBuzzPaymentView({Key? key, this.amount}) : super(key: key);

  @override
  _EaseBuzzPaymentViewState createState() => _EaseBuzzPaymentViewState();
}

class _EaseBuzzPaymentViewState extends State<EaseBuzzPaymentView> {
  static MethodChannel _channel = MethodChannel('easebuzz');
  String accessKey = "K98FUOEK92";
  String salt = "C7SR81ZU12";
  String productInfo = "Vidarbha Basket";
  String firstName = "";
  String email = "";
  String phone = "";



  fetchUserDetails() async {
    var map = Map<String, String>();
    try {
      UserProfileResponse? response =
      await Repository().fetchUserProfile(context, map);
      if (response.success ?? false) {
        setState(() {
          email = response.data?.email??"";
          firstName = response.data?.name??"";
          phone = response.data?.mobileNumber??"";
        });
      } else {

      }
    } catch (e) {
      print("error: ${e.toString()}");
      print(e);
    }
  }

  initValues()async{
    await fetchUserDetails();
    easePaymentInit();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initValues();
    //paymentInit();
  }

  easePaymentInit(){
    String transId = generateRandomString(10);
    String hashInput = "$accessKey|$transId|${widget.amount}|${productInfo}|${firstName}|${email}|||||||||||$salt";

    Map<String,String> map = Map<String,String>();
    map['key'] = accessKey;
    map['txnid'] = transId;
    map['amount'] = "${widget.amount??0.0}";
    map['productinfo'] = productInfo;
    map['firstname'] = firstName;
    map['email'] = email;
    map['udf1'] = "";
    map['udf2'] = "";
    map['udf3'] = "";
    map['udf4'] = "";
    map['udf5'] = "";
    map['udf6'] = "";
    map['udf7'] = "";
    map['udf8'] = "";
    map['udf9'] = "";
    map['udf10'] = "";
    map['salt'] = salt;
    map['hash'] = genetateSha512(hashInput);
    map['surl'] = "http://localhost:3000/response.php";
    map['furl'] = "http://localhost:3000/response.php";
    map['address1'] = "";
    map['address2'] = "";
    map['city'] = "";
    map['state'] = "";
    map['country'] = "";
    map['zipcode'] = "";
    map['sub_merchant_id'] = "";
    map['phone'] = phone;

    Repository().easeBuzzPaymentInit(context, map).then((value) {
      print("payment init ${value.toString()}");
      paymentInit(value.data??"");
    });

  }

  String genetateSha512(String value){
    var bytes = utf8.encode(value);
    Digest sha512Result = sha512.convert(bytes);
    return sha512Result.toString();
  }



  paymentInit(String accessKey) async {
    String access_key = accessKey;
    String pay_mode = "production";//"test"; //or “production";

    Object parameters = {
      "access_key": access_key,
      "pay_mode": pay_mode,
      // "amount": 50.0,
      // "customer_phone": "7304610113",
      // "txnid": "2PBP7IABZ2",
      // "productinfo": "Tshirt",
      // "key": access_key,
      // "salt": "C7SR81ZU12"
    };
    final payment_response =
        await _channel.invokeMethod("payWithEasebuzz", parameters);

    print("payment response  -- > ${payment_response.toString()}");
    final Map response =
        await _channel.invokeMethod("payWithEasebuzz", parameters);
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [],
      ),
    );
  }
}
