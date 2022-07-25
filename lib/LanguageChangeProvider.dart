import 'package:flutter/cupertino.dart';

import 'data/remote/model/setting/language_change_response.dart';

class LanguageChangeProvider with ChangeNotifier{
  Locale _currentLocale = new Locale("en");
  Map<String,String> languageSet = Map();

  Locale get currentLocale => _currentLocale;

  void changeLocale(String _locale)async{
    this._currentLocale = new Locale(_locale);
    notifyListeners();
  }

  void languageUpdate(LanguageChangeResponse languageChangeResponse){

  }

}