//import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:delivery_basket/constants.dart';
import 'package:delivery_basket/data/AppNotifer.dart';
import 'package:delivery_basket/data/local/DBProvider.dart';
import 'package:delivery_basket/data/local/model/CartModel.dart';
import 'package:delivery_basket/data/local/shared_pref.dart';
import 'package:delivery_basket/data/remote/model/cart/cart_list_response.dart';
import 'package:delivery_basket/data/remote/model/setting/application_setting_response.dart';
import 'package:delivery_basket/data/remote/model/setting/tag_line_response.dart';
import 'package:delivery_basket/data/remote/model/setting/user_profile_response.dart';
import 'package:delivery_basket/data/remote/repository.dart';
import 'package:delivery_basket/generated/l10n.dart';
import 'package:delivery_basket/screens/category/sub_category_screen.dart';
import 'package:delivery_basket/screens/home/tabs/cart_tab_screen.dart';
import 'package:delivery_basket/screens/home/tabs/offer_tab_screen.dart';
import 'package:delivery_basket/screens/home/tabs/store_tab_screen.dart';
import 'package:delivery_basket/screens/home/tabs/wishlist_tab_screen.dart';
import 'package:delivery_basket/screens/login/login_screen.dart';
import 'package:delivery_basket/screens/search/search_screen.dart';

class HomeScreen extends StatefulWidget {
  final int currentPage;

  const HomeScreen({Key? key, this.currentPage = 0}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //static final facebookAppEvents = FacebookAppEvents();
  int _currentIndex = 0;
  bool isUserLogin = false;
  Repository? _repository;
  CheckOutNotifier? checkOutNotifier;
  int cart = 0;

  String store = "";
  String strCart = "";
  String offers = "";
  String wishlist = "";
  String alert = "";
  String areYouSureCLoseApp = "";
  String yes = "";
  String no = "";

  init() async {
    store = await getI18n("store");
    strCart = await getI18n("cart");
    offers = await getI18n("offers");
    wishlist = await getI18n("wishlist");
    alert = await getI18n("alert");
    areYouSureCLoseApp = await getI18n("areYouSureCLoseApp");
    yes = await getI18n("yes");
    no = await getI18n("no");
    setState(() {});
  }

  @override
  void initState() {
    init();
    super.initState();
    setState(() {
      _currentIndex = widget.currentPage;
    });
    checkOutNotifier = Provider.of<CheckOutNotifier>(context, listen: false);
    _repository = Repository();
    checkLogin();
    fetchTagLine();
    // facebookAppEvents.logEvent(
    //   name: 'home',
    //   parameters: {
    //     'status': 'home_screen_launch',
    //   },
    // );
    setState(() {
      cart = checkOutNotifier?.cartCount ?? 0;
    });
    checkOutNotifier?.addListener(() {
      setState(() {
        cart = checkOutNotifier?.cartCount ?? 0;
      });
    });
  }

  void checkLogin() async {
    bool? tempLogin = await getLogin();
    setState(() {
      isUserLogin = tempLogin!;
    });
    if (isUserLogin == true) {
      fetchCartLoginList();
      fetchUserDetails();
    }
  }

  fetchUserDetails() async {
    var map = Map<String, String>();
    try {
      UserProfileResponse? response =
          await _repository?.fetchUserProfile(context, map);
      if (response?.success ?? false) {
        await saveUserName(response?.data?.name ?? "");
      } else {
        Fluttertoast.showToast(msg: "failed to load user details");
      }
    } catch (e) {
      print("error: ${e.toString()}");
      print(e);
    }
  }

  fetchCartLoginList() async {
    var map = Map<String, String>();
    try {
      CartListResponse? response =
          await _repository?.fetchCartLoginList(context, map);
      if (response?.success ?? false) {
        await DBProvider.db.deleteAllCart();
        response?.data?.product?.forEach((element) async {
          await DBProvider.db.newCart(Cart(
              id: element?.productId ?? 0,
              prodId: element?.productId ?? 0,
              name: "",
              quantity: double.parse(element?.quantity ?? "0").toInt()));
        });
        List<Cart> cartsLocal = await DBProvider.db.getAllCart();
        Provider.of<CheckOutNotifier>(context, listen: false)
            .cartCountUpdate(cartsLocal.length);
        setState(() {
          cartsLocal = cartsLocal;
        });
      }
    } catch (e) {
      print("error: ${e.toString()}");

      print(e);
    }
  }

  fetchTagLine() async {
    var map = Map<String, String>();
    try {
      TagLineResponse? response = await _repository?.fetchTagLine(context, map);
      if (response?.success ?? false) {
        await saveTagLine(response?.data?.tagLine?.tagLine ?? "");
        List<String> finalPopularList = [];
        response?.data?.tagLine?.popularSearch?.forEach((element) {
          finalPopularList.add(element?.product?.productName != null
              ? element?.product?.productName?.name ?? ""
              : element?.product?.name ?? "");
        });
        await savePopularSearch(finalPopularList);
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
    var items = [
      StoreTabView(),
      CartTabView(),
      OfferTabView(),
      isUserLogin ? WishlistTabView() : Container(),
    ];

    return WillPopScope(
      onWillPop: () {
        if (_currentIndex != 0) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen(
                        currentPage: 0,
                      )),
              (route) => false);
        } else {
          showAlertDialog(context);
        }
        return new Future(() => false);
      },
      child: Scaffold(
        body: SafeArea(child: items[_currentIndex]),
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: kPrimaryColor,
            selectedIconTheme: IconThemeData(
              color: Color(0xffA3CC39),
            ),
            selectedLabelStyle: TextStyle(color: kPrimaryColor),
            unselectedItemColor: Color(0xff0F0F0F),
            selectedFontSize: 14,
            unselectedFontSize: 14,
            currentIndex: _currentIndex,
            onTap: (value) {
              setState(() => _currentIndex = value);
              if (isUserLogin == false && value == 3) {
                //loginAlertShow(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginScreen(
                              isShowBack: true,
                            )));
              }
            },
            items: [
              BottomNavigationBarItem(
                label: store,
                icon: SvgPicture.asset(
                  "assets/images/ic_store.svg",
                  color: _currentIndex == 0 ? Color(0xffA3CC39) : Colors.black,
                ),
              ),
              
              BottomNavigationBarItem(
                  label: strCart,
                  icon: new Stack(
                    children: <Widget>[
                      new SvgPicture.asset(
                        "assets/images/ic_cart.svg",
                        color: _currentIndex == 1
                            ? Color(0xffA3CC39)
                            : Colors.black,
                      ),
                      if (cart != 0)
                        new Positioned(
                          right: 0,
                          child: new Container(
                            padding: EdgeInsets.all(1),
                            decoration: new BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 12,
                              minHeight: 12,
                            ),
                            child: new Text(
                              '$cart',
                              style: new TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                    ],
                  )),
              BottomNavigationBarItem(
                label: offers,
                icon: SvgPicture.asset(
                  "assets/images/ic_offer.svg",
                  color: _currentIndex == 2 ? Color(0xffA3CC39) : Colors.black,
                ),
              ),
              BottomNavigationBarItem(
                label: wishlist,
                icon: SvgPicture.asset(
                  "assets/images/ic_wishlist.svg",
                  color: _currentIndex == 3 ? Color(0xffA3CC39) : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: new Text(alert),
              content: new Text(areYouSureCLoseApp),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text(yes),
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                ),
                CupertinoDialogAction(
                  child: Text(no),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }
}
