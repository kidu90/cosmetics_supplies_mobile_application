import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrl = "http://127.0.0.1:8000/api";
  static const storage = FlutterSecureStorage(); // secure token storage

  // products
  static Future<List<dynamic>> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load products: ${response.statusCode}");
    }
  }

// products by id
  static Future<Map<String, dynamic>> fetchProductById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/products/$id'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load product with ID $id");
    }
  }

// categories
  static Future<List<dynamic>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load categories: ${response.statusCode}");
    }
  }

// products by category
  static Future<List<dynamic>> fetchProductsByCategory(int id) async {
    final response =
        await http.get(Uri.parse('$baseUrl/products/categories/$id'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          "Failed to load products for category ID $id: ${response.statusCode}");
    }
  }

// register user
  static Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      // Store the token if it's returned
      if (data['token'] != null) {
        await storage.write(key: 'auth_token', value: data['token']);
      }
      return data;
    } else {
      throw Exception("Registration failed: ${response.body}");
    }
  }

// login user
  static Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Store the token
      if (data['token'] != null) {
        await storage.write(key: 'auth_token', value: data['token']);
      }
      return data;
    } else {
      throw Exception("Login failed: ${response.body}");
    }
  }

  // logout user
  static Future<void> logoutUser() async {
    try {
      final token = await storage.read(key: 'auth_token');
      
      if (token != null) {
        final response = await http.post(
          Uri.parse('$baseUrl/logout'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode != 200) {
          throw Exception("Logout failed: ${response.body}");
        }
      }
    } finally {
      // Always delete the token from storage
      await storage.delete(key: 'auth_token');
    }
  }

  // method to get the auth token
  static Future<String?> getAuthToken() async {
    return await storage.read(key: 'auth_token');
  }

  // method to check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getAuthToken();
    return token != null;
  }


  // method to get the user's name
  static Future<String?> getUserName() async {
    final token = await getAuthToken();
    if (token != null) {
      final response = await http.get(Uri.parse('$baseUrl/user'), headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['name'];
      }
    }
    return null;
  }

  // method to get the user's email
}
