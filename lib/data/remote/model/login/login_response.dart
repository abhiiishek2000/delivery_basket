///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class LoginResponseData {
/*
{
  "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiOGQwYTg4NWNiMjBmZjFiMjAzOWRkZDkwMTQ4MzQ4MmQ0Zjg3YjFkM2JkMTJmZDk5OTI0ZDZkNThlMTVjNGNmYTZiZmU5ODBlMTYzODk2NGQiLCJpYXQiOjE2MzAwNDcxNzcsIm5iZiI6MTYzMDA0NzE3NywiZXhwIjoxNjYxNTgzMTc3LCJzdWIiOiIyIiwic2NvcGVzIjpbXX0.EWBfGkYRX70JYc_B01ppVGYql1GM1-v4HULveJkwy-gldccazvj9eU87N9TZUZ2yd9tTrVkjXw7mAKZQX071djv7oaKuHpufK2YTLxIb6rcBN_QVh1RIven-q12WsXkj5I3R6Zm8Qyni50Y4XVgXgMunXecIs2cr5l4JYTw1ypz9WeBCOfuT1ubWm_qP0xtbCZ1q9K6GjWDYcbIzx3C5Trtn_aeAw8TI7Qb2U-124QB-FB8m1f68BfE2S0JuV0X3iWY_ojLQcvdiK7v58oYl8Xem9pNKM9eMzl0zgD_GnfL7TcnWnZe-L6wZiuyliAf2PFQyHNgej8xtWiXBSzD_LTG38qOnO--6-pnzLmyrP2zrJGRHxBK-T0wKX4LGhVLxvjH4ZtfdRRopUwaX4VsE8arZXb8VNLn1qvTdDOlWdRAG1i_GLXau1zqC-DACNp4Fr40pcnv_cQy_ap_evZpkkqqmbKItnigyat3OAei5lx_tsMkYWS1Ys_km_qUq36hWJ8RTO-qM4EJR5GQMgQd-KC7xZfgL9lwag5Z20JVvRmZpWoGwh6B3Vls5WIiqcfFWsJt3_B-dHWdWA2h_L-S_Hs-DRZp5y3AKqgpnjvi1WXhUiSLD-WMkYGISE-ZCj8oPlhunlg4SxKqahcMM1POdTwE7YXzf1EAdSH5O9jEUeHM",
  "name": "jayesh",
  "user_id": 2
}
*/

  String? token;
  String? name;
  int? userId;

  LoginResponseData({
    this.token,
    this.name,
    this.userId,
  });
  LoginResponseData.fromJson(Map<String, dynamic> json) {
    token = json["token"]?.toString();
    name = json["name"]?.toString();
    userId = json["user_id"]?.toInt();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["token"] = token;
    data["name"] = name;
    data["user_id"] = userId;
    return data;
  }
}

class LoginResponse {
/*
{
  "success": true,
  "data": {
    "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiOGQwYTg4NWNiMjBmZjFiMjAzOWRkZDkwMTQ4MzQ4MmQ0Zjg3YjFkM2JkMTJmZDk5OTI0ZDZkNThlMTVjNGNmYTZiZmU5ODBlMTYzODk2NGQiLCJpYXQiOjE2MzAwNDcxNzcsIm5iZiI6MTYzMDA0NzE3NywiZXhwIjoxNjYxNTgzMTc3LCJzdWIiOiIyIiwic2NvcGVzIjpbXX0.EWBfGkYRX70JYc_B01ppVGYql1GM1-v4HULveJkwy-gldccazvj9eU87N9TZUZ2yd9tTrVkjXw7mAKZQX071djv7oaKuHpufK2YTLxIb6rcBN_QVh1RIven-q12WsXkj5I3R6Zm8Qyni50Y4XVgXgMunXecIs2cr5l4JYTw1ypz9WeBCOfuT1ubWm_qP0xtbCZ1q9K6GjWDYcbIzx3C5Trtn_aeAw8TI7Qb2U-124QB-FB8m1f68BfE2S0JuV0X3iWY_ojLQcvdiK7v58oYl8Xem9pNKM9eMzl0zgD_GnfL7TcnWnZe-L6wZiuyliAf2PFQyHNgej8xtWiXBSzD_LTG38qOnO--6-pnzLmyrP2zrJGRHxBK-T0wKX4LGhVLxvjH4ZtfdRRopUwaX4VsE8arZXb8VNLn1qvTdDOlWdRAG1i_GLXau1zqC-DACNp4Fr40pcnv_cQy_ap_evZpkkqqmbKItnigyat3OAei5lx_tsMkYWS1Ys_km_qUq36hWJ8RTO-qM4EJR5GQMgQd-KC7xZfgL9lwag5Z20JVvRmZpWoGwh6B3Vls5WIiqcfFWsJt3_B-dHWdWA2h_L-S_Hs-DRZp5y3AKqgpnjvi1WXhUiSLD-WMkYGISE-ZCj8oPlhunlg4SxKqahcMM1POdTwE7YXzf1EAdSH5O9jEUeHM",
    "name": "jayesh",
    "user_id": 2
  },
  "message": "Login successfully."
}
*/

  bool? success;
  LoginResponseData? data;
  String? message;

  LoginResponse({
    this.success,
    this.data,
    this.message,
  });
  LoginResponse.fromJson(Map<String, dynamic> json) {
    success = json["success"];
    data = (json["data"] != null) ? LoginResponseData.fromJson(json["data"]) : null;
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
