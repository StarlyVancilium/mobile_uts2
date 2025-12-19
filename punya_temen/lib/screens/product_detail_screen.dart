import 'package:flutter/material.dart';
import '../services/product_service.dart';
import '../services/order_services.dart';
import '../models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductService _productService = ProductService();
  
  ProductModel? _product;
  bool _loading = true;
  bool _ordering = false;
  String _error = '';

  int _quantity = 1;
  bool _balado = false;
  bool _keju = false;
  bool _pedas = false;
  bool _asin = false;
  bool _barbeque = false;

  @override
  void initState() {
    super.initState();
    _loadProductDetail();
  }

  Future<void> _loadProductDetail() async {
    setState(() {
      _loading = true;
      _error = '';
    });

    try {
      final products = await _productService.getProducts();
      final product = products.firstWhere((p) => p.id == widget.productId);
      
      setState(() {
        _product = product;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _createOrder() async {
    setState(() => _ordering = true);

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token != null) {
        // PERBAIKAN: Menggunakan named argument token: token
        final orderService = OrderService(token: token);
        
        // PERBAIKAN: Memanggil method createOrder (sesuai yang ada di order_services.dart)
        final success = await orderService.createOrder(
          productId: widget.productId,
          totalBarang: _quantity,
          balado: _balado,
          keju: _keju,
          pedas: _pedas,
          asin: _asin,
          barbeque: _barbeque,
        );

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Pesanan berhasil dibuat!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pop(context);
        } else {
          throw Exception('Gagal membuat pesanan. Cek stok produk.');
        }
      } else {
        throw Exception('Sesi habis, silakan login kembali.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    setState(() => _ordering = false);
  }

  int _calculateTotal() { // Ubah dari double ke int
  if (_product == null) return 0;
  return _product!.harga * _quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade400, Colors.orange.shade50],
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
                      ElevatedButton(
                        onPressed: _loadProductDetail,
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                )
              : Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 300,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.orange.shade400,
                                  Colors.orange.shade600,
                                ],
                              ),
                            ),
                            child: Stack(
                              children: [
                                Center(
                                 child: (_product?.foto_url != null && _product!.foto_url.isNotEmpty)
                              ? Image.network(
                                  _product!.foto_url, 
                                  fit: BoxFit.cover, 
                                  width: double.infinity,
                                  // Tambahkan loading builder agar lebih rapi
                                  errorBuilder: (context, error, stackTrace) => const Icon(
                                    Icons.broken_image,
                                    size: 120,
                                    color: Colors.grey,
                                  ),
                                )
                              : Icon(
                                  Icons.egg,
                                  size: 120,
                                  color: Colors.white.withOpacity(0.3),
                                ),
                                ),
                                SafeArea(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: IconButton(
                                            icon: const Icon(Icons.arrow_back),
                                            onPressed: () => Navigator.pop(context),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            transform: Matrix4.translationValues(0, -30, 0),
                            padding: const EdgeInsets.all(24),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _product?.nama_produk ?? '',
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _product?.description ?? 'Tidak ada deskripsi',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey.shade600,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade50,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    'Rp ${_product?.harga}',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange.shade700,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                const Text('Jumlah', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _buildQuantityButton(
                                        icon: Icons.remove,
                                        onPressed: () { if (_quantity > 1) setState(() => _quantity--); },
                                      ),
                                      Container(
                                        width: 60,
                                        alignment: Alignment.center,
                                        child: Text('$_quantity', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                      ),
                                      _buildQuantityButton(
                                        icon: Icons.add,
                                        onPressed: () => setState(() => _quantity++),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 30),
                                const Text('Pilihan Rasa', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: [
                                    _buildToppingChip('Balado', _balado, (v) => setState(() => _balado = v)),
                                    _buildToppingChip('Keju', _keju, (v) => setState(() => _keju = v)),
                                    _buildToppingChip('Pedas', _pedas, (v) => setState(() => _pedas = v)),
                                    _buildToppingChip('Asin', _asin, (v) => setState(() => _asin = v)),
                                    _buildToppingChip('Barbeque', _barbeque, (v) => setState(() => _barbeque = v)),
                                  ],
                                ),
                                const SizedBox(height: 100),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0, left: 0, right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5))],
                        ),
                        child: SafeArea(
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Total', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                                    Text('Rp ${_calculateTotal()}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange)),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: SizedBox(
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed: _ordering ? null : _createOrder,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                    ),
                                    child: _ordering 
                                      ? const SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                        )
                                      : const Text('Pesan Sekarang', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildQuantityButton({required IconData icon, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: IconButton(icon: Icon(icon), onPressed: onPressed, color: Colors.orange),
    );
  }

  Widget _buildToppingChip(String label, bool selected, Function(bool) onSelected) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      selectedColor: Colors.orange.shade100,
      checkmarkColor: Colors.orange,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}