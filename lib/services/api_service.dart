import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrl = "http://127.0.0.1:8000/api";
  static const storage = FlutterSecureStorage(); // secure token storage

  // Session ID methods
  static Future<void> saveSessionId(String sessionId) async {
    await storage.write(key: 'session_id', value: sessionId);
  }

  static Future<String?> getSessionId() async {
    return await storage.read(key: 'session_id');
  }

  static Future<void> clearSessionId() async {
    await storage.delete(key: 'session_id');
  }

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
      // Store the token and session ID if they're returned
      if (data['token'] != null) {
        await storage.write(key: 'auth_token', value: data['token']);
      }
      if (data['session_id'] != null) {
        await saveSessionId(data['session_id']);
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
      // Store the token and session ID
      if (data['token'] != null) {
        await storage.write(key: 'auth_token', value: data['token']);
      }
      if (data['session_id'] != null) {
        await saveSessionId(data['session_id']);
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
      // Always delete the token and session ID from storage
      await storage.delete(key: 'auth_token');
      await clearSessionId();
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
      final response = await http.get(Uri.parse('$baseUrl/user'),
          headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['name'];
      }
    }
  }

  // Cart endpoints
  static Future<List<dynamic>> getCart() async {
    final token = await getAuthToken();
    final sessionId = await getSessionId();
    if (token == null && sessionId == null)
      throw Exception('Not authenticated');

    final response = await http.get(
      Uri.parse('$baseUrl/cart'),
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
        if (sessionId != null) 'X-Session-ID': sessionId,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch cart: ${response.body}");
    }
  }

  static Future<void> addToCart(int productId, int quantity) async {
    final token = await getAuthToken();
    final sessionId = await getSessionId();
    if (token == null && sessionId == null)
      throw Exception('Not authenticated');

    final response = await http.post(
      Uri.parse('$baseUrl/cart/add'),
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
        if (sessionId != null) 'X-Session-ID': sessionId,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'product_id': productId,
        'quantity': quantity,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to add to cart: ${response.body}");
    }
  }

  static Future<void> updateCartItem(int id, int quantity) async {
    final token = await getAuthToken();
    final sessionId = await getSessionId();
    if (token == null && sessionId == null)
      throw Exception('Not authenticated');

    final response = await http.put(
      Uri.parse('$baseUrl/cart/update/$id'),
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
        if (sessionId != null) 'X-Session-ID': sessionId,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'quantity': quantity,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update cart: ${response.body}");
    }
  }

  static Future<void> removeFromCart(int id) async {
    final token = await getAuthToken();
    final sessionId = await getSessionId();
    if (token == null && sessionId == null)
      throw Exception('Not authenticated');

    final response = await http.delete(
      Uri.parse('$baseUrl/cart/remove/$id'),
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
        if (sessionId != null) 'X-Session-ID': sessionId,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to remove from cart: ${response.body}");
    }
  }

  static Future<int> getCartCount() async {
    final token = await getAuthToken();
    final sessionId = await getSessionId();
    if (token == null && sessionId == null)
      throw Exception('Not authenticated');

    final response = await http.get(
      Uri.parse('$baseUrl/cart/count'),
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
        if (sessionId != null) 'X-Session-ID': sessionId,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['count'] ?? 0;
    } else {
      throw Exception("Failed to get cart count: ${response.body}");
    }
  }

  // Get reviews for a product
  static Future<List<dynamic>> getProductReviews(int id) async {
    final token = await getAuthToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await http.get(
      Uri.parse('$baseUrl/products/$id/reviews'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load reviews: ${response.body}');
    }
  }

  // Submit a new review
  static Future<Map<String, dynamic>> submitReview({
    required int productId,
    required int rating,
    required String comment,
    File? photo,
  }) async {
    final token = await getAuthToken();
    if (token == null) throw Exception('Not authenticated');

    // Create multipart request
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/reviews'),
    );

    // Add authorization header
    request.headers.addAll({
      'Authorization': 'Bearer $token',
    });

    // Add text fields
    request.fields.addAll({
      'product_id': productId.toString(),
      'rating': rating.toString(),
      'comment': comment,
    });

    // Add photo if provided
    if (photo != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'photo',
          photo.path,
        ),
      );
    }

    try {
      // Send the request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to submit review: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error submitting review: $e');
    }
  }

  // Order endpoints
  static Future<List<dynamic>> getOrders() async {
    final token = await getAuthToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await http.get(
      Uri.parse('$baseUrl/orders'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load orders: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> getOrderDetails(int orderId) async {
    final token = await getAuthToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await http.get(
      Uri.parse('$baseUrl/orders/$orderId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load order details: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> createOrder({
    required String shippingName,
    required String shippingEmail,
    required String shippingPhone,
    required String shippingAddress,
    required String shippingCity,
    required String shippingState,
    required String shippingPostalCode,
    String? notes,
  }) async {
    final token = await getAuthToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'shipping_name': shippingName,
        'shipping_email': shippingEmail,
        'shipping_phone': shippingPhone,
        'shipping_address': shippingAddress,
        'shipping_city': shippingCity,
        'shipping_state': shippingState,
        'shipping_postal_code': shippingPostalCode,
        'notes': notes,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create order: ${response.body}');
    }
  }
}
