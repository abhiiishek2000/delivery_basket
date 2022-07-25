import 'dart:convert';

RecentSearch searchFromJson(String str) {
  final jsonData = json.decode(str);
  return RecentSearch.fromMap(jsonData);
}

String searchToJson(RecentSearch data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class RecentSearch {
  int id;
  String keyword;
  String time;

  RecentSearch({
    required this.id,
    required this.keyword,
    required this.time,
  });

  //id,pro_id,name,quantity
  factory RecentSearch.fromMap(Map<String, dynamic> json) => new RecentSearch(
      id: json["id"],
      keyword: json["keyword"],
      time: json["time"]
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "keyword" : keyword,
    "time": time
  };
}
