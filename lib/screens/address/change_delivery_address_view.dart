import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:delivery_basket/constants.dart';
import 'package:delivery_basket/data/AppNotifer.dart';
import 'package:delivery_basket/data/local/shared_pref.dart';
import 'package:delivery_basket/data/remote/model/address/address_delete_response.dart';
import 'package:delivery_basket/data/remote/model/address/address_list_response.dart';
import 'package:delivery_basket/data/remote/repository.dart';
import 'package:delivery_basket/generated/l10n.dart';
import 'package:delivery_basket/screens/address/address_new_view.dart';

class ChangeDeliveryAddressView extends StatefulWidget {
  @override
  _ChangeDeliveryAddressViewState createState() =>
      _ChangeDeliveryAddressViewState();
}

class _ChangeDeliveryAddressViewState extends State<ChangeDeliveryAddressView> {
  Repository? _repository;
  bool isLoading = false;
  bool isAddressLoading = false;
  List<AddressListResponseDataAddress?>? addressList = [];
  AddressListResponseDataAddress? defaultAddress;

  String noAddressFound = "";
  String addNewAddress = "";
  String changeDeliveryAddress = "";
  String cancel = "";
  String continueText = "";
  String stralert = "";
  String areYouSureDeleteAddress = "";
  String strdefaultAddress = "";

  init() async {
    noAddressFound = await getI18n("noAddressFound");
    addNewAddress = await getI18n("addNewAddress");
    changeDeliveryAddress = await getI18n("changeDeliveryAddress");
    cancel = await getI18n("cancel");
    continueText = await getI18n("continueText");
    stralert = await getI18n("alert");
    areYouSureDeleteAddress = await getI18n("areYouSureDeleteAddress");
    strdefaultAddress = await getI18n("defaultAddress");
    setState(() {});
  }

  @override
  void initState() {
    init();
    super.initState();
    _repository = Repository();
    fetchAddressList();
  }

  fetchAddressList() async {
    setState(() {
      isAddressLoading = true;
    });
    var map = Map<String, String>();
    try {
      AddressListResponse? response =
          await _repository?.fetchAddressList(context, map);
      setState(() {
        isAddressLoading = false;
      });
      if (response?.success ?? false) {
        setState(() {
          addressList = [];
          addressList?.addAll(response!.data!.address!);
        });
      } else {
        Fluttertoast.showToast(msg: "address list not loaded");
      }
    } catch (e) {
      print("error: ${e.toString()}");
      print(e);
    }
  }

  deleteAddress(AddressListResponseDataAddress address) async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    try {
      AddressDeleteResponse? response =
          await _repository?.addressDelete(context, map, address.id ?? 0);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        setState(() {
          addressList?.remove(address);
        });
        Fluttertoast.showToast(msg: "address deleted successfully");
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(msg: "failed to delete");
      }
    } catch (e) {
      print("error: ${e.toString()}");
      print(e);
    }
  }

  setDefaultAddress(AddressListResponseDataAddress address) {
    setState(() {
      defaultAddress = address;
    });
    final checkOutNotifier =
        Provider.of<CheckOutNotifier>(context, listen: false);
    checkOutNotifier.addressId = address.id ?? -1;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar(),
        body: Stack(
          children: [
            isAddressLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : addressList?.length == 0
                    ? Center(
                        child: Text(
                          noAddressFound,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 80),
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: addressList?.length,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              AddressListResponseDataAddress? address =
                                  addressList?[index];
                              return InkWell(
                                  onTap: () {
                                    setDefaultAddress(address!);
                                  },
                                  child: addressItem(address!));
                            }),
                      ),
            SizedBox(
              height: 16,
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CupertinoButton(
                    child: Text(
                      addNewAddress,
                      style: TextStyle(color: Color(0xff323232)),
                    ),
                    onPressed: () async {
                      await Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddressNewView(
                                    isUpdateAddress: false,
                                  )));

                      fetchAddressList();
                    },
                    color: kPrimaryColor,
                  ),
                ))
          ],
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
                changeDeliveryAddress,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ],
        ),
      ),
    );
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

  deleteDialog(BuildContext context, AddressListResponseDataAddress address) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(cancel),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text(continueText),
      onPressed: () {
        deleteAddress(address);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(stralert),
      content: Text(areYouSureDeleteAddress),
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

  Widget addressItem(AddressListResponseDataAddress address) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xffF3F3F3)),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: Color(0xffF3F3F3))]),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "${address.name}",
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              if (defaultAddress == address) ...[
                Text(
                  strdefaultAddress,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      ?.copyWith(color: kPrimaryColor),
                ),
              ],
              IconButton(
                  onPressed: () async {
                    await Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddressNewView(
                                  isUpdateAddress: true,
                                  address: address,
                                )));
                    fetchAddressList();
                  },
                  icon: Icon(Icons.edit)),
              IconButton(
                  onPressed: () {
                    deleteDialog(context, address);
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red.withOpacity(0.8),
                  )),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
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
                      child: Image.asset("assets/images/ic_map_home.png"))
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
                        "${address.address}"),
                    addressDetailsItem(
                        "assets/images/ic_user.svg", "${address.landMark}"),
                    addressDetailsItem(
                        "assets/images/ic_call.svg", "${address.mobile}")
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
