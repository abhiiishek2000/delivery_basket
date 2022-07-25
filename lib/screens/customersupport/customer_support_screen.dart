import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:delivery_basket/data/local/shared_pref.dart';
import 'package:delivery_basket/data/remote/model/setting/customer_support_response.dart';
import 'package:delivery_basket/data/remote/repository.dart';
import 'package:delivery_basket/generated/l10n.dart';

class CustomerSupportScreen extends StatefulWidget {
  @override
  _CustomerSupportScreenState createState() => _CustomerSupportScreenState();
}

class _CustomerSupportScreenState extends State<CustomerSupportScreen> {
  bool isLoading = false;
  Repository? _repository;
  CustomerSupportResponse? customerSupportResponse;

  String strcustomerSupport = "";
  init()async{
    strcustomerSupport = await getI18n("customerSupport");
    setState(() {
    });
  }
  @override
  void initState() {
    _repository = Repository();
    super.initState();
    customerSupport();
  }

  customerSupport() async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    try {
      CustomerSupportResponse? response =
          await _repository?.apiCustomerSupport(context, map);
      if (response?.success ?? false) {
        setState(() {
          customerSupportResponse = response;
        });
      }
    } catch (e) {
      print("error: ${e.toString()}");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            customerSupportResponse != null
                ? Html(
                    data: customerSupportResponse?.data?.customerSupport?.name)
                : Container()
          ],
        ),
      ),
    );
  }

  PreferredSize appBar() {
    return PreferredSize(
      preferredSize: Size(MediaQuery.of(context).size.width, 56),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 22, 8, 8),
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
                strcustomerSupport,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
