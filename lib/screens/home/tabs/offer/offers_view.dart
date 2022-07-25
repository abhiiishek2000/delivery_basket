import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:delivery_basket/constants.dart';
import 'package:delivery_basket/data/remote/model/offers/offer_list_response.dart';
import 'package:delivery_basket/data/remote/repository.dart';
import 'package:html/parser.dart';
import 'package:delivery_basket/screens/check_details/order_details_view.dart';
import 'package:delivery_basket/screens/home/tabs/offer/offer_details_view.dart';


class OffersView extends StatefulWidget {
  final List<OfferListResponseDataOffer?>? offers ;

  const OffersView({Key? key,required this.offers}) : super(key: key);

  @override
  _OffersViewState createState() => _OffersViewState();
}

class _OffersViewState extends State<OffersView> {


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: widget.offers?.length,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          OfferListResponseDataOffer? offer = widget.offers ? [index];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Color(0xffF6F6F6)),
                boxShadow: [
                  BoxShadow(
                      color: Color(0xffF6F6F6),
                      spreadRadius: 1,
                      offset: Offset(0.2, 1.0))
                ]),
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>OfferDetailsView(offer: offer!)));
              },
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    backgroundImage: NetworkImage(
                        "$ImageBaseUrlTest${offer?.image}"),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${offer?.name?.toUpperCase()}",
                          style: Theme
                              .of(context)
                              .textTheme
                              .caption
                              ?.copyWith(color: Color(0xff8F8F8F)),
                        ),
                        SizedBox(height: 4,),
                        Text(
                          "${_parseHtmlString(offer?.text ?? "")} ...",
                          style: Theme
                              .of(context)
                              .textTheme
                              .subtitle1
                              ?.copyWith(color: Colors.black,fontSize: 18),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8,),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded,size: 12,color: Colors.grey,)
                ],
              ),
            ),
          );
        });
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body?.text).documentElement
        ?.text ?? "";
    if(parsedString.length < 50){
      return parsedString;
    }
    return parsedString.substring(0,50);
  }
}
