///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class FirebaseTokenPushResponseData {
/*
{
  "notification": "success fully added"
}
*/

  String? notification;

  FirebaseTokenPushResponseData({
    this.notification,
  });
  FirebaseTokenPushResponseData.fromJson(Map<String, dynamic> json) {
    notification = json["notification"]?.toString();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["notification"] = notification;
    return data;
  }
}

class FirebaseTokenPushResponse {
/*
{
  "success": true,
  "data": {
    "notification": "success fully added"
  },
  "message": "Notification list."
}
*/

  bool? success;
  FirebaseTokenPushResponseData? data;
  String? message;

  FirebaseTokenPushResponse({
    this.success,
    this.data,
    this.message,
  });
  FirebaseTokenPushResponse.fromJson(Map<String, dynamic> json) {
    success = json["success"];
    data = (json["data"] != null) ? FirebaseTokenPushResponseData.fromJson(json["data"]) : null;
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
