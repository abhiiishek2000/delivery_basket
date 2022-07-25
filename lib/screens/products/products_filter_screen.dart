import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:delivery_basket/data/AppNotifer.dart';
import 'package:delivery_basket/data/local/shared_pref.dart';
import 'package:delivery_basket/data/remote/model/subcategory/sub_category_response.dart';
import 'package:delivery_basket/data/remote/repository.dart';
import 'package:delivery_basket/screens/home/home_screen.dart';
import 'package:delivery_basket/screens/home/tabs/store/model/category_response.dart';
import 'package:delivery_basket/screens/home/tabs/store/model/product_response.dart';
import 'package:delivery_basket/screens/home/widget/product_item_view_small.dart';

import '../../constants.dart';

class ProductsFilterScreen extends StatefulWidget {
  final CategoryResponseDataCategory? category;
  final SubCategoryResponseDataSubCategory? subCategory;

  const ProductsFilterScreen({Key? key, this.category, this.subCategory})
      : super(key: key);

  @override
  _ProductsFilterScreenState createState() => _ProductsFilterScreenState();
}

class _ProductsFilterScreenState extends State<ProductsFilterScreen> {
  bool isLoading = false;
  Repository? _repository;
  List<ProductResponseDataProdcutData?>? products = [];
  ProductResponse? productResponse;
  ScrollController? _scrollController;
  double? _scrollPosition;
  String headerTitle = "";
  int _currentIndex = 0;
  CheckOutNotifier? checkOutNotifier;
  int cart = 0;

  String store = "";
  String strCart = "";
  String offers = "";
  String wishlist = "";
  String strallProducts = "";

  init() async {
    store = await getI18n("store");
    strCart = await getI18n("cart");
    offers = await getI18n("offers");
    wishlist = await getI18n("wishlist");
    strallProducts = await getI18n("allProducts");
    setState(() {});
  }

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

  @override
  void initState() {
    init();
    super.initState();
    checkOutNotifier = Provider.of<CheckOutNotifier>(context, listen: false);
    setState(() {
      cart = checkOutNotifier?.cartCount ?? 0;
    });
    checkOutNotifier?.addListener(() {
      setState(() {
        cart = checkOutNotifier?.cartCount ?? 0;
      });
    });
    setState(() {
      if (widget.category != null && widget.subCategory != null) {
        headerTitle =
            "${widget.category?.categoryName != null ? widget.category?.categoryName?.name : widget.category?.name} >"
            " ${widget.subCategory?.subCategoryName != null ? widget.subCategory?.subCategoryName?.name : widget.subCategory?.name}";
      } else if (widget.category != null) {
        headerTitle =
            "${widget.category?.categoryName != null ? widget.category?.categoryName?.name : widget.category?.name}";
      } else if (widget.subCategory != null) {
        headerTitle =
            "${widget.subCategory?.subCategoryName != null ? widget.subCategory?.subCategoryName?.name : widget.subCategory?.name}";
      } else {
        headerTitle = strallProducts;
      }
    });

    _scrollController = ScrollController();
    _scrollController?.addListener(_scrollListener);
    _repository = Repository();
    fetchProductList(1);
  }

  fetchProductList(int page) async {
    var map = Map<String, String>();
    map['page'] = "${page}";

    map['sub_category_id'] =
        "${widget.subCategory != null ? widget.subCategory?.id : ""}";
    map['category_id'] =
        "${widget.category != null ? widget.category?.id : ""}";
    try {
      ProductResponse? response =
          await _repository?.fetchProductFilter(context, map);
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar(),
        body: ListView(
          shrinkWrap: true,
          controller: _scrollController,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Text(
                strallProducts,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            NotificationListener(
              onNotification: (scrollNotification) {
                print('inside the onNotification');
                if (_scrollController?.position.userScrollDirection ==
                    ScrollDirection.reverse) {
                  print('scrolled down');
                  if ((productResponse?.data?.prodcut?.lastPage ?? 0) >
                      (productResponse?.data?.prodcut?.currentPage ?? 0)) {
                    fetchProductList(
                        (productResponse?.data?.prodcut?.currentPage ?? 1) + 1);
                  }
                } else if (_scrollController?.position.userScrollDirection ==
                    ScrollDirection.forward) {
                  print('scrolled up');
                  //setState function
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(
                            currentPage: value,
                          )));
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
      child: Container(
        color: Color(0xff0000ffff),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
                child: Text("${headerTitle}",
                    style: GoogleFonts.getFont(
                      'Lato',
                      color: Color(0xFF000000),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
