import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/product_model.dart';

class ProductService {
  final String _baseUrl = dotenv.env['BASE_URL'] ?? '';

  Future<List<ProductModel>> getProducts() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/products'),
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat daftar produk');
    }
  }

  Future<ProductModel> getProductDetail(int productId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/products/$productId'),
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      // PERBAIKAN: Mengembalikan ProductModel.fromJson, bukan Map
      return ProductModel.fromJson(data);
    } else {
      throw Exception('Gagal memuat detail produk');
    }
  }
}