import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:upi_india/upi_response.dart';
import 'package:delivery_basket/constants.dart';
import 'package:delivery_basket/data/local/shared_pref.dart';
import 'package:delivery_basket/data/remote/model/order/order_cancel_response.dart';
import 'package:delivery_basket/data/remote/model/order/order_history_details_response.dart';
import 'package:delivery_basket/data/remote/model/order/order_payment_response.dart';
import 'package:delivery_basket/data/remote/model/payment/RazorpayOrderResponse.dart';
import 'package:delivery_basket/data/remote/model/setting/application_setting_response.dart';
import 'package:delivery_basket/data/remote/repository.dart';
import 'package:delivery_basket/generated/l10n.dart';
import 'package:delivery_basket/screens/check_details/upi_app_list_view.dart';
import 'package:http/http.dart' as http;
import 'package:delivery_basket/screens/component/basket_button.dart';
import 'package:delivery_basket/screens/component/basket_image_view.dart';
import 'package:delivery_basket/screens/order/order_history_screen.dart';

class OrderHistoryDetailsScreen extends StatefulWidget {
  final String orderId;

  const OrderHistoryDetailsScreen({Key? key, required this.orderId})
      : super(key: key);

  @override
  _OrderHistoryDetailsScreenState createState() =>
      _OrderHistoryDetailsScreenState();
}

class _OrderHistoryDetailsScreenState extends State<OrderHistoryDetailsScreen> {
  Repository? _repository;
  bool isLoading = false;
  OrderHistoryDetailsResponseDataOrder? orderDetails;
  int selected = -1;
  //razorpay init
  static const platform = const MethodChannel("razorpay_flutter");
  late Razorpay _razorpay;
  double walletAmount = 0.0;
  ApplicationSettingResponse? applicationSetting;

  String strorderId = "";
  String strproducts = "";
  String strorderSummary = "";
  String strorderStatus =  "";
  String strpaymentStatus = "";
  String strpaymentOptions = "";
  String strupi = "";
  String strnetBanking = "";
  String strorderDetails  = "";
  String strquantity = "";

  init()async{
    strorderId = await getI18n("orderId");
    strproducts = await getI18n("products");
    strorderSummary = await getI18n("orderSummary");
    strorderStatus = await getI18n("orderStatus");
    strpaymentStatus = await getI18n("paymentStatus");
    strupi = await getI18n("upi");
    strnetBanking = await getI18n("netBanking");
    strorderDetails = await getI18n("orderDetails");
    strquantity = await getI18n("quantity");
    setState(() {
    });
  }

  @override
  void initState() {
    init();
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _repository = Repository();
    fetchApplicationSetting();
    fetchOrderHistoryDetails();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  Future<dynamic> createOrder() async {
    var mapHeader = new Map<String, String>();
    mapHeader['Authorization'] =
        "Basic ${applicationSetting?.data?.applicationSetting?.rezorPayAuthKey}";
    mapHeader['Accept'] = "application/json";
    mapHeader['Content-Type'] = "application/x-www-form-urlencoded";
    var map = new Map<String, String>();
    map['amount'] =
        "${(double.parse(orderDetails?.totalPrice ?? "0.0").toInt() * 100)}";
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

  orderCancel() async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    map['order_id'] = widget.orderId;
    try {
      OrderCancelResponse? response =
      await _repository?.apiOrderCancel(context, map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        Fluttertoast.showToast(msg: "Order canceled successfully");
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(msg: "Order cancel failed");
      }
    } catch (e) {
      print("error: ${e.toString()}");
      Fluttertoast.showToast(msg: "Order cancel failed");
      print(e);
    }
  }

  void openCheckout(RazorpayOrderResponse data) async {
    var options = {
      'key': '${applicationSetting?.data?.applicationSetting?.rPayKey}',
      'amount': double.parse(orderDetails?.totalPrice ?? "0.0").toInt() * 100,
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
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId!,
        toastLength: Toast.LENGTH_SHORT);
    fetchOrderPayment(response);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message!,
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT);
  }

