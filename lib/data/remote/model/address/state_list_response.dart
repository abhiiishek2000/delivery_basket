///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class StateListResponseDataState {
/*
{
  "id": 1,
  "country_id": 1,
  "name": "maharashtra",
  "status": true,
  "created_at": null,
  "updated_at": null,
  "deleted_at": null
}
*/

  int? id;
  int? countryId;
  String? name;
  bool? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  StateListResponseDataState({
    this.id,
    this.countryId,
    this.name,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });
  StateListResponseDataState.fromJson(Map<String, dynamic> json) {
    id = json["id"]?.toInt();
    countryId = json["country_id"]?.toInt();
    name = json["name"]?.toString();
    status = json["status"];
    createdAt = json["created_at"]?.toString();
    updatedAt = json["updated_at"]?.toString();
    deletedAt = json["deleted_at"]?.toString();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    data["country_id"] = countryId;
    data["name"] = name;
    data["status"] = status;
    data["created_at"] = createdAt;
    data["updated_at"] = updatedAt;
    data["deleted_at"] = deletedAt;
    return data;
  }
}

class StateListResponseData {
/*
{
  "state": [
    {
      "id": 1,
      "country_id": 1,
      "name": "maharashtra",
      "status": true,
      "created_at": null,
      "updated_at": null,
      "deleted_at": null
    }
  ]
}
*/

  List<StateListResponseDataState?>? state;

  StateListResponseData({
    this.state,
  });
  StateListResponseData.fromJson(Map<String, dynamic> json) {
    if (json["state"] != null) {
      final v = json["state"];
      final arr0 = <StateListResponseDataState>[];
      v.forEach((v) {
        arr0.add(StateListResponseDataState.fromJson(v));
      });
      state = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (state != null) {
      final v = state;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data["state"] = arr0;
    }
    return data;
  }
}

class StateListResponse {
/*
{
  "success": true,
  "data": {
    "state": [
      {
        "id": 1,
        "country_id": 1,
        "name": "maharashtra",
        "status": true,
        "created_at": null,
        "updated_at": null,
        "deleted_at": null
      }
    ]
  },
  "message": "State list."
}
*/

  bool? success;
  StateListResponseData? data;
  String? message;

  StateListResponse({
    this.success,
    this.data,
    this.message,
  });
  StateListResponse.fromJson(Map<String, dynamic> json) {
    success = json["success"];
    data = (json["data"] != null) ? StateListResponseData.fromJson(json["data"]) : null;
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
