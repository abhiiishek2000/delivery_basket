//import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';
import 'package:delivery_basket/data/AppNotifer.dart';
import 'package:delivery_basket/data/local/DBProvider.dart';
import 'package:delivery_basket/data/local/model/CartModel.dart';
import 'package:delivery_basket/data/local/shared_pref.dart';
import 'package:delivery_basket/data/remote/model/cart/cart_list_response.dart';
import 'package:delivery_basket/data/remote/model/cart/cart_update_response.dart';
import 'package:delivery_basket/data/remote/model/setting/application_setting_response.dart';
import 'package:delivery_basket/data/remote/repository.dart';
import 'package:delivery_basket/generated/l10n.dart';
import 'package:delivery_basket/screens/check_details/check_details_screen.dart';
import 'package:delivery_basket/screens/home/tabs/product_details/product_details_view.dart';
import 'package:delivery_basket/screens/home/tabs/store/model/product_response.dart';
import 'package:delivery_basket/screens/home/welcome/welcome_screen.dart';
import 'package:delivery_basket/screens/home/widget/drawer_view.dart';
import 'package:delivery_basket/screens/home/widget/ic_menu_button.dart';
import '../../../constants.dart';

class CartTabView extends StatefulWidget {
  @override
  _CartTabViewState createState() => _CartTabViewState();
}

class _CartTabViewState extends State<CartTabView> {
  //static final facebookAppEvents = FacebookAppEvents();
  Repository? _repository;
  bool isLoading = false;
  List<ProductResponseDataProdcutData?>? products = [];
  List<CartListResponseDataProduct?>? carts = [];
  List<Cart> cartsLocal = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  double amount = 0.0;
  double weight = 0.0;
  double priceItems = 0.0;
  double discountPrice = 0.0;
  double deliveryCharge = 0.0;
  bool isUserLogin = false;
  ScrollController? _scrollController;
  double? _scrollPosition;
  CartListResponse? cartListResponse;
  ApplicationSettingResponse? applicationSetting;
  final translator = GoogleTranslator();

  String priceDetail = "";
  String price = "";
  String items = "";
  String discount = "";
  String subTotal = "";
  String youWllSave = "";
  String onThisOrder = "";
  String pleaseWait = "";
  String cartIsEmpty = "";
  String cartUpdated = "";
  String strWeight = "";
  String cartDeleted = "";
  String outOfStock = "";
  String strSubTotal = "";
  String minimumOrderPriceIs = "";
  String pleaseRemoveOutOfStockProduct = "";
  String checkout = "";
  String ok = "";
  String vidarbhaBasket = "";
  String strCart = "";
  String strdeliveryChargesVary = "";
  String strSaveExtraAmount = "";

  @override
  void initState() {
    init();
    super.initState();
    _repository = Repository();
    getLocalCart();
  }

  init() async {
    priceDetail = await getI18n("priceDetail");
    price = await getI18n("price");
    items = await getI18n("items");
    discount = await getI18n("discount");
    subTotal = await getI18n("subTotal");
    youWllSave = await getI18n("youWllSave");
    onThisOrder = await getI18n("onThisOrder");
    pleaseWait = await getI18n("pleaseWait");
    cartIsEmpty = await getI18n("cartIsEmpty");
    cartUpdated = await getI18n("cartUpdated");
    strWeight = await getI18n("weight");
    cartDeleted = await getI18n("cartDeleted");
    outOfStock = await getI18n("outOfStock");
    strSubTotal = await getI18n("subTotal");
    minimumOrderPriceIs = await getI18n("minimumOrderPriceIs");
    pleaseRemoveOutOfStockProduct =
        await getI18n("pleaseRemoveOutOfStockProduct");
    checkout = await getI18n("checkout");
    strSaveExtraAmount = await getI18n("saveExtraAmountUsingOffers");
    ok = await getI18n("ok");
    vidarbhaBasket = await getI18n("vidarbhaBasket");
    strCart = await getI18n("cart");
    strdeliveryChargesVary = await getI18n("deliveryChargesVary");
    setState(() {});
  }

  void getLocalCart() async {
    bool? temLogin = await getLogin();
    setState(() {
      isUserLogin = temLogin!;
    });
    List<Cart> carts = await DBProvider.db.getAllCart();
    setState(() {
      cartsLocal = carts;
    });
    if (isUserLogin == true) {
      fetchCartLoginList(1);
      fetchApplicationSetting();
    } else {
      fetchCartList(carts);
    }
  }

