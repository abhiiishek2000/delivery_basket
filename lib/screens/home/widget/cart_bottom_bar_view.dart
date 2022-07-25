import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CartBottomBarView extends StatefulWidget {
  @override
  _CartBottomBarViewState createState() => _CartBottomBarViewState();
}

class _CartBottomBarViewState extends State<CartBottomBarView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2), offset: Offset(1.0, 1.0))
          ]),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xffF5595C),
            ),
            child: SvgPicture.asset(
              "assets/images/ic_cart.svg",
              height: 22,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "₹160",
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  "2 Items",
                  style: Theme.of(context).textTheme.caption?.copyWith(color: Color(0xffB3B3B3)),
                )
              ],
            ),
          ),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        const Color(0xffFFBB57),
                        const Color(0xffFEB01C),
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 0.0),
                      stops: [1.0, 1.0],
                      tileMode: TileMode.clamp),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xffFFBB57),
                      spreadRadius: 1,
                    )
                  ],
                  borderRadius: BorderRadius.circular(6)),
              child: Text(
                "View Cart",
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    ?.copyWith(color: Colors.white),
              ))
        ],
      ),
    );
  }
}
