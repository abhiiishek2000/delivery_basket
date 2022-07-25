import 'dart:convert';

//import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:delivery_basket/data/AppNotifer.dart';
import 'package:delivery_basket/data/local/DBProvider.dart';
import 'package:delivery_basket/data/local/shared_pref.dart';
import 'package:delivery_basket/data/remote/model/address/DistanceMatrixResponse.dart';
import 'package:delivery_basket/data/remote/model/address/address_list_response.dart';
import 'package:delivery_basket/data/remote/model/cart/delivery_charge_list_response.dart';
import 'package:delivery_basket/data/remote/model/coupon/CouponApplyResponse.dart';
import 'package:delivery_basket/data/remote/model/coupon/coupon_fail_response.dart';
import 'package:delivery_basket/data/remote/model/order/order_place_response.dart';
import 'package:delivery_basket/data/remote/model/setting/application_setting_response.dart';
import 'package:delivery_basket/data/remote/repository.dart';
import 'package:delivery_basket/generated/l10n.dart';
import 'package:delivery_basket/screens/address/address_new_view.dart';
import 'package:delivery_basket/screens/address/change_delivery_address_view.dart';
import 'package:delivery_basket/screens/check_details/order_success_dialog_view.dart';

import '../../constants.dart';
import '../../main.dart';
import 'check_delivery_method_view.dart';
import 'check_payment_options_view.dart';

class CheckDetailsScreen extends StatefulWidget {
  final double amount;
  final int totalItems;
  final double totalPrice;
  final double discountAmount;
  final double priceItems;

  const CheckDetailsScreen(
      {Key? key,
      required this.amount,
      required this.totalItems,
      required this.totalPrice,
      required this.discountAmount,
      required this.priceItems})
      : super(key: key);

  @override
  _CheckDetailsScreenState createState() => _CheckDetailsScreenState();
}

class _CheckDetailsScreenState extends State<CheckDetailsScreen> {
  //static final facebookAppEvents = FacebookAppEvents();
  TextEditingController couponController = TextEditingController();
  Repository? _repository;
  bool isLoading = false;
  CouponApplyResponse? couponResponse;
  List<AddressListResponseDataAddress?>? addressList = [];
  bool isCouponApplied = false;
  AddressListResponseDataAddress? addressSelected;
  double couponApplied = 0.0;
  double finalAmount = 0.0;
  CheckOutNotifier? checkOutNotifier;
  int deliverySelected = 0;
  ApplicationSettingResponse? applicationSetting;
  double deliveryFree = 0.0;
  double km = 0.0;

  String stralert = "";
  String strselectAddress = "";
  String strselectDeliveryDate = "";
  String strselectTimeSlot = "";
  String strconfirmOrder = "";
  String strdeliveryFrom = "";
  String stratHome = "";
  String strselfPickUp = "";
  String straddress = "";
  String strchange = "";
  String strmyDeliveryAddressAndBillingAddressSame = "";
  String strorderBill = "";
  String strorderList = "";
  String stritems = "";
  String strtotalPrice = "";
  String strdeliveryFee = "";
  String strcouponAmount = "";
  String strdiscountedAmount = "";
  String strtotalBill = "";
  String strorderPlacedSuccessfully = "";
  String strok = "";
  String strcoupon = "";
  String strenterCouponCode = "";
  String strremove = "";
  String strapply = "";
  String stryouSaved = "";
  String strproceedToPay = "";
  String straddNewAddress = "";