  fetchCartList(List<Cart> carts) async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    int index = 0;
    carts.forEach((element) {
      map['product_id[$index]'] = "${element.prodId}";
      index++;
    });
    if (carts.length != 0) {
      try {
        ProductResponse? response =
            await _repository?.fetchCartList(context, map);
        if (response?.success ?? false) {
          setState(() {
            products?.addAll(response!.data!.prodcut!.data!);
            getSubAmount();
          });
        }
        Provider.of<CheckOutNotifier>(context, listen: false)
            .cartCountUpdate(products?.length ?? 0);
        setState(() {
          isLoading = false;
        });
      } catch (e) {
        print("error: ${e.toString()}");

        print(e);
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  fetchCartLoginList(int page) async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    try {
      CartListResponse? response =
          await _repository?.fetchCartLoginList(context, map);
      if (response?.success ?? false) {
        if (page == 1) {
          await DBProvider.db.deleteAllCart();
        }
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
        setState(() {
          carts?.addAll(response!.data!.product!);
          getSubAmount();
        });
        Provider.of<CheckOutNotifier>(context, listen: false)
            .cartCountUpdate(carts?.length ?? 0);
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("error: ${e.toString()}");

      print(e);
    }
  }

  void getSubAmount() async {
    double temAmount = 0.0;
    double temPriceItem = 0.0;
    double temWeight = 0.0;
    if (isUserLogin == true) {
      carts?.forEach((element) {
        temAmount = temAmount +
            (double.parse(
                    element?.product?.productSinglePrice?.sPrice ?? "0.0") *
                double.parse(element?.quantity ?? "0.0"));
        temPriceItem = temPriceItem +
            (double.parse(
                    element?.product?.productSinglePrice?.price ?? "0.0") *
                double.parse(element?.quantity ?? "0.0"));
        // temWeight = temWeight + int.parse(element?.product?.weight ?? "0");
      });
    } else {
      List<Cart> carts = await DBProvider.db.getAllCart();
      carts.forEach((element) {
        double sprice = double.parse(products
                ?.firstWhere((e) => (e?.id ?? 0) == (element.id))
                ?.productSinglePrice
                ?.sPrice ??
            "0.0");
        double price = double.parse(products
                ?.firstWhere((e) => (e?.id ?? 0) == (element.id))
                ?.productSinglePrice
                ?.price ??
            "0.0");
        temAmount = temAmount + (sprice * element.quantity);
        temPriceItem = temPriceItem + (price * element.quantity);
      });
    }
    setState(() {
      amount = temAmount;
      priceItems = temPriceItem;
      discountPrice = priceItems - amount;
      weight = temWeight;
      deliveryCharge = 0.0;
      amount = temAmount;
    });
  }

  fetchApplicationSetting() async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    try {
      ApplicationSettingResponse? response =
          await _repository?.fetchApplicationSetting(context, map);
      if (response?.success ?? false) {
        setState(() {
          applicationSetting = response;
        });
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
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: appBar(),
      body: Stack(
        children: [
          if (carts?.length != 0 || products?.length != 0)
            Container(
              height: double.maxFinite,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        isUserLogin == true
                            ? ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: carts!.length,
                                separatorBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 1,
                                      decoration: BoxDecoration(
                                          color: Color(0xffB8B8B8)),
                                    ),
                                  );
                                },
                                itemBuilder: (context, index) {
                                  CartListResponseDataProduct? cart =
                                      carts?[index];
                                  Cart? cartLocal = cartsLocal.firstWhere(
                                      (element) =>
                                          element.prodId ==
                                          (cart?.product?.id ?? 0));
                                  return cartItemLogin(cart!, cartLocal);
                                })
                            : ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: products!.length,
                                separatorBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 1,
                                      decoration: BoxDecoration(
                                          color: Color(0xffB8B8B8)),
                                    ),
                                  );
                                },
                                itemBuilder: (context, index) {
                                  var product = products?[index];
                                  Cart cart = cartsLocal.firstWhere((element) =>
                                      element.prodId == (product?.id ?? 0));
                                  return cartItem(product!, cart);
                                }),
                        //CartSummaryView(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 8,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                priceDetail,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    ?.copyWith(color: Color(0xff8C8C8C)),
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${price} (${isUserLogin ? carts?.length : products?.length} ${items})",
                                    style: TextStyle(
                                        color: Color(0xff464646),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    "₹${priceItems.toStringAsFixed(2)}",
                                    style: TextStyle(
                                        color: Color(0xff242424),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    discount,
                                    style: TextStyle(
                                        color: Color(0xff464646),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    "₹ ${discountPrice.toStringAsFixed(1)}",
                                    style: TextStyle(
                                        color: Color(0xff3E7A39),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: MySeparator(color: Colors.grey),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    strSubTotal,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    "₹ ${amount.toStringAsFixed(2)}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700),
                                  )
                                ],
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 16),
                              child: Text(
                                "${youWllSave} ₹${discountPrice.toStringAsFixed(2)} ${onThisOrder}",
                                style: TextStyle(
                                    color: Color(0xff318637),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              color: Color(0xffFDF7EA),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        color: Colors.black,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        child: Text(
                                          strSaveExtraAmount,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        color: Colors.black,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        child: Text(
                                          strdeliveryChargesVary,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 120,
                        ),
                      ],
                    ),
                  ),
                  Align(alignment: Alignment.bottomCenter, child: cartBottom()),
                ],
              ),
            )
          else
            isLoading
                ? Center(
                    child: Text(
                      pleaseWait,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  )
                : Center(
                    child: Text(
                      cartIsEmpty,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
          if (isLoading) ...[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(child: CircularProgressIndicator()),
            )
          ]
        ],
      ),
      drawer: DrawerView(),
    );
  }

  cartLiveUpdate(String operation, CartListResponseDataProduct cart) async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    map['product_id'] = "${cart.product?.id ?? ""}";
    map['quantity'] = "${cart.quantity}";
    try {
      CartUpdateResponse? response =
          await _repository?.cartUpdate(context, map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        Fluttertoast.showToast(msg: cartUpdated);
        if (operation == "+" && cart.quantity == "1") {
          Provider.of<CheckOutNotifier>(context, listen: false).cartIncrement();
        } else if (operation == "-" && cart.quantity == "0") {
          Provider.of<CheckOutNotifier>(context, listen: false).cartDecrement();
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("error: ${e.toString()}");
      print(e);
    }
  }

  Widget cartItemLogin(CartListResponseDataProduct cart, Cart cartLocal) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailsView(
                    product: ProductResponseDataProdcutData(
                        id: cart.product?.id,
                        userId: cart.product?.userId,
                        categoryId: cart.product?.subCategoryId,
                        name: cart.product?.name,
                        weight: cart.product?.weight,
                        unit: cart.product?.unit,
                        productSinglePrice:
                            ProductResponseDataProdcutDataProductSinglePrice(
                                id: cart.product?.productSinglePrice?.id,
                                sPrice:
                                    cart.product?.productSinglePrice?.sPrice,
                                price: cart.product?.productSinglePrice?.price),
                        pImage: cart.product?.pImage,
                        description: cart.product?.description,
                        stock: cart.product?.stock,
                        storeStock: ProductResponseDataProdcutDataStoreStock(
                          id: cart.product?.storeStock?.id,
                          userId: cart.product?.storeStock?.userId,
                          quantity: cart.product?.storeStock?.quantity,
                          productId: cart.product?.storeStock?.productId,
                        )))));
      },
      child: Container(
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
                  "$ImageBaseUrlTest${cart.product?.pImage}",
                  width: 110,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  width: 8,
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "${cart.product?.productName != null ? cart.product?.productName?.name : cart.product?.name}",
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                    Text(
                        "${strWeight} ${cart.product?.weight} ${cart.product?.unit}"),
                    SizedBox(
                      height: 8,
                    ),
                    RichText(
                      text: TextSpan(
                        text: "₹${cart.product?.productSinglePrice?.sPrice} ",
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            color: Color(0xff63BA06),
                            fontWeight: FontWeight.w700,
                            fontSize: 17),
                        children: [
                          TextSpan(
                            text: "₹${cart.product?.productSinglePrice?.price}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                ?.copyWith(
                                    color: Color(0xff8F8F8F),
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.lineThrough),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                        "₹${(double.parse(cart.product?.productSinglePrice?.price ?? "0.0") * double.parse(cart.quantity ?? "0.0")).toStringAsFixed(2)}",
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: Color(0xff8F8F8F))),
                    Text(
                      "₹${(double.parse(cart.product?.productSinglePrice?.sPrice ?? "0.0") * double.parse(cart.quantity ?? "0.0")).toStringAsFixed(2)}",
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                )
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: InkWell(
                onTap: () async {
                  if (isLoading == false) {
                    await DBProvider.db
                        .deleteByProductIdCart(cart.product?.id ?? 0);
                    setState(() {
                      carts?.remove(cart);
                    });
                    cart.quantity = "0";
                    cartLiveUpdate("-", cart);
                    getSubAmount();
                    Fluttertoast.showToast(msg: cartDeleted);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    'Remove',
                    style: GoogleFonts.getFont(
                      'Open Sans',
                      color: Color(0xFFD11F30),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
                right: 0,
                bottom: 8,
                child: ((cart.product?.stock == 0) ||
                            (double.parse(cart.product?.storeStock?.quantity ??
                                    "0") ==
                                0)) ||
                        (double.parse(
                                cart.product?.storeStock?.quantity ?? "0") <=
                            double.parse(cart.quantity ?? "0.0"))
                    ? Container(
                        height: 32,
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              4,
                            ),
                            color: kPrimaryColor),
                        child: Center(
                            child: Text(
                          outOfStock,
                          style: TextStyle(color: Colors.white),
                        )),
                      )
                    : Container()),
            Positioned(
                bottom: 0,
                right: 0,
                child: ((cart.product?.stock == 0) ||
                            (double.parse(cart.product?.storeStock?.quantity ??
                                    "0") ==
                                0)) ||
                        (double.parse(
                                cart.product?.storeStock?.quantity ?? "0") <=
                            double.parse(cart.quantity ?? "0.0"))
                    ? Container(
                        height: 40,
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                              onPressed: () async {
                                if (isLoading == false) {
                                  if (cartLocal.quantity == 1) {
                                    await DBProvider.db.deleteByProductIdCart(
                                        cart.product?.id ?? 0);
                                    setState(() {
                                      carts?.remove(cart);
                                    });
                                    cart.quantity = "0";
                                    cartLiveUpdate("-", cart);
                                    getSubAmount();
                                    Fluttertoast.showToast(msg: cartDeleted);
                                  } else {
                                    cartLocal.quantity = cartLocal.quantity - 1;
                                    await DBProvider.db.updateCart(Cart(
                                        id: cartLocal.id,
                                        prodId: cartLocal.id,
                                        name: cartLocal.name,
                                        quantity: cartLocal.quantity));
                                    setState(() {});
                                    cart.quantity =
                                        "${double.parse(cart.quantity ?? "0") - 1}";
                                    cartLiveUpdate("-", cart);
                                    getSubAmount();
                                  }
                                }
                              },
                              icon: SvgPicture.asset(
                                  "assets/images/ic_cart_minus.svg")),
                          Text(
                            "${cart.quantity}",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          IconButton(
                              onPressed: () async {
                                if (isLoading == false) {
                                  cartLocal.quantity = cartLocal.quantity + 1;
                                  await DBProvider.db.updateCart(Cart(
                                      id: cartLocal.id,
                                      prodId: cartLocal.id,
                                      name: cartLocal.name,
                                      quantity: cartLocal.quantity));
                                  setState(() {});

                                  cart.quantity =
                                      "${double.parse(cart.quantity ?? "0") + 1}";
                                  cartLiveUpdate("+", cart);
                                  getSubAmount();
                                }
                              },
                              icon: SvgPicture.asset(
                                  "assets/images/ic_cart_plus.svg")),
                        ],
                      ))
          ],
        ),
      ),
    );
  }

  Widget cartItem(ProductResponseDataProdcutData product, Cart cart) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 6,
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Color(0xffF3F3F3).withOpacity(0.5),
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Color(0xffF3F3F3),
                blurRadius: 3,
                offset: Offset(2.0, 3.0))
          ]),
      child: Stack(
        children: [
          Row(
            children: [
              Image.network(
                "$ImageBaseUrlTest${product.pImage}",
                width: 110,
                fit: BoxFit.cover,
              ),
              SizedBox(
                width: 8,
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    "${product.productName != null ? product.productName?.name : product.name}",
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                  Text("$weight ${product.weight} ${product.unit}"),
                  SizedBox(
                    height: 8,
                  ),
                  RichText(
                    text: TextSpan(
                      text: "₹${product.productSinglePrice?.sPrice} ",
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                          color: Color(0xff63BA06),
                          fontWeight: FontWeight.w700,
                          fontSize: 17),
                      children: [
                        TextSpan(
                          text: "₹${product.productSinglePrice?.price}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.copyWith(
                                  color: Color(0xff8F8F8F),
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.lineThrough),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                      "₹${(double.parse(product.productSinglePrice?.price ?? "0.0") * (cart.quantity)).toStringAsFixed(2)}",
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                          decoration: TextDecoration.lineThrough,
                          color: Color(0xff8F8F8F))),
                  Text(
                    "₹${(double.parse(product.productSinglePrice?.sPrice ?? "0.0") * (cart.quantity)).toStringAsFixed(2)}",
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                ],
              )
            ],
          ),
          Positioned(
              top: 8,
              right: 8,
              child: InkWell(
                onTap: () async {
                  await DBProvider.db.deleteByProductIdCart(product.id ?? 0);
                  setState(() {
                    products?.remove(product);
                  });
                  getSubAmount();
                  Fluttertoast.showToast(msg: cartDeleted);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.asset(
                    "assets/images/ic_delete.svg",
                    color: Colors.red,
                    height: 20,
                  ),
                ),
              )),
          Positioned(
            bottom: 8,
            right: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () async {
                      if (cart.quantity == 1) {
                        await DBProvider.db
                            .deleteByProductIdCart(product.id ?? 0);
                        setState(() {
                          products?.remove(product);
                        });
                        Fluttertoast.showToast(msg: cartDeleted);
                      } else {
                        cart.quantity = cart.quantity - 1;
                        await DBProvider.db.updateCart(Cart(
                            id: product.id ?? 0,
                            prodId: product.id ?? 0,
                            name: product.name ?? "",
                            quantity: cart.quantity));
                        setState(() {});
                      }
                      getSubAmount();
                    },
                    icon: SvgPicture.asset("assets/images/ic_cart_minus.svg")),
                Text(
                  "${cart.quantity}",
                  style: Theme.of(context).textTheme.headline6,
                ),
                IconButton(
                    onPressed: () async {
                      cart.quantity = cart.quantity + 1;
                      await DBProvider.db.updateCart(Cart(
                          id: product.id ?? 0,
                          prodId: product.id ?? 0,
                          name: product.name ?? "",
                          quantity: cart.quantity));
                      setState(() {});
                      getSubAmount();
                    },
                    icon: SvgPicture.asset("assets/images/ic_cart_plus.svg")),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget cartBottom() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      height: 65,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Color(0xff1a000000),
                blurRadius: 22.0,
                offset: Offset(0, 10))
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subTotal,
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        color: Color(0xff191919),
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "₹ ${amount.toStringAsFixed(2)}",
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "(${isUserLogin ? carts?.length : products?.length} ${items})",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            ?.copyWith(color: Color(0xffA8A8A8)),
                      )
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: () async {
                  // facebookAppEvents.logEvent(
                  //   name: 'checkout',
                  //   parameters: {
                  //     'status': 'trying_to_check_out',
                  //   },
                  // );
                  bool isProductOutOfStock = false;
                  carts?.forEach((cart) {
                    if (((cart?.product?.stock == 0) ||
                            (double.parse(cart?.product?.storeStock?.quantity ??
                                    "0") ==
                                0)) ||
                        (double.parse(
                                cart?.product?.storeStock?.quantity ?? "0") <=
                            double.parse(cart?.quantity ?? "0.0"))) {
                      isProductOutOfStock = true;
                    }
                  });
                  if (int.parse(applicationSetting
                              ?.data?.applicationSetting?.mOPrice ??
                          "0") >
                      amount) {
                    showAlertDialog(context,
                        "${minimumOrderPriceIs} ${applicationSetting?.data?.applicationSetting?.mOPrice ?? "0"}");
                  }
                  /*else if(int.parse(applicationSetting?.data?.applicationSetting?.minmumOrderWeight??"0") >= weight){
                    showAlertDialog(context,"Minimum order weight is ${applicationSetting?.data?.applicationSetting?.minmumOrderWeight??"0"}");
                  }*/
                  else if (isProductOutOfStock == true) {
                    Fluttertoast.showToast(msg: pleaseRemoveOutOfStockProduct);
                  } else if (isUserLogin == true) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CheckDetailsScreen(
                                  amount: amount,
                                  totalItems: isUserLogin
                                      ? carts?.length ?? 0
                                      : products?.length ?? 0,
                                  totalPrice: amount,
                                  discountAmount: discountPrice,
                                  priceItems: priceItems,
                                )));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WelcomeScreen()));
                  }
                },
                onLongPress: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => PayScreen()));
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(4)),
                  child: Text(
                    checkout,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        ?.copyWith(color: Color(0xFF323232), fontSize: 18),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context, String message) {
    Widget okButton = TextButton(
      child: Text(ok),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text(vidarbhaBasket),
      content: Text("$message"),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
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
            MenuButton(
              onClick: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Text(
                strCart,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MySeparator extends StatelessWidget {
  final double height;
  final Color color;

  const MySeparator({this.height = 1, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = 10.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
