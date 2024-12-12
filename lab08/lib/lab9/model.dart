// lib/model/user.dart

class User {
  final int id; // Ensure this exists
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  // From JSON to User object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'], // Ensure the 'id' is fetched correctly
      name: json['name'],
      email: json['email'],
    );
  }

  // Convert User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id, // Ensure 'id' is part of the JSON serialization
      'name': name,
      'email': email,
    };
  }
}
