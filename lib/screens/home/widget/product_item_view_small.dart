//import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';
import 'package:delivery_basket/LanguageChangeProvider.dart';
import 'package:delivery_basket/constants.dart';
import 'package:delivery_basket/data/AppNotifer.dart';
import 'package:delivery_basket/data/local/DBProvider.dart';
import 'package:delivery_basket/data/local/model/CartModel.dart';
import 'package:delivery_basket/data/local/shared_pref.dart';
import 'package:delivery_basket/data/remote/model/cart/cart_update_response.dart';
import 'package:delivery_basket/data/remote/model/wishlist/WishUpdateResponse.dart';
import 'package:delivery_basket/data/remote/repository.dart';
import 'package:delivery_basket/generated/l10n.dart';
import 'package:delivery_basket/screens/component/basket_image_view.dart';
import 'package:delivery_basket/screens/home/tabs/store/model/product_response.dart';
import 'package:delivery_basket/screens/home/tabs/product_details/product_details_view.dart';
import 'package:delivery_basket/screens/home/widget/login_alert_view.dart';

class ProductItemViewSmall extends StatefulWidget {
  final ProductResponseDataProdcutData? product;
  final bool isShortView;
  final bool isFilterScreen;

  ProductItemViewSmall(
      {Key? key,
      this.product,
      this.isShortView = false,
      this.isFilterScreen = false})
      : super(key: key);

  @override
  _ProductItemViewSmallState createState() => _ProductItemViewSmallState();
}

class _ProductItemViewSmallState extends State<ProductItemViewSmall> {
  //static final facebookAppEvents = FacebookAppEvents();
  ProductResponseDataProdcutData? product;
  Repository? _repository;
  int quantity = 0;
  bool isLoading = false;
  bool? isUserLogin = false;
  bool isWish = false;
  String tagLine = "";
  String productName = "";
  final translator = GoogleTranslator();

  String strweight = "";
  String stroutofStock = "";
  String strVidharbha = "";
  String strAdd = "";

  init() async {
    strweight = await getI18n("weight");
    stroutofStock = await getI18n("outOfStock");
    strVidharbha = await getI18n("vidarbhaBasket");
    strAdd = await getI18n("add");
    setState(() {});
  }

  @override
  void initState() {
    init();
    super.initState();
    _repository = Repository();
    setState(() {
      product = widget.product;
    });

    initData();
  }

  void initData() async {
    isUserLogin = await getLogin();
    tagLine = await getTagLine();
    Cart? cart = await DBProvider.db.getCartByProductId(product?.id ?? 0);
    setState(() {
      quantity = cart?.quantity ?? 0;
      isWish = product?.wish != null ? true : false;
    });

    productName = product?.productName != null
        ? product?.productName?.name ?? ""
        : product?.name ?? "";
    setState(() {});
  }

