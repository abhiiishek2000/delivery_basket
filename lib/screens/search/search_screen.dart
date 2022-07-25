//import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:delivery_basket/data/local/DBProvider.dart';
import 'package:delivery_basket/data/local/model/recent_search_model.dart';
import 'package:delivery_basket/data/local/shared_pref.dart';
import 'package:delivery_basket/data/remote/repository.dart';
import 'package:delivery_basket/screens/home/home_screen.dart';
import 'package:delivery_basket/screens/home/tabs/store/model/product_response.dart';
import 'package:delivery_basket/screens/home/widget/ic_menu_button.dart';
import 'package:delivery_basket/screens/home/widget/product_item_view_small.dart';

import '../../constants.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  //static final facebookAppEvents = FacebookAppEvents();
  Repository? _repository;
  TextEditingController search = TextEditingController();
  bool isLoading = false;
  bool recentSearchShow = true;
  List<ProductResponseDataProdcutData?>? products = [];
  List<String> popularList = [];
  List<RecentSearch> recentSearchList = [];
  int _currentIndex = 0;

  String strSearch = "";
  String strrecentSearch = "";
  String strpopularSearch = "";
  String strproductNotAvailable = "";
  String store = "";
  String strCart = "";
  String offers = "";
  String wishlist = "";
  String strallProducts = "";

  init() async {
    strSearch = await getI18n("search");
    strrecentSearch = await getI18n("recentSearch");
    strpopularSearch = await getI18n("popularSearch");
    strproductNotAvailable = await getI18n("productNotAvailable");
    store = await getI18n("store");
    strCart = await getI18n("cart");
    offers = await getI18n("offers");
    wishlist = await getI18n("wishlist");
    strallProducts = await getI18n("allProducts");
    setState(() {});
  }

  fetchSearchList(String name) async {
    setState(() {
      products = [];
      isLoading = true;
      recentSearchShow = false;
    });
    var map = Map<String, String>();
    map['search_name'] = name;
    try {
      ProductResponse? response =
          await _repository?.fetchProductSearchList(context, map);
      if (response?.success ?? false) {
        setState(() {
          products?.addAll(response!.data!.prodcut!.data!);
        });
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("error: ${e.toString()}");

      print(e);
    }
  }

  void getRecentSearch() async {
    await DBProvider.db.deleteSearchExceptLast();
    List<RecentSearch> tempList = await DBProvider.db.getAllRecentSearch();
    print("recent search list --- ${tempList.map((e) => e.keyword).toList()}");

    List<String> tempPopularSearch = await getPopularSearch();

    setState(() {
      recentSearchList = [];
      popularList = [];
      recentSearchList.addAll(tempList);
      popularList.addAll(tempPopularSearch);
    });
  }

  @override
  void initState() {
    init();
    super.initState();
    _repository = Repository();
    getRecentSearch();
    //facebookAppEvents.logEvent(name: 'search', parameters: {'status': 'search_screen_open',},);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar(),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xffF7F7F7),
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Color(0x10000000),
                                blurRadius: 6,
                                offset: Offset(0, 2))
                          ]),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextFormField(
                        controller: search,
                        autofocus: true,
                        keyboardType: TextInputType.name,
                        onChanged: (value) {
                          if (value.length > 3) {
                            fetchSearchList(value);
                          }
                        },
                        decoration: InputDecoration(
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: InkWell(
                              onTap: () async {
                                if (search.text.length >= 3) {
                                  if (search.text.isNotEmpty) {
                                    await DBProvider.db.newRecentSearchAdd(
                                        search.text,
                                        DateTime.now().millisecond.toString());
                                    fetchSearchList(search.text);
                                  }
                                }
                              },
                              child: SvgPicture.asset(
                                "assets/images/search.svg",
                              ),
                            ),
                          ),
                          hintText: "$strSearch...",
                          hintStyle: TextStyle(color: Color(0xffD2D2D2)),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            recentSearchShow
                ? Expanded(child: recentSearchView())
                : isLoading
                    ? Expanded(
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: 2,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: double.infinity,
                                  height: 60,
                                  color: Colors.white,
                                );
                              }),
                        ),
                      )
                    : products?.length == 0
                        ? Center(
                            child: Text(strproductNotAvailable),
                          )
                        : Expanded(
                            child: ListView.separated(
                                shrinkWrap: true,
                                separatorBuilder: (context, index) {
                                  return Container(
                                    height: 1,
                                    width: MediaQuery.of(context).size.width,
                                    color: Color(0xffF4F4F4),
                                  );
                                },
                                itemCount: products?.length ?? 0,
                                physics: AlwaysScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  var product = products?[index];
                                  return ProductItemViewSmall(
                                    product: product,
                                  );
                                }),
                          )
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
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
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeScreen(
                          currentPage: value,
                        )),
                (route) => false);
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
              icon: SvgPicture.asset(
                "assets/images/ic_cart.svg",
                color: _currentIndex == 1 ? Color(0xffA3CC39) : Colors.black,
              ),
            ),
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
                color: _currentIndex == 3 ? Color(0xff38ab00) : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget recentSearchView() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (recentSearchList.length != 0) ...[
            Text(
              strrecentSearch,
              style: Theme.of(context).textTheme.subtitle2,
            ),
            SizedBox(
              height: 8,
            ),
            Wrap(
              spacing: 8.0, // gap between adjacent chips
              runSpacing: 4.0, // gap between lines
              children: <Widget>[...generate_recent_tags()],
            ),
          ],
          SizedBox(
            height: 16,
          ),
          Text(
            strpopularSearch,
            style: Theme.of(context).textTheme.subtitle2,
          ),
          SizedBox(
            height: 8,
          ),
          Wrap(
            spacing: 8.0, // gap between adjacent chips
            runSpacing: 4.0, // gap between lines
            children: <Widget>[...generate_tags()],
          )
        ],
      ),
    );
  }

  generate_recent_tags() {
    return recentSearchList.map((tag) => get_chip(tag.keyword)).toList();
  }

  generate_tags() {
    return popularList.map((tag) => get_chip(tag)).toList();
  }

  get_chip(name) {
    return FilterChip(
      selectedColor: Colors.blue.shade800,
      disabledColor: Colors.blue.shade400,
      labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      label: Text(
        "○ ${name}",
        style: TextStyle(color: Colors.black),
      ),
      onSelected: (bool value) {
        setState(() {
          search.text = name;
        });
        fetchSearchList(search.text);
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
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                    (route) => false);
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
                strSearch,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
