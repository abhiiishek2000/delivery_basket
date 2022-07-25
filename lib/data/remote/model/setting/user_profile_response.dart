///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class UserProfileResponseData {
/*
{
  "id": 2,
  "name": "jayesh",
  "email": null,
  "mobile_number": "7304610113",
  "shope_name": null,
  "address": null,
  "pincode": null,
  "latitude": null,
  "longitude": null,
  "shope_type_id": null,
  "sales_executive": null,
  "email_verified_at": null,
  "type": "customer",
  "version": "1.0.0",
  "status": true,
  "created_at": "2021-08-27T06:12:47.000000Z",
  "updated_at": "2021-08-31T09:56:22.000000Z"
}
*/

  int? id;
  String? name;
  String? email;
  String? mobileNumber;
  String? shopeName;
  String? address;
  String? pincode;
  String? latitude;
  String? longitude;
  String? shopeTypeId;
  String? salesExecutive;
  String? emailVerifiedAt;
  String? type;
  String? version;
  bool? status;
  String? createdAt;
  String? updatedAt;

  UserProfileResponseData({
    this.id,
    this.name,
    this.email,
    this.mobileNumber,
    this.shopeName,
    this.address,
    this.pincode,
    this.latitude,
    this.longitude,
    this.shopeTypeId,
    this.salesExecutive,
    this.emailVerifiedAt,
    this.type,
    this.version,
    this.status,
    this.createdAt,
    this.updatedAt,
  });
  UserProfileResponseData.fromJson(Map<String, dynamic> json) {
    id = json["id"]?.toInt();
    name = json["name"]?.toString();
    email = json["email"]?.toString();
    mobileNumber = json["mobile_number"]?.toString();
    shopeName = json["shope_name"]?.toString();
    address = json["address"]?.toString();
    pincode = json["pincode"]?.toString();
    latitude = json["latitude"]?.toString();
    longitude = json["longitude"]?.toString();
    shopeTypeId = json["shope_type_id"]?.toString();
    salesExecutive = json["sales_executive"]?.toString();
    emailVerifiedAt = json["email_verified_at"]?.toString();
    type = json["type"]?.toString();
    version = json["version"]?.toString();
    status = json["status"];
    createdAt = json["created_at"]?.toString();
    updatedAt = json["updated_at"]?.toString();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    data["name"] = name;
    data["email"] = email;
    data["mobile_number"] = mobileNumber;
    data["shope_name"] = shopeName;
    data["address"] = address;
    data["pincode"] = pincode;
    data["latitude"] = latitude;
    data["longitude"] = longitude;
    data["shope_type_id"] = shopeTypeId;
    data["sales_executive"] = salesExecutive;
    data["email_verified_at"] = emailVerifiedAt;
    data["type"] = type;
    data["version"] = version;
    data["status"] = status;
    data["created_at"] = createdAt;
    data["updated_at"] = updatedAt;
    return data;
  }
}

class UserProfileResponse {
/*
{
  "success": true,
  "data": {
    "id": 2,
    "name": "jayesh",
    "email": null,
    "mobile_number": "7304610113",
    "shope_name": null,
    "address": null,
    "pincode": null,
    "latitude": null,
    "longitude": null,
    "shope_type_id": null,
    "sales_executive": null,
    "email_verified_at": null,
    "type": "customer",
    "version": "1.0.0",
    "status": true,
    "created_at": "2021-08-27T06:12:47.000000Z",
    "updated_at": "2021-08-31T09:56:22.000000Z"
  },
  "message": "User Detail."
}
*/

  bool? success;
  UserProfileResponseData? data;
  String? message;

  UserProfileResponse({
    this.success,
    this.data,
    this.message,
  });
  UserProfileResponse.fromJson(Map<String, dynamic> json) {
    success = json["success"];
    data = (json["data"] != null) ? UserProfileResponseData.fromJson(json["data"]) : null;
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