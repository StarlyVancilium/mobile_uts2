import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal dan mata uang
import '../../models/pesanan_model.dart';
import '../../models/admin_model.dart';
import '../../services/api_service.dart';

class AdminOrdersScreen extends StatefulWidget {
  final Admin admin; // Menerima data admin dari dashboard

  const AdminOrdersScreen({Key? key, required this.admin}) : super(key: key);

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  List<Pesanan> _pesananList = [];
  bool _isLoading = true;

  final List<String> _statuses = [
    'PENDING',
    'PROCESSED',
    'SHIPPED',
    'COMPLETED',
    'CANCELLED'
  ];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);
    try {
      final orders = await ApiService.getAllPesanan();
      setState(() {
        _pesananList = orders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat pesanan: $e')),
      );
    }
  }

  Future<void> _updateStatus(int pesananId, String newStatus) async {
    final result = await ApiService.updateStatusPesanan(pesananId, newStatus);

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status pesanan berhasil diperbarui')),
      );
      _loadOrders(); // Muat ulang data setelah update
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(result['message'] ?? 'Gagal memperbarui status')),
      );
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'PENDING':
        return Colors.orange;
      case 'PROCESSED':
        return Colors.blue;
      case 'SHIPPED':
        return Colors.lightBlue;
      case 'COMPLETED':
        return Colors.green;
      case 'CANCELLED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatCurrency(double amount) {
    // Menggunakan intl package untuk format mata uang Indonesia
    final format =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return format.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kelola Pesanan'),
        backgroundColor: Colors.blue, // Mengikuti tema Admin
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadOrders,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.blue))
          : RefreshIndicator(
              onRefresh: _loadOrders,
              child: _pesananList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox_outlined,
                              size: 80, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('Tidak ada pesanan masuk.'),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(12),
                      itemCount: _pesananList.length,
                      itemBuilder: (context, index) {
                        final pesanan = _pesananList[index];
                        return Card(
                          elevation: 4,
                          margin: EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ExpansionTile(
                            leading: Icon(Icons.shopping_bag,
                                color: _getStatusColor(pesanan.status)),
                            title: Text(
                              '${pesanan.kodePesanan} (${pesanan.user?.name ?? 'N/A'})',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                                'Total: ${_formatCurrency(pesanan.totalBayar)}'),
                            trailing: Chip(
                              label: Text(
                                pesanan.status,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              backgroundColor: _getStatusColor(pesanan.status),
                            ),
                            children: [
                              Divider(height: 1),
                              _buildOrderDetail(pesanan),
                              Divider(height: 1),
                              _buildStatusDropdown(pesanan),
                            ],
                          ),
                        );
                      },
                    ),
            ),
    );
  }

  // Widget untuk menampilkan detail pesanan (alamat, subtotal, ongkir)
  Widget _buildOrderDetail(Pesanan pesanan) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              'Tanggal Pesan: ${DateFormat('dd MMMM yyyy HH:mm').format(pesanan.tanggalPesanan)}',
              style: TextStyle(color: Colors.grey[700])),
          SizedBox(height: 8),
          Text('Alamat Kirim: ${pesanan.alamatKirim}, ${pesanan.kotaTujuan}',
              style: TextStyle(fontWeight: FontWeight.w500)),
          if (pesanan.catatan != null && pesanan.catatan!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text('Catatan: ${pesanan.catatan}',
                  style: TextStyle(fontStyle: FontStyle.italic)),
            ),
          SizedBox(height: 12),
          Text('Produk Dipesan:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          ...pesanan.details!
              .map((detail) => Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${detail.namaProduk} x${detail.jumlah}'),
                        Text(_formatCurrency(detail.subtotal)),
                      ],
                    ),
                  ))
              .toList(),
          Divider(height: 16),
          _buildSummaryRow('Subtotal', pesanan.subtotal),
          _buildSummaryRow('Ongkir', pesanan.ongkir),
          _buildSummaryRow('Total Bayar', pesanan.totalBayar, isTotal: true),
        ],
      ),
    );
  }

  // Widget untuk baris ringkasan
  Widget _buildSummaryRow(String title, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
              color: isTotal ? Colors.black : Colors.grey[700],
            ),
          ),
          Text(
            _formatCurrency(amount),
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
              color: isTotal ? Colors.blue : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk Dropdown Status
  Widget _buildStatusDropdown(Pesanan pesanan) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Ubah Status:', style: TextStyle(fontWeight: FontWeight.bold)),
          DropdownButton<String>(
            value: pesanan.status,
            items: _statuses.map((String status) {
              return DropdownMenuItem<String>(
                value: status,
                child: Text(
                  status,
                  style: TextStyle(
                      color: _getStatusColor(status),
                      fontWeight: FontWeight.bold),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null && newValue != pesanan.status) {
                _updateStatus(pesanan.id!, newValue);
              }
            },
            underline: Container(), // Menghilangkan garis bawah
          ),
        ],
      ),
    );
  }
}
