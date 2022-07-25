//import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:upi_india/upi_india.dart';
import 'package:delivery_basket/data/AppNotifer.dart';
import 'package:delivery_basket/data/local/DBProvider.dart';
import 'package:delivery_basket/data/remote/model/order/order_place_response.dart';
import 'package:delivery_basket/data/remote/model/setting/application_setting_response.dart';
import 'package:delivery_basket/data/remote/repository.dart';

import '../../main.dart';
import 'order_success_dialog_view.dart';

class UpiAppListView extends StatefulWidget {
  final double amount;
  final bool? isOrderRepeat;

  const UpiAppListView(
      {Key? key, required this.amount, this.isOrderRepeat = false})
      : super(key: key);
  @override
  _UpiAppListViewState createState() => _UpiAppListViewState();
}

class _UpiAppListViewState extends State<UpiAppListView> {
  //static final facebookAppEvents = FacebookAppEvents();
  Future<UpiResponse>? _transaction;
  UpiIndia _upiIndia = UpiIndia();
  List<UpiApp>? apps;
  bool isLoading = false;
  Repository? _repository;
  ApplicationSettingResponse? applicationSetting;
  CheckOutNotifier? checkOutNotifier;
  bool isOrderStarted = false;

  @override
  void initState() {
    checkOutNotifier = Provider.of<CheckOutNotifier>(context, listen: false);
    _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
      setState(() {
        apps = value;
      });
    }).catchError((e) {
      apps = [];
    });
    _repository = Repository();
    super.initState();
    fetchApplicationSetting();
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar(),
        body: upiIndiaView(),
      ),
    );
  }

  Widget upiIndiaView() {
    return Column(
      children: <Widget>[
        Expanded(
          child: displayUpiApps(),
        ),
        Expanded(
          child: FutureBuilder(
            future: _transaction,
            builder:
                (BuildContext context, AsyncSnapshot<UpiResponse> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      _upiErrorHandler(snapshot.error.runtimeType),
                    ), // Print's text message on screen
                  );
                }

                // If we have data then definitely we will have UpiResponse.
                // It cannot be null
                UpiResponse _upiResponse = snapshot.data!;

                // Data in UpiResponse can be null. Check before printing
                String txnId = _upiResponse.transactionId ?? 'N/A';
                String resCode = _upiResponse.responseCode ?? 'N/A';
                String txnRef = _upiResponse.transactionRefId ?? 'N/A';
                String status = _upiResponse.status ?? 'N/A';
                String approvalRef = _upiResponse.approvalRefNo ?? 'N/A';
                _checkTxnStatus(status, _upiResponse);

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      displayTransactionData('Transaction Id', txnId),
                      displayTransactionData('Response Code', resCode),
                      displayTransactionData('Reference Id', txnRef),
                      displayTransactionData('Status', status.toUpperCase()),
                      displayTransactionData('Approval No', approvalRef),
                    ],
                  ),
                );
              } else
                return Center(
                  child: Text(''),
                );
            },
          ),
        )
      ],
    );
  }

  Widget displayUpiApps() {
    if (apps == null)
      return Center(child: CircularProgressIndicator());
    else if (apps!.length == 0)
      return Center(
        child: Text(
          "No apps found to handle transaction.",
        ),
      );
    else
      return Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Wrap(
            children: apps!.map<Widget>((UpiApp app) {
              return GestureDetector(
                onTap: () {
                  _transaction = initiateTransaction(app);
                  setState(() {});
                },
                child: Container(
                  height: 100,
                  width: 100,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.memory(
                        app.icon,
                        height: 60,
                        width: 60,
                      ),
                      Text(app.name),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
  }

  Future<UpiResponse> initiateTransaction(UpiApp app) async {
    print("vb${new DateTime.now().millisecondsSinceEpoch}");
    return _upiIndia.startTransaction(
        app: app,
        receiverUpiId:
            "${applicationSetting?.data?.applicationSetting?.receiverId}",
        receiverName:
            '${applicationSetting?.data?.applicationSetting?.receiverName}',
        transactionRefId: 'vb${new DateTime.now().millisecondsSinceEpoch}',
        transactionNote: 'Paying for Vidarbha Basket.',
        amount: widget.amount,
        merchantId:
            "${applicationSetting?.data?.applicationSetting?.merchantPaymentId}");
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
                "UPI List",
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _upiErrorHandler(error) {
    switch (error) {
      case UpiIndiaAppNotInstalledException:
        return 'Requested app not installed on device';
      case UpiIndiaUserCancelledException:
        return 'You cancelled the transaction';
      case UpiIndiaNullResponseException:
        return 'Requested app didn\'t return any response';
      case UpiIndiaInvalidParametersException:
        return 'Requested app cannot handle the transaction';
      default:
        return 'An Unknown error has occurred';
    }
  }

  void _checkTxnStatus(String status, UpiResponse upiResponse) {
    switch (status) {
      case UpiPaymentStatus.SUCCESS:
        print('Transaction Successful');
        if (widget.isOrderRepeat == true) {
          Future.delayed(Duration.zero, () async {
            if (isOrderStarted == false) {
              Navigator.pop(context, upiResponse);
              setState(() {
                isOrderStarted = true;
              });
            }
          });
        } else {
          checkOutNotifier?.paymentType = "UPI";
          checkOutNotifier?.paymentStatus = 1;
          checkOutNotifier?.razorPayPaymentId = "${upiResponse.transactionId}";
          checkOutNotifier?.orderId = "${upiResponse.transactionRefId}";
          checkOutNotifier?.signature = "${upiResponse.status}";
          checkOutNotifier?.comment = "Upi payment success";
          Future.delayed(Duration.zero, () async {
            if (isOrderStarted == false) {
              checkValidOrder();
            }
          });
        }

        break;
      case UpiPaymentStatus.SUBMITTED:
        print('Transaction Submitted');
        checkOutNotifier?.paymentType = "UPI";
        checkOutNotifier?.paymentStatus = 1;
        checkOutNotifier?.razorPayPaymentId = "${upiResponse.transactionId}";
        checkOutNotifier?.orderId = "${upiResponse.transactionRefId}";
        checkOutNotifier?.signature = "${upiResponse.status}";
        checkOutNotifier?.comment = "Upi payment pending";
        break;
      case UpiPaymentStatus.FAILURE:
        print('Transaction Failed');
        checkOutNotifier?.paymentType = "UPI";
        checkOutNotifier?.paymentStatus = 2;
        checkOutNotifier?.razorPayPaymentId = "${upiResponse.transactionId}";
        checkOutNotifier?.orderId = "${upiResponse.transactionRefId}";
        checkOutNotifier?.signature = "${upiResponse.status}";
        checkOutNotifier?.comment = "Upi payment failed";
        break;
      default:
        print('Received an Unknown transaction status');
    }
  }

  Widget displayTransactionData(title, body) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$title: "),
          Flexible(
              child: Text(
            body,
          )),
        ],
      ),
    );
  }

  void checkValidOrder() {
    setState(() {
      isOrderStarted = true;
    });
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
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        Fluttertoast.showToast(msg: "Order placed successfully");
        await DBProvider.db.deleteAllCart();
        //facebookAppEvents.logEvent(name: 'order', parameters: {'order_${checkOutNotifier.paymentType}_success': 'order_placed_successfully',},);
        Navigator.of(context).push(
          PageRouteBuilder(
            opaque: false, // set to false
            pageBuilder: (_, __, ___) => OrderSuccessDialogView(),
          ),
        );
      } else {
        //facebookAppEvents.logEvent(name: 'order', parameters: {'order_${checkOutNotifier.paymentType}_failed': 'order_failed_place',},);
        Fluttertoast.showToast(msg: "${response?.message}");
      }
    } catch (e) {
      //facebookAppEvents.logEvent(name: 'order', parameters: {'order_${checkOutNotifier.paymentType}_failed': 'order_failed_place',},);
      print("error: ${e.toString()}");
      print(e);
    }
  }
}
