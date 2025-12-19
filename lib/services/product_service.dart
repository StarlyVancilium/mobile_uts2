import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/produk_model.dart';

class ProductService {
  final String _baseUrl =
      'https://backendsistemtelorgulung-production.up.railway.app/api';

  Future<List<Produk>> getProducts() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/products'),
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((e) => Produk.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat daftar produk');
    }
  }

  Future<Produk> getProductDetail(int productId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/products/$productId'),
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      // PERBAIKAN: Mengembalikan ProductModel.fromJson, bukan Map
      return Produk.fromJson(data);
    } else {
      throw Exception('Gagal memuat detail produk');
    }
  }
}
