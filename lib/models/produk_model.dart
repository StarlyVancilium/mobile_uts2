// lib/models/produk_model.dart
class Produk {
  final int id;
  final int kategoriId;
  final String namaProduk;
  final String deskripsi;
  final double harga;
  final int stok;
  final String gambarUrl;
  final bool isActive;
  final String? namaKategori;

  Produk({
    this.id = 0,
    this.kategoriId = 0,
    required this.namaProduk,
    required this.deskripsi,
    required this.harga,
    required this.stok,
    required this.gambarUrl,
    this.isActive = true,
    this.namaKategori,
  });

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      kategoriId: int.tryParse(json['kategori_id']?.toString() ?? '0') ?? 0,
      // Menyesuaikan key dengan referensi 'punya_temen'
      namaProduk: json['nama_produk']?.toString() ?? 'Tanpa Nama',
      deskripsi: json['description']?.toString() ?? json['deskripsi'] ?? '-',
      harga: double.tryParse(json['harga']?.toString() ?? '0') ?? 0.0,
      stok: int.tryParse(json['ketersediaan_stok']?.toString() ??
              json['stok']?.toString() ??
              '0') ??
          0,
      // Referensi menggunakan 'foto_url' untuk gambar lengkap
      gambarUrl: json['foto_url']?.toString() ?? json['gambar_url'] ?? '',
      isActive: true, // Asumsikan aktif jika data muncul dari API
      namaKategori: json['nama_kategori']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_produk': namaProduk,
      'harga': harga,
      'stok': stok,
      'description': deskripsi,
    };
  }
}