  init() async {
    stralert = await getI18n("alert");
    strselectAddress = await getI18n("selectAddress");
    strselectDeliveryDate = await getI18n("selectDeliveryDate");
    strselectTimeSlot = await getI18n("selectTimeSlot");
    strconfirmOrder = await getI18n("confirmOrder");
    strdeliveryFrom = await getI18n("deliveryFrom");
    stratHome = await getI18n("atHome");
    strselfPickUp = await getI18n("selfPickUp");
    straddress = await getI18n("address");
    strchange = await getI18n("change");
    strmyDeliveryAddressAndBillingAddressSame = await getI18n("myDeliveryAddressAndBillingAddressSame");
    strorderBill = await getI18n("orderBill");
    strorderList = await getI18n("orderList");
    stritems = await getI18n("items");
    strtotalPrice = await getI18n("totalPrice");
    strdeliveryFee = await getI18n("deliveryFee");
    strcouponAmount = await getI18n("couponAmount");
    strdiscountedAmount = await getI18n("discountedAmount");
    strtotalBill = await getI18n("totalBill");
    strorderPlacedSuccessfully = await getI18n("orderPlacedSuccessfully");
    strok = await getI18n("ok");
    strcoupon = await getI18n("coupon");
    strenterCouponCode = await getI18n("enterCouponCode");
    strremove = await getI18n("remove");
    strapply = await getI18n("apply");
    stryouSaved = await getI18n("youSaved");
    strproceedToPay = await getI18n("proceedToPay");
    straddNewAddress = await getI18n("addNewAddress");
    setState(() {});
  }

  @override
  void initState() {
    init();
    super.initState();
    checkOutNotifier = Provider.of<CheckOutNotifier>(context, listen: false);
    checkOutNotifier?.addressId = -1;
    // facebookAppEvents.logEvent(
    //   name: 'order',
    //   parameters: {
    //     'order_screen_open': 'order_screen_open',
    //   },
    // );
    _repository = Repository();
    changeFinalAmount();
    fetchApplicationSetting();
  }

