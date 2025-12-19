// lib/screens/client/home_screen.dart
import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../models/produk_model.dart';
import '../../models/pesanan_model.dart';
import '../../models/detail_pesanan_model.dart';
import '../../services/api_service.dart';

class ClientHomeScreen extends StatefulWidget {
  final User user;

  ClientHomeScreen({required this.user});

  @override
  _ClientHomeScreenState createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  List<Produk> _produkList = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final produk = await ApiService.getProduk();
      setState(() {
        _produkList =
            produk; // Tidak perlu filter isActive dulu untuk memastikan data masuk
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  // Fungsi Pesan Langsung (diadaptasi dari kode lama Anda)
  Future<void> _orderNow(Produk produk) async {
    // Tampilkan loading indicator sederhana
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('Sedang memproses pesanan...'),
          duration: Duration(seconds: 1)),
    );

    final result = await ApiService.createPesanan(
      Pesanan(
        userId: widget.user.id!, // Pastikan ID user tidak null
        total_barang: 1,
        total_harga: produk.harga,
        balado: false,
        keju: false,
        pedas: false,
        asin: false,
        barbeque: false,
        status: 'menunggu antrian',
        kodePesanan: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
        tanggalPesanan: DateTime.now(),
        subtotal: produk.harga,
        ongkir: 0.0,
        totalBayar: produk.harga,
        alamatKirim: widget.user.alamat ?? '-',
        kotaTujuan: widget.user.kota ?? '-',
      ),
      [
        DetailPesanan(
          pesananId: 0,
          produkId: produk.id,
          namaProduk: produk.namaProduk,
          hargaSatuan: produk.harga,
          jumlah: 1,
          subtotal: produk.harga,
        ),
      ],
    );

    if (result['success'] == true || result['message'] == 'Success') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Berhasil memesan ${produk.namaProduk}!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal: ${result['message']}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.orange.shade400,
              Colors.orange.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header Custom
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Builder(
                      builder: (context) => InkWell(
                        onTap: () => Scaffold.of(context).openDrawer(),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.menu,
                              color: Colors.orange, size: 28),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Halo, ${widget.user.name}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Mau jajan apa hari ini?',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Content List
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: _isLoading
                      ? const Center(
                          child:
                              CircularProgressIndicator(color: Colors.orange))
                      : _error.isNotEmpty
                          ? Center(child: Text(_error))
                          : _produkList.isEmpty
                              ? const Center(
                                  child: Text('Belum ada menu tersedia'))
                              : RefreshIndicator(
                                  onRefresh: _loadData,
                                  color: Colors.orange,
                                  child: ListView.builder(
                                    padding: const EdgeInsets.all(20),
                                    itemCount: _produkList.length,
                                    itemBuilder: (context, index) {
                                      return _buildProductCard(
                                          _produkList[index]);
                                    },
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

  Widget _buildProductCard(Produk produk) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigasi ke detail (jika ada) atau tampilkan dialog
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Foto Produk
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: produk.gambarUrl.isNotEmpty
                        ? Image.network(
                            produk.gambarUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(Icons.egg,
                                color: Colors.orange, size: 40),
                          )
                        : const Icon(Icons.egg, color: Colors.orange, size: 40),
                  ),
                ),
                const SizedBox(width: 16),

                // Info Produk & Tombol Beli
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        produk.namaProduk,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        produk.deskripsi,
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Rp ${produk.harga.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade700,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => _orderNow(produk),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              minimumSize: Size(0, 36),
                            ),
                            child: Text('Beli'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(widget.user.name),
            accountEmail: Text(widget.user.email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                widget.user.name.isNotEmpty
                    ? widget.user.name[0].toUpperCase()
                    : 'U',
                style: TextStyle(fontSize: 24.0, color: Colors.orange),
              ),
            ),
            decoration: BoxDecoration(color: Colors.orange),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Riwayat Pesanan'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/client/orders',
                  arguments: widget.user);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
          ),
        ],
      ),
    );
  }
}
