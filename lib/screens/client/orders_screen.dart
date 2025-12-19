// lib/screens/client/orders_screen.dart

import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../models/pesanan_model.dart';
import '../../services/api_service.dart';

class OrdersScreen extends StatefulWidget {
  final User user;

  const OrdersScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Pesanan> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);
    try {
      final orders = await ApiService.getPesananByUser(widget.user.id!);
      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat pesanan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Pesanan'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadOrders,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _orders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.receipt_long,
                          size: 80, color: Colors.grey[400]),
                      SizedBox(height: 16),
                      Text(
                        'Anda belum memiliki pesanan.',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: _orders.length,
                  itemBuilder: (context, index) {
                    final pesanan = _orders[index];
                    Color statusColor;
                    switch (pesanan.status) {
                      case 'selesai':
                        statusColor = Colors.green;
                        break;
                      case 'diproses':
                        statusColor = Colors.blue;
                        break;
                      case 'dibatalkan':
                        statusColor = Colors.red;
                        break;
                      default:
                        statusColor = Colors.grey;
                    }

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: ExpansionTile(
                        leading: Icon(Icons.shopping_bag_outlined,
                            color: Theme.of(context).primaryColor),
                        title: Text(
                          'Pesanan: ${pesanan.kodePesanan}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                            'Tanggal: ${pesanan.tanggalPesanan?.toLocal().toString().split(' ')[0] ?? 'N/A'}'),
                        trailing: Chip(
                          label: Text(
                            pesanan.status,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: statusColor,
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (pesanan.details != null &&
                                    pesanan.details!.isNotEmpty)
                                  ...pesanan.details!.map((detail) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                '${detail.namaProduk} x${detail.jumlah}'),
                                            Text(
                                                'Rp ${detail.subtotal.toStringAsFixed(0)}'),
                                          ],
                                        ),
                                      )),
                                Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Total:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        'Rp ${pesanan.totalBayar?.toStringAsFixed(0) ?? '0'}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orange)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
