// lib/services/api.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lab08/lab9/model.dart';

class ApiService {
  final String baseUrl = "https://jsonplaceholder.typicode.com";

  // Fetch Users
  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  // Create a new User
  Future<User> createUser(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      body: json.encode(user.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create user');
    }
  }

  // Update User
  Future<User> updateUser(int id, User user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/$id'),
      body: json.encode(user.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update user');
    }
  }

  // Delete User
  Future<void> deleteUser(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/users/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }
}
