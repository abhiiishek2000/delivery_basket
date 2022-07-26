///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class TimeSlotResponseDataTimeSlot {
/*
{
  "id": 1,
  "s_time": "12:00:11",
  "e_time": "16:00:11",
  "status": true,
  "created_at": null,
  "updated_at": null,
  "deleted_at": null
}
*/

  int? id;
  String? sTime;
  String? eTime;
  bool? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  TimeSlotResponseDataTimeSlot({
    this.id,
    this.sTime,
    this.eTime,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });
  TimeSlotResponseDataTimeSlot.fromJson(Map<String, dynamic> json) {
    id = json["id"]?.toInt();
    sTime = json["s_time"]?.toString();
    eTime = json["e_time"]?.toString();
    status = json["status"];
    createdAt = json["created_at"]?.toString();
    updatedAt = json["updated_at"]?.toString();
    deletedAt = json["deleted_at"]?.toString();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    data["s_time"] = sTime;
    data["e_time"] = eTime;
    data["status"] = status;
    data["created_at"] = createdAt;
    data["updated_at"] = updatedAt;
    data["deleted_at"] = deletedAt;
    return data;
  }
}

class TimeSlotResponseData {
/*
{
  "timeSlot": [
    {
      "id": 1,
      "s_time": "12:00:11",
      "e_time": "16:00:11",
      "status": true,
      "created_at": null,
      "updated_at": null,
      "deleted_at": null
    }
  ]
}
*/

  List<TimeSlotResponseDataTimeSlot?>? timeSlot;

  TimeSlotResponseData({
    this.timeSlot,
  });
  TimeSlotResponseData.fromJson(Map<String, dynamic> json) {
    if (json["timeSlot"] != null) {
      final v = json["timeSlot"];
      final arr0 = <TimeSlotResponseDataTimeSlot>[];
      v.forEach((v) {
        arr0.add(TimeSlotResponseDataTimeSlot.fromJson(v));
      });
      timeSlot = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (timeSlot != null) {
      final v = timeSlot;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data["timeSlot"] = arr0;
    }
    return data;
  }
}

class TimeSlotResponse {
/*
{
  "success": true,
  "data": {
    "timeSlot": [
      {
        "id": 1,
        "s_time": "12:00:11",
        "e_time": "16:00:11",
        "status": true,
        "created_at": null,
        "updated_at": null,
        "deleted_at": null
      }
    ]
  },
  "message": "timeSlot list."
}
*/

  bool? success;
  TimeSlotResponseData? data;
  String? message;

  TimeSlotResponse({
    this.success,
    this.data,
    this.message,
  });
  TimeSlotResponse.fromJson(Map<String, dynamic> json) {
    success = json["success"];
    data = (json["data"] != null) ? TimeSlotResponseData.fromJson(json["data"]) : null;
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