  wishItemAdd() async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    map['product_id'] = "${widget.product?.id}";
    try {
      WishUpdateResponse? response =
          await _repository?.wishListAdd(context, map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        setState(() {
          isWish = true;
          WishUpdateResponseDataWish? data = response?.data?.wish?.first;
          product?.wish = ProductResponseDataProdcutDataWish(
            id: data?.id,
            userId: data?.userId,
            productId: data?.productId,
          );
        });
        // facebookAppEvents.logEvent(
        //   name: 'product_wish_list_add',
        //   parameters: {
        //     'added': 'added',
        //   },
        // );
        Fluttertoast.showToast(msg: "added to wish list");
      } else {
        Fluttertoast.showToast(msg: "failed to add wish list");
        // facebookAppEvents.logEvent(
        //   name: 'product_wish_list_add',
        //   parameters: {
        //     'failed': 'failed',
        //   },
        // );
      }
    } catch (e) {
      print("error: ${e.toString()}");
      // facebookAppEvents.logEvent(
      //   name: 'product_wish_list_add',
      //   parameters: {
      //     'failed': 'failed',
      //   },
      // );
      print(e);
    }
  }

  wishItemRemove() async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    map['wish_id[0]'] = "${widget.product?.wish?.id}";
    try {
      WishUpdateResponse? response =
          await _repository?.wishListDelete(context, map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        setState(() {
          isWish = false;
          product?.wish = null;
        });
        Fluttertoast.showToast(msg: "removed from wish list");
      } else {
        Fluttertoast.showToast(msg: "failed to remove wish list");
      }
    } catch (e) {
      print("error: ${e.toString()}");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    double? percentOffer =
        ((double.parse(product?.productSinglePrice?.price ?? "0.0") -
                double.parse(product?.productSinglePrice?.sPrice ?? "0.0")) /
            double.parse(product?.productSinglePrice?.price ?? "0.0") *
            100);
    //print("offers ${percentOffer}");
    return Stack(
      children: [
        InkWell(
          onTap: () async {
            var data = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProductDetailsView(
                          product: product!,
                        )));
            initData();
          },
          child: widget.isShortView
              ? Container(
                  width: MediaQuery.of(context).size.width / 2 - 16,
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      border: Border.all(color: Color(0xffFCFCFC)),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0xffEEEEEE),
                            offset: Offset(1.0, 1.0),
                            blurRadius: 3.0)
                      ]),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xfffaf7f2),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12))),
                        child: Stack(
                          children: [
                            Center(
                              child: BasketImageView(
                                url: "$ImageBaseUrlTest${product?.pImage}",
                                width: 120,
                                height: 120,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Align(
                                alignment: Alignment.topRight,
                                child: InkWell(
                                  onTap: () {
                                    if (isLoading == false) {
                                      if (isUserLogin == true) {
                                        if (isWish) {
                                          wishItemRemove();
                                        } else {
                                          wishItemAdd();
                                        }
                                      } else {
                                        loginAlertShow(context);
                                      }
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: isWish
                                        ? Icon(
                                            Icons.favorite,
                                            color: Color(0xffFF1414),
                                          )
                                        : Icon(
                                            Icons.favorite_outline,
                                            color: Colors.grey,
                                          ),
                                  ),
                                ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "$productName",
                                style: GoogleFonts.getFont(
                                  'Open Sans',
                                  color: Color(0xFF222B45),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.left,
                                maxLines: 2,
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "$strweight ${product?.weight} ${product?.unit}",
                                  style: GoogleFonts.getFont(
                                    'Open Sans',
                                    color: Color(0xFF8f8f8f),
                                    fontSize: 10,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              width: double.infinity,
                              child: Stack(
                                children: [
                                  Positioned(
                                      top: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: quantity == 0
                                          ? InkWell(
                                              onTap: () async {
                                                if (isLoading == false &&
                                                    double.parse(product
                                                                ?.productSinglePrice
                                                                ?.sPrice ??
                                                            "0.0") >
                                                        0) {
                                                  if (isUserLogin ?? false) {
                                                    quantity = quantity + 1;
                                                    await DBProvider.db.newCart(
                                                        Cart(
                                                            id: product?.id ??
                                                                0,
                                                            prodId:
                                                                product?.id ??
                                                                    0,
                                                            name: productName,
                                                            quantity:
                                                                quantity));
                                                    setState(() {});
                                                    cartLiveUpdate("+");
                                                  } else {
                                                    quantity = quantity + 1;
                                                    await DBProvider.db.newCart(
                                                        Cart(
                                                            id: product?.id ??
                                                                0,
                                                            prodId:
                                                                product?.id ??
                                                                    0,
                                                            name: productName,
                                                            quantity:
                                                                quantity));
                                                    setState(() {});
                                                  }
                                                }
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                    color: Color(0xffA3CC39),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Color(
                                                                  0xff37AB01)
                                                              .withOpacity(0.3))
                                                    ]),
                                                child: SvgPicture.asset(
                                                  "assets/images/ic_cart_small.svg",
                                                  height: 20,
                                                  width: 20,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            )
                                          : cartItem()),
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    bottom: 0,
                                    child: RichText(
                                      text: TextSpan(
                                        text:
                                            "₹${product?.productSinglePrice?.sPrice} \n",
                                        style: GoogleFonts.getFont(
                                          'Lato',
                                          color: Color(0xFFA3CC39),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        children: [
                                          TextSpan(
                                              text:
                                                  "${product?.productSinglePrice?.price}",
                                              style: GoogleFonts.getFont('Lato',
                                                  color: Color(0xFF8f8f8f),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  decoration: TextDecoration
                                                      .lineThrough)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 36,
                                  ),
                                  Positioned(
                                      right: 0,
                                      top: 0,
                                      bottom: 0,
                                      child: ((product?.stock == 0) ||
                                                  (double.parse(product
                                                              ?.storeStock
                                                              ?.quantity ??
                                                          "0") ==
                                                      0)) ||
                                              (double.parse(product?.storeStock
                                                          ?.quantity ??
                                                      "0") <=
                                                  quantity)
                                          ? Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 3),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    4,
                                                  ),
                                                  color: kPrimaryColor),
                                              child: Center(
                                                  child: Text(
                                                stroutofStock,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                            )
                                          : Container())
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  width: MediaQuery.of(context).size.width / 2 - 16,
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      border: Border.all(color: Color(0xffFCFCFC)),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0xffEEEEEE),
                            offset: Offset(1.0, 1.0),
                            blurRadius: 3.0)
                      ]),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xfffaf7f2),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12))),
                        child: Stack(
                          children: [
                            Center(
                              child: BasketImageView(
                                url: "$ImageBaseUrlTest${product?.pImage}",
                                width: 120,
                                height: 120,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Align(
                                alignment: Alignment.topRight,
                                child: InkWell(
                                  onTap: () {
                                    if (isLoading == false) {
                                      if (isUserLogin == true) {
                                        if (isWish) {
                                          wishItemRemove();
                                        } else {
                                          wishItemAdd();
                                        }
                                      } else {
                                        loginAlertShow(context);
                                      }
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: isWish
                                        ? Icon(
                                            Icons.favorite,
                                            color: Color(0xffFF1414),
                                          )
                                        : Icon(
                                            Icons.favorite_outline,
                                            color: Colors.grey,
                                          ),
                                  ),
                                ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "$productName",
                                style: GoogleFonts.getFont(
                                  'Open Sans',
                                  color: Color(0xFF222B45),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.left,
                                maxLines: 2,
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "$strweight ${product?.weight} ${product?.unit}",
                                  style: GoogleFonts.getFont(
                                    'Open Sans',
                                    color: Color(0xFF8f8f8f),
                                    fontSize: 10,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              width: double.infinity,
                              child: Stack(
                                children: [
                                  Positioned(
                                      top: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: quantity == 0
                                          ? InkWell(
                                              onTap: () async {
                                                if (isLoading == false &&
                                                    double.parse(product
                                                                ?.productSinglePrice
                                                                ?.sPrice ??
                                                            "0.0") >
                                                        0) {
                                                  if (isUserLogin ?? false) {
                                                    quantity = quantity + 1;
                                                    await DBProvider.db.newCart(
                                                        Cart(
                                                            id: product?.id ??
                                                                0,
                                                            prodId:
                                                                product?.id ??
                                                                    0,
                                                            name: productName,
                                                            quantity:
                                                                quantity));
                                                    setState(() {});
                                                    cartLiveUpdate("+");
                                                  } else {
                                                    quantity = quantity + 1;
                                                    await DBProvider.db.newCart(
                                                        Cart(
                                                            id: product?.id ??
                                                                0,
                                                            prodId:
                                                                product?.id ??
                                                                    0,
                                                            name: productName,
                                                            quantity:
                                                                quantity));
                                                    setState(() {});
                                                  }
                                                }
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                    color: Color(0xffA3CC39),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Color(
                                                                  0xff37AB01)
                                                              .withOpacity(0.3))
                                                    ]),
                                                child: SvgPicture.asset(
                                                  "assets/images/ic_cart_small.svg",
                                                  height: 20,
                                                  width: 20,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            )
                                          : cartItem()),
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    bottom: 0,
                                    child: RichText(
                                      text: TextSpan(
                                        text:
                                            "₹${product?.productSinglePrice?.sPrice} \n",
                                        style: GoogleFonts.getFont(
                                          'Lato',
                                          color: Color(0xFFA3CC39),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        children: [
                                          TextSpan(
                                              text:
                                                  "${product?.productSinglePrice?.price}",
                                              style: GoogleFonts.getFont('Lato',
                                                  color: Color(0xFF8f8f8f),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  decoration: TextDecoration
                                                      .lineThrough)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 36,
                                  ),
                                  Positioned(
                                      right: 0,
                                      top: 0,
                                      bottom: 0,
                                      child: ((product?.stock == 0) ||
                                                  (double.parse(product
                                                              ?.storeStock
                                                              ?.quantity ??
                                                          "0") ==
                                                      0)) ||
                                              (double.parse(product?.storeStock
                                                          ?.quantity ??
                                                      "0") <=
                                                  quantity)
                                          ? Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 3),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    4,
                                                  ),
                                                  color: kPrimaryColor),
                                              child: Center(
                                                  child: Text(
                                                stroutofStock,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                            )
                                          : Container())
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
        isLoading
            ? Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                top: 0,
                child: Center(child: CircularProgressIndicator()))
            : Container()
      ],
    );
  }

  cartLiveUpdate(String operation) async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    map['product_id'] = "${product?.id ?? ""}";
    map['quantity'] = "${quantity}";
    try {
      CartUpdateResponse? response =
          await _repository?.cartUpdate(context, map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        Fluttertoast.showToast(msg: "Cart Updated");
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
          id: product?.id ?? 0,
          prodId: product?.id ?? 0,
          name: productName,
          quantity: quantity));
      setState(() {});
      print(e);
    }
  }

  Widget cartItem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            constraints: BoxConstraints(),
            onPressed: () async {
              if (isLoading == false &&
                  double.parse(product?.productSinglePrice?.sPrice ?? "0.0") >
                      0) {
                if (isUserLogin ?? false) {
                  quantity = quantity - 1;
                  await DBProvider.db.updateCart(Cart(
                      id: product?.id ?? 0,
                      prodId: product?.id ?? 0,
                      name: productName,
                      quantity: quantity));
                  setState(() {});
                  cartLiveUpdate("-");
                } else {
                  quantity = quantity - 1;
                  await DBProvider.db.updateCart(Cart(
                      id: product?.id ?? 0,
                      prodId: product?.id ?? 0,
                      name: productName,
                      quantity: quantity));
                  setState(() {});
                }
              }
            },
            icon: SvgPicture.asset("assets/images/ic_cart_minus.svg")),
        Text(
          "${quantity}",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        IconButton(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            constraints: BoxConstraints(),
            onPressed: () async {
              if (isLoading == false &&
                  double.parse(product?.productSinglePrice?.sPrice ?? "0.0") >
                      0) {
                if (isUserLogin ?? false) {
                  quantity = quantity + 1;
                  await DBProvider.db.updateCart(Cart(
                      id: product?.id ?? 0,
                      prodId: product?.id ?? 0,
                      name: productName,
                      quantity: quantity));
                  setState(() {});
                  cartLiveUpdate("+");
                } else {
                  quantity = quantity + 1;
                  await DBProvider.db.updateCart(Cart(
                      id: product?.id ?? 0,
                      prodId: product?.id ?? 0,
                      name: productName,
                      quantity: quantity));
                  setState(() {});
                }
              }
            },
            icon: SvgPicture.asset("assets/images/ic_cart_plus.svg")),
      ],
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
