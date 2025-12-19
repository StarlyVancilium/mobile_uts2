// lib/screens/admin/products_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/admin_model.dart';
import '../../models/produk_model.dart';
import '../../services/api_service.dart';

class AdminProductsScreen extends StatefulWidget {
  final Admin admin;

  const AdminProductsScreen({Key? key, required this.admin}) : super(key: key);

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  List<Produk> _produkList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProduk();
  }

  Future<void> _loadProduk() async {
    setState(() => _isLoading = true);
    final produk = await ApiService.getProduk();
    setState(() {
      _produkList = produk;
      _isLoading = false;
    });
  }

  Future<void> _deleteProduk(int id) async {
    final result = await ApiService.deleteProduk(id);
    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Produk berhasil dihapus')),
      );
      _loadProduk();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Gagal menghapus produk')),
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
        title: Text('Kelola Produk'),
        backgroundColor: Colors.blue,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.blue))
          : RefreshIndicator(
              onRefresh: _loadProduk,
              child: ListView.builder(
                padding: EdgeInsets.all(12),
                itemCount: _produkList.length,
                itemBuilder: (context, index) {
                  final produk = _produkList[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Icon(Icons.egg_outlined, size: 40, color: produk.isActive ? Colors.blue : Colors.grey),
                      title: Text(produk.namaProduk, style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_formatCurrency(produk.harga), style: TextStyle(color: Colors.green)),
                          Text('Stok: ${produk.stok} | Kategori: ${produk.namaKategori ?? '-'}'),
                          Text(produk.isActive ? 'Status: Aktif' : 'Status: Nonaktif', style: TextStyle(color: produk.isActive ? Colors.blue : Colors.red)),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.indigo),
                            onPressed: () => _showProductForm(context, produk: produk),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteProduk(produk.id!),
                          ),
                        ],
                      ),
                      onTap: () => _showProductForm(context, produk: produk),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () => _showProductForm(context),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showProductForm(BuildContext context, {Produk? produk}) {
    // Implementasi sederhana form dalam dialog
    final isEditing = produk != null;
    final TextEditingController namaController = TextEditingController(text: produk?.namaProduk);
    final TextEditingController hargaController = TextEditingController(text: produk?.harga.toString());
    final TextEditingController stokController = TextEditingController(text: produk?.stok.toString());
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Produk' : 'Tambah Produk Baru'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: namaController, decoration: InputDecoration(labelText: 'Nama Produk')),
                TextField(controller: hargaController, decoration: InputDecoration(labelText: 'Harga'), keyboardType: TextInputType.number),
                TextField(controller: stokController, decoration: InputDecoration(labelText: 'Stok'), keyboardType: TextInputType.number),
                // Asumsi: TextField lain untuk kategori_id, deskripsi, dll.
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newProduk = Produk(
                  id: produk?.id,
                  namaProduk: namaController.text,
                  harga: double.tryParse(hargaController.text) ?? 0.0,
                  stok: int.tryParse(stokController.text) ?? 0,
                  // Asumsi data lain adalah default atau tidak diubah
                );

                final result = isEditing 
                    ? await ApiService.updateProduk(newProduk)
                    : await ApiService.createProduk(newProduk);

                Navigator.pop(context);
                if (result['success']) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Produk berhasil ${isEditing ? 'diupdate' : 'ditambahkan'}')),
                  );
                  _loadProduk();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(result['message'] ?? 'Gagal menyimpan produk')),
                  );
                }
              },
              child: Text(isEditing ? 'Simpan' : 'Tambah'),
            ),
          ],
        );
      },
    );
  }
}