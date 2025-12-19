class ProductModel {
  final int id; // Tambahkan ini
  final String nama_produk;
  final int ketersediaan_stok;
  final String description;
  final int harga;
  final String foto;
  final String foto_url; // Tambahkan ini untuk URL gambar lengkap

  ProductModel({
    required this.id,
    required this.nama_produk,
    required this.ketersediaan_stok,
    required this.description,
    required this.harga,
    required this.foto,
    required this.foto_url,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      // Gunakan tryParse agar aman dari error "String is not subtype of int"
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      nama_produk: json['nama_produk']?.toString() ?? '',
      ketersediaan_stok: int.tryParse(json['ketersediaan_stok']?.toString() ?? '0') ?? 0,
      description: json['description']?.toString() ?? '',
      harga: (double.tryParse(json['harga']?.toString() ?? '0') ?? 0).toInt(),
      foto: json['foto']?.toString() ?? '',
      foto_url: json['foto_url']?.toString() ?? '', // Ambil URL lengkap dari backend
    );
  }
}