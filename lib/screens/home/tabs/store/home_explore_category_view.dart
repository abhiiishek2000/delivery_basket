import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:delivery_basket/constants.dart';
import 'package:delivery_basket/data/local/shared_pref.dart';
import 'package:delivery_basket/data/remote/repository.dart';
import 'package:delivery_basket/generated/l10n.dart';
import 'package:delivery_basket/screens/category/sub_category_screen.dart';
import 'package:delivery_basket/screens/home/tabs/store/model/category_response.dart';
import 'package:delivery_basket/screens/products/products_filter_screen.dart';

class HomeExploreCategoryView extends StatefulWidget {
  @override
  _HomeExploreCategoryViewState createState() =>
      _HomeExploreCategoryViewState();
}

class _HomeExploreCategoryViewState extends State<HomeExploreCategoryView> {
  Repository? _repository;
  List<CategoryResponseDataCategory?>? categorys = [];
  bool isLoading = true;

  String shopByCategory = "";
  String allProducts = "";

  init() async {
    shopByCategory = await getI18n("shopByCategory");
    allProducts = await getI18n("allProducts");
    setState(() {});
  }

  @override
  void initState() {
    init();
    super.initState();
    _repository = Repository();
    fetchCategoryList();
  }

  fetchCategoryList() async {
    var map = Map<String, String>();
    setState(() {
      isLoading = true;
    });
    try {
      CategoryResponse? response =
          await _repository?.fetchCategoryList(context, map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        setState(() {
          categorys?.addAll(response!.data!.category!);
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
      child: isLoading
          ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        width: 120,
                        height: 30,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 110,
                    child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: 4,
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            width: 0,
                          );
                        },
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: Column(
                              children: [
                                Container(
                                  height: 56,
                                  width: 56,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  width: 32,
                                  height: 8,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: Colors.white),
                                )
                              ],
                            ),
                          );
                        }),
                  )
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        shopByCategory,
                        style: GoogleFonts.getFont(
                          'Lato',
                          color: Color(0xFF323232),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Container(
                  height: 110,
                  child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: (categorys?.length ?? 0) + 1,
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          width: 0,
                        );
                      },
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        if (categorys?.length == index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProductsFilterScreen()));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.asset(
                                      'assets/images/ic_all_product.png',
                                      height: 62,
                                      width: 62,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    allProducts,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        ?.copyWith(fontSize: 12),
                                  )
                                ],
                              ),
                            ),
                          );
                        } else {
                          var category = categorys?[index];
                          return Container(
                            width: 80,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SubCategoryScreen(
                                              subcategory: category!,
                                            )));
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: Column(
                                  children: [
                                    // CircleAvatar(
                                    //   backgroundImage: NetworkImage(
                                    //       "$ImageBaseUrlTest${category?.image}",scale: 0.6),
                                    //   radius: 35,
                                    // ),
                                    //Image.network("$ImageBaseUrlTest${category?.image}",height: 56,alignment: new Alignment(-1.0, -1.0),fit: BoxFit.cover,),
                                    ClipRRect(
                                      borderRadius:
                                          new BorderRadius.circular(50.0),
                                      child: Image.network(
                                        "$ImageBaseUrlTest${category?.image}",
                                        height: 62,
                                        width: 62,
                                        alignment: Alignment.bottomCenter,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2),
                                      child: Text(
                                        "${category?.categoryName != null ? category?.categoryName?.name : category?.name}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            ?.copyWith(fontSize: 12),
                                        maxLines: 2,
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      }),
                )
              ],
            ),
    );
  }
}
