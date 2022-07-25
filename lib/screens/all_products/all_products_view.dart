import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:delivery_basket/screens/home/widget/product_item_view_small.dart';

class AllProductsView extends StatefulWidget {
  @override
  _AllProductsViewState createState() => _AllProductsViewState();
}

class _AllProductsViewState extends State<AllProductsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SafeArea(
        child:GridView.builder(
          shrinkWrap: true,
          physics: AlwaysScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, index) => ProductItemViewSmall(),
          itemCount: 20,
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                  border: Border.all(
                    color: Color(0xffF1F1F1).withOpacity(0.9),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Color(0xffF1F1F1),
                        offset: Offset(0.3, 1.0),
                        blurRadius: 3.0)
                  ]),
              child: SvgPicture.asset("assets/images/ic_back.svg"),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Text(
                "App Products",
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
