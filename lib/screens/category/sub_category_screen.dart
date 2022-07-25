import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:delivery_basket/constants.dart';
import 'package:delivery_basket/data/AppNotifer.dart';
import 'package:delivery_basket/data/local/shared_pref.dart';
import 'package:delivery_basket/data/remote/model/subcategory/sub_category_response.dart';
import 'package:delivery_basket/data/remote/repository.dart';
import 'package:delivery_basket/screens/home/home_screen.dart';
import 'package:delivery_basket/screens/home/tabs/store/model/category_response.dart';
import 'package:delivery_basket/screens/products/products_filter_screen.dart';

class SubCategoryScreen extends StatefulWidget {
  final CategoryResponseDataCategory subcategory;

  const SubCategoryScreen({Key? key, required this.subcategory})
      : super(key: key);

  @override
  _SubCategoryScreenState createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  bool isLoading = false;
  Repository? _repository;
  List<SubCategoryResponseDataSubCategory?>? subCategoryList = [];
  int _currentIndex = 0;
  CheckOutNotifier? checkOutNotifier;
  int cart = 0;

  String store = "";
  String strCart = "";
  String offers = "";
  String wishlist = "";
  String strsubCategoryNotAvailable = "";
  String strviewAllProductsIn = "";

  init() async {
    store = await getI18n("store");
    strCart = await getI18n("cart");
    offers = await getI18n("offers");
    wishlist = await getI18n("wishlist");
    strsubCategoryNotAvailable = await getI18n("subCategoryNotAvailable");
    strviewAllProductsIn = await getI18n("viewAllProductsIn");
    setState(() {});
  }

  @override
  void initState() {
    init();
    super.initState();
    _repository = Repository();
    fetchSubCategoryList();
    checkOutNotifier = Provider.of<CheckOutNotifier>(context, listen: false);
    setState(() {
      cart = checkOutNotifier?.cartCount ?? 0;
    });
    checkOutNotifier?.addListener(() {
      setState(() {
        cart = checkOutNotifier?.cartCount ?? 0;
      });
    });
  }

  fetchSubCategoryList() async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    map['category_id'] = "${widget.subcategory.id}";
    try {
      SubCategoryResponse? response =
          await _repository?.fetchSubCategory(context, map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        setState(() {
          subCategoryList?.addAll(response!.data!.subCategory!);
        });
      } else {}
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
        body: subCategoryList?.length == 0
            ? Center(
                child: Text(
                  strsubCategoryNotAvailable,
                  style: Theme.of(context).textTheme.headline6,
                ),
              )
            : ListView(
                shrinkWrap: true,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                    margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: ListTile(
                      leading: Image.network(
                          "$ImageBaseUrlTest${widget.subcategory.image}"),
                      title: Text(
                          "$strviewAllProductsIn ${widget.subcategory.categoryName != null ? widget.subcategory.categoryName?.name : widget.subcategory.name}"),
                      trailing: Icon(Icons.arrow_forward_ios_outlined),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductsFilterScreen(
                                      category: widget.subcategory,
                                    )));
                      },
                    ),
                  ),
                  GridView.builder(
                      itemCount: subCategoryList?.length,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        SubCategoryResponseDataSubCategory? subCategory =
                            subCategoryList?[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductsFilterScreen(
                                          subCategory: subCategory,
                                          category: widget.subcategory,
                                        )));
                          },
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                            margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: Offset(
                                      0, 1), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Image.network(
                                    "$ImageBaseUrlTest${subCategory?.image}",
                                    height: 110),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "${subCategory?.subCategoryName != null ? subCategory?.subCategoryName?.name : subCategory?.name}",
                                  style: Theme.of(context).textTheme.subtitle2,
                                )
                              ],
                            ),
                          ),
                        );
                      })
                ],
              ),
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: kPrimaryColor,
            selectedIconTheme: IconThemeData(
              color: kPrimaryColor,
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
                  color: _currentIndex == 0 ? Color(0xff38ab00) : Colors.black,
                ),
              ),
              BottomNavigationBarItem(
                  label: strCart,
                  icon: new Stack(
                    children: <Widget>[
                      new SvgPicture.asset(
                        "assets/images/ic_cart.svg",
                        color: _currentIndex == 1
                            ? Color(0xff38ab00)
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
                  color: _currentIndex == 2 ? Color(0xff38ab00) : Colors.black,
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
                "${widget.subcategory.categoryName != null ? widget.subcategory.categoryName?.name ?? "" : widget.subcategory.name ?? ""}",
                style: GoogleFonts.getFont(
                  'Lato',
                  color: Color(0xFF000000),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
