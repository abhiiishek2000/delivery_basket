import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:delivery_basket/constants.dart';
import 'package:delivery_basket/data/local/shared_pref.dart';
import 'package:delivery_basket/data/remote/model/address/address_add_response.dart';
import 'package:delivery_basket/data/remote/model/address/address_list_response.dart';
import 'package:delivery_basket/data/remote/model/address/city_list_response.dart';
import 'package:delivery_basket/data/remote/model/address/pincode_list_response.dart';
import 'package:delivery_basket/data/remote/model/address/state_list_response.dart';
import 'package:delivery_basket/data/remote/repository.dart';
import 'package:delivery_basket/generated/l10n.dart';
import 'package:delivery_basket/screens/address/change_delivery_address_view.dart';
import 'package:delivery_basket/screens/address/city_list_view.dart';
import 'package:delivery_basket/screens/address/state_list_view.dart';

class AddressNewView extends StatefulWidget {
  final bool isUpdateAddress;
  final AddressListResponseDataAddress? address;

  const AddressNewView({Key? key, required this.isUpdateAddress, this.address})
      : super(key: key);

  @override
  _AddressNewViewState createState() => _AddressNewViewState();
}

class _AddressNewViewState extends State<AddressNewView> {
  Repository? _repository;
  Completer<GoogleMapController> _controller = Completer();
  LatLng currentLatLong = LatLng(37.42796133580664, -122.085749655962);
  bool isLoading = false;
  Position? _currentPosition;
  String? _currentAddress;
  TextEditingController nameController = TextEditingController();
  TextEditingController flatNoController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  StateListResponseDataState? stateSelected;
  CityListResponseDataCity? citySelected;
  List<PincodeListResponseDataPincode?>? pinCodeList = [];
  bool isUseMyLocation = false;

  String straddressUpdatedSuccessfully = "";
  String straddressAddedSuccessfully = "";
  String strfailedToUpateAddress = "";
  String strfailedToaddAddress = "";
  String strok = "";
  String strsorryForInconvenience = "";
  String strdeliveryNotAvailable = "";
  String strpleaseEnter = "";
  String strfullName = "";
  String strflatNo = "";
  String strlandmark = "";
  String strenterMobileNumber = "";
  String strenterValidMobileNumber = "";
  String strselect = "";
  String strstate = "";
  String strcity = "";
  String strenterValidPinCode = "";
  String strsave = "";
  String straddNewAddress = "";
  String strpincode = "";
  String strdefaultDeliveryAddress = "";
  String struseMyLocation = "";
  String strUseOtherLocation = "";

  init() async {
    straddressUpdatedSuccessfully = await getI18n("addressUpdatedSuccessfully");
    straddressAddedSuccessfully = await getI18n("addressAddedSuccessfully");
    strfailedToUpateAddress = await getI18n("failedToUpateAddress");
    strfailedToaddAddress = await getI18n("failedToaddAddress");
    strok = await getI18n("ok");
    strsorryForInconvenience = await getI18n("sorryForInconvenience");
    strdeliveryNotAvailable = await getI18n("deliveryNotAvailable");
    strpleaseEnter = await getI18n("pleaseEnter");
    strfullName = await getI18n("fullName");
    strflatNo = await getI18n("flatNo");
    strlandmark = await getI18n("landmark");
    strenterMobileNumber = await getI18n("enterMobileNumber");
    strenterValidMobileNumber = await getI18n("enterValidMobileNumber");
    strselect = await getI18n("select");
    strstate = await getI18n("state");
    strcity = await getI18n("city");
    strenterValidPinCode = await getI18n("enterValidPinCode");
    strsave = await getI18n("save");
    straddNewAddress = await getI18n("addNewAddress");
    strpincode = await getI18n("pincode");
    strdefaultDeliveryAddress = await getI18n("defaultDeliveryAddress");
    struseMyLocation = await getI18n("useMyLocation");
    strUseOtherLocation = await getI18n("useOtherLocation");
    setState(() {});
  }

  @override
  void initState() {
    init();
    super.initState();
    _repository = Repository();
    _getCurrentLocation();
    fetchPincodeList();
    print(_currentAddress);
    setState(() {
      if (widget.isUpdateAddress) {
        nameController.text = widget.address?.name ?? "";
        flatNoController.text = widget.address?.address ?? "";
        landmarkController.text = widget.address?.landMark ?? "";
        mobileController.text = widget.address?.mobile ?? "";
        pinCodeController.text = widget.address?.pincode ?? "";
      }
    });
    if (widget.isUpdateAddress) {
      fetchStateList();
    }
  }

