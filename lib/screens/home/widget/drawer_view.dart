import 'package:delivery_basket/screens/signup/mobile_fill_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:delivery_basket/constants.dart';
import 'package:delivery_basket/data/local/DBProvider.dart';
import 'package:delivery_basket/data/local/shared_pref.dart';
import 'package:delivery_basket/data/remote/model/address/address_list_response.dart';
import 'package:delivery_basket/data/remote/model/login/logout_response.dart';
import 'package:delivery_basket/data/remote/model/setting/user_profile_response.dart';
import 'package:delivery_basket/data/remote/model/wallet/wallet_add_response.dart';
import 'package:delivery_basket/data/remote/repository.dart';
import 'package:delivery_basket/generated/l10n.dart';
import 'package:delivery_basket/screens/address/change_delivery_address_view.dart';
import 'package:delivery_basket/screens/customersupport/customer_support_screen.dart';
import 'package:delivery_basket/screens/home/home_screen.dart';
import 'package:delivery_basket/screens/language_screen/language_screen.dart';
import 'package:delivery_basket/screens/login/login_screen.dart';
import 'package:delivery_basket/screens/order/order_history_screen.dart';
import 'package:delivery_basket/screens/profile_update/profile_update_view.dart';
import 'package:delivery_basket/screens/wallet/wallet_overview.dart';

class DrawerView extends StatefulWidget {
  @override
  _DrawerViewState createState() => _DrawerViewState();
}

