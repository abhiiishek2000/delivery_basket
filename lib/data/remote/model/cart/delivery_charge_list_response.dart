///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class DeliveryChargeListResponseDataDeliveryCharge {
/*
{
  "id": 1,
  "user_id": 1,
  "name": "Free Delivery Above 200",
  "m_o_price": "200.00",
  "charges": "25.00",
  "m_o_quantity": 22,
  "status": true,
  "created_at": null,
  "updated_at": "2021-10-04T11:33:54.000000Z",
  "deleted_at": null,
  "km": "0.00",
  "s_km": "0.00",
  "e_km": "10.00"
}
*/

  int? id;
  int? userId;
  String? name;
  String? mOPrice;
  String? charges;
  int? mOQuantity;
  bool? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? km;
  String? sKm;
  String? eKm;

  DeliveryChargeListResponseDataDeliveryCharge({
    this.id,
    this.userId,
    this.name,
    this.mOPrice,
    this.charges,
    this.mOQuantity,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.km,
    this.sKm,
    this.eKm,
  });
  DeliveryChargeListResponseDataDeliveryCharge.fromJson(Map<String, dynamic> json) {
    id = json["id"]?.toInt();
    userId = json["user_id"]?.toInt();
    name = json["name"]?.toString();
    mOPrice = json["m_o_price"]?.toString();
    charges = json["charges"]?.toString();
    mOQuantity = json["m_o_quantity"]?.toInt();
    status = json["status"];
    createdAt = json["created_at"]?.toString();
    updatedAt = json["updated_at"]?.toString();
    deletedAt = json["deleted_at"]?.toString();
    km = json["km"]?.toString();
    sKm = json["s_km"]?.toString();
    eKm = json["e_km"]?.toString();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    data["user_id"] = userId;
    data["name"] = name;
    data["m_o_price"] = mOPrice;
    data["charges"] = charges;
    data["m_o_quantity"] = mOQuantity;
    data["status"] = status;
    data["created_at"] = createdAt;
    data["updated_at"] = updatedAt;
    data["deleted_at"] = deletedAt;
    data["km"] = km;
    data["s_km"] = sKm;
    data["e_km"] = eKm;
    return data;
  }
}

class DeliveryChargeListResponseData {
/*
{
  "deliveryCharge": [
    {
      "id": 1,
      "user_id": 1,
      "name": "Free Delivery Above 200",
      "m_o_price": "200.00",
      "charges": "25.00",
      "m_o_quantity": 22,
      "status": true,
      "created_at": null,
      "updated_at": "2021-10-04T11:33:54.000000Z",
      "deleted_at": null,
      "km": "0.00",
      "s_km": "0.00",
      "e_km": "10.00"
    }
  ]
}
*/

  List<DeliveryChargeListResponseDataDeliveryCharge?>? deliveryCharge;

  DeliveryChargeListResponseData({
    this.deliveryCharge,
  });
  DeliveryChargeListResponseData.fromJson(Map<String, dynamic> json) {
    if (json["deliveryCharge"] != null) {
      final v = json["deliveryCharge"];
      final arr0 = <DeliveryChargeListResponseDataDeliveryCharge>[];
      v.forEach((v) {
        arr0.add(DeliveryChargeListResponseDataDeliveryCharge.fromJson(v));
      });
      deliveryCharge = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (deliveryCharge != null) {
      final v = deliveryCharge;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data["deliveryCharge"] = arr0;
    }
    return data;
  }
}

class DeliveryChargeListResponse {
/*
{
  "success": true,
  "data": {
    "deliveryCharge": [
      {
        "id": 1,
        "user_id": 1,
        "name": "Free Delivery Above 200",
        "m_o_price": "200.00",
        "charges": "25.00",
        "m_o_quantity": 22,
        "status": true,
        "created_at": null,
        "updated_at": "2021-10-04T11:33:54.000000Z",
        "deleted_at": null,
        "km": "0.00",
        "s_km": "0.00",
        "e_km": "10.00"
      }
    ]
  },
  "message": "Delivery Charge."
}
*/

  bool? success;
  DeliveryChargeListResponseData? data;
  String? message;

  DeliveryChargeListResponse({
    this.success,
    this.data,
    this.message,
  });
  DeliveryChargeListResponse.fromJson(Map<String, dynamic> json) {
    success = json["success"];
    data = (json["data"] != null) ? DeliveryChargeListResponseData.fromJson(json["data"]) : null;
    message = json["message"]?.toString();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["success"] = success;
    if (data != null) {
      data["data"] = this.data!.toJson();
    }
    data["message"] = message;
    return data;
  }
}
