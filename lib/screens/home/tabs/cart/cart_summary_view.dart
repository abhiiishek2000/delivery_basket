import 'package:flutter/material.dart';

class CartSummaryView extends StatefulWidget {
  @override
  _CartSummaryViewState createState() => _CartSummaryViewState();
}

class _CartSummaryViewState extends State<CartSummaryView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Summary",
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Discount",
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    ?.copyWith(color: Color(0xff222B45)),
              ),
              Text(
                "Apply coupon",
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    ?.copyWith(color: Color(0xff46B00E)),
              ),
            ],
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Taxes",
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    ?.copyWith(color: Color(0xff222B45)),
              ),
              Text(
                "₹0",
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    ?.copyWith(color: Color(0xff222B45)),
              ),
            ],
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Delivery charges",
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    ?.copyWith(color: Color(0xff222B45)),
              ),
              RichText(
                text: TextSpan(
                  text: "Free   ",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      ?.copyWith(color: Color(0xff46B00E)),
                  children: [
                    TextSpan(
                      text: "₹80",
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                          color: Color(0xff222B45),
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.lineThrough),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
