import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:delivery_basket/data/local/DBProvider.dart';
import 'package:delivery_basket/data/local/model/ClientModel.dart';
import 'package:delivery_basket/data/remote/repository.dart';
import 'package:delivery_basket/screens/all_products/all_products_view.dart';
import 'package:delivery_basket/screens/home/tabs/store/model/product_response.dart';
import 'package:delivery_basket/screens/home/widget/product_item_view_small.dart';
import 'dart:math' as math;

class HomeProductsView extends StatefulWidget {
  final bool isLoadMore;
  final Function(bool isLoading) onLoadingMore;

  const HomeProductsView(
      {Key? key, required this.isLoadMore, required this.onLoadingMore})
      : super(key: key);
  @override
  _HomeProductsViewState createState() => _HomeProductsViewState();
}

class _HomeProductsViewState extends State<HomeProductsView> {
  Repository? _repository;
  List<ProductResponseDataProdcutData?>? products = [];

  ScrollController? _scrollController;
  double? _scrollPosition;

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController?.position.pixels;
      print("position ${_scrollPosition}");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _scrollController = ScrollController();
    _scrollController?.addListener(_scrollListener);
    super.initState();
    _repository = Repository();
    fetchProductList(1);
    print("isload More ${widget.isLoadMore}");
  }

  fetchProductList(int page) async {
    widget.onLoadingMore(true);
    var map = Map<String, String>();
    map['page'] = "${page}";
    try {
      ProductResponse? response =
          await _repository?.fetchProductList(context, map);
      widget.onLoadingMore(false);
      if (response?.success ?? false) {
        setState(() {
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
    // ignore: unnecessary_statements
    widget.isLoadMore ? fetchProductList(2) : null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "All",
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.left,
                ),
                // InkWell(
                //   onTap: () {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => AllProductsView()));
                //   },
                //   child: Text(
                //     "View all",
                //     style: Theme.of(context)
                //         .textTheme
                //         .bodyText2
                //         ?.copyWith(color: Color(0xff37AB01)),
                //     textAlign: TextAlign.left,
                //   ),
                // ),
              ],
            ),
          ),
          NotificationListener(
            onNotification: (scrollNotification) {
              print('inside the onNotification');
              if (_scrollController?.position.userScrollDirection ==
                  ScrollDirection.reverse) {
                print('scrolled down');
                //the setState function
              } else if (_scrollController?.position.userScrollDirection ==
                  ScrollDirection.forward) {
                print('scrolled up');
                //setState function
              }
              return true;
            },
            child: GridView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (context, index) {
                var product = products?[index];
                return ProductItemViewSmall(
                  product: product,
                );
              },
              itemCount: 3,
            ),
          )
        ],
      ),
    );
  }

  Widget getDatabaseExample() {
    List<Client> testClients = [
      Client(firstName: "Raouf", lastName: "Rahiche", blocked: false, id: 0),
      Client(firstName: "Zaki", lastName: "oun", blocked: true, id: 1),
      Client(firstName: "oussama", lastName: "ali", blocked: false, id: 2),
    ];
    return Column(
      children: [
        TextButton(
            onPressed: () async {
              Client rnd =
                  testClients[math.Random().nextInt(testClients.length)];
              await DBProvider.db.newClient(rnd);
              setState(() {});
            },
            child: Text("add")),
        Container(
          height: 120,
          child: FutureBuilder<List<Client>>(
            future: DBProvider.db.getAllClients(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Client>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (BuildContext context, int index) {
                    Client? item = snapshot.data?[index];
                    return Dismissible(
                      key: UniqueKey(),
                      background: Container(color: Colors.red),
                      onDismissed: (direction) {
                        DBProvider.db.deleteClient(item?.id ?? 0);
                      },
                      child: ListTile(
                        title: Text(item?.lastName ?? ""),
                        leading: Text(item!.id.toString()),
                      ),
                    );
                  },
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ],
    );
  }
}
