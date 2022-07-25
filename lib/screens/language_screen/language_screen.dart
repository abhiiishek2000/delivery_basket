import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:delivery_basket/constants.dart';
import 'package:delivery_basket/data/local/shared_pref.dart';
import 'package:delivery_basket/data/remote/model/setting/language_change_response.dart';
import 'package:delivery_basket/data/remote/model/setting/language_list_response.dart';
import 'package:delivery_basket/data/remote/repository.dart';
import 'package:delivery_basket/generated/l10n.dart';
import 'package:delivery_basket/screens/component/basket_button.dart';
import 'package:delivery_basket/screens/home/home_screen.dart';
import 'package:delivery_basket/screens/intro/intro_screen.dart';

import '../../LanguageChangeProvider.dart';

class LanguageScreen extends StatefulWidget {
  final bool hideBackButton;

  const LanguageScreen({Key? key,required this.hideBackButton}) : super(key: key);
  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  bool isLoading = false;
  Repository? _repository;
  LanguageListResponse? languageListResponse;
  String language = "";
  String languageCode = "En";
  String strContinue = "";

  @override
  void initState() {
    _repository = Repository();
    init();
    super.initState();
    getLanguageList();
    initialLanguage();
  }
  initialLanguage()async{
    String lang = await getLangCode();
    changeLanguage(lang);
  }


  init() async {
    language = await getI18n("language");
    languageCode = await getLangCode();
    strContinue = await getI18n("continueText");
    setState(() {});
  }

  getLanguageList() async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    try {
      LanguageListResponse? response =
          await _repository?.apiLanguageList(context, map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        setState(() {
          languageListResponse = response;
        });
      } else {
        Fluttertoast.showToast(msg: "failed to load  languages");
      }
    } catch (e) {
      print("error: ${e.toString()}");
      print(e);
    }
  }

  changeLanguage(String lang) async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    map['lang'] = "$lang";
    try {
      LanguageChangeResponse? response =
          await _repository?.apiLanguageChangeList(context, map);
      if (response?.success ?? false) {
        response?.data?.data?.forEach((key, value) {
          saveI18n(key, value);
        });
      } else {
        Fluttertoast.showToast(msg: "failed to load  languages");
      }
      init();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("error: ${e.toString()}");
      print(e);
    }
  }

  void checkUserLogin() async {
    Timer(Duration(seconds: 2), () async {
      bool? showIntro = await getIntroShow();
      if (showIntro == true) {
        await saveIntroShow(false);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => IntroScreen()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(language),
      ),

      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: languageListResponse?.data?.language?.length ?? 0,
                    itemBuilder: (context, index) {
                      LanguageListResponseDataLanguage? language =
                      languageListResponse?.data?.language?[index];
                      return Container(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.grey),
                            color: languageCode == language?.code
                                ? Colors.grey
                                : Colors.white),
                        child: ListTile(
                          title: Text(language?.name ?? ""),
                          trailing: language?.url == null
                              ? null
                              : Image.network("$ImageBaseUrlTest${language?.url}"),
                          onTap: () async {
                            setState(() {
                              languageCode = language?.code ?? "En";
                            });
                            // Provider.of<LanguageChangeProvider>(context,
                            //     listen: false)
                            //     .changeLocale(language?.code?.toLowerCase() ?? "en");
                            await saveLangCode(language?.code ?? "");
                            changeLanguage(language?.code ?? "");
                          },
                        ),
                      );
                    }),
              ),
              BasketButton(title: strContinue, onClick: (){
                if(isLoading == true){
                  Fluttertoast.showToast(msg: "Please wait... Language updating");
                }else{
                  checkUserLogin();
                }
              }),
            ],
          ),
          isLoading
              ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                Text("Please wait",style: Theme.of(context).textTheme.headline6,),
              ],
            ),
          ):Container(),
        ],
      ),
    ), onWillPop: () {
      if(widget.hideBackButton == true) {
        Fluttertoast.showToast(msg: "Back press not allowed");
        //changeLanguage("en");
      }else{
        Navigator.pop(context);
      }
      return new Future(() => false);
    }
    );
  }

  String someLocalizedString(String argument) => Intl.message(
        'demo',
        name: 'language',
        desc: '',
        args: [],
      );

  // Map<dynamic,dynamic> flattenTranslations(Map<String, dynamic> json, [String prefix = '']) {
  //   final Map<String, String> translations = {};
  //   json.forEach((String key, dynamic value) {
  //     if (value is Map) {
  //       translations.addAll(flattenTranslations("$value", "$prefix$key"));
  //     } else {
  //       translations['$prefix$key'] = value.toString();
  //     }
  //   });
  //   return translations;
  // }
  //
  // Future<bool> load() async {
  //   String jsonString = await rootBundle.loadString('assets/i18n/en.json');
  //   Map<String, dynamic> jsonMap = jsonDecode(jsonString);
  //   _localizedStrings = flattenTranslations(jsonMap);
  //   return true;
  // }

  // Widget i10Languages() {
  //   return Column(
  //     children: [
  //       ListTile(
  //         leading: Icon(Icons.language),
  //         title: Text("English"),
  //         onTap: () {
  //           Provider.of<LanguageChangeProvider>(context, listen: false)
  //               .changeLocale("en");
  //         },
  //       ),
  //       ListTile(
  //         leading: Icon(Icons.language),
  //         title: Text("Hindi"),
  //         onTap: () {
  //           Provider.of<LanguageChangeProvider>(context, listen: false)
  //               .changeLocale("hi");
  //         },
  //       ),
  //       ListTile(
  //         leading: Icon(Icons.language),
  //         title: Text("Marathi"),
  //         onTap: () {
  //           Provider.of<LanguageChangeProvider>(context, listen: false)
  //               .changeLocale("mr");
  //         },
  //       ),
  //       ListTile(
  //         leading: Icon(Icons.language),
  //         title: Text("Gujrati"),
  //         onTap: () {
  //           Provider.of<LanguageChangeProvider>(context, listen: false)
  //               .changeLocale("gu");
  //         },
  //       ),
  //       ListTile(
  //         leading: Icon(Icons.language),
  //         title: Text("Tamil"),
  //         onTap: () {
  //           Provider.of<LanguageChangeProvider>(context, listen: false)
  //               .changeLocale("ta");
  //         },
  //       ),
  //       ListTile(
  //         leading: Icon(Icons.language),
  //         title: Text("Telgu"),
  //         onTap: () {
  //           Provider.of<LanguageChangeProvider>(context, listen: false)
  //               .changeLocale("te");
  //         },
  //       ),
  //     ],
  //   );
  // }
}
