import 'dart:convert';

//import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:delivery_basket/data/AppNotifer.dart';
import 'package:delivery_basket/data/local/DBProvider.dart';
import 'package:delivery_basket/data/local/shared_pref.dart';
import 'package:delivery_basket/data/remote/model/order/order_place_response.dart';
import 'package:delivery_basket/data/remote/model/payment/RazorpayOrderResponse.dart';
import 'package:delivery_basket/data/remote/model/setting/application_setting_response.dart';
import 'package:delivery_basket/data/remote/model/wallet/wallet_add_response.dart';
import 'package:delivery_basket/data/remote/model/wallet/wallet_deduct_response.dart';
import 'package:delivery_basket/data/remote/repository.dart';
import 'package:delivery_basket/screens/check_details/ease_buzz_view.dart';
import 'package:delivery_basket/screens/check_details/upi_app_list_view.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';
import 'order_success_dialog_view.dart';

class CheckPaymentOptionsView extends StatefulWidget {
  final double amount;
  final double priceItems;

  const CheckPaymentOptionsView(
      {Key? key, required this.amount, required this.priceItems})
      : super(key: key);

  @override
  _CheckPaymentOptionsViewState createState() =>
      _CheckPaymentOptionsViewState();
}

class _CheckPaymentOptionsViewState extends State<CheckPaymentOptionsView> {
  int? selected;
  //static final facebookAppEvents = FacebookAppEvents();

  //razorpay init
  static const platform = const MethodChannel("razorpay_flutter");
  late Razorpay _razorpay;
  double walletAmount = 0.0;
  ApplicationSettingResponse? applicationSetting;
  bool isLoading = false;
  Repository? _repository;
  CheckOutNotifier? checkOutNotifier;

  String strPaymentOptions = "";
  String strupi = "";
  String strcredit = "";
  String strwallet = "";
  String strcod = "";
  String strinsufficientAmountInWallet = "";

  init() async {
    strPaymentOptions = await getI18n("paymentOptions");
    strupi = await getI18n("upi");
    strcredit = await getI18n("netBanking");
    strwallet = await getI18n("wallet");
    strcod = await getI18n("cod");
    strinsufficientAmountInWallet = await getI18n("insufficientAmountInWallet");
    setState(() {});
  }

  @override
  void initState() {
    init();
    print(platform);
    checkOutNotifier = Provider.of<CheckOutNotifier>(context, listen: false);
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _repository = Repository();
    super.initState();
    fetchWalletAmount();
    fetchApplicationSetting();
    setState(() {
      selected = 4;
    });
    checkOutNotifier?.paymentType = "COD";
    checkOutNotifier?.paymentStatus = 2;
  }

