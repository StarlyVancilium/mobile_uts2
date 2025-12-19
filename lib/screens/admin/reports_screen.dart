// lib/screens/admin/reports_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/admin_model.dart';
import '../../models/laporan_model.dart';
import '../../services/api_service.dart';

class AdminReportsScreen extends StatefulWidget {
  final Admin admin;

  const AdminReportsScreen({Key? key, required this.admin}) : super(key: key);

  @override
  State<AdminReportsScreen> createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends State<AdminReportsScreen> {
  List<LaporanPenjualan> _laporanList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    setState(() => _isLoading = true);
    try {
      final laporan = await ApiService.getLaporanPenjualan();
      setState(() {
        _laporanList = laporan;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat laporan: $e')),
      );
    }
  }

  String _formatCurrency(double amount) {
    final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return format.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laporan Penjualan'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadReports,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.blue))
          : RefreshIndicator(
              onRefresh: _loadReports,
              child: _laporanList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.bar_chart, size: 80, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('Tidak ada data laporan penjualan.'),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(12),
                      itemCount: _laporanList.length,
                      itemBuilder: (context, index) {
                        final laporan = _laporanList[index];
                        return Card(
                          margin: EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat('dd MMMM yyyy').format(laporan.tanggal),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[700],
                                  ),
                                ),
                                Divider(height: 16),
                                _buildReportRow('Total Pesanan', laporan.totalPesanan.toString(), Icons.receipt),
                                _buildReportRow('Total Pendapatan', _formatCurrency(laporan.totalPendapatan), Icons.monetization_on, color: Colors.green),
                                _buildReportRow('Rata-rata Pesanan', _formatCurrency(laporan.rataPesanan), Icons.trending_up),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }

  Widget _buildReportRow(String title, String value, IconData icon, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color ?? Colors.grey[700]),
          SizedBox(width: 12),
          Expanded(child: Text(title, style: TextStyle(fontSize: 16))),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}