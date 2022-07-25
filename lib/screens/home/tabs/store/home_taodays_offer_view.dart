import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:delivery_basket/data/local/shared_pref.dart';
import 'package:delivery_basket/data/remote/repository.dart';
import 'package:delivery_basket/generated/l10n.dart';
import 'package:delivery_basket/screens/home/tabs/store/model/product_response.dart';
import 'package:delivery_basket/screens/home/widget/product_item_view_small.dart';

class HomeTodaysOfferView extends StatefulWidget {
  @override
  _HomeTodaysOfferViewState createState() => _HomeTodaysOfferViewState();
}

class _HomeTodaysOfferViewState extends State<HomeTodaysOfferView> {
  Repository? _repository;
  List<ProductResponseDataProdcutData?>? offers = [];
  bool isLoading = true;
  String todaysOffer = "";
  init()async{
    todaysOffer = await getI18n("todaysOffer");
    setState(() {
    });
  }

  @override
  void initState() {
    init();
    super.initState();
    _repository = Repository();
    fetchOffersList();
  }

  fetchOffersList() async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();

    try {
      ProductResponse? response =
          await _repository?.fetchOfferProductList(context,map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        setState(() {
          offers?.addAll(response!.data!.prodcut!.data!);
        });
      }
    } catch (e) {
      print("error: ${e.toString()}");

      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    width: 120,
                    height: 30,
                    color: Colors.white,
                  ),
                  SizedBox(height: 8,),
                  Container(
                    height: 195,
                    child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: 5,
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            width: 0,
                          );
                        },
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            height: 195,
                            width: 190,
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(10),
                             color: Colors.white,
                           ),
                          );
                        }),
                  )
                ],
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    todaysOffer,
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: 6,),
                Container(
                  height: 230,
                  child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: offers?.length ?? 0,
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          width: 0,
                        );
                      },
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        var offer = offers?[index];
                        return ProductItemViewSmall(
                         product: offer,
                          isShortView: true,
                        );
                      }),
                )
              ],
            ),
          );
  }
}