  void paymentUpdated(int index) {
    setState(() {
      selected = index;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  Future<dynamic> createOrder() async {
    setState(() {
      isLoading = true;
    });
    var mapHeader = new Map<String, String>();
    mapHeader['Authorization'] =
        "Basic ${applicationSetting?.data?.applicationSetting?.rezorPayAuthKey}";
    mapHeader['Accept'] = "application/json";
    mapHeader['Content-Type'] = "application/x-www-form-urlencoded";
    var map = new Map<String, String>();
    map['amount'] = "${widget.amount.toInt() * 100}";
    map['currency'] = "INR";
    map['receipt'] = "receipt1";
    print("map $map");
    var response = await http.post(Uri.https("api.razorpay.com", "/v1/orders"),
        headers: mapHeader, body: map);
    print("...." + response.body);
    if (response.statusCode == 200) {
      RazorpayOrderResponse data =
          RazorpayOrderResponse.fromJson(json.decode(response.body));
      openCheckout(data);
    }
    setState(() {
      isLoading = true;
    });
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

  walletDeductAmount() async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    map['amount'] = "${widget.amount}";
    try {
      WalletDeductResponse? response =
          await _repository?.walletDeduct(context, map);
      if (response?.success ?? false) {
        Fluttertoast.showToast(msg: "Order Processing ... Please wait");
        checkOutNotifier?.paymentType = "WALLET";
        checkOutNotifier?.paymentStatus = 1;
        checkValidOrder();
      } else {
        Fluttertoast.showToast(msg: "failed to load application setting");
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("error: ${e.toString()}");
      print(e);
    }
  }

  void checkValidOrder() {
    CheckOutNotifier checkOutNotifier =
        Provider.of<CheckOutNotifier>(context, listen: false);
    var map = Map<String, String>();
    map['time_slot_id'] = "${checkOutNotifier.timeSlot}";
    map['delivery_date'] = "${checkOutNotifier.deliveryDate}";
    map['type'] = "${checkOutNotifier.paymentType}";
    map['payment_statu_id'] = "${checkOutNotifier.paymentStatus}";
    map['customer_address_id'] =
        "${checkOutNotifier.deliveryOption == 0 ? checkOutNotifier.addressId : ""}";
    map['coupon'] = "${checkOutNotifier.couponCode}";
    map['type'] = "${checkOutNotifier.paymentType}";
    map['razor_payment_id'] = "${checkOutNotifier.razorPayPaymentId}";
    map['order_id'] = "${checkOutNotifier.orderId}";
    map['signature'] = "${checkOutNotifier.signature}";
    map['comment'] = "${checkOutNotifier.comment}";

    print(map.toString());
    if (checkOutNotifier.deliveryOption == 0 &&
        checkOutNotifier.addressId == -1) {
      showErrorAlertDialog(context, "Alert", "Please select address");
    } else if (checkOutNotifier.deliveryDate == "") {
      showErrorAlertDialog(context, "Alert", "Please select delivery date");
    } else if (checkOutNotifier.timeSlot == -1) {
      showErrorAlertDialog(context, "Alert", "Please select time slot");
    } else if (checkOutNotifier.paymentType == "COD") {
      orderPlace();
    } else {
      orderPlace();
    }
  }

  orderPlace() async {
    setState(() {
      isLoading = true;
    });
    showLoaderDialog(context);
    CheckOutNotifier checkOutNotifier =
        Provider.of<CheckOutNotifier>(context, listen: false);
    var map = Map<String, String>();
    map['time_slot_id'] = "${checkOutNotifier.timeSlot}";
    map['delivery_date'] = "${checkOutNotifier.deliveryDate}";
    map['type'] = "${checkOutNotifier.paymentType}";
    map['payment_statu_id'] = "${checkOutNotifier.paymentStatus}";
    map['customer_address_id'] = "${checkOutNotifier.addressId}";
    map['coupon'] = "${checkOutNotifier.couponCode}";
    map['type'] = "${checkOutNotifier.paymentType}";
    map['razor_payment_id'] = "${checkOutNotifier.razorPayPaymentId}";
    map['order_id'] = "${checkOutNotifier.orderId}";
    map['signature'] = "${checkOutNotifier.signature}";
    map['comment'] = "${checkOutNotifier.comment}";
    try {
      OrderPlaceResponse? response =
          await _repository?.placeOrder(context, map);
      if (response?.success ?? false) {
        Fluttertoast.showToast(msg: "Order placed successfully");
        await DBProvider.db.deleteAllCart();
        // facebookAppEvents.logEvent(
        //   name: 'order',
        //   parameters: {
        //     'order_${checkOutNotifier.paymentType}_success':
        //         'order_placed_successfully',
        //   },
        // );
        Navigator.of(context).push(
          PageRouteBuilder(
            opaque: false, // set to false
            pageBuilder: (_, __, ___) => OrderSuccessDialogView(),
          ),
        );
      } else {
        // facebookAppEvents.logEvent(
        //   name: 'order',
        //   parameters: {
        //     'order_${checkOutNotifier.paymentType}_failed':
        //         'order_failed_to_place',
        //   },
        // );
        Fluttertoast.showToast(msg: "${response?.message}");
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      // facebookAppEvents.logEvent(
      //   name: 'order',
      //   parameters: {
      //     'order_${checkOutNotifier.paymentType}_failed':
      //         'order_failed_to_place',
      //   },
      // );
      print("error: ${e.toString()}");
      Navigator.pop(context);
      print(e);
    }
  }

  void openCheckout(RazorpayOrderResponse data) async {
    setState(() {
      isLoading = true;
    });
    var options = {
      'key': '${applicationSetting?.data?.applicationSetting?.rPayKey}',
      'amount': widget.amount * 100,
      'name': 'Vidarbha Basket.',
      'description': '',
      'order_id': '${data.id}',
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: "Payment paid successfully");
    final checkOutNotifier =
        Provider.of<CheckOutNotifier>(context, listen: false);
    checkOutNotifier.paymentStatus = 1; //done
    checkOutNotifier.razorPayPaymentId = response.paymentId ?? "";
    checkOutNotifier.orderId = response.orderId ?? "";
    checkOutNotifier.signature = response.signature ?? "";
    checkOutNotifier.comment = "razorpay payment sucess";
    checkValidOrder();
    setState(() {
      isLoading = false;
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: "Payment failed");
    final checkOutNotifier =
        Provider.of<CheckOutNotifier>(context, listen: false);
    checkOutNotifier.paymentStatus = 2; //fail
    checkOutNotifier.razorPayPaymentId = "";
    checkOutNotifier.orderId = "";
    checkOutNotifier.signature = "";
    checkOutNotifier.comment = "razorpay payment failed";
    setState(() {
      isLoading = false;
    });
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT);
    setState(() {
      isLoading = false;
    });
  }

  fetchWalletAmount() async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    try {
      WalletResponse? response =
          await _repository?.fetchWalletAmount(context, map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        setState(() {
          walletAmount = double.parse(response?.data?.wallet ?? "0.0");
        });
        print(
            "wallet amount ----- $walletAmount  -- ${response?.data?.wallet}");
      } else {
        Fluttertoast.showToast(msg: "failed to to load wallet money");
      }
    } catch (e) {
      print("error: ${e.toString()}");
      print(e);
    }
  }

  walletAlertShow(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () {
        if (isLoading == false) {
          Fluttertoast.showToast(msg: "Payment proceed through wallet");
          walletDeductAmount();
          checkOutNotifier?.paymentType = "WALLET";
          Navigator.pop(context);
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text("Are you sure place order from wallet amount?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final checkOutNotifier =
        Provider.of<CheckOutNotifier>(context, listen: false);

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              border: Border.all(color: Color(0xffF3F3F3))),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                     strPaymentOptions,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  if (isLoading == false) {
                    paymentUpdated(1);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpiAppListView(
                                  amount: widget.amount,
                                )));
                    checkOutNotifier.paymentType = "UPI";
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        strupi,
                        style:
                            TextStyle(color: Color(0xff8F9BB3), fontSize: 16),
                      ),
                      Icon(
                        Icons.radio_button_checked,
                        color: selected == 1
                            ? Color(0xff64BA02)
                            : Colors.grey[200],
                      )
                    ],
                  ),
                ),
              ),
              Divider(),
              InkWell(
                onTap: () {
                  if (isLoading == false) {
                    paymentUpdated(2);
                    createOrder();
                    checkOutNotifier.paymentType = "RAZORPAY";
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        strcredit,
                        style:
                            TextStyle(color: Color(0xff8F9BB3), fontSize: 16),
                      ),
                      Icon(
                        Icons.radio_button_checked,
                        color: selected == 2
                            ? Color(0xff64BA02)
                            : Colors.grey[200],
                      )
                    ],
                  ),
                ),
              ),
              Divider(),
              InkWell(
                onTap: () {
                  if (isLoading == false) {
                    paymentUpdated(3);
                    if (walletAmount < widget.amount) {
                      Fluttertoast.showToast(
                          msg: strinsufficientAmountInWallet);
                    } else {
                      walletAlertShow(context);
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "$strwallet $walletAmount",
                        style:
                            TextStyle(color: Color(0xff8F9BB3), fontSize: 16),
                      ),
                      Icon(
                        Icons.radio_button_checked,
                        color: selected == 3 && walletAmount > widget.amount
                            ? Color(0xff64BA02)
                            : Colors.grey[200],
                      )
                    ],
                  ),
                ),
              ),
              Divider(),
              InkWell(
                onTap: () {
                  if (isLoading == false) {
                    paymentUpdated(4);
                    checkOutNotifier.paymentType = "COD";
                    checkOutNotifier.paymentStatus = 2;
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                       strcod,
                        style:
                            TextStyle(color: Color(0xff8F9BB3), fontSize: 16),
                      ),
                      Icon(
                        Icons.radio_button_checked,
                        color: selected == 4
                            ? Color(0xff64BA02)
                            : Colors.grey[200],
                      )
                    ],
                  ),
                ),
              ),
              Divider(),
              InkWell(
                onTap: () {
                  if (isLoading == false) {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>EaseBuzzPaymentView(amount: widget.amount,)));
                    checkOutNotifier.paymentType = "easebuzz";
                    checkOutNotifier.paymentStatus = 5;
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "EaseBuzz",
                        style:
                        TextStyle(color: Color(0xff8F9BB3), fontSize: 16),
                      ),
                      Icon(
                        Icons.radio_button_checked,
                        color: selected == 5
                            ? Color(0xff64BA02)
                            : Colors.grey[200],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        isLoading
            ? Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Center(
                  child: CircularProgressIndicator(),
                ))
            : Container()
      ],
    );
  }
}
