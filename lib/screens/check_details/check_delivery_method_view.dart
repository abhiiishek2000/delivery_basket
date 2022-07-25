import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:delivery_basket/data/AppNotifer.dart';
import 'package:delivery_basket/data/local/shared_pref.dart';
import 'package:delivery_basket/data/remote/model/order/time_slot_response.dart';
import 'package:delivery_basket/data/remote/model/setting/application_setting_response.dart';
import 'package:delivery_basket/data/remote/repository.dart';

import '../../constants.dart';

class CheckDeliveryMethodView extends StatefulWidget {
  @override
  _CheckDeliveryMethodViewState createState() =>
      _CheckDeliveryMethodViewState();
}

class _CheckDeliveryMethodViewState extends State<CheckDeliveryMethodView> {
  int address = 0;
  bool deliveryAddressChecked = false;
  DateTime? selectedDate;
  Repository? _repository;
  bool isLoading = false;
  List<TimeSlotResponseDataTimeSlot?>? timeSlots = [];
  ApplicationSettingResponse? applicationSetting;
  TimeSlotResponseDataTimeSlot? timeSelected;


  String strDeliveryOption = "";

  init()async{
    strDeliveryOption = await getI18n("deliveryOptions");
    setState(() {
    });
  }

  @override
  void initState() {
    init();
    super.initState();
    _repository = Repository();
    timeSlot();
    fetchApplicationSetting();
  }

  timeSlot() async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    map['date'] = applicationSetting?.data?.applicationSetting?.curentDate??"";
    try {
      TimeSlotResponse? response =
          await _repository?.fetchTimeSlot(context,map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        setState(() {
          timeSlots?.addAll(response!.data!.timeSlot!);
          timeSelected = timeSlots?.first;
        });
        final checkOutNotifier = Provider.of<CheckOutNotifier>(context, listen:false);
        checkOutNotifier.timeSlot = timeSelected?.id??-1;
      } else {
        Fluttertoast.showToast(msg: "failed to load time slot");
      }
    } catch (e) {
      print("error: ${e.toString()}");
      print(e);
    }
  }

  fetchApplicationSetting() async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    try {
      ApplicationSettingResponse? response =
      await _repository?.fetchApplicationSetting(context,map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        setState(() {
          applicationSetting = response;
          selectedDate =  new DateFormat("yyyy-MM-dd").parse(applicationSetting?.data?.applicationSetting?.curentDate??"");
        });
        final checkOutNotifier = Provider.of<CheckOutNotifier>(context, listen:false);
        checkOutNotifier.deliveryDate = selectedDate.toString();
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
                strDeliveryOption,
                style: Theme.of(context).textTheme.subtitle1?.copyWith(
                    color: Colors.black, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: kPrimaryColor.withOpacity(0.2))),
            child: InkWell(
              onTap: () {
                _selectDate(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Text(
                      selectedDate != null
                          ? "${selectedDate?.toLocal()}".split(' ')[0]
                          : "Select Delivery Date",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          ?.copyWith(color: Colors.black),
                    ),
                  ),
                  Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                        color: Color(0xff53AC44),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: FaIcon(
                      FontAwesomeIcons.calendarAlt,
                      color: Colors.white,
                      size: 16,
                    )),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: timeSlots?.length,
              itemBuilder: (context, index) {
                TimeSlotResponseDataTimeSlot? timeSlot = timeSlots?[index];
                print("start time ${timeSlot?.sTime??""}");
                var formatter = DateFormat.Hms('en_US');
                DateTime startTime = new DateFormat.Hms('en_US').parse(timeSlot?.sTime??"");
                DateTime endTime = new DateFormat.Hms('en_US').parse(timeSlot?.eTime??"");
                return InkWell(
                  onTap: () {
                    timeSlotSelected(timeSlot!);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${DateFormat('h:mm a').format(startTime)} - ${DateFormat('h:mm a').format(endTime)}",
                          style:
                              TextStyle(color: Color(0xff64BA02), fontSize: 16),
                        ),
                        timeSelected != timeSlot
                            ? Icon(
                                Icons.check_circle_outline,
                                color: Colors.grey[200],
                              )
                            : Icon(
                                Icons.check_circle_outline,
                                color: Color(0xff64BA02)
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

  void timeSlotSelected(TimeSlotResponseDataTimeSlot timeSlot){
    setState(() {
      timeSelected = timeSlot;
    });
    final checkOutNotifier = Provider.of<CheckOutNotifier>(context, listen:false);
    checkOutNotifier.timeSlot = timeSlot.id??0;
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime startDate = new DateFormat("yyyy-MM-dd").parse(applicationSetting?.data?.applicationSetting?.curentDate??"");

    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: startDate,
        firstDate: startDate,
        lastDate: DateTime.now().add(Duration(days: applicationSetting?.data?.applicationSetting?.lastDate??10)));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
    final checkOutNotifier = Provider.of<CheckOutNotifier>(context, listen:false);
    checkOutNotifier.deliveryDate = selectedDate.toString();
  }
}
