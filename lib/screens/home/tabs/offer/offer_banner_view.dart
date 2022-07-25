import 'package:flutter/material.dart';
import 'package:delivery_basket/data/remote/model/offers/offer_list_response.dart';

import '../../../../constants.dart';

class OfferBannerView extends StatefulWidget {
  final List<OfferListResponseDataBanner?>? banners ;

  const OfferBannerView({Key? key,required this.banners}) : super(key: key);
  @override
  _OfferBannerViewState createState() => _OfferBannerViewState();
}

class _OfferBannerViewState extends State<OfferBannerView> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Container(
          height: 160,
          child: PageView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.banners?.length,
            onPageChanged: (value){
              setState(() {
                currentIndex = value;
              });
            },
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network("$ImageBaseUrlTest${widget.banners?[index]?.image}",height: 210,width: MediaQuery.of(context).size.width,fit: BoxFit.fitWidth,)),
              );
            },
          ),
        ),
        SizedBox(height: 8,),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (int i = 0; i < (widget.banners?.length??0); i++)
              if (i == currentIndex) ...[circleBar(true)] else
                circleBar(false),
          ],
        ),
      ],
    );
  }

  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 6 : 4,
      width: isActive ? 6 : 4,
      decoration: BoxDecoration(
          color: isActive ? kPrimaryColor : kColorGrey,
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }
}
