import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:delivery_basket/data/local/shared_pref.dart';
import 'package:delivery_basket/data/remote/model/payment/RazorpayOrderResponse.dart';
import 'package:delivery_basket/data/remote/model/setting/application_setting_response.dart';
import 'package:delivery_basket/data/remote/model/wallet/wallet_add_response.dart';
import 'package:delivery_basket/data/remote/repository.dart';
import 'package:delivery_basket/generated/l10n.dart';
import 'package:delivery_basket/screens/wallet/wallet_overview.dart';
import '../../constants.dart';

class WalletFillAmountScreen extends StatefulWidget {
  @override
  _WalletFillAmountScreenState createState() => _WalletFillAmountScreenState();
}

class _WalletFillAmountScreenState extends State<WalletFillAmountScreen> {
  TextEditingController amountController = TextEditingController();
  static const platform = const MethodChannel("razorpay_flutter");
  bool isLoading = false;
  late Razorpay _razorpay;
  Repository? _repository;
  ApplicationSettingResponse? applicationSetting;

  String strwallet = "";
  String strenterAmount = "";
  String straddAmount = "";
  init()async{
     strwallet = await getI18n("wallet");
     strenterAmount = await getI18n("enterAmount");
     straddAmount = await getI18n("addAmount");
    setState(() {
    });
  }

  @override
  void initState() {
    init();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
    _repository = Repository();
    fetchApplicationSetting();
  }


  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  fetchApplicationSetting() async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    try {
      ApplicationSettingResponse? response =
      await _repository?.fetchApplicationSetting(context, map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        setState(() {
          applicationSetting = response;
        });
      } else {
        Fluttertoast.showToast(msg: "failed to load application setting");
      }
    } catch (e) {
      print("error: ${e.toString()}");
      print(e);
    }
  }

  walletAddAmount(PaymentSuccessResponse response) async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    map['amount'] = amountController.text;
    map['type'] = "razorpay";
    map['razor_payment_id'] = response.paymentId.toString();
    map['order_id'] = response.orderId.toString();
    map['signature'] = response.signature.toString();
    map['comment'] = "add to wallet";
    try {
      WalletResponse? response = await _repository?.walletAddMoney(context,map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        Fluttertoast.showToast(msg: "Money added successfully to wallet");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>WalletOverViewScreen()));
      } else {
        Fluttertoast.showToast(msg: "failed to add money on wallet");
      }
    } catch (e) {
      print("error: ${e.toString()}");
      print(e);
    }
  }

  Future<dynamic> createOrder() async {
    setState(() {
      isLoading = true;
    });
    var mapHeader = new Map<String, String>();
    mapHeader['Authorization'] = "Basic ${applicationSetting?.data?.applicationSetting?.rezorPayAuthKey}";
    mapHeader['Accept'] = "application/json";
    mapHeader['Content-Type'] = "application/x-www-form-urlencoded";
    var map =  new Map<String, String>();
    map['amount'] = "${int.parse(amountController.text)*100}";
    map['currency'] = "INR";
    map['receipt']  = "receipt1";
    print("map ${map}");
    var response = await http.post(Uri.https( "api.razorpay.com","/v1/orders"),headers:mapHeader,body: map );
    setState(() {
      isLoading = false;
    });
    print("...."+response.body);
    if (response.statusCode == 200) {
      RazorpayOrderResponse data  = RazorpayOrderResponse.fromJson(json.decode(response.body));
      openCheckout(data);
    }
  }

  void openCheckout(RazorpayOrderResponse data) async {
    var options = {
      'key': '${applicationSetting?.data?.applicationSetting?.rPayKey}',
      'amount': "${int.parse(amountController.text)*100}",
      'name': 'Vidarbha Basket.',
      'description': '',
      'order_id':'${data.id}',
      //'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        //'wallets': ['paytm']
      }
    };

    try {
      setState(() {
        isLoading = true;
      });
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId!, toastLength: Toast.LENGTH_SHORT);
    setState(() {
      isLoading = false;
    });
    walletAddAmount(response);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message!,
        toastLength: Toast.LENGTH_SHORT);
    setState(() {
      isLoading = false;
    });
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!, toastLength: Toast.LENGTH_SHORT);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffCECECE)),
                    borderRadius: BorderRadius.circular(15)
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 6),
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        border: Border.all(color: kPrimaryColor,),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: FaIcon(FontAwesomeIcons.rupeeSign,size: 20,color: Colors.white,),
                    ),
                    SizedBox(width: 8,),
                    Expanded(child:  TextFormField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.fromLTRB(6, 3, 6, 3),
                          hintText:strwallet
                      ),
                    ))
                  ],
                ),
              ),
              SizedBox(height: 16,),
              InkWell(
                onTap: (){
                    if(amountController.text.isEmpty){
                      Fluttertoast.showToast(msg:strenterAmount);
                    }else{
                      createOrder();
                    }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(child: Text(straddAmount,style: Theme.of(context).textTheme.subtitle1?.copyWith(color: Colors.white),)),
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
                    color: Colors.white,
                    border: Border.all(
                      color: Color(0xffF1F1F1).withOpacity(0.9),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Color(0xffF1F1F1),
                          offset: Offset(0.3, 1.0),
                          blurRadius: 3.0)
                    ]),
                child: SvgPicture.asset("assets/images/ic_back.svg"),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Text(
               strwallet,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
