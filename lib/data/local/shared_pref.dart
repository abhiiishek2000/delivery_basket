import 'package:shared_preferences/shared_preferences.dart';

Future<bool?> getLogin() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getBool("login") != null
      ? preferences.getBool("login")
      : false;
}

Future<bool> saveLogin(bool isLogin) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return await preferences.setBool("login", isLogin);
}

Future<String> getToken() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString("token") ?? "";
}

Future<bool> saveToken(String token) async {
  print("token saved $token");
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return await preferences.setString("token", token);
}

Future<bool> getIntroShow() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getBool("intro_show") ?? true;
}

Future<bool> saveIntroShow(bool show) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return await preferences.setBool("intro_show", show);
}

Future<String> getUserName() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString("username") ?? "";
}

Future<bool> saveUserName(String name) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return await preferences.setString("username", name);
}

Future<String> saveEmail() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString("emailaddress_") ?? "";
}

Future<bool> getEmail(String name) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return await preferences.setString("emailaddress_", name);
}


Future<String> getMobile() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString("username") ?? "";
}

Future<bool> saveMobile(String name) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return await preferences.setString("username", name);
}

Future<String> getTagLine() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString("tagline") ?? "";
}

Future<bool> saveTagLine(String name) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return await preferences.setString("tagline", name);
}

Future<List<String>> getPopularSearch() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getStringList("search") ?? [];
}

Future<bool> savePopularSearch(List<String> popularSearchList) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return await preferences.setStringList("search", popularSearchList);
}

Future<String> getI18n(String key) async {
  String data = "";
  print("language key $key");
  try {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(key) ?? "";
  }catch(e){
      print("language exception $key");
  }
  return data;
}

Future<bool> saveI18n(String key,String name) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return await preferences.setString(key, name);
}

Future<String> getLangCode() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString("lang") ?? "En";
}

Future<bool> saveLangCode(String name) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return await preferences.setString("lang", name);
}

Future<String> getFirebaseToken() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString("firebaseID") ?? "";
}

Future<bool> saveFirebaseToken(String name) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return await preferences.setString("firebaseID", name);
}
