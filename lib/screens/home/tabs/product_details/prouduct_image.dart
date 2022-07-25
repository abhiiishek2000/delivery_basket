import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:delivery_basket/constants.dart';
import 'package:delivery_basket/data/local/shared_pref.dart';
import 'package:delivery_basket/data/remote/model/wishlist/WishUpdateResponse.dart';
import 'package:delivery_basket/data/remote/repository.dart';
import 'package:delivery_basket/screens/home/tabs/product_details/image_full_screen.dart';
import 'package:delivery_basket/screens/home/tabs/store/model/product_response.dart';
import 'package:delivery_basket/screens/home/widget/login_alert_view.dart';

class ProductImageView extends StatefulWidget {
  final ProductResponseDataProdcutData product;

  const ProductImageView({Key? key, required this.product}) : super(key: key);
  @override
  _ProductImageViewState createState() => _ProductImageViewState();
}

class _ProductImageViewState extends State<ProductImageView> {
  Repository? _repository;
  bool isLoading = false;
  bool isWish = false;
  bool isUserLogin = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _repository = Repository();
    setState(() {
      if (widget.product.wish != null) {
        isWish = true;
      } else {
        isWish = false;
      }
    });
    checkLogin();
  }

  void checkLogin() async {
    bool? tempLogin = await getLogin();
    setState(() {
      isUserLogin = tempLogin!;
    });
  }

  wishItemAdd() async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    map['product_id'] = "${widget.product.id}";
    try {
      WishUpdateResponse? response =
          await _repository?.wishListAdd(context, map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        setState(() {
          isWish = true;
        });
        Fluttertoast.showToast(msg: "added to wish list");
      } else {
        Fluttertoast.showToast(msg: "failed to add wish list");
      }
    } catch (e) {
      print("error: ${e.toString()}");
      print(e);
    }
  }

  wishItemRemove() async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    map['wish_id[0]'] = "${widget.product.wish?.id}";
    try {
      WishUpdateResponse? response =
          await _repository?.wishListDelete(context, map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        setState(() {
          isWish = false;
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
    return Container(
      height: 320,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Color(0xff0d000000),
                blurRadius: 18,
                offset: Offset(0, 3)),
          ]),
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ImageFullScreen(
                          url: "$ImageBaseUrlTest${widget.product.pImage}")));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                "$ImageBaseUrlTest${widget.product.pImage}",
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xff9AA1B1),
                  borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  "${widget.product.weight} ${widget.product.unit}",
                  style: TextStyle(
                      fontSize: 8,
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
          Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  if (isUserLogin == true) {
                    if (isWish) {
                      wishItemRemove();
                    } else {
                      wishItemAdd();
                    }
                  } else {
                    loginAlertShow(context);
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
    );
  }
}
