import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:delivery_basket/data/local/shared_pref.dart';
import 'package:delivery_basket/data/remote/model/notification/notification_list_response.dart';
import 'package:delivery_basket/data/remote/model/setting/user_profile_response.dart';
import 'package:delivery_basket/data/remote/repository.dart';
import 'package:delivery_basket/generated/l10n.dart';
import 'package:delivery_basket/screens/all_products/all_products_view.dart';
import 'package:delivery_basket/screens/component/notification_button_view.dart';
import 'package:delivery_basket/screens/home/tabs/store/basket_banner_view.dart';
import 'package:delivery_basket/screens/home/tabs/store/home_explore_category_view.dart';
import 'package:delivery_basket/screens/home/tabs/store/home_products_view.dart';
import 'package:delivery_basket/screens/home/tabs/store/home_taodays_offer_view.dart';
import 'package:delivery_basket/screens/home/tabs/store/model/product_response.dart';
import 'package:delivery_basket/screens/home/widget/basket_search_view.dart';
import 'package:delivery_basket/screens/home/widget/cart_bottom_bar_view.dart';
import 'package:delivery_basket/screens/home/widget/drawer_view.dart';
import 'package:delivery_basket/screens/home/widget/ic_menu_button.dart';
import 'package:delivery_basket/screens/home/widget/product_item_view_small.dart';
import 'package:google_fonts/google_fonts.dart';

class StoreTabView extends StatefulWidget {
  @override
  _StoreTabViewState createState() => _StoreTabViewState();
}

class _StoreTabViewState extends State<StoreTabView> {
  Repository? _repository;
  List<ProductResponseDataProdcutData?>? products = [];
  ProductResponse? productResponse;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoading = false;
  String username = "";
  bool isUserlogin = false;
  bool isScrollingDown = false;
  int count = 0;

  ScrollController? _scrollController;
  double? _scrollPosition;
  String allProducts = "";
  String morning = "";
  String afternoon = "";
  String evening = "";
  String hello = "";
  String user = "";
  String good = "";

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController?.position.pixels;
      if (_scrollController?.position.pixels ==
          _scrollController?.position.maxScrollExtent) {
        if ((productResponse?.data?.prodcut?.lastPage ?? 0) >
            (productResponse?.data?.prodcut?.currentPage ?? 0)) {
          fetchProductList(
              (productResponse?.data?.prodcut?.currentPage ?? 1) + 1);
        }
      }
    });
  }

  init() async {
    allProducts = await getI18n("allProducts");
    morning = await getI18n("morning");
    afternoon = await getI18n("afternoon");
    evening = await getI18n("evening");
    hello = await getI18n("hello");
    user = await getI18n("user");
    good = await getI18n("good");
    setState(() {});
  }

  fetchProductList(int page) async {
    var map = Map<String, String>();
    map['page'] = "${page}";
    try {
      ProductResponse? response =
          await _repository?.fetchProductList(context, map);
      if (response?.success ?? false) {
        setState(() {
          productResponse = response;
          products?.addAll(response!.data!.prodcut!.data!);
        });
      }
    } catch (e) {
      print("error: ${e.toString()}");

      print(e);
    }
  }

  @override
  void initState() {
    init();
    _scrollController = ScrollController();
    _scrollController?.addListener(_scrollListener);
    super.initState();
    _repository = Repository();
    fetchProductList(1);
    getUserDetails();
  }

  void getUserDetails() async {
    String tname = await getUserName();
    bool? tlogin = await getLogin();
    setState(() {
      username = tname;
      isUserlogin = tlogin!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: appBar(),
      body: Column(
        children: [
          BasketSearchView(
            isEnable: false,
          ),
          Flexible(
            child: ListView(
              controller: _scrollController,
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              children: [
                HomeExploreCategoryView(),
                BasketBannerView(),
                HomeTodaysOfferView(),
                homePorduct()
              ],
            ),
          ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: CartBottomBarView(),
          // )
        ],
      ),
      drawer: DrawerView(),
    );
  }

  Widget homePorduct() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  allProducts,
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          NotificationListener(
            onNotification: (scrollNotification) {
              print('inside the onNotification');
              if (_scrollController?.position.userScrollDirection ==
                  ScrollDirection.reverse) {
                print('scrolled down');
                setState(() {
                  isScrollingDown = true;
                });
              } else if (_scrollController?.position.userScrollDirection ==
                  ScrollDirection.forward) {
                setState(() {
                  isScrollingDown = false;
                });
              }
              return true;
            },
            child: GridView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                itemCount: products?.length ?? 0,
                itemBuilder: (context, index) {
                  var product = products?[index];
                  return ProductItemViewSmall(
                    product: product,
                  );
                }),
          )
        ],
      ),
    );
  }

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return morning;
    }
    if (hour < 17) {
      return afternoon;
    }
    return evening;
  }

  PreferredSize appBar() {
    return PreferredSize(
      preferredSize: Size(MediaQuery.of(context).size.width, 56),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            MenuButton(
              onClick: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${hello} ${isUserlogin ? username : user}",
                    style: GoogleFonts.getFont(
                      'Lato',
                      color: Color(0xFF222B45),
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text("${good} ${greeting()}...!")
                ],
              ),
            ),
            NotificationButtonView(
              count: count,
            ),
          ],
        ),
      ),
    );
  }
}