  fetchOrderPayment(PaymentSuccessResponse response) async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    map['order_id'] = "${orderDetails?.id}";
    map['type'] = "razorpay";
    map['razor_payment_id'] = response.paymentId.toString();
    map['razor_order_id'] = response.orderId.toString();
    map['signature'] = response.signature.toString();
    map['comment'] = "add to wallet";
    try {
      OrderPaymentResponse? response =
          await _repository?.fetchOrderPayment(context, map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        Fluttertoast.showToast(msg: "Order amount paid successfully");
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => OrderHistoryScreen()));
      } else {
        Fluttertoast.showToast(msg: "failed to load order payment");
      }
    } catch (e) {
      print("error: ${e.toString()}");
      print(e);
    }
  }

  fetchOrderUPiPayment(UpiResponse upiResponse) async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    map['order_id'] = "${orderDetails?.id}";
    map['type'] = "UPI";
    map['razor_payment_id'] = upiResponse.transactionId.toString();
    map['razor_order_id'] = upiResponse.transactionRefId.toString();
    map['signature'] = upiResponse.status.toString();
    map['comment'] = "deduct from UPI";
    try {
      OrderPaymentResponse? response =
          await _repository?.fetchOrderPayment(context, map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        Fluttertoast.showToast(msg: "Order amount paid successfully");
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => OrderHistoryScreen()));
      } else {
        Fluttertoast.showToast(msg: "failed to load order payment");
      }
    } catch (e) {
      print("error: ${e.toString()}");
      print(e);
    }
  }

  fetchOrderHistoryDetails() async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    map['order_id'] = "${widget.orderId}";
    try {
      OrderHistoryDetailsResponse? response =
          await _repository?.fetchOrderHistoryDetails(context, map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        setState(() {
          orderDetails = response?.data?.order;
        });
      } else {
        Fluttertoast.showToast(msg: "failed to load order details");
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
        body: Stack(
          children: [
            orderDetails == null
                ? Container()
                : ListView(
              children: [
                //search bar
                ListTile(
                  title: Text(
                   strorderId,
                    style: TextStyle(color: Color(0xff8F9BB3)),
                  ),
                  trailing: Text(
                    "#${orderDetails?.orderId}",
                    style: TextStyle(color: Color(0xff64BA02)),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                             strproducts,
                              style: TextStyle(
                                  color: Color(0xff8F9BB3), fontSize: 16),
                            ),
                            Text(
                              "",
                              style: TextStyle(
                                  color: Color(0xff64BA02), fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: ListView.builder(
                            itemCount: orderDetails?.orderProduct?.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              OrderHistoryDetailsResponseDataOrderOrderProduct?
                              product =
                              orderDetails?.orderProduct?[index];
                              return product == null
                                  ? Container()
                                  : Row(
                                children: [
                                  BasketImageView(
                                    url:
                                    "$ImageBaseUrlTest${product.product?.pImage}",
                                    height: 110,
                                    width: 110,
                                    fit: BoxFit.fill,
                                  ),
                                  SizedBox(width: 8,),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${product.product?.productName != null ? product.product?.productName?.name : product.product?.name}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                        ),
                                        Text(
                                            "${strquantity} : ${product.quantity}"),

                                      ],
                                    ),
                                  ),
                                  Text(
                                    "₹ ${product.sPrice}",
                                    style: TextStyle(
                                        color: Color(0xff64BA02)),
                                  )
                                ],
                              );
                            }),
                      )
                    ],
                  ),
                ),

                ListTile(
                  title: Text(
                   strorderSummary,
                    style: TextStyle(color: Color(0xff8F9BB3), fontSize: 16),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                             strorderStatus,
                              style: TextStyle(
                                  color: Color(0xff8F9BB3), fontSize: 16),
                            ),
                            Text(
                              "${orderDetails?.orderStatus?.name}",
                              style: TextStyle(
                                  color: Color(0xff64BA02), fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                             strpaymentStatus,
                              style: TextStyle(
                                  color: Color(0xff8F9BB3), fontSize: 16),
                            ),
                            Text(
                              "${orderDetails?.orderPaymentStatus?.paymentStatus?.name}",
                              style: TextStyle(
                                  color: Color(0xff64BA02), fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: orderDetails?.orderTotal?.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        OrderHistoryDetailsResponseDataOrderOrderTotal?
                        extra = orderDetails?.orderTotal?[index];
                        return InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${extra?.title}",
                                  style: TextStyle(
                                      color: Color(0xff8F9BB3), fontSize: 16),
                                ),
                                Text(
                                  "${extra?.value}",
                                  style: TextStyle(
                                      color: Color(0xff64BA02), fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),

                if (([1,2,3,4].contains(orderDetails?.orderStatus?.id)) &&
                    (orderDetails?.orderPaymentStatus?.paymentStatus?.id ==
                        2)) ...[
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
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
                               strpaymentOptions,
                                style: TextStyle(
                                    color: Color(0xff8F9BB3), fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            UpiResponse upiResponse = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UpiAppListView(
                                      amount: double.parse(
                                          orderDetails?.totalPrice ??
                                              "0.0"),
                                      isOrderRepeat: true,
                                    )));
                            fetchOrderUPiPayment(upiResponse);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                 strupi,
                                  style: TextStyle(
                                      color: Color(0xff8F9BB3), fontSize: 16),
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
                            createOrder();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                 strnetBanking,
                                  style: TextStyle(
                                      color: Color(0xff8F9BB3), fontSize: 16),
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
                      ],
                    ),
                  )
                ],

                if(orderDetails?.orderStatus?.id == 1 && orderDetails?.orderPaymentStatus?.paymentStatus?.id == 2) Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: OutlinedButton(onPressed: (){
                    showAlertDialog(context);
                  }, child: Text("Cancel Order",style: TextStyle(color: Colors.redAccent.withOpacity(0.8)),), style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      width: 1.0,
                      color: Colors.redAccent.withOpacity(0.6),
                    ),
                  ),),
                ),
                SizedBox(height: 16,),
              ],
            ),
           if(isLoading) Center(child: CupertinoActivityIndicator())
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed:  () {
        Navigator.pop(context);
        orderCancel();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text("Are you sure cancel this order?"),
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
               strorderDetails,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
