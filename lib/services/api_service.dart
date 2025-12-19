import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/produk_model.dart';
import '../models/keranjang_model.dart';
import '../models/pesanan_model.dart';
import '../models/ongkir_model.dart';
import '../models/detail_pesanan_model.dart';

class ApiService {
  // Ganti dengan URL API Anda
  static const String baseUrl =
      'https://backendsistemtelorgulung-production.up.railway.app/api';

  // SharedPreferences keys
  static const String _tokenKey = 'auth_token';
  static const String _roleKey = 'user_role';
  static const String _userKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';

  // Headers
  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // Get headers with token
  static Future<Map<String, String>> get headersWithToken async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ==================== SHARED PREFERENCES METHODS ====================

  // Save login data
  static Future<void> saveLoginData(
      String token, String role, User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_roleKey, role);
    await prefs.setString(_userKey, json.encode(user.toJson()));
    await prefs.setBool(_isLoggedInKey, true);
  }

  // Get token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Get role
  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey);
  }

  // Get user data
  static Future<User?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      return User.fromJson(json.decode(userJson));
    }
    return null;
  }

  // Check if logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Get login info as variables
  static Future<Map<String, dynamic>> getLoginInfo() async {
    final isLoggedIn = await ApiService.isLoggedIn();
    final token = await ApiService.getToken();
    final role = await ApiService.getRole();
    final user = await ApiService.getUserData();

    return {
      'isLoggedIn': isLoggedIn,
      'token': token,
      'role': role,
      'user': user,
    };
  }

  // ==================== AUTH SERVICES ====================

  // Register User
  static Future<Map<String, dynamic>> registerUser(
      Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: headers,
        body: json.encode(data),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        var body = json.decode(response.body);
        return {
          'success': true,
          'message': body['message'] ?? 'Success',
          'data': body['data'] ?? body
        };
      } else {
        var body = json.decode(response.body);
        String message = body['message'] ?? 'Registration failed';
        if (body.containsKey('errors')) {
          // Laravel validation errors
          var errors = body['errors'] as Map<String, dynamic>;
          message += '\n' + errors.values.map((e) => e.join(', ')).join('\n');
        }
        return {'success': false, 'message': message};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Login Admin
  static Future<Map<String, dynamic>> loginAdmin(
      String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/admin/login'),
        headers: headers,
        body: json.encode({'username': username, 'password': password}),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        var body = json.decode(response.body);
        // Assuming response contains 'token' and 'user'
        final token = body['token'] as String?;
        final userData = body['user'] ?? body['data'] ?? body;
        final user = User.fromJson(userData);

        // Save to SharedPreferences
        if (token != null) {
          await saveLoginData(token, user.role, user);
        }

        return {
          'success': true,
          'message': body['message'] ?? 'Login successful',
          'data': userData
        };
      } else {
        var body = json.decode(response.body);
        final message = body['message'] ?? 'Login failed';

        // Debug: Print error to console if in debug mode
        if (kDebugMode) {
          print('Admin login failed: $message');
          print('Response status: ${response.statusCode}');
          print('Response body: ${response.body}');
        }

        return {'success': false, 'message': message};
      }
    } catch (e) {
      // Debug: Print error to console if in debug mode
      if (kDebugMode) {
        print('Admin login error: $e');
      }

      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Login User
  static Future<Map<String, dynamic>> loginUser(
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: headers,
        body: json.encode({'email': email, 'password': password}),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        var body = json.decode(response.body);
        // Assuming response contains 'token' and 'user'
        final token = body['token'] as String?;
        final userData = body['user'] ?? body['data'] ?? body;
        final user = User.fromJson(userData);

        // Save to SharedPreferences
        if (token != null) {
          await saveLoginData(token, user.role, user);
        }

        return {
          'success': true,
          'message': body['message'] ?? 'Login successful',
          'data': userData
        };
      } else {
        var body = json.decode(response.body);
        final message = body['message'] ?? 'Login failed';

        // Debug: Print error to console if in debug mode
        if (kDebugMode) {
          print('User login failed: $message');
          print('Response status: ${response.statusCode}');
          print('Response body: ${response.body}');
        }

        return {'success': false, 'message': message};
      }
    } catch (e) {
      // Debug: Print error to console if in debug mode
      if (kDebugMode) {
        print('User login error: $e');
      }

      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // ==================== PRODUK SERVICES ====================

  // Get all products
  static Future<List<Produk>> getProduk() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return (data['data'] as List)
              .map((produk) => Produk.fromJson(produk))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error getProduk: $e');
      return [];
    }
  }

  // Create product (admin)
  static Future<Map<String, dynamic>> createProduk(Produk produk) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/produk/create.php'),
        headers: headers,
        body: json.encode(produk.toJson()),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Update product (admin)
  static Future<Map<String, dynamic>> updateProduk(Produk produk) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/produk/update.php'),
        headers: headers,
        body: json.encode(produk.toJson()),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Delete product (admin)
  static Future<Map<String, dynamic>> deleteProduk(int produkId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/produk/delete.php?id=$produkId'),
        headers: headers,
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // ==================== KERANJANG SERVICES ====================

  // Get cart by user
  static Future<List<Keranjang>> getKeranjang(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/keranjang/get_by_user.php?user_id=$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return (data['data'] as List)
              .map((item) => Keranjang.fromJson(item))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error getKeranjang: $e');
      return [];
    }
  }

  // Add to cart
  static Future<Map<String, dynamic>> addToKeranjang(
      int userId, int produkId, int jumlah,
      {bool balado = false,
      bool keju = false,
      bool pedas = false,
      bool asin = false,
      bool barbeque = false}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/keranjang/add.php'),
        headers: headers,
        body: json.encode({
          'user_id': userId,
          'produk_id': produkId,
          'jumlah': jumlah,
          'balado': balado,
          'keju': keju,
          'pedas': pedas,
          'asin': asin,
          'barbeque': barbeque,
        }),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Update cart
  static Future<Map<String, dynamic>> updateKeranjang(
      int keranjangId, int jumlah) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/keranjang/update.php'),
        headers: headers,
        body: json.encode({
          'id': keranjangId,
          'jumlah': jumlah,
        }),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Remove from cart
  static Future<Map<String, dynamic>> removeFromKeranjang(
      int keranjangId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/keranjang/delete.php?id=$keranjangId'),
        headers: headers,
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Clear cart
  static Future<Map<String, dynamic>> clearKeranjang(int userId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/keranjang/clear.php?user_id=$userId'),
        headers: headers,
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // ==================== PESANAN SERVICES ====================

  // Create order
  static Future<Map<String, dynamic>> createPesanan(
      Pesanan pesanan, List<DetailPesanan> details) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/orders'),
        headers: headers,
        body: json.encode({
          'pesanan': pesanan.toJson(),
          'details': details.map((d) => d.toJson()).toList(),
        }),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Get orders by user
  static Future<List<Pesanan>> getPesananByUser(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/orders?user_id=$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return (data['data'] as List)
              .map((pesanan) => Pesanan.fromJson(pesanan))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error getPesananByUser: $e');
      return [];
    }
  }

  // ==================== ONGKIR SERVICE (RajaOngkir API) ====================

  static Future<List<OngkirResult>> getOngkir(
      String origin, String destination, int weight) async {
    try {
      // Ganti dengan API KEY RajaOngkir Anda
      const String apiKey = 'YOUR_RAJAONGKIR_API_KEY';

      final response = await http.post(
        Uri.parse('https://api.rajaongkir.com/starter/cost'),
        headers: {
          'key': apiKey,
          'content-type': 'application/x-www-form-urlencoded',
        },
        body: {
          'origin': origin, // ID kota asal (misal: 23 untuk Bandung)
          'destination': destination, // ID kota tujuan
          'weight': weight.toString(), // dalam gram
          'courier': 'jne', // bisa jne, pos, tiki
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['rajaongkir']['status']['code'] == 200) {
          final results = data['rajaongkir']['results'][0]['costs'] as List;
          return results.map((cost) => OngkirResult.fromJson(cost)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error getOngkir: $e');
      return [];
    }
  }
}
