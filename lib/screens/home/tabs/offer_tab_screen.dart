import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:delivery_basket/data/local/shared_pref.dart';
import 'package:delivery_basket/data/remote/model/offers/offer_list_response.dart';
import 'package:delivery_basket/data/remote/repository.dart';
import 'package:delivery_basket/generated/l10n.dart';
import 'package:delivery_basket/screens/home/widget/drawer_view.dart';
import 'package:delivery_basket/screens/home/widget/ic_menu_button.dart';

import 'offer/offer_banner_view.dart';
import 'offer/offers_view.dart';

class OfferTabView extends StatefulWidget {
  @override
  _OfferTabViewState createState() => _OfferTabViewState();
}

class _OfferTabViewState extends State<OfferTabView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Repository? _repository;
  bool isLoading = false;
  List<OfferListResponseDataOffer?>? offers = [];
  List<OfferListResponseDataBanner?>? banners = [];
  String stroffers = "";
  String offersNotAvailable = "";

  init()async{
     stroffers = await getI18n("offers");
     offersNotAvailable =  await getI18n("offersNotAvailable");
     setState(() {
     });
  }


  fetchOfferList() async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    try {
      OfferListResponse? response =
          await _repository?.fetchOffers(context, map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        setState(() {
          offers?.addAll(response!.data!.offer!);
          banners?.addAll(response!.data!.banner!);
        });
      } else {
        Fluttertoast.showToast(msg: "failed to load offers");
      }
    } catch (e) {
      print("error: ${e.toString()}");
      print(e);
    }
  }

  @override
  void initState() {
    init();
    super.initState();
    _repository = Repository();
    fetchOfferList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBar(),
      body: isLoading
          ? Center(
              child: Text(
                stroffers,
                style: Theme.of(context).textTheme.headline6,
              ),
            )
          : offers?.length == 0 ? Center(
        child: Text(
          offersNotAvailable,
          style: Theme.of(context).textTheme.headline6,
        ),
      ): Column(
              children: [
                OfferBannerView(
                  banners: banners,
                ),
                OffersView(
                  offers: offers,
                ),
              ],
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
              stroffers,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
