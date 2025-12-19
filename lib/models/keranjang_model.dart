import 'produk_model.dart';

class Keranjang {
  final int? id;
  final int userId;
  final int produkId;
  final int jumlah;
  final Produk? produk;
  final bool balado;
  final bool keju;
  final bool pedas;
  final bool asin;
  final bool barbeque;

  Keranjang({
    this.id,
    required this.userId,
    required this.produkId,
    required this.jumlah,
    this.produk,
    this.balado = false,
    this.keju = false,
    this.pedas = false,
    this.asin = false,
    this.barbeque = false,
  });

  factory Keranjang.fromJson(Map<String, dynamic> json) {
    return Keranjang(
      id: json['id'],
      userId: json['user_id'],
      produkId: json['product_id'] ?? json['produk_id'],
      jumlah: json['total_barang'] ?? json['jumlah'],
      produk: json['produk'] != null ? Produk.fromJson(json['produk']) : null,
      balado: json['balado'] ?? false,
      keju: json['keju'] ?? false,
      pedas: json['pedas'] ?? false,
      asin: json['asin'] ?? false,
      barbeque: json['barbeque'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'produk_id': produkId,
      'jumlah': jumlah,
      'balado': balado,
      'keju': keju,
      'pedas': pedas,
      'asin': asin,
      'barbeque': barbeque,
    };
  }

  double get subtotal => (produk?.harga ?? 0) * jumlah;
}
