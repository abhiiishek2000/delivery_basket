///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class DistanceMatrixResponseRowsElementsDuration {
/*
{
  "text": "17 mins",
  "value": 1032
}
*/

  String? text;
  int? value;

  DistanceMatrixResponseRowsElementsDuration({
    this.text,
    this.value,
  });
  DistanceMatrixResponseRowsElementsDuration.fromJson(Map<String, dynamic> json) {
    text = json["text"]?.toString();
    value = json["value"]?.toInt();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["text"] = text;
    data["value"] = value;
    return data;
  }
}

class DistanceMatrixResponseRowsElementsDistance {
/*
{
  "text": "11.3 km",
  "value": 11295
}
*/

  String? text;
  int? value;

  DistanceMatrixResponseRowsElementsDistance({
    this.text,
    this.value,
  });
  DistanceMatrixResponseRowsElementsDistance.fromJson(Map<String, dynamic> json) {
    text = json["text"]?.toString();
    value = json["value"]?.toInt();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["text"] = text;
    data["value"] = value;
    return data;
  }
}

class DistanceMatrixResponseRowsElements {
/*
{
  "distance": {
    "text": "11.3 km",
    "value": 11295
  },
  "duration": {
    "text": "17 mins",
    "value": 1032
  },
  "status": "OK"
}
*/

  DistanceMatrixResponseRowsElementsDistance? distance;
  DistanceMatrixResponseRowsElementsDuration? duration;
  String? status;

  DistanceMatrixResponseRowsElements({
    this.distance,
    this.duration,
    this.status,
  });
  DistanceMatrixResponseRowsElements.fromJson(Map<String, dynamic> json) {
    distance = (json["distance"] != null) ? DistanceMatrixResponseRowsElementsDistance.fromJson(json["distance"]) : null;
    duration = (json["duration"] != null) ? DistanceMatrixResponseRowsElementsDuration.fromJson(json["duration"]) : null;
    status = json["status"]?.toString();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (distance != null) {
      data["distance"] = distance!.toJson();
    }
    if (duration != null) {
      data["duration"] = duration!.toJson();
    }
    data["status"] = status;
    return data;
  }
}

class DistanceMatrixResponseRows {
/*
{
  "elements": [
    {
      "distance": {
        "text": "11.3 km",
        "value": 11295
      },
      "duration": {
        "text": "17 mins",
        "value": 1032
      },
      "status": "OK"
    }
  ]
}
*/

  List<DistanceMatrixResponseRowsElements?>? elements;

  DistanceMatrixResponseRows({
    this.elements,
  });
  DistanceMatrixResponseRows.fromJson(Map<String, dynamic> json) {
    if (json["elements"] != null) {
      final v = json["elements"];
      final arr0 = <DistanceMatrixResponseRowsElements>[];
      v.forEach((v) {
        arr0.add(DistanceMatrixResponseRowsElements.fromJson(v));
      });
      elements = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (elements != null) {
      final v = elements;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data["elements"] = arr0;
    }
    return data;
  }
}

class DistanceMatrixResponse {
/*
{
  "destination_addresses": [
    "Warje, Pune, Maharashtra, India"
  ],
  "origin_addresses": [
    "DSK Ranwara Rd, Patil Nagar, Bavdhan, Pune, Maharashtra 411021, India"
  ],
  "rows": [
    {
      "elements": [
        {
          "distance": {
            "text": "11.3 km",
            "value": 11295
          },
          "duration": {
            "text": "17 mins",
            "value": 1032
          },
          "status": "OK"
        }
      ]
    }
  ],
  "status": "OK"
}
*/

  List<String?>? destinationAddresses;
  List<String?>? originAddresses;
  List<DistanceMatrixResponseRows?>? rows;
  String? status;

  DistanceMatrixResponse({
    this.destinationAddresses,
    this.originAddresses,
    this.rows,
    this.status,
  });
  DistanceMatrixResponse.fromJson(Map<String, dynamic> json) {
    if (json["destination_addresses"] != null) {
      final v = json["destination_addresses"];
      final arr0 = <String>[];
      v.forEach((v) {
        arr0.add(v.toString());
      });
      destinationAddresses = arr0;
    }
    if (json["origin_addresses"] != null) {
      final v = json["origin_addresses"];
      final arr0 = <String>[];
      v.forEach((v) {
        arr0.add(v.toString());
      });
      originAddresses = arr0;
    }
    if (json["rows"] != null) {
      final v = json["rows"];
      final arr0 = <DistanceMatrixResponseRows>[];
      v.forEach((v) {
        arr0.add(DistanceMatrixResponseRows.fromJson(v));
      });
      rows = arr0;
    }
    status = json["status"]?.toString();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (destinationAddresses != null) {
      final v = destinationAddresses;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v);
      });
      data["destination_addresses"] = arr0;
    }
    if (originAddresses != null) {
      final v = originAddresses;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v);
      });
      data["origin_addresses"] = arr0;
    }
    if (rows != null) {
      final v = rows;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data["rows"] = arr0;
    }
    data["status"] = status;
    return data;
  }
}