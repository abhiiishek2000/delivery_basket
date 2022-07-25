import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:delivery_basket/data/remote/repository.dart';
import 'package:delivery_basket/screens/home/tabs/store/model/banner_response.dart';

import '../../../../constants.dart';

class BasketBannerView extends StatefulWidget {
  @override
  _BasketBannerViewState createState() => _BasketBannerViewState();
}

class _BasketBannerViewState extends State<BasketBannerView> {
  int currentIndex = 0;
  Repository? _repository;
  List<BannerResponseDataBanner?>? banners = [];
  bool isLoading = true;
  PageController _pageController = PageController(
    initialPage: 0,
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _repository = Repository();
    fetchBannerList();
  }

  fetchBannerList() async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();

    try {
      BannerResponse? response = await _repository?.fetchBannerList(context,map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        setState(() {
          banners?.addAll(response!.data!.banner!);
        });
        Timer.periodic(Duration(seconds: 5), (Timer timer) {
          if (currentIndex < (banners?.length??0)) {
            currentIndex++;
          } else {
            currentIndex = 0;
          }
          try {
            _pageController.animateToPage(
              currentIndex,
              duration: Duration(milliseconds: 350),
              curve: Curves.easeIn,
            );
          }catch(e){}
        });
      }
    } catch (e) {
      print("error: ${e.toString()}");

      print(e);
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              for (int i = 0; i < banners!.length; i++)
                if (i == currentIndex) ...[circleBar(true)] else circleBar(false),
            ],
          ),
        ],
      ),
    ): Column(
      children: [
        Container(
          height: 160,
          child: PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            itemCount: banners?.length,
            onPageChanged: (value) {
              setState(() {
                currentIndex = value;
              });
            },
            itemBuilder: (BuildContext context, int index) {
              var banner = banners?[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      "$ImageBaseUrlTest${banner?.image ?? ""}",
                      height: 210,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fitWidth,
                    )),
              );
            },
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (int i = 0; i < banners!.length; i++)
              if (i == currentIndex) ...[circleBar(true)] else circleBar(false),
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
