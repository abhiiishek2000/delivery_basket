import 'package:flutter/material.dart';
import 'package:delivery_basket/data/local/shared_pref.dart';
import 'package:delivery_basket/data/remote/repository.dart';
import 'package:delivery_basket/screens/home/tabs/store/model/product_response.dart';
import 'package:delivery_basket/screens/home/widget/product_item_view_small.dart';

class SimillarProductView extends StatefulWidget {
  final ProductResponseDataProdcutData parentProdcut;

  const SimillarProductView({Key? key, required this.parentProdcut})
      : super(key: key);
  @override
  _SimillarProductViewState createState() => _SimillarProductViewState();
}

class _SimillarProductViewState extends State<SimillarProductView> {
  Repository? _repository;
  List<ProductResponseDataProdcutData?>? products = [];
  ProductResponse? productResponse;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  ScrollController? _scrollController;
  double? _scrollPosition;
  String strsimilarProducts = "";

  init() async {
    strsimilarProducts = await getI18n("similarProducts");
    setState(() {});
  }

  @override
  void initState() {
    init();
    super.initState();
    _repository = Repository();
    fetchSimillarProductList(1);
  }

  fetchSimillarProductList(int page) async {
    var map = Map<String, String>();
    map['page'] = "${page}";
    map['product_id'] = "${widget.parentProdcut.id}";
    try {
      ProductResponse? response =
          await _repository?.fetchSimillarProductList(context, map);
      if (response?.success ?? false) {
        setState(() {
          productResponse = response;
          products?.addAll(response!.data!.prodcut!.data!);
        });
      }
    } catch (e) {
      print("error: ${e.toString()}");

      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              strsimilarProducts,
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            height: 230,
            child: ListView.separated(
                shrinkWrap: true,
                itemCount: products?.length ?? 0,
                separatorBuilder: (context, index) {
                  return SizedBox(
                    width: 0,
                  );
                },
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  ProductResponseDataProdcutData? product = products?[index];
                  return ProductItemViewSmall(
                    product: product,
                  );
                }),
          )
        ],
      ),
    );
  }
}
