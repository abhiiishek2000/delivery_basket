import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:delivery_basket/data/local/shared_pref.dart';
import 'package:delivery_basket/data/remote/model/order/order_history_list_response.dart';
import 'package:delivery_basket/data/remote/repository.dart';
import 'package:delivery_basket/generated/l10n.dart';

import 'order_history_details_screen.dart';

class OrderHistoryScreen extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  Repository? _repository;
  bool isLoading = false;
  List<OrderHistoryListResponseDataOrderData?>? orders = [];

  String strmyOrders = "";
  String strorderListIsEmpty = "";
  String strOrderNo = "";
  String strDeliveryDate = "";
  String strTimeSlot = "";
  String strAmount = "";
  String strOrderStatus = "";
  String strPaymentStatus = "";

  init() async {
    strmyOrders = await getI18n("myOrders");
    strorderListIsEmpty = await getI18n("orderListIsEmpty");
    strOrderNo = await getI18n("orderNo");
    strDeliveryDate = await getI18n("deliveryDate");
    strTimeSlot = await getI18n("timeSlot");
    strAmount = await getI18n("amount");
    strOrderStatus = await getI18n('orderStatus');
    strPaymentStatus = await getI18n("paymentStatus");
    setState(() {});
  }

  @override
  void initState() {
    init();
    super.initState();
    _repository = Repository();
    fetchOrderHistory();
  }

  fetchOrderHistory() async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    try {
      OrderHistoryListResponse? response =
          await _repository?.fetchOrderHistory(context, map);
      if (response?.success ?? false) {
        setState(() {
          orders?.addAll(response!.data!.order!.data!);
        });
      } else {
        Fluttertoast.showToast(msg: "failed to load order history");
      }
      setState(() {
        isLoading = false;
      });
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
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : orders?.length == 0
                ? Center(
                    child: Text(
                     strorderListIsEmpty,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: orders?.length,
                    itemBuilder: (context, index) {
                      OrderHistoryListResponseDataOrderData? order =
                          orders?[index];
                      DateTime startTime = new DateFormat("H:m:s")
                          .parse(order?.timeSlot?.sTime ?? "");
                      DateTime endTime = new DateFormat("H:m:s")
                          .parse(order?.timeSlot?.eTime ?? "");

                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset:
                                  Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        OrderHistoryDetailsScreen(
                                          orderId: "${order?.id}",
                                        )));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${order?.createdAt?.substring(0, 10)}",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    ?.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Row(
                                children: [
                                  Text("${strOrderNo}: "),
                                  Text(
                                    "${order?.orderId}",
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Row(
                                children: [
                                  Text("${strDeliveryDate} : "),
                                  Text(
                                    "${order?.deliveryDate}",
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Row(
                                children: [
                                  Text("${strTimeSlot}: "),
                                  Text(
                                    "${DateFormat('h:mm a').format(startTime)} - ${DateFormat('h:mm a').format(endTime)}",
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Row(
                                children: [
                                  Text("${strTimeSlot}: "),
                                  Text(
                                    "Rs ${order?.totalPrice}",
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                  )
                                ],
                              ),

                              SizedBox(
                                height: 6,
                              ),
                              Row(
                                children: [
                                  Text("$strOrderStatus: "),
                                  Text(
                                    "${order?.orderStatus?.name}",
                                    style:
                                    Theme.of(context).textTheme.subtitle2,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Row(
                                children: [
                                  Text("$strPaymentStatus: "),
                                  Text(
                                    "${order?.orderPaymentStatus?.paymentStatus?.name}",
                                    style:
                                    Theme.of(context).textTheme.subtitle2,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
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
               strmyOrders,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
