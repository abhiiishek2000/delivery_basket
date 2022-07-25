///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class AddressAddResponse {
/*
{
  "success": true,
  "data": "Sucessfully Added",
  "message": "address list."
}
*/

  bool? success;
  String? data;
  String? message;

  AddressAddResponse({
    this.success,
    this.data,
    this.message,
  });
  AddressAddResponse.fromJson(Map<String, dynamic> json) {
    success = json["success"];
    data = json["data"]?.toString();
    message = json["message"]?.toString();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["success"] = success;
    data["data"] = this.data;
    data["message"] = message;
    return data;
  }
}
