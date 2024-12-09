class Cart{
  String id;
  String name;
  String description;
  double price;
  String unit;
  String imageUrl;
  int quantity;
  double totalPrice;
  int createdAt;

  Cart({required this.id, required this.name, required this.description, required this.price, required this.unit,
    required this.imageUrl, required this.quantity, required this.createdAt, required this.totalPrice});

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "name": this.name,
      "description": this.description,
      "price": this.price,
      "unit": this.unit,
      "imageUrl": this.imageUrl,
      "quantity": this.quantity,
      "totalPrice": this.totalPrice,
      "createdAt": this.createdAt,
    };
  }

  factory Cart.fromJson(dynamic json) {
    return Cart(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      price: double.parse(json["price"].toString()),
      unit: json["unit"],
      imageUrl: json["imageUrl"],
      quantity: int.parse(json["quantity"].toString()),
      totalPrice: double.parse(json["totalPrice"].toString()),
      createdAt: json["createdAt"],
    );
  }
//
}