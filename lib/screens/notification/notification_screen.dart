import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:delivery_basket/constants.dart';
import 'package:delivery_basket/data/local/shared_pref.dart';
import 'package:delivery_basket/data/remote/model/notification/notification_list_response.dart';
import 'package:delivery_basket/data/remote/model/notification/notification_viewed_response.dart';
import 'package:delivery_basket/data/remote/model/subcategory/sub_category_response.dart';
import 'package:delivery_basket/data/remote/repository.dart';
import 'package:delivery_basket/generated/l10n.dart';
import 'package:delivery_basket/screens/category/sub_category_screen.dart';
import 'package:delivery_basket/screens/component/basket_button.dart';
import 'package:delivery_basket/screens/home/home_screen.dart';
import 'package:delivery_basket/screens/home/tabs/product_details/product_details_view.dart';
import 'package:delivery_basket/screens/home/tabs/store/model/category_response.dart';
import 'package:delivery_basket/screens/home/tabs/store/model/product_response.dart';
import 'package:delivery_basket/screens/login/login_screen.dart';
import 'package:delivery_basket/screens/products/products_filter_screen.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isLoading = true;
  Repository? _repository;
  List<NotificationListResponseDataNotificationData?>? notifications = [];
  NotificationListResponse? notificationListResponse;
  ScrollController? _scrollController;
  double? _scrollPosition;
  String strNotofication = "";
  bool? isLogin;

  init() async {
    strNotofication = await getI18n("notification");
    isLogin = await getLogin();
    setState(() {});
  }

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController?.position.pixels;
      if (_scrollController?.position.pixels ==
          _scrollController?.position.maxScrollExtent) {
        if ((notificationListResponse?.data?.notification?.lastPage ?? 0) >
            (notificationListResponse?.data?.notification?.currentPage ?? 0)) {
          fetchNotificationList(
              (notificationListResponse?.data?.notification?.currentPage ?? 1) +
                  1);
        }
      }
    });
  }

  @override
  void initState() {
    init();
    super.initState();
    _scrollController = ScrollController();
    _scrollController?.addListener(_scrollListener);
    _repository = Repository();
    fetchNotificationList(1);
  }

  fetchNotificationList(int page) async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    map['page'] = "${page}";
    map['device_key'] = await getFirebaseToken();
    try {
      NotificationListResponse? response =
          await _repository?.apiNotificationList(context, map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        setState(() {
          notificationListResponse = response;
          notifications?.addAll(response!.data!.notification!.data!);
        });
      }
    } catch (e) {
      print("error: ${e.toString()}");

      print(e);
    }
  }

  fetchNotificationUpdate(int id) async {
    var map = Map<String, String>();
    map['_method'] = "put";

    try {
      NotificationViewedResponse? response =
          await _repository?.apiNotificationUpdate(context, map, id);
      if (response?.success ?? false) {}
    } catch (e) {
      print("error: ${e.toString()}");

      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: isLogin == false
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(FontAwesomeIcons.bell),
                  Text(
                    "You're missing out.",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text("Sign in to view personalised notifications."),
                  BasketButton(
                      title: "Sign in",
                      onClick: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      }),
                ],
              ),
            )
          : isLoading == false && notifications?.length == 0
              ? Center(
                  child: Text(
                  "Notification list is empty",
                  style: Theme.of(context).textTheme.headline6,
                ))
              : ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemCount: notifications?.length,
                  itemBuilder: (context, index) {
                    NotificationListResponseDataNotificationData? notification =
                        notifications?[index];
                    String image = "";
                    if (notification?.category == null &&
                        notification?.subCategory == null &&
                        notification?.product == null) {
                      image = "";
                    } else if (notification?.category != null &&
                        notification?.subCategory == null) {
                      image = notification?.category?.image ?? "";
                    } else if (notification?.category != null &&
                        notification?.subCategory != null &&
                        notification?.product == null) {
                      image = notification?.subCategory?.image ?? "";
                    } else if (notification?.product != null) {
                      image = notification?.product?.pImage ?? "";
                    }
                    return InkWell(
                      onTap: () {
                        if (notification?.status == true) {
                          fetchNotificationUpdate(notification?.id ?? 0);
                          if (notification?.category == null &&
                              notification?.subCategory == null &&
                              notification?.product == null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()));
                          } else if (notification?.category != null &&
                              notification?.subCategory == null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SubCategoryScreen(
                                          subcategory:
                                              CategoryResponseDataCategory(
                                                  id: notification
                                                      ?.category?.id,
                                                  name: notification
                                                      ?.category?.name,
                                                  image: notification
                                                      ?.category?.image),
                                        )));
                          } else if (notification?.category != null &&
                              notification?.subCategory != null &&
                              notification?.product == null) {
                            //ProductsFilterScreen
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductsFilterScreen(
                                          category:
                                              CategoryResponseDataCategory(
                                                  id: notification
                                                      ?.category?.id,
                                                  name: notification
                                                      ?.category?.name,
                                                  image: notification
                                                      ?.category?.image),
                                          subCategory:
                                              SubCategoryResponseDataSubCategory(
                                            id: notification?.subCategory?.id,
                                            name:
                                                notification?.subCategory?.name,
                                            image: notification
                                                ?.subCategory?.image,
                                          ),
                                        )));
                          } else if (notification?.product != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductDetailsView(
                                        product: notification!.product!)));
                          }
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: notification?.status != true
                                ? Colors.grey.shade50
                                : Colors.white,
                            border: Border.all(color: Color(0xffFCFCFC)),
                            boxShadow: [
                              BoxShadow(
                                  color: notification?.status != true
                                      ? Colors.transparent
                                      : Color(0xffEEEEEE),
                                  offset: Offset(1.0, 1.0),
                                  blurRadius: 3.0)
                            ]),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                "assets/images/logo_small.png",
                                width: 36,
                                height: 36,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    notification?.name ?? "",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(notification?.content ?? ""),
                                  Text(
                                    "",
                                    style: Theme.of(context).textTheme.caption,
                                  )
                                ],
                              ),
                            ),
                            image == null || image == ""
                                ? Container()
                                : Image.network(
                                    "$ImageBaseUrlTest$image",
                                    width: 56,
                                    height: 56,
                                  )
                          ],
                        ),
                      ),
                    );
                  }),
    );
  }

  PreferredSize appBar() {
    return PreferredSize(
      preferredSize: Size(MediaQuery.of(context).size.width, 56),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 24, 8, 0),
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
                  color: Color(0xff0000ffff),
                ),
                child: SvgPicture.asset("assets/images/ic_back.svg"),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Text(
                strNotofication,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
