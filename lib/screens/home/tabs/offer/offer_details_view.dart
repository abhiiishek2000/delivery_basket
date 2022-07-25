import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:delivery_basket/data/remote/model/offers/offer_list_response.dart';

class OfferDetailsView extends StatefulWidget {
  final OfferListResponseDataOffer offer;

  const OfferDetailsView({Key? key,required this.offer}) : super(key: key);
  @override
  _OfferDetailsViewState createState() => _OfferDetailsViewState();
}

class _OfferDetailsViewState extends State<OfferDetailsView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar(),
        body:  ListView(
          shrinkWrap: true,
          children: [
          Html(data: widget.offer.text)
        ],),
      ),
    );
  }
  PreferredSize appBar() {
    return PreferredSize(
      preferredSize: Size(MediaQuery
          .of(context)
          .size
          .width, 56),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
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
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Text(
                "${widget.offer.name?.toUpperCase()}",
                style: Theme
                    .of(context)
                    .textTheme
                    .headline6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
