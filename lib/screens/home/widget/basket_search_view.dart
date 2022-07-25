import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:delivery_basket/data/local/shared_pref.dart';
import 'package:delivery_basket/screens/search/search_screen.dart';

class BasketSearchView extends StatefulWidget {
  final bool isEnable;

  const BasketSearchView({Key? key, required this.isEnable}) : super(key: key);
  @override
  _BasketSearchViewState createState() => _BasketSearchViewState();
}

class _BasketSearchViewState extends State<BasketSearchView> {
  String strSearch = "";
  init() async {
    strSearch = await getI18n("search");
    setState(() {});
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
        onTap: () {
          if (!widget.isEnable) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SearchScreen()));
          }
        },
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xffF7F7F7),
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Color(0x10000000),
                          blurRadius: 6,
                          offset: Offset(0, 2))
                    ]),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: TextFormField(
                  enabled: widget.isEnable,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SvgPicture.asset(
                        "assets/images/search.svg",
                      ),
                    ),
                    hintText: "$strSearch...",
                    hintStyle: TextStyle(color: Color(0xffD2D2D2)),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            // Container(
            //   decoration: BoxDecoration(
            //     color: Color(0xff63BA01),
            //     borderRadius: BorderRadius.circular(6),
            //   ),
            //   padding: const EdgeInsets.all(8),
            //   child: SvgPicture.asset("assets/images/search.svg"),
            // )
          ],
        ),
      ),
    );
  }
}
