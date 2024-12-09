class Category{
  String? id;
  String name;
  String description;
  String imageUrl;
  int createdAt;
  bool isActive;

  Category({this.id, required this.name, required this.description, required this.imageUrl, required this.createdAt,required this.isActive});

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description":description,
      "imageUrl": imageUrl,
      "createdAt": createdAt,
      "isActive" : isActive
    };
  }

  factory Category.fromJson(dynamic json) {
    return Category(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      imageUrl: json["imageUrl"],
      createdAt: json["createdAt"],
      isActive: json["isActive"]
    );
  }
//
}