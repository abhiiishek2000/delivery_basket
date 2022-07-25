// To parse this JSON data, do
//
//     final couponFailResponse = couponFailResponseFromJson(jsonString);

import 'dart:convert';

CouponFailResponse couponFailResponseFromJson(String str) => CouponFailResponse.fromJson(json.decode(str));

String couponFailResponseToJson(CouponFailResponse data) => json.encode(data.toJson());

class CouponFailResponse {
  CouponFailResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  String data;

  factory CouponFailResponse.fromJson(Map<String, dynamic> json) => CouponFailResponse(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : json["data"],
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
    "data": data == null ? null : data,
  };
}
