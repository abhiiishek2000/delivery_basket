// To parse this JSON data, do
//
//     final languageChangeResponse = languageChangeResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

LanguageChangeResponse languageChangeResponseFromJson(String str) => LanguageChangeResponse.fromJson(json.decode(str));

String languageChangeResponseToJson(LanguageChangeResponse data) => json.encode(data.toJson());

class LanguageChangeResponse {
  LanguageChangeResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  bool success;
  Data? data;
  String message;

  factory LanguageChangeResponse.fromJson(Map<String, dynamic> json) => LanguageChangeResponse(
    success: json["success"] == null ? null : json["success"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "data": data == null ? null : data!.toJson(),
    "message": message == null ? null : message,
  };
}

class Data {
  Data({
    required this.data,
  });

  Map<String, String>? data;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    data: json["data"] == null ? null : Map.from(json["data"]).map((k, v) => MapEntry<String, String>(k, v)),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : Map.from(data!).map((k, v) => MapEntry<String, dynamic>(k, v)),
  };
}
