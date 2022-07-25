import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:delivery_basket/constants.dart';
import 'package:delivery_basket/data/local/DBProvider.dart';
import 'package:delivery_basket/screens/home/tabs/store/model/product_response.dart';

class CartItemView extends StatefulWidget {
  final ProductResponseDataProdcutData product;

  const CartItemView({Key? key, required this.product}) : super(key: key);

  @override
  _CartItemViewState createState() => _CartItemViewState();
}

class _CartItemViewState extends State<CartItemView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                "$ImageBaseUrlTest${widget.product.pImage}",
                height: 90,
                width: 90,
              ),
              SizedBox(
                width: 8,
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.product.name}",
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "Price: ₹${widget.product.sPrice}",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        ?.copyWith(color: Colors.black.withOpacity(0.8)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {

                          },
                          icon: SvgPicture.asset(
                              "assets/images/ic_cart_minus.svg")),
                      Text(
                        "2",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      IconButton(
                          onPressed: () {

                          },
                          icon: SvgPicture.asset(
                              "assets/images/ic_cart_plus.svg")),
                    ],
                  )
                ],
              )
            ],
          ),
          Positioned(
              top: 0,
              right: 0,
              child: InkWell(
                onTap: () async {
                  await DBProvider.db.deleteByProductIdCart(widget.product.id ?? 0);
                  setState(() {

                  });
                  Fluttertoast.showToast(msg: "Cart Deleted");
                },
                child: SvgPicture.asset(
                  "assets/images/ic_delete.svg",
                  height: 18,
                ),
              )),
        ],
      ),
    );
  }
}
