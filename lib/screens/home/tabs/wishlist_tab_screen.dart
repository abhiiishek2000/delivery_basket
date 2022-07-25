import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:delivery_basket/constants.dart';
import 'package:delivery_basket/data/local/DBProvider.dart';
import 'package:delivery_basket/data/local/model/CartModel.dart';
import 'package:delivery_basket/data/local/shared_pref.dart';
import 'package:delivery_basket/data/remote/model/cart/cart_list_response.dart';
import 'package:delivery_basket/data/remote/model/wishlist/WishUpdateResponse.dart';
import 'package:delivery_basket/data/remote/model/wishlist/wish_cart_add_response.dart';
import 'package:delivery_basket/data/remote/model/wishlist/wish_list_response.dart';
import 'package:delivery_basket/data/remote/repository.dart';
import 'package:delivery_basket/generated/l10n.dart';
import 'package:delivery_basket/screens/home/tabs/wishlist/wishlist_view.dart';
import 'package:delivery_basket/screens/home/widget/drawer_view.dart';
import 'package:delivery_basket/screens/home/widget/ic_menu_button.dart';
import 'package:google_fonts/google_fonts.dart';

class WishlistTabView extends StatefulWidget {
  @override
  _WishlistTabViewState createState() => _WishlistTabViewState();
}

