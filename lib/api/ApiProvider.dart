

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:delivery_basket/data/local/shared_pref.dart';
import 'package:delivery_basket/data/remote/model/setting/MaintenanceResponse.dart';
import 'package:delivery_basket/screens/maintenance/account_inactive_view.dart';
import 'package:delivery_basket/screens/maintenance/app_update_view.dart';
import 'package:delivery_basket/screens/maintenance/exception_view.dart';
import 'package:delivery_basket/screens/maintenance/maintenance_view.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

import '../constants.dart';
import 'CustomException.dart';

class ApiProvider {

  Future<dynamic> getMapDistance(BuildContext context,String url,Map<String,String> map) async {
    var mapHeader = new Map<String, String>();
    mapHeader['Accept'] = "application/json";
    mapHeader['lang'] = await getLangCode();
    print("param : $mapHeader");
    var responseJson;
    try {
      var uri =  Uri.https("maps.googleapis.com" ,"/maps/api/distancematrix/json",map);
      print("request: $uri $url - $mapHeader");
      final response = await http.get(uri,headers: mapHeader);
      print("response: $uri $url - $map ${response.body}");
      responseJson = _response(context,response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> easeBuzzPaymentInit(BuildContext context,Map<String,String> map) async {
    var mapHeader = new Map<String, String>();
    mapHeader['Accept'] = "application/json";
    mapHeader['lang'] = await getLangCode();
    print("param : $mapHeader");
    var responseJson;
    try {
      var uri =  Uri.https("pay.easebuzz.in" ,"/payment/initiateLink");
      print("request: $uri  - $mapHeader");
      final response = await http.post(uri,headers: mapHeader,body: map);
      print("response: $uri  - $map ${response.body}");
      responseJson = _response(context,response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> get(BuildContext context,String url,Map<String,String> map) async {
    var mapHeader = new Map<String, String>();
    mapHeader['Authorization'] = (await getToken());
    mapHeader['Accept'] = "application/json";
    mapHeader['lang'] = await getLangCode();
    print("param : $mapHeader");
    var responseJson;
    try {
      var uri = IsProduction ?  Uri.https(BaseUrlTest ,BaseShortUrl+url,map) : Uri.http(BaseUrlTest ,BaseShortUrl+url,map);
      print("request: $uri $url - $mapHeader");
      final response = await http.get(uri,headers: mapHeader);
      print("response: $uri $url - $map ${response.body}");
      responseJson = _response(context,response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(BuildContext context,String url,Map<String,String> map) async {
    var mapHeader = new Map<String, String>();
    mapHeader['Authorization'] = await getToken();
    mapHeader['Accept'] = "application/json";
    mapHeader['lang'] = await getLangCode();
    var responseJson;
    try {
      var uri = IsProduction ?  Uri.https(BaseUrlTest ,BaseShortUrl+url) : Uri.http(BaseUrlTest ,BaseShortUrl+url);
      print("request: $uri $url - $map");
      final response = await http.post(uri,body: map,headers: mapHeader);
      print("response:$uri $url - $map ${response.body}");
      responseJson = _response(context,response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> delete(BuildContext context,String url,Map<String,String> map) async {
    var mapHeader = new Map<String, String>();
    mapHeader['Authorization'] = await getToken();
    mapHeader['Accept'] = "application/json";
    mapHeader['lang'] = await getLangCode();
    var responseJson;
    try {
      var uri = IsProduction ?  Uri.https(BaseUrlTest ,BaseShortUrl+url) : Uri.http(BaseUrlTest ,BaseShortUrl+url);
      print("request: $uri $url - $map");
      final response = await http.delete(uri,body: map,headers: mapHeader);
      print("response: $uri $url - $map ${response.body}");
      responseJson = _response(context,response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }



  dynamic _response(BuildContext context,http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      case 404:
         throw InvalidInputException(response.body.toString());
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
        Navigator.of(context).push(
          PageRouteBuilder(
            opaque: false, // set to false
            pageBuilder: (_, __, ___) => AccountInActiveView(value: "${MaintenanceResponse.fromJson(json.decode(response.body.toString())).message}"),
          ),
        );
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
        Navigator.of(context).push(
          PageRouteBuilder(
            opaque: false, // set to false
            pageBuilder: (_, __, ___) => ExceptionView(value: "Opps Something Went Wrong!"),
          ),
        );
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
      case 202:
        Navigator.of(context).push(
          PageRouteBuilder(
            opaque: false, // set to false
            pageBuilder: (_, __, ___) => AppUpdateView(value: "${MaintenanceResponse.fromJson(json.decode(response.body.toString())).message}"),
          ),
        );
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
      case 503:
        Navigator.of(context).push(
          PageRouteBuilder(
            opaque: false, // set to false
            pageBuilder: (_, __, ___) => MaintentanceView(value: "${MaintenanceResponse.fromJson(json.decode(response.body.toString())).message}"),
          ),
        );
        throw MaintenanceException(response.body.toString());
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }


}