  void changeFinalAmount() {
    setState(() {
      finalAmount = widget.amount + deliveryFree - couponApplied;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar(),
        body: ListView(
          shrinkWrap: true,
          children: [
            deliveryFrom(),
            if (deliverySelected == 0) checkAddressView(),
            CheckDeliveryMethodView(),
            couponView(),
            checkOutOrderView(),
            CheckPaymentOptionsView(
              amount: finalAmount,
              priceItems: widget.priceItems,
            ),
            SizedBox(
              height: 16,
            ),
            InkWell(
              onTap: () {
                if (isLoading == false) {
                  var map = Map<String, String>();
                  map['time_slot_id'] = "${checkOutNotifier?.timeSlot}";
                  map['delivery_date'] = "${checkOutNotifier?.deliveryDate}";
                  map['type'] = "${checkOutNotifier?.paymentType}";
                  map['payment_statu_id'] =
                      "${checkOutNotifier?.paymentStatus}";
                  map['customer_address_id'] = "${checkOutNotifier?.addressId}";
                  map['coupon'] = "${checkOutNotifier?.couponCode}";
                  map['type'] = "${checkOutNotifier?.paymentType}";
                  map['razor_payment_id'] =
                      "${checkOutNotifier?.razorPayPaymentId}";
                  map['order_id'] = "${checkOutNotifier?.orderId}";
                  map['signature'] = "${checkOutNotifier?.signature}";
                  map['comment'] = "${checkOutNotifier?.comment}";

                  print(map.toString());
                  if (deliverySelected == 0 &&
                      checkOutNotifier?.addressId == -1) {
                    showErrorAlertDialog(context, stralert,
                        strselectAddress);
                    Fluttertoast.showToast(msg: strselectAddress);
                  } else if (checkOutNotifier?.deliveryDate == "") {
                    showErrorAlertDialog(context, stralert,
                        strselectDeliveryDate);
                    Fluttertoast.showToast(
                        msg: strselectDeliveryDate);
                  } else if (checkOutNotifier?.timeSlot == -1) {
                    showErrorAlertDialog(context, stralert,
                        strselectTimeSlot);
                    Fluttertoast.showToast(msg: strselectTimeSlot);
                  } else if (checkOutNotifier?.paymentType == "COD") {
                    orderPlace();
                  } else if (checkOutNotifier?.paymentStatus == 1) {
                    orderPlace();
                  }
                }
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                    child: Text(
                  strconfirmOrder,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      ?.copyWith(color: Colors.white, fontSize: 18),
                )),
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  void distanceCalculator(String origin, String destination) async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    map['origins'] = origin;
    map['destinations'] = destination;
    map['mode'] = "driving";
    map['key'] = "AIzaSyCzKSXNFa6SVglo8rEf00ok5ION6tapdYg";
    try {
      DistanceMatrixResponse? response =
          await _repository?.apiDistanceMatrix(context, map);
      setState(() {
        isLoading = false;
      });
      if (response?.status == "OK") {
        print(
            "distance is ${response?.rows?.first?.elements?.first?.distance?.text ?? ""}");
        fetchDeliveryCharges(response!);
      } else {
      }
    } catch (e) {
      print("error: ${e.toString()}");
      print(e);
    }
  }

  fetchDeliveryCharges(DistanceMatrixResponse matrixResponse) async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    try {
      DeliveryChargeListResponse? response =
          await _repository?.apiDeliveryChargeList(context, map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        int kmInt =
            matrixResponse.rows?.first?.elements?.first?.distance?.value ?? 0;
        setState(() {
          km = double.parse(kmInt.toString()) / 1000;
        });
        print("km $km");
        //changeFinalAmount();
        response?.data?.deliveryCharge?.forEach((element) {
          if (finalAmount < double.parse(element?.mOPrice ?? "")) {
            if (double.parse(element?.sKm ?? "0.0") <= km &&
                double.parse(element?.eKm ?? "0.0") >= km) {
              print("is km valid");
              setState(() {
                deliveryFree = double.parse(element?.charges ?? "");
              });
              changeFinalAmount();
            }
          }
        });
      }
    } catch (e) {
      print("error: ${e.toString()}");
      print(e);
    }
  }

  Widget deliveryFrom() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(color: Color(0xffF3F3F3))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strdeliveryFrom,
            style: Theme.of(context)
                .textTheme
                .subtitle1
                ?.copyWith(color: Colors.black, fontWeight: FontWeight.w600),
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: 2,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    if(index == 0){
                      setState(() {
                        deliverySelected = index;
                      });
                      fetchApplicationSetting();
                    }else if(index ==1) {
                      setState(() {
                        deliverySelected = index;
                        if (index == 1) {
                          deliveryFree = 0.0;
                        }
                      });
                      changeFinalAmount();
                    }
                    Provider.of<CheckOutNotifier>(context, listen: false)
                        .deliveryOption = index;
                    setState(() {
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/${index == 0 ? "ic_delivery_home" : "ic_delivery_self"}.png",
                          width: 18,
                          height: 18,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                            child: Text(
                          "${index == 0 ? stratHome : strselfPickUp}",
                          style: Theme.of(context).textTheme.subtitle2,
                        )),
                        Icon(
                          Icons.check_circle_outline,
                          color: index == deliverySelected
                              ? kPrimaryColor
                              : Colors.grey,
                        )
                      ],
                    ),
                  ),
                );
              })
        ],
      ),
    );
  }

  Widget checkAddressView() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(color: Color(0xffF3F3F3))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                straddress,
                style: Theme.of(context).textTheme.subtitle1?.copyWith(
                    color: Colors.black, fontWeight: FontWeight.w600),
              ),
              TextButton(
                  onPressed: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChangeDeliveryAddressView()));
                    fetchAddressList();
                  },
                  child: Text(
                    strchange,
                    style: TextStyle(color: kPrimaryColor),
                  )),
            ],
          ),
          addressItemNew(),
          SizedBox(
            height: 8,
          ),
          addressSelected != null ? addressInfo(addressSelected) : Container(),
          SizedBox(
            height: 8,
          ),
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.solidCheckSquare,
                  color: kPrimaryColor,
                  size: 18,
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                    child: Text(
                        strmyDeliveryAddressAndBillingAddressSame))
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget checkOutOrderView() {
    return Container(
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
                  strorderBill,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "",
                  style: TextStyle(color: Color(0xff64BA02), fontSize: 16),
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  strorderList,
                  style: TextStyle(color: Color(0xff8F9BB3), fontSize: 16),
                ),
                Text(
                  "${widget.totalItems} ${stritems}",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  strtotalPrice,
                  style: TextStyle(color: Color(0xff8F9BB3), fontSize: 16),
                ),
                Text(
                  "₹ ${widget.priceItems}/-",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  strdeliveryFee,
                  style: TextStyle(color: Color(0xff8F9BB3), fontSize: 16),
                ),
                Text(
                  "+₹ ${deliveryFree}/-",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  strcouponAmount,
                  style: TextStyle(color: Color(0xff8F9BB3), fontSize: 16),
                ),
                Text(
                  "-₹ $couponApplied/-",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  strdiscountedAmount,
                  style: TextStyle(color: Color(0xff8F9BB3), fontSize: 16),
                ),
                Text(
                  "-₹ ${widget.discountAmount.toStringAsFixed(2)}/-",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  strtotalBill,
                  style: TextStyle(color: Color(0xff64BA02), fontSize: 16),
                ),
                Text(
                  "₹ $finalAmount/-",
                  style: TextStyle(color: Color(0xff64BA02), fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  applyCoupon(String couponCode, double amount) async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    map['cupon_code'] = couponCode;
    map['amount'] = amount.toString();
    try {
      CouponApplyResponse? response =
          await _repository?.applyCoupon(context, map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        setState(() {
          couponApplied = double.parse(response?.data?.amount ?? "0.0");
          couponResponse = response;
          isCouponApplied = true;
        });
        changeFinalAmount();

        Fluttertoast.showToast(msg: "Coupon applied successfully");
        final checkOutNotifier =
            Provider.of<CheckOutNotifier>(context, listen: false);
        checkOutNotifier.couponCode = couponCode;
      } else {
        Fluttertoast.showToast(msg: "${response?.message}");
      }
    } catch (e) {
      print("error: ${e.toString()}");
      CouponFailResponse data =
          CouponFailResponse.fromJson(json.decode(e.toString()));
      couponAlertShow(context, "${data.message}");
      Fluttertoast.showToast(msg: "${data.message}");
      print(e);
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
    map['customer_address_id'] =
        "${checkOutNotifier.deliveryOption == 0 ? checkOutNotifier.addressId : ""}";
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
        // facebookAppEvents.logEvent(
        //   name: 'order',
        //   parameters: {
        //     'order_${checkOutNotifier.paymentType}_success':
        //         'order_placed_successfully',
        //   },
        // );
        Fluttertoast.showToast(msg: strorderPlacedSuccessfully);
        await DBProvider.db.deleteAllCart();
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
        //     'status': 'order_failed_to_place',
        //   },
        // );
        Fluttertoast.showToast(msg: "${response?.message}");
      }
    } catch (e) {
      // facebookAppEvents.logEvent(
      //   name: 'order',
      //   parameters: {
      //     'status': 'order_failed_to_place',
      //   },
      // );
      print("error: ${e.toString()}");
      print(e);
    }
  }

  couponAlertShow(BuildContext context, String value) {
    // set up the button
    Widget okButton = TextButton(
      child: Text(strok),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(strcoupon),
      content: Text(value),
      actions: [
        okButton,
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

  fetchApplicationSetting() async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    try {
      ApplicationSettingResponse? response =
          await _repository?.fetchApplicationSetting(context, map);
      if (response?.success ?? false) {
        setState(() {
          applicationSetting = response;
        });
        fetchAddressList();
      } else {
        Fluttertoast.showToast(msg: "failed to load application setting");
      }
    } catch (e) {
      print("error: ${e.toString()}");
      print(e);
    }
  }

  fetchAddressList() async {
    CheckOutNotifier checkOutNotifier =
    Provider.of<CheckOutNotifier>(context, listen: false);
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    try {
      AddressListResponse? response =
          await _repository?.fetchAddressList(context, map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        setState(() {
          addressList = [];
          addressList?.addAll(response!.data!.address!);
          if (checkOutNotifier.addressId == -1 && addressList?.length != 0) {
            checkOutNotifier.addressId = addressList?.first?.id ?? -1;
          }
          try {
            addressSelected = addressList?.firstWhere(
                (element) => (element?.id) == checkOutNotifier.addressId);
          } catch (e) {}
        });
        distanceCalculator(
            "${addressSelected?.latitude},${addressSelected?.longitude}",
            "${applicationSetting?.data?.applicationSetting?.storeLat},${applicationSetting?.data?.applicationSetting?.storeLong}");
      } else {
        Fluttertoast.showToast(msg: "address list not loaded");
      }
    } catch (e) {
      print("error: ${e.toString()}");
      print(e);
    }
  }

  Widget couponView() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(color: Color(0xffF3F3F3))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                strcoupon,
                style: Theme.of(context).textTheme.subtitle1?.copyWith(
                    color: Colors.black, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            decoration: BoxDecoration(
                color: isCouponApplied
                    ? Colors.grey.withOpacity(0.6)
                    : Colors.white,
                border: Border.all(color: Color(0xffCECECE)),
                borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                  enabled: isCouponApplied == true ? false : true,
                  controller: couponController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.fromLTRB(6, 3, 6, 3),
                      hintText: strenterCouponCode),
                )),
                TextButton(
                    onPressed: () {
                      if (isCouponApplied) {
                        setState(() {
                          couponApplied = 0.0;
                          couponResponse = null;
                          isCouponApplied = false;
                          couponController.text = "";
                        });
                        changeFinalAmount();
                      } else {
                        if (couponController.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: strenterCouponCode);
                        } else {
                          applyCoupon(couponController.text, widget.amount);
                        }
                      }
                    },
                    child: Text(
                      "${isCouponApplied == true ? strremove : strapply}",
                      style: TextStyle(color: kPrimaryColor),
                    ))
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          couponResponse != null
              ? Text(
                  "${stryouSaved} ₹${couponResponse?.data?.amount}")
              : Container()
        ],
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
                strproceedToPay,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget addressItemNew() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/ic_map_home.png"),
          SizedBox(
            width: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: OutlinedButton(
                onPressed: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AddressNewView(isUpdateAddress: false)));
                  fetchAddressList();
                },
                child: Text(straddNewAddress)),
          )
        ],
      ),
    );
  }

  Widget addressInfo(AddressListResponseDataAddress? addressFirst) {
    if (addressFirst != null) {
      return Row(
        children: [
          Stack(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    "assets/images/ic_map_thumbnail.png",
                    width: 90,
                    height: 90,
                  )),
              Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  top: 0,
                  child: Image.asset("assets/images/ic_map_home.png")),
            ],
          ),
          SizedBox(
            width: 8,
          ),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                addressDetailsItem("assets/images/ic_location_border.svg",
                    "${addressFirst.address}"),
                addressDetailsItem(
                    "assets/images/ic_user.svg", "${addressFirst.name}"),
                addressDetailsItem(
                    "assets/images/ic_call.svg", "${addressFirst.mobile}"),
                Text("Distance from store ${km.toStringAsFixed(1)} Km")
              ],
            ),
          )
        ],
      );
    } else {
      return Container();
    }
  }

  Widget addressDetailsItem(String image, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          image.contains(".svg") ? SvgPicture.asset(image) : Image.asset(image),
          SizedBox(
            width: 8,
          ),
          Expanded(
              child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            maxLines: 1,
          ))
        ],
      ),
    );
  }
}
