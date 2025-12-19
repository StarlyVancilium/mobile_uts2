import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/order_model.dart';

class OrderService {
  final String _baseUrl = dotenv.env['BASE_URL'] ?? '';
  final String? token;

  OrderService({this.token});

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  Future<bool> createOrder({
    required int productId,
    required int totalBarang,
    bool balado = false,
    bool keju = false,
    bool pedas = false,
    bool asin = false,
    bool barbeque = false,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/orders'),
      headers: _headers,
      body: jsonEncode({
        'product_id': productId,
        'total_barang': totalBarang,
        'balado': balado,
        'keju': keju,
        'pedas': pedas,
        'asin': asin,
        'barbeque': barbeque,
      }),
    );
    return response.statusCode == 201;
  }

  Future<List<OrderModel>> getMyOrders() async {
    final response = await http.get(Uri.parse('$_baseUrl/orders'), headers: _headers);
    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((e) => OrderModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat riwayat pesanan');
    }
  }

  Future<OrderModel> showOrder(int orderId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/orders/$orderId'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return OrderModel.fromJson(data);
    } else {
      throw Exception('Gagal memuat detail pesanan');
    }
  }

  Future<OrderModel> getOrderDetail(int orderId) => showOrder(orderId);
}