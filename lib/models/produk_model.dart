class Produk {
  final int? id;
  final int? kategoriId;
  final String namaProduk;
  final String? deskripsi;
  final double harga;
  final int stok;
  final String? gambarUrl;
  final bool isActive;
  final String? namaKategori;

  Produk({
    this.id,
    this.kategoriId,
    required this.namaProduk,
    this.deskripsi,
    required this.harga,
    required this.stok,
    this.gambarUrl,
    this.isActive = true,
    this.namaKategori,
  });

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      id: json['id'],
      kategoriId: json['kategori_id'],
      namaProduk: json['nama_produk'],
      deskripsi: json['deskripsi'],
      harga: double.parse(json['harga'].toString()),
      stok: json['stok'],
      gambarUrl: json['gambar_url'],
      isActive: json['is_active'] == 1,
      namaKategori: json['nama_kategori'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kategori_id': kategoriId,
      'nama_produk': namaProduk,
      'deskripsi': deskripsi,
      'harga': harga,
      'stok': stok,
      'gambar_url': gambarUrl,
      'is_active': isActive ? 1 : 0,
    };
  }
}