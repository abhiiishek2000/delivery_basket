import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:delivery_basket/data/AppNotifer.dart';
import 'package:delivery_basket/data/local/DBProvider.dart';
import 'package:delivery_basket/data/local/model/CartModel.dart';
import 'package:delivery_basket/data/local/shared_pref.dart';
import 'package:delivery_basket/data/remote/model/cart/cart_update_response.dart';
import 'package:delivery_basket/data/remote/repository.dart';
import 'package:delivery_basket/screens/home/tabs/product_details/product_rating_view.dart';
import 'package:delivery_basket/screens/home/tabs/product_details/smililar_prouduct_view.dart';
import 'package:delivery_basket/screens/home/tabs/store/model/product_response.dart';

class ProductDetailsExtraView extends StatefulWidget {
  final ProductResponseDataProdcutData product;

  const ProductDetailsExtraView({Key? key, required this.product})
      : super(key: key);
  @override
  _ProductDetailsExtraViewState createState() =>
      _ProductDetailsExtraViewState();
}

class _ProductDetailsExtraViewState extends State<ProductDetailsExtraView> {
  int quantity = 0;
  bool isLoading = false;
  Repository? _repository;
  bool? isUserLogin = false;

  String strcartUpdated = "";
  String strweight = "";
  String stroutofStock = "";
  String straddToCart = "";
  String strSafe = "";
  String strQuality = "";
  String strfresh = "";

  init() async {
    strcartUpdated = await getI18n("cartUpdated");
    strweight = await getI18n("weight");
    stroutofStock = await getI18n("outOfStock");
    straddToCart = await getI18n("addToCart");
    strSafe = await getI18n("safe");
    strQuality = await getI18n("quality");
    strfresh = await getI18n("fresh");
    setState(() {});
  }

  @override
  void initState() {
    init();
    super.initState();
    _repository = Repository();
    getQuantity();
  }

  void getQuantity() async {
    isUserLogin = await getLogin();
    Cart? carts =
        await DBProvider.db.getCartByProductId(widget.product.id ?? 0);
    setState(() {
      quantity = carts?.quantity ?? 0;
    });
  }

  cartLiveUpdate(String operation) async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    map['product_id'] = "${widget.product.id ?? ""}";
    map['quantity'] = "${quantity}";
    try {
      CartUpdateResponse? response =
          await _repository?.cartUpdate(context, map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        Fluttertoast.showToast(msg: strcartUpdated);
        if (operation == "+" && quantity == 1) {
          Provider.of<CheckOutNotifier>(context, listen: false).cartIncrement();
        } else if (operation == "-" && quantity == 0) {
          Provider.of<CheckOutNotifier>(context, listen: false).cartDecrement();
        }
      }
    } catch (e) {
      print("error: ${e.toString()}");
      if (operation == "+") {
        quantity = quantity - 1;
      } else if (operation == "-") {
        quantity = quantity + 1;
      }
      await DBProvider.db.updateCart(Cart(
          id: widget.product.id ?? 0,
          prodId: widget.product.id ?? 0,
          name: widget.product.name ?? "",
          quantity: quantity));
      setState(() {});
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          SizedBox(
            height: 16,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Center(
                    child: Text(
                        "${widget.product.productName?.name != null ? widget.product.productName?.name : widget.product.name}",
                        style: GoogleFonts.getFont(
                          'Lato',
                          color: Color(0xFF000000),
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ))),
                // Positioned(
                //     right: 0, top: 0, bottom: 0, child: ProductRatingView()),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          RichText(
            text: TextSpan(
              text: "₹${widget.product.productSinglePrice?.sPrice} ",
              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                  color: Color(0xffA3CC39),
                  fontWeight: FontWeight.w700,
                  fontSize: 17),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          if (((widget.product.stock == 0) ||
                  (double.parse(widget.product.storeStock?.quantity ?? "0") ==
                      0)) ||
              (double.parse(widget.product.storeStock?.quantity ?? "0") <=
                  quantity)) ...[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  4,
                ),
              ),
              child: Center(
                  child: Text(
                "$stroutofStock",
                style: Theme.of(context).textTheme.subtitle1,
              )),
            )
          ] else ...[
            if (quantity != 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () async {
                        if (isUserLogin ?? false) {
                          quantity = quantity - 1;
                          await DBProvider.db.updateCart(Cart(
                              id: widget.product.id ?? 0,
                              prodId: widget.product.id ?? 0,
                              name: widget.product.name ?? "",
                              quantity: quantity));
                          setState(() {});
                          cartLiveUpdate("-");
                        } else {
                          quantity = quantity - 1;
                          await DBProvider.db.updateCart(Cart(
                              id: widget.product.id ?? 0,
                              prodId: widget.product.id ?? 0,
                              name: widget.product.name ?? "",
                              quantity: quantity));
                          setState(() {});
                          Fluttertoast.showToast(msg: strcartUpdated);
                        }
                      },
                      icon:
                          SvgPicture.asset("assets/images/ic_cart_minus.svg")),
                  Text(
                    "${quantity}",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  IconButton(
                      onPressed: () async {
                        if (isUserLogin ?? false) {
                          quantity = quantity + 1;
                          await DBProvider.db.updateCart(Cart(
                              id: widget.product.id ?? 0,
                              prodId: widget.product.id ?? 0,
                              name: widget.product.name ?? "",
                              quantity: quantity));
                          setState(() {});
                          cartLiveUpdate("+");
                        } else {
                          quantity = quantity + 1;
                          await DBProvider.db.updateCart(Cart(
                              id: widget.product.id ?? 0,
                              prodId: widget.product.id ?? 0,
                              name: widget.product.name ?? "",
                              quantity: quantity));
                          setState(() {});
                          Fluttertoast.showToast(msg: strcartUpdated);
                        }
                      },
                      icon: SvgPicture.asset("assets/images/ic_cart_plus.svg")),
                ],
              )
            else
              Container(),
            SizedBox(
              height: 8,
            ),
            quantity == 0
                ? CupertinoButton(
                    child: Text(
                      straddToCart,
                      style: TextStyle(color: Color(0xff323232)),
                    ),
                    onPressed: () async {
                      if (isUserLogin ?? false) {
                        quantity = quantity + 1;
                        await DBProvider.db.newCart(Cart(
                            id: widget.product.id ?? 0,
                            prodId: widget.product.id ?? 0,
                            name: widget.product.name ?? "",
                            quantity: quantity));
                        setState(() {});
                        cartLiveUpdate("+");
                      } else {
                        quantity = quantity + 1;
                        await DBProvider.db.newCart(Cart(
                            id: widget.product.id ?? 0,
                            prodId: widget.product.id ?? 0,
                            name: widget.product.name ?? "",
                            quantity: quantity));
                        setState(() {});
                        Fluttertoast.showToast(msg: "Cart Updated");
                      }
                    },
                    color: Color(0xffA3CC39),
                  )
                : Container(),
          ],
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              productExtra(strSafe, "assets/images/ic_safe.svg"),
              productExtra(strQuality, "assets/images/ic_quality.svg"),
              productExtra(strfresh, "assets/images/ic_fresh.svg"),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Html(
              data: widget.product.productName?.descripation != null
                  ? widget.product.productName?.descripation
                  : widget.product.description,
            ),
          ),
          SimillarProductView(
            parentProdcut: widget.product,
          )
        ],
      ),
    );
  }

  Widget productExtra(String title, String image) {
    return Row(
      children: [
        Row(
          children: [
            SvgPicture.asset(
              image,
              color: Color(0xff64BA02),
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.subtitle1,
            )
          ],
        )
      ],
    );
  }
}
