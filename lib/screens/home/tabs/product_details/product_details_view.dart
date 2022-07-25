import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:delivery_basket/data/AppNotifer.dart';
import 'package:delivery_basket/data/local/shared_pref.dart';
import 'package:delivery_basket/screens/home/home_screen.dart';
import 'package:delivery_basket/screens/home/tabs/product_details/product_details_extra_view.dart';
import 'package:delivery_basket/screens/home/tabs/product_details/prouduct_image.dart';
import 'package:delivery_basket/screens/home/tabs/store/model/product_response.dart';
import 'package:delivery_basket/screens/home/widget/ic_menu_button.dart';

import '../../../../constants.dart';

class ProductDetailsView extends StatefulWidget {
  final ProductResponseDataProdcutData product;

  const ProductDetailsView({Key? key, required this.product}) : super(key: key);
  @override
  _ProductDetailsViewState createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  int _currentIndex = 0;
  CheckOutNotifier? checkOutNotifier;
  int cart = 0;
  String store = "";
  String strCart = "";
  String offers = "";
  String wishlist = "";

  init() async {
    store = await getI18n("store");
    strCart = await getI18n("cart");
    offers = await getI18n("offers");
    wishlist = await getI18n("wishlist");
    setState(() {});
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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ProductImageView(
                product: widget.product,
              ),
              ProductDetailsExtraView(
                product: widget.product,
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
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
                color: _currentIndex == 0 ? kPrimaryColor : Colors.black,
              ),
            ),
            BottomNavigationBarItem(
                label: strCart,
                icon: new Stack(
                  children: <Widget>[
                    new SvgPicture.asset(
                      "assets/images/ic_cart.svg",
                      color: _currentIndex == 1 ? kPrimaryColor : Colors.black,
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
                color: _currentIndex == 2 ? kPrimaryColor : Colors.black,
              ),
            ),
            BottomNavigationBarItem(
              label: wishlist,
              icon: SvgPicture.asset(
                "assets/images/ic_wishlist.svg",
                color: _currentIndex == 3 ? kPrimaryColor : Colors.black,
              ),
            ),
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
                "${widget.product.productName?.name != null ? widget.product.productName?.name : widget.product.name}",
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
