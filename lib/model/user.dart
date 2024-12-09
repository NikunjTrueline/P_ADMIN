class UserData {
  final String id;
  final String contact;
  final int createdAt;
  final String email;
  final String name;

  UserData({required this.id, required this.contact, required this.createdAt, required this.email, required this.name});

  factory UserData.fromJson(Map<dynamic, dynamic> json) {
    return UserData(
      id: json['id'],
      contact: json['contact'],
      createdAt: json['createdAt'],
      email: json['email'] ?? '', // Use get method to handle null
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "contact": this.contact,
      "name": this.name,
      "email": this.email,
      "createdAt": this.createdAt,
    };
  }
}