class _WishlistTabViewState extends State<WishlistTabView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoading = false;
  Repository? _repository;
  List<WishListResponseDataWish?>? wishList = [];
  String pleaseWait = "";
  String wishListIsEmpty = "";
  String addAllToCart = "";
  String productOutOfStock = "";
  String productPriceIsZero = "";
  String strwishlist = "";
  String removedFromWishList = "";
  String failed = "";
  String productAddedToCartSuccess = "";

  init() async {
    pleaseWait = await getI18n("pleaseWait");
    wishListIsEmpty = await getI18n("wishListIsEmpty");
    addAllToCart = await getI18n("addAllToCart");
    productOutOfStock = await getI18n("productOutOfStock");
    productPriceIsZero = await getI18n("productPriceIsZero");
    strwishlist = await getI18n("wishlist");
    removedFromWishList = await getI18n("removedFromWishList");
    failed = await getI18n("failed");
    productAddedToCartSuccess = await getI18n("productAddedToCartSuccess");
    setState(() {});
  }

  @override
  void initState() {
    init();
    super.initState();

    _repository = Repository();
    fetchWishList();
  }

  fetchWishList() async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    try {
      WishListResponse? response =
          await _repository?.wishListGetAll(context, map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        setState(() {
          wishList?.addAll(response!.data!.wish!);
        });
      } else {
        Fluttertoast.showToast(msg: "failed to load wishlist");
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("error: ${e.toString()}");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBar(),
      body: isLoading
          ? Center(
              child: Text(
                pleaseWait,
                style: Theme.of(context).textTheme.headline6,
              ),
            )
          : wishList?.length == 0
              ? Center(
                  child: Text(
                    wishListIsEmpty,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: wishList!.length,
                          separatorBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 1,
                                decoration:
                                    BoxDecoration(color: Color(0xffB8B8B8)),
                              ),
                            );
                          },
                          itemBuilder: (context, index) {
                            WishListResponseDataWish? wishItem =
                                wishList?[index];
                            return wishListItem(wishItem);
                          }),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: CupertinoButton(
                            child: Text(
                              addAllToCart,
                              style: GoogleFonts.getFont(
                                'Lato',
                                color: Color(0xFF323232),
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onPressed: () {
                              List<WishListResponseDataWish?>? outOfStockList =
                                  [];
                              List<WishListResponseDataWish?>? priceZeroList =
                                  [];
                              wishList?.forEach((wishItem) {
                                if (((wishItem?.product?.stock == 0) ||
                                        (double.parse(wishItem?.product
                                                    ?.storeStock?.quantity ??
                                                "0") ==
                                            0)) ||
                                    (double.parse(wishItem?.product?.storeStock
                                                ?.quantity ??
                                            "0") <=
                                        1)) {
                                  outOfStockList.add(wishItem);
                                } else if (double.parse(wishItem?.product
                                            ?.productSinglePrice?.sPrice ??
                                        "0.0") >
                                    0) {
                                } else {
                                  priceZeroList.add(wishItem);
                                }
                              });

                              if (outOfStockList.length != 0) {
                                var productNames = outOfStockList
                                    .map((e) => e?.product?.name)
                                    .toList();
                                Fluttertoast.showToast(
                                    msg: "$productNames ${productOutOfStock}");
                              } else if (priceZeroList.length != 0) {
                                var productNames = priceZeroList
                                    .map((e) => e?.product?.name)
                                    .toList();
                                Fluttertoast.showToast(
                                    msg: "$productNames ${productPriceIsZero}");
                              } else {
                                wishToAllCart();
                              }
                            },
                            color: kPrimaryColor,
                          ))
                    ],
                  ),
                ),
      drawer: DrawerView(),
    );
  }

  PreferredSize appBar() {
    return PreferredSize(
      preferredSize: Size(MediaQuery.of(context).size.width, 56),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            MenuButton(onClick: () {
              _scaffoldKey.currentState?.openDrawer();
            }),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Text(
                strwishlist,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  wishItemRemove(WishListResponseDataWish? wishItem) async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    map['wish_id[0]'] = "${wishItem?.id}";
    try {
      WishUpdateResponse? response =
          await _repository?.wishListDelete(context, map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        setState(() {
          wishList = [];
        });
        fetchWishList();
        Fluttertoast.showToast(msg: removedFromWishList);
      } else {
        Fluttertoast.showToast(msg: failed);
      }
    } catch (e) {
      print("error: ${e.toString()}");
      print(e);
    }
  }

  wishToCart(WishListResponseDataWish? wishItem) async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    map['product_id[0]'] = "${wishItem?.product?.id}";
    try {
      WishCartAddResponse? response =
          await _repository?.wishListToCartAdd(context, map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        setState(() {
          wishList = [];
        });
        fetchWishList();
        Fluttertoast.showToast(msg: productAddedToCartSuccess);
        fetchCartLoginList();
      } else {
        Fluttertoast.showToast(msg: "failed to add in cart");
      }
    } catch (e) {
      print("error: ${e.toString()}");
      print(e);
    }
  }

  wishToAllCart() async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    int index = 0;
    wishList?.forEach((element) {
      map['product_id[$index]'] = "${element?.product?.id}";
      index = index + 1;
    });
    try {
      WishCartAddResponse? response =
          await _repository?.wishListToCartAdd(context, map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        setState(() {
          wishList = [];
        });
        fetchWishList();
        Fluttertoast.showToast(msg: productAddedToCartSuccess);
        fetchCartLoginList();
      } else {
        Fluttertoast.showToast(msg: "failed to add in cart");
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
        setState(() {
          cartsLocal = cartsLocal;
        });
      }
    } catch (e) {
      print("error: ${e.toString()}");

      print(e);
    }
  }

  Widget wishListItem(WishListResponseDataWish? wishItem) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Image.network(
                "$ImageBaseUrlTest${wishItem?.product?.pImage}",
                height: 110,
                width: 110,
                fit: BoxFit.fill,
              ),
              SizedBox(
                width: 8,
              ),
              Flexible(
                child: Text(
                  "${wishItem?.product?.productName != null ? wishItem?.product?.productName?.name : wishItem?.product?.name}",
                  style: GoogleFonts.getFont(
                    'Lato',
                    color: Color(0xFF000000),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                width: 26,
              ),
            ],
          ),
          Positioned(
              top: 0,
              right: 0,
              child: InkWell(
                onTap: () {
                  wishItemRemove(wishItem);
                },
                child: SvgPicture.asset(
                  "assets/images/ic_favourite.svg",
                  height: 18,
                ),
              )),
          Positioned(
              bottom: 0,
              right: 0,
              child: IconButton(
                  icon: Icon(Icons.add_shopping_cart_outlined),
                  onPressed: () {
                    if (((wishItem?.product?.stock == 0) ||
                            (double.parse(
                                    wishItem?.product?.storeStock?.quantity ??
                                        "0") ==
                                0)) ||
                        (double.parse(wishItem?.product?.storeStock?.quantity ??
                                "0") <=
                            1)) {
                      Fluttertoast.showToast(msg: productOutOfStock);
                    } else if (double.parse(
                            wishItem?.product?.productSinglePrice?.sPrice ??
                                "0.0") >
                        0) {
                      wishToCart(wishItem);
                    } else {
                      Fluttertoast.showToast(msg: productPriceIsZero);
                    }
                  })),
        ],
      ),
    );
  }
}
