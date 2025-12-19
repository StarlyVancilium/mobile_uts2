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

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final produk = await ApiService.getProduk();

    setState(() {
      _produkList = produk.where((p) => p.isActive).toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Toko Telur Gulung'),
        backgroundColor: Colors.orange,
      ),
      drawer: _buildDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: GridView.builder(
                padding: EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _produkList.length,
                itemBuilder: (context, index) {
                  final produk = _produkList[index];
                  return _buildProdukCard(produk);
                },
              ),
            ),
    );
  }

  Widget _buildProdukCard(Produk produk) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Center(
                child: Icon(Icons.egg_outlined, size: 80, color: Colors.orange),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  produk.namaProduk,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  'Rp ${produk.harga.toStringAsFixed(0)}',
                  style: TextStyle(
                      color: Colors.orange, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text('Stok: ${produk.stok}',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: produk.stok > 0 ? () => _orderNow(produk) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(vertical: 8),
                    ),
                    child:
                        Text('Pesan Sekarang', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _orderNow(Produk produk) async {
    // For now, order with default options (no toppings)
    final result = await ApiService.createPesanan(
      Pesanan(
        userId: widget.user.id!,
        kodePesanan: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
        tanggalPesanan: DateTime.now(),
        status: 'menunggu antrian',
        subtotal: produk.harga,
        ongkir: 0.0,
        totalBayar: produk.harga,
        alamatKirim: widget.user.alamat ?? 'Alamat Default',
        kotaTujuan: widget.user.kota,
      ),
      [
        DetailPesanan(
          pesananId: 0, // Will be set by backend
          produkId: produk.id!,
          namaProduk: produk.namaProduk,
          hargaSatuan: produk.harga,
          jumlah: 1,
          subtotal: produk.harga,
        ),
      ],
    );

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${produk.namaProduk} berhasil dipesan')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memesan: ${result['message']}')),
      );
    }
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(widget.user.name),
            accountEmail: Text(widget.user.email),
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
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Tentang'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/about');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
          ),
        ],
      ),
    );
  }
}