class _DrawerViewState extends State<DrawerView> {
  bool isUserLogin = false;
  bool isLoading = false;
  Repository? _repository;
  UserProfileResponseData? userDetails;
  List<AddressListResponseDataAddress?>? addressList = [];
  String walletAmount = "";
  String strLogin = "";
  String strRegister = "";
  String strNoAddressFound = "";
  String strChange = "";
  String strWallet = "";
  String strMyOrders = "";
  String strMyDeliveryAddress = "";
  String strLanguage = "";
  String strCustomerSupport = "";
  String strLogout = "";
  String strPleaseLoginFirst = "";
  String strcustomerSupport = "";
  String strHelloUser = "";
  String strAlert = "";
  String strcancel = "";
  String strcontinue = "";
  String strareYouSureLogout = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _repository = Repository();
    checkLogin();
    init();
  }

  init() async {
    strLogin = await getI18n("loginpage");
    strRegister = await getI18n('register');
    strNoAddressFound = await getI18n("noAddressFound");
    strChange = await getI18n("change");
    strWallet = await getI18n("wallet");
    strMyOrders = await getI18n("myOrders");
    strMyDeliveryAddress = await getI18n("myDeliveryAddress");
    strLanguage = await getI18n("language");
    strLogout = await getI18n("logout");
    strPleaseLoginFirst = await getI18n("pleaseLoginFirst");
    strcustomerSupport = await getI18n("customerSupport");
    strHelloUser = await getI18n("helloUser");
    strAlert = await getI18n("alert");
    strcancel = await getI18n("cancel");
    strcontinue = await getI18n("continueText");
    strareYouSureLogout = await getI18n("areYouSureLogout");
    setState(() {});
  }

  fetchUserDetails() async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    try {
      UserProfileResponse? response =
          await _repository?.fetchUserProfile(context, map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        setState(() {
          userDetails = response?.data;
        });
        await saveUserName(userDetails?.name ?? "");
      } else {
        Fluttertoast.showToast(msg: "failed to load user details");
      }
    } catch (e) {
      print("error: ${e.toString()}");
      print(e);
    }
  }

  apiUserLogout() async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    map['device_key'] = await getFirebaseToken();
    try {
      LogoutResponse? response = await _repository?.apiLogout(context, map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        await DBProvider.db.deleteAllCart();
        await saveLogin(false);
        await saveToken("");
        await saveUserName("");
        await saveMobile("");
        await saveFirebaseToken("");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false);
      } else {
        Fluttertoast.showToast(msg: "Logout failed");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Logout failed");
      print(e);
    }
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
          walletAmount = response?.data?.wallet ?? "";
        });
      } else {
        Fluttertoast.showToast(msg: "failed to to load wallet money");
      }
    } catch (e) {
      print("error: ${e.toString()}");
      print(e);
    }
  }

  fetchAddressList() async {
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width / 1.3,
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              child: Stack(
                children: [
                  Container(
                    height: 168,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              const Color(0xff7DCC39),
                              const Color(0xffFBBB5A),
                            ],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(1.0, 0.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(20))),
                  ),
                  if (isUserLogin == true) ...[
                    Positioned(
                      top: 60,
                      child: Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 1.3 - 32,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0xff1a000000),
                                      offset: Offset(0, 3),
                                      blurRadius: 22),
                                ]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 70,
                                  width: 56,
                                ),
                                Text(
                                  "${userDetails?.name ?? ""}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                  maxLines: 2,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "${userDetails?.mobileNumber ?? ""}",
                                  style: Theme.of(context).textTheme.bodyText2,
                                  maxLines: 1,
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 1),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color(0xffEFEFEF)),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                          "assets/images/ic_location_orange.svg"),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                          child: Text(
                                        "${addressList?.length == 0 ? strNoAddressFound : addressList?.first?.address}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                      OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                              width: 1.0,
                                              color: Color(0xffA3CC39)),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChangeDeliveryAddressView()));
                                        },
                                        child: Text(
                                          strChange,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Container(
                          //   padding: const EdgeInsets.symmetric(
                          //       horizontal: 12, vertical: 12),
                          //   decoration: BoxDecoration(
                          //       color: Colors.white,
                          //       borderRadius: BorderRadius.circular(10),
                          //       border:
                          //           Border.all(color: Color(0xff84CA62))),
                          //   child: Text(
                          //     "${strWallet}\n₹$walletAmount",
                          //     textAlign: TextAlign.center,
                          //   ),
                          // )

                          Positioned(
                            left: 100,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: FaIcon(
                                FontAwesomeIcons.user,
                                size: 56,
                                color: Color(0xffB4B4B4),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: 320,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.3,
                        child: Column(
                          children: [
                            menuItem(strMyOrders, () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          OrderHistoryScreen()));
                            }),
                            menuItem(strWallet, () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          WalletOverViewScreen()));
                            }),
                            // menuItem("My ratings", () {}),
                            // menuItem("Notifications", () {}),
                            menuItem(strMyDeliveryAddress, () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ChangeDeliveryAddressView()));
                            }),
                            menuItem(strLanguage, () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LanguageScreen(
                                            hideBackButton: false,
                                          )));
                            }),
                            menuItem(strcustomerSupport, () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CustomerSupportScreen()));
                            }),
                            isUserLogin == true
                                ? InkWell(
                                    onTap: () async {
                                      showAlertDialog(context);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            strLogout,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1
                                                ?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xffFF1414)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    )
                  ],
                  if (isUserLogin == false) ...[
                    Positioned(
                      top: 60,
                      child: Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 1.3 - 32,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0xff1a000000),
                                      offset: Offset(0, 3),
                                      blurRadius: 22),
                                ]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 90,
                                  width: 56,
                                ),
                                Text(
                                  strHelloUser,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                  maxLines: 2,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                InkWell(
                                  onTap: () => Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen(
                                                isShowBack: true,
                                              )),
                                      (route) => false),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 41,
                                    decoration: BoxDecoration(
                                        color: Color(0xffA3CC39),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Center(child: Text('Login')),
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (builder) =>
                                              MobileFillScreen())),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 41,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color(0xffA3CC39), width: 1),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Center(child: Text('Sign Up')),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Positioned(
                            left: 100,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: FaIcon(
                                FontAwesomeIcons.user,
                                size: 56,
                                color: Color(0xffB4B4B4),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: 320,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.3,
                        child: Column(
                          children: [
                            menuItem(strMyOrders, () {
                              Fluttertoast.showToast(msg: strPleaseLoginFirst);
                            }),
                            menuItem(strWallet, () {
                              Fluttertoast.showToast(msg: strPleaseLoginFirst);
                            }),
                            // menuItem("My ratings", () {}),
                            // menuItem("Notifications", () {}),
                            menuItem(strMyDeliveryAddress, () {
                              Fluttertoast.showToast(msg: strPleaseLoginFirst);
                            }),
                            menuItem(strLanguage, () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LanguageScreen(
                                            hideBackButton: false,
                                          )));
                            }),
                            menuItem(strcustomerSupport, () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CustomerSupportScreen()));
                            }),
                          ],
                        ),
                      ),
                    )
                  ]
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(strcancel),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text(strcontinue),
      onPressed: () async {
        apiUserLogout();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(strAlert),
      content: Text(strareYouSureLogout),
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

  Widget menuItem(String title, Function() onclick) {
    return InkWell(
      onTap: onclick,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$title",
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            FaIcon(
              FontAwesomeIcons.chevronRight,
              size: 15,
            )
          ],
        ),
      ),
    );
  }

  void checkLogin() async {
    bool? temLogin = await getLogin();
    setState(() {
      isUserLogin = temLogin!;
    });
    if (temLogin == true) {
      fetchUserDetails();
      fetchAddressList();
      fetchWalletAmount();
    }
  }
}
