import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:delivery_basket/constants.dart';
import 'package:delivery_basket/data/local/shared_pref.dart';
import 'package:delivery_basket/data/remote/model/wallet/credit_list_response.dart';
import 'package:delivery_basket/data/remote/model/wallet/debit_list_response.dart';
import 'package:delivery_basket/data/remote/model/wallet/wallet_add_response.dart';
import 'package:delivery_basket/data/remote/repository.dart';
import 'package:delivery_basket/generated/l10n.dart';
import 'package:delivery_basket/screens/wallet/wallet_fill_amont_view.dart';

class WalletOverViewScreen extends StatefulWidget {
  @override
  _WalletOverViewScreenState createState() => _WalletOverViewScreenState();
}

class _WalletOverViewScreenState extends State<WalletOverViewScreen>
    with SingleTickerProviderStateMixin {
  Repository? _repository;
  bool isLoading = false;
  String walletAmount = "";
  TabController? _controller;
  int _selectedIndex = 0;
  List<CreditListResponseDataCredit?>? credits = [];
  List<DebitListResponseDataDebit?>? debits = [];

  List<Widget> list = [
    Tab(text: "Credit"),
    Tab(text: "Debit"),
  ];

  String strwalletSummary = "";
  String strwalletActivity = "";
  String strwallet = "";

  init() async {
    strwalletSummary = await getI18n("walletSummary");
    strwalletActivity = await getI18n("walletActivity");
    strwallet = await getI18n("wallet");
    setState(() {});
  }

  @override
  void initState() {
    init();
    super.initState();
    _repository = Repository();
    _controller = TabController(length: list.length, vsync: this);

    _controller?.addListener(() {
      setState(() {
        _selectedIndex = _controller?.index ?? 0;
      });
      if (_selectedIndex == 0) {
        creditList();
      } else {
        debitList();
      }
      print("Selected Index: " + _controller!.index.toString());
    });
    fetchWalletAmount();
    creditList();
  }

  fetchWalletAmount() async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    try {
      WalletResponse? response =
          await _repository?.fetchWalletAmount(context, map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        setState(() {
          walletAmount = response?.data?.wallet ?? "";
        });
      } else {
        Fluttertoast.showToast(msg: "failed to to load wallet money");
      }
    } catch (e) {
      print("error: ${e.toString()}");
      print(e);
    }
  }

  creditList() async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    try {
      CreditListResponse? response =
          await _repository?.fetchCreditList(context, map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        setState(() {
          credits = [];
          credits?.addAll(response!.data!.credit!);
        });
      } else {
        Fluttertoast.showToast(msg: "failed to to load wallet money");
      }
    } catch (e) {
      print("error: ${e.toString()}");
      print(e);
    }
  }

  debitList() async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    try {
      DebitListResponse? response =
          await _repository?.fetchDebitList(context, map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        setState(() {
          debits = [];
          debits?.addAll(response!.data!.debit!);
        });
      } else {
        Fluttertoast.showToast(msg: "failed to to load wallet money");
      }
    } catch (e) {
      print("error: ${e.toString()}");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 16,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Color(0xffF3F3F3)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Color(0xffF3F3F3), offset: Offset(.3, 1.5))
                    ]),
                child: Row(
                  children: [
                    Image.asset("assets/images/ic_wallet_header.png"),
                    SizedBox(
                      width: 8,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strwalletSummary,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text("Current balance Rs. ${walletAmount}")
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Center(
                child: CupertinoButton(
                  child: Text(strwallet),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WalletFillAmountScreen()));
                  },
                  color: kPrimaryColor,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                strwalletActivity,
                style: Theme.of(context).textTheme.subtitle1?.copyWith(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.start,
              ),
              TabBar(
                onTap: (index) {
                  // Should not used it as it only called when tab options are clicked,
                  // not when user swapped
                },
                controller: _controller,
                tabs: list,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
              ),
              Container(
                height: 210,
                child: TabBarView(
                  controller: _controller,
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: credits?.length,
                        itemBuilder: (context, index) {
                          CreditListResponseDataCredit? credit =
                              credits?[index];
                          return ListTile(
                            leading: Text("${index + 1}"),
                            title: Text("${credit?.amount}"),
                            subtitle: Text(
                                "${credit?.createdAt?.substring(0, 10)} on ${credit?.createdAt?.substring(11, 16)}"),
                            trailing: Text(""),
                          );
                        }),
                    ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: debits?.length,
                        itemBuilder: (context, index) {
                          DebitListResponseDataDebit? debit = debits?[index];
                          return ListTile(
                            leading: Text("${index + 1}"),
                            title: Text("${debit?.amount}"),
                            subtitle: Text(
                                "${debit?.createdAt?.substring(0, 10)} on ${debit?.createdAt?.substring(11, 16)}"),
                            trailing: Text(""),
                          );
                        })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  PreferredSize appBar() {
    return PreferredSize(
      preferredSize: Size(MediaQuery.of(context).size.width, 56),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
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
                    color: Colors.white,
                    border: Border.all(
                      color: Color(0xffF1F1F1).withOpacity(0.9),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Color(0xffF1F1F1),
                          offset: Offset(0.3, 1.0),
                          blurRadius: 3.0)
                    ]),
                child: SvgPicture.asset("assets/images/ic_back.svg"),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Text(
                strwallet,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
