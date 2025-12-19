import 'package:flutter/material.dart';
import '../services/order_services.dart';
import '../models/order_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetailScreen extends StatefulWidget {
  final OrderModel? order; // Bisa menerima objek langsung
  final int? orderId;     // Atau menerima ID untuk di-load

  const OrderDetailScreen({this.order, this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  OrderModel? _order;
  bool _loading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    if (widget.order != null) {
      _order = widget.order;
      _loading = false;
    } else {
      _loadOrderDetail();
    }
  }

  Future<void> _loadOrderDetail() async {
    setState(() {
      _loading = true;
      _error = '';
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token != null) {
        // PERBAIKAN: Menggunakan named parameter 'token:' dan variabel 'token'
        final orderService = OrderService(token: token);
        
        // Memanggil method showOrder (pastikan sudah ada di order_services.dart)
        final order = await orderService.showOrder(widget.orderId!);
        setState(() {
          _order = order;
          _loading = false;
        });
      } else {
        setState(() {
          _error = 'Sesi habis, silakan login kembali';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Gagal memuat detail: ${e.toString()}';
        _loading = false;
      });
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'menunggu antrian':
      case 'pending':
        return Colors.orange;
      case 'diproses':
        return Colors.blue;
      case 'selesai':
        return Colors.green;
      case 'dibatalkan':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade400, Colors.blue.shade50],
                ),
              ),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            )
          : _error.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(_error),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadOrderDetail,
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.blue.shade400,
                        Colors.white,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_back),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Text(
                                'Detail Pesanan',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  _buildStatusCard(),
                                  const SizedBox(height: 20),
                                  _buildInfoCard(),
                                  const SizedBox(height: 20),
                                  _buildProductCard(),
                                  const SizedBox(height: 20),
                                  _buildToppingsCard(),
                                  const SizedBox(height: 20),
                                  _buildPriceSummaryCard(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildStatusCard() {
    final status = _order?.status ?? 'pending';
    final statusColor = _getStatusColor(status);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getStatusIcon(status),
              size: 48,
              color: statusColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getStatusMessage(status),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informasi Pesanan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.receipt, 'Order ID', '#${_order?.id}'),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.calendar_today, 'Status Saat Ini', _order?.status ?? '-'),
        ],
      ),
    );
  }

  Widget _buildProductCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(Icons.egg, size: 40, color: Colors.orange),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(
  _order?.productName ?? 'Produk', // PERBAIKAN
  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
),
const SizedBox(height: 8),
Container(
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  decoration: BoxDecoration(
    color: Colors.blue.shade50,
    borderRadius: BorderRadius.circular(12),
  ),
  child: Text(
    'Jumlah: ${_order?.total_barang} item', // PERBAIKAN
    style: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.bold,
      color: Colors.blue.shade700,
    ),
  ),
),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToppingsCard() {
    final toppings = <String>[];
    if (_order?.balado == true) toppings.add('Balado');
    if (_order?.keju == true) toppings.add('Keju');
    if (_order?.pedas == true) toppings.add('Pedas');
    if (_order?.asin == true) toppings.add('Asin');
    if (_order?.barbeque == true) toppings.add('Barbeque');

    if (toppings.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.restaurant_menu, color: Colors.orange),
              SizedBox(width: 8),
              Text('Pilihan Rasa', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: toppings.map((topping) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.orange.shade300),
              ),
              child: Text(topping, style: TextStyle(color: Colors.orange.shade700, fontWeight: FontWeight.bold)),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.blue.shade700, Colors.blue.shade500]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Harga', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              Text(
  'Rp ${_order?.total_harga}', // PERBAIKAN
  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)
),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blue),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'menunggu antrian':
        return Icons.access_time;
      case 'diproses':
        return Icons.restaurant;
      case 'selesai':
        return Icons.check_circle;
      case 'dibatalkan':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  String _getStatusMessage(String status) {
    switch (status.toLowerCase()) {
      case 'menunggu antrian':
        return 'Pesanan Anda menunggu antrian';
      case 'diproses':
        return 'Pesanan Anda sedang dimasak';
      case 'selesai':
        return 'Pesanan sudah siap dinikmati!';
      case 'dibatalkan':
        return 'Pesanan telah dibatalkan';
      default:
        return 'Status tidak diketahui';
    }
  }
}