  Future<LatLng> getCenter() async {
    final GoogleMapController controller = await _controller.future;
    LatLngBounds visibleRegion = await controller.getVisibleRegion();
    LatLng centerLatLng = LatLng(
      (visibleRegion.northeast.latitude + visibleRegion.southwest.latitude) / 2,
      (visibleRegion.northeast.longitude + visibleRegion.southwest.longitude) /
          2,
    );

    return centerLatLng;
  }

  fetchStateList() async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    try {
      StateListResponse? response =
          await _repository?.fetchStateList(context, map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        setState(() {
          if (widget.isUpdateAddress) {
            stateSelected = response?.data?.state?.first;
          } else {
            response?.data?.state?.forEach((element) {
              if (element?.id == widget.address?.stateId) {
                stateSelected = element;
              }
            });
          }
        });
        fetchCityList();
      } else {
        Fluttertoast.showToast(msg: "state list not loaded");
      }
    } catch (e) {
      print("error: ${e.toString()}");
      print(e);
    }
  }

  fetchCityList() async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    map['state_id'] = "${widget.address?.stateId.toString()}";
    try {
      CityListResponse? response =
          await _repository?.fetchCityList(context, map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        setState(() {
          if (widget.isUpdateAddress) {
            citySelected = response?.data?.city?.first;
          } else {
            response?.data?.city?.forEach((element) {
              if (element?.id == widget.address?.cityId) {
                citySelected = element;
              }
            });
          }
        });
      } else {
        Fluttertoast.showToast(msg: "city list not loaded");
      }
    } catch (e) {
      print("error: ${e.toString()}");
      print(e);
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  _getCurrentLocation() async {
    // Position? position = await Geolocator.getLastKnownPosition();
    // setState(() {
    //   _currentPosition = position;
    //   currentLatLong = LatLng(position?.latitude??0.0, position?.longitude??0.0);
    //   _getAddressFromLatLng();
    // });

    Position? position = await _determinePosition();
    setState(() {
      _currentPosition = position;
      currentLatLong = LatLng(position.latitude, position.longitude);
      _getAddressFromLatLng();
    });

    // Geolocator.getCurrentPosition(
    //         desiredAccuracy: LocationAccuracy.best,
    //         forceAndroidLocationManager: true)
    //     .then((Position position) {
    //   setState(() {
    //     _currentPosition = position;
    //     currentLatLong = LatLng(position.latitude, position.longitude);
    //     _getAddressFromLatLng();
    //   });
    // }).catchError((e) {
    //   print(e);
    // });
  }

  _getAddressFromLatLng() async {
    try {
      if (_currentPosition != null) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            _currentPosition?.latitude ?? 0.0,
            _currentPosition?.longitude ?? 0.0);
        //latLongToAddress();
        Placemark place = placemarks[0];

        setState(() {
          _currentAddress =
              "${place.locality}, ${place.postalCode}, ${place.country}";
          // flatNoController.text = "${place.locality}";
          // landmarkController.text = "${place.subLocality}";
        });
      }
    } catch (e) {
      print(e);
    }
  }

  fetchPincodeList() async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    try {
      PincodeListResponse? response =
          await _repository?.fetchPinCodeList(context, map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        setState(() {
          pinCodeList = [];
          pinCodeList?.addAll(response!.data!.pincode!);
        });
      } else {
        Fluttertoast.showToast(msg: "pincode list not loaded");
      }
    } catch (e) {
      print("error: ${e.toString()}");
      print(e);
    }
  }

  void latLongToAddress() async {
    try {
      List<Placemark> newPlace = await placemarkFromCoordinates(
          _currentPosition?.latitude ?? 0.0,
          _currentPosition?.longitude ?? 0.0);

      // this is all you need
      Placemark placeMark = newPlace[0];
      String name = placeMark.name ?? "";
      String subLocality = placeMark.subLocality ?? "";
      String locality = placeMark.locality ?? "";
      String administrativeArea = placeMark.administrativeArea ?? "";
      String postalCode = placeMark.postalCode ?? "";
      String country = placeMark.country ?? "";
      String address =
          "$name, $subLocality, $locality, $administrativeArea $postalCode, $country";

      print("address -------- $address");
      setState(() {
        flatNoController.text = name;
        landmarkController.text = "$subLocality $locality";
        pinCodeController.text = postalCode;
      });
    } catch (e) {}
  }

  addressToLatLong() async {
    List<Location> locations = await locationFromAddress(
        "${flatNoController.text} ${landmarkController.text} ${pinCodeController.text}");
    setState(() {
      currentLatLong =
          LatLng(locations.first.latitude, locations.first.longitude);
    });
    print("address to lat long set done ${currentLatLong}");
  }

  addAddress() async {
    setState(() {
      isLoading = true;
    });

    if (isUseMyLocation == false) {
      await addressToLatLong();
    }

    var map = Map<String, String>();
    map['name'] = nameController.text;
    map['mobile'] = mobileController.text;
    map['address'] = flatNoController.text;
    map['land_mark'] = landmarkController.text;
    map['pincode'] = pinCodeController.text;
    map['latitude'] = "${currentLatLong.latitude}";
    map['longitude'] = "${currentLatLong.longitude}";
    map['country_id'] = "1";
    map['state_id'] = "${stateSelected?.id}";
    map['city_id'] = "${citySelected?.id}";

    if (widget.isUpdateAddress) {
      map['_method'] = "PUT";
    }

    try {
      AddressAddResponse? response = widget.isUpdateAddress
          ? await _repository?.addressUpdate(context, map, widget.address!.id!)
          : await _repository?.addressAdd(context, map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        Fluttertoast.showToast(
            msg: widget.isUpdateAddress
                ? straddressUpdatedSuccessfully
                : straddressAddedSuccessfully);
        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => ChangeDeliveryAddressView()));
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
            msg: widget.isUpdateAddress
                ? strfailedToUpateAddress
                : strfailedToaddAddress);
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              bottomSheet(),
            ],
          ),
        ),
        // body: Stack(
        //   children: [
        //     GoogleMap(
        //       mapType: MapType.normal,
        //       initialCameraPosition: CameraPosition(
        //         target: currentLatLong,
        //         zoom: 14.4746,
        //       ),
        //       onMapCreated: (GoogleMapController controller) {
        //         _controller.complete(controller);
        //       },
        //       myLocationButtonEnabled: true,
        //       onLongPress: (location) {
        //         currentLatLong = location;
        //       },
        //       myLocationEnabled: true,
        //     ),
        //     Align(
        //       alignment: Alignment.bottomCenter,
        //       child: Padding(
        //         padding: const EdgeInsets.only(bottom: 16),
        //         child: CupertinoButton(
        //             color: kPrimaryColor,
        //             onPressed: () {
        //               showModalBottomSheet(
        //                   context: context,
        //                   isScrollControlled: true,
        //                   builder: (context) {
        //                     return bottomSheet();
        //                   });
        //             },
        //             child: Text(
        //                 " ${widget.isUpdateAddress ? "Update" : "Add"} new Address")),
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text(strok),
      onPressed: () {
        Navigator.pop(context);
        pinCodeController.text = "";
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(strsorryForInconvenience),
      content: Text(strdeliveryNotAvailable),
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

  Widget bottomSheet() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      margin: const EdgeInsets.only(top: 32),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0xffDCE1DF),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 0), // changes
            )
          ]),
      child: Stack(
        children: [
          Align(
              alignment: Alignment.topRight,
              child: OutlinedButton(
                  onPressed: () {
                    bool pincodeValid = false;
                    pinCodeList?.forEach((element) {
                      if (element?.pincode.toString().trim() ==
                          pinCodeController.text.trim()) {
                        pincodeValid = true;
                      }
                    });
                    if (nameController.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "${strpleaseEnter} ${strfullName}");
                    } else if (flatNoController.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "${strpleaseEnter} ${strflatNo}");
                    } else if (landmarkController.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "${strpleaseEnter} ${strlandmark}");
                    } else if (mobileController.text.isEmpty) {
                      Fluttertoast.showToast(msg: strenterMobileNumber);
                    } else if (mobileController.text.length != 10) {
                      Fluttertoast.showToast(msg: strenterValidMobileNumber);
                    } else if (stateSelected == null) {
                      Fluttertoast.showToast(msg: "${strselect} ${strstate}");
                    } else if (citySelected == null) {
                      Fluttertoast.showToast(msg: "${strselect} ${strcity}");
                    } else if (pincodeValid == false) {
                      Fluttertoast.showToast(msg: strenterValidPinCode);
                      showAlertDialog(context);
                    } else {
                      addAddress();
                    }
                  },
                  child: Text(
                    strsave,
                    style: TextStyle(color: kPrimaryColor),
                  ))),
          Align(
              alignment: Alignment.topLeft,
              child: RawMaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                elevation: 2.0,
                fillColor: kPrimaryColor,
                child: Icon(
                  Icons.close,
                  size: 24.0,
                  color: Colors.black,
                ),
                padding: EdgeInsets.all(2.0),
                shape: CircleBorder(),
              )),
          Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Text(
                straddNewAddress,
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(
                height: 8,
              ),
              OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    isUseMyLocation = !isUseMyLocation;
                  });
                  if (isUseMyLocation == false) {
                    flatNoController.text = "";
                    landmarkController.text = "";
                    pinCodeController.text = "";
                  } else {
                    latLongToAddress();
                  }
                },
                icon: Icon(
                  Icons.gps_fixed,
                  color: kPrimaryColor.withOpacity(0.9),
                ),
                label: Text(
                  "${isUseMyLocation == false ? struseMyLocation : strUseOtherLocation} ",
                  style: TextStyle(color: kPrimaryColor),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                      width: 1.0, color: kPrimaryColor.withOpacity(0.5)),
                ),
              ),
              if (isUseMyLocation)
                Text(
                    "Now we are using your current location, for use other location tap on above button 'USE OTHER LOCATION'"),
              if (!isUseMyLocation)
                Text(
                  "Now you can set manually address, for use current location tap on above button 'USE MY LOCATION'",
                  textAlign: TextAlign.center,
                ),
              Divider(),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    width: 90,
                    decoration: BoxDecoration(
                        color: Color(0xffEFEFEF),
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset("assets/images/ic_home.svg"),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xffC5CEE0),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                          color: Color(0xffEFEFEF),
                          borderRadius: BorderRadius.circular(8)),
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.fromLTRB(6, 3, 6, 3),
                            hintText: strfullName),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                    color: Color(0xffEFEFEF),
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        enabled: !isUseMyLocation,
                        controller: flatNoController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.fromLTRB(6, 3, 6, 3),
                            hintText: strflatNo),
                      ),
                    ),
                    SvgPicture.asset("assets/images/ic_location_green.svg")
                  ],
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                    color: Color(0xffEFEFEF),
                    borderRadius: BorderRadius.circular(8)),
                child: TextFormField(
                  enabled: !isUseMyLocation,
                  controller: landmarkController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.fromLTRB(6, 3, 6, 3),
                      hintText: strlandmark),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              InkWell(
                onTap: stateCall,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                      color: Color(0xffEFEFEF),
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${stateSelected == null ? "${strselect} ${strstate}" : stateSelected?.name}",
                        style: TextStyle(color: Colors.black),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xffC5CEE0),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              InkWell(
                onTap: cityCall,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                      color: Color(0xffEFEFEF),
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${citySelected == null ? "${strselect} ${strcity}" : citySelected?.name}",
                        style: TextStyle(color: Colors.black),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xffC5CEE0),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Container(
                    width: 120,
                    alignment: Alignment.centerLeft,
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                        color: Color(0xffEFEFEF),
                        borderRadius: BorderRadius.circular(8)),
                    child: TextFormField(
                      enabled: !isUseMyLocation,
                      controller: pinCodeController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        new LengthLimitingTextInputFormatter(6),
                      ],
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.fromLTRB(6, 3, 6, 3),
                          hintText: strpincode),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                    color: Color(0xffEFEFEF),
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    Image.asset("assets/images/ic_india_flag.png"),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "+91",
                      style: TextStyle(color: Color(0xff222B45)),
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
                            contentPadding: EdgeInsets.fromLTRB(6, 3, 6, 3),
                            hintText: "0000 000 0000"),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Radio(value: false, groupValue: false, onChanged: (value) {}),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    strdefaultDeliveryAddress,
                    style: TextStyle(color: Color(0xff222B45)),
                  )
                ],
              )
            ],
          ),
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
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangeDeliveryAddressView()));
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
          ],
        ),
      ),
    );
  }

  void stateCall() async {
    StateListResponseDataState result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => StateListView()));
    print("result state ${result.name}");
    stateSelected = result;
    setState(() {});
  }

  void cityCall() async {
    CityListResponseDataCity result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CityListView(
                  stateId: stateSelected?.id ?? 0,
                )));
    print("result city ${result.name}");
    citySelected = result;
    setState(() {});
  }
}
