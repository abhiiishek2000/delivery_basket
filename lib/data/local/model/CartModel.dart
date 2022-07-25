import 'dart:convert';

Cart clientFromJson(String str) {
  final jsonData = json.decode(str);
  return Cart.fromMap(jsonData);
}

String clientToJson(Cart data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Cart {
  int id;
  int prodId;
  String name;
  int quantity;

  Cart({
    required this.id,
    required this.prodId,
    required this.name,
    required this.quantity
  });

  //id,pro_id,name,quantity
  factory Cart.fromMap(Map<String, dynamic> json) => new Cart(
        id: json["id"],
        prodId: json["pro_id"],
        name: json["name"],
        quantity: json["quantity"]
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "pro_id" : prodId,
        "name": name,
        "quantity":quantity
      };
}
