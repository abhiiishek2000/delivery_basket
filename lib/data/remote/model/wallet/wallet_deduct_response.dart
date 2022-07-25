///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class WalletDeductResponseData {
/*
{
  "debit": "Debit"
}
*/

  String? debit;

  WalletDeductResponseData({
    this.debit,
  });
  WalletDeductResponseData.fromJson(Map<String, dynamic> json) {
    debit = json["debit"]?.toString();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["debit"] = debit;
    return data;
  }
}

class WalletDeductResponse {
/*
{
  "success": true,
  "data": {
    "debit": "Debit"
  },
  "message": "Debit list."
}
*/

  bool? success;
  WalletDeductResponseData? data;
  String? message;

  WalletDeductResponse({
    this.success,
    this.data,
    this.message,
  });
  WalletDeductResponse.fromJson(Map<String, dynamic> json) {
    success = json["success"];
    data = (json["data"] != null) ? WalletDeductResponseData.fromJson(json["data"]) : null;
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