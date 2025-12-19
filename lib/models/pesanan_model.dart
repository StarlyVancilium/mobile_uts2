class Pesanan {
  final int id;
  final int user_id;
  final int product_id;
  final int total_barang;
  final bool balado;
  final bool keju;
  final bool pedas;
  final bool asin;
  final bool barbeque;
  final double total_harga;
  final String status;

  // ! Data Relasi
  final String? productName;
  final String? productPhoto;
  final String? userName;

  // Tambahkan untuk kompatibilitas
  final int? userId;
  final String? kodePesanan;
  final DateTime? tanggalPesanan;
  final double? subtotal;
  final double? ongkir;
  final double? totalBayar;
  final String? alamatKirim;
  final String? kotaTujuan;
  final String? catatan;
  final List? details;

  Pesanan({
    this.id = 0, // CHANGED: Added default value
    this.user_id = 0, // CHANGED: Added default value
    this.product_id = 0, // CHANGED: Added default value
    required this.total_barang,
    required this.balado,
    required this.keju,
    required this.pedas,
    required this.asin,
    required this.barbeque,
    required this.total_harga,
    required this.status,
    this.productName,
    this.productPhoto,
    this.userName,
    this.userId,
    this.kodePesanan,
    this.tanggalPesanan,
    this.subtotal,
    this.ongkir,
    this.totalBayar,
    this.alamatKirim,
    this.kotaTujuan,
    this.catatan,
    this.details,
  });

  factory Pesanan.fromJson(Map<String, dynamic> json) {
    String? pName;
    String? pPhoto;
    String? uName;

    if (json['product'] != null) {
      pName = json['product']['nama_produk']?.toString();
      pPhoto = json['product']['foto']?.toString();
    }

    if (json['user'] != null) {
      uName = json['user']['name']?.toString();
    }

    return Pesanan(
      // ! Parse ID
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      user_id: int.tryParse(json['user_id']?.toString() ?? '0') ?? 0,
      product_id: int.tryParse(json['product_id']?.toString() ?? '0') ?? 0,
      total_barang: int.tryParse(json['total_barang']?.toString() ?? '0') ?? 0,

      // ! Parse Boolean
      balado: _parseBool(json['balado']),
      keju: _parseBool(json['keju']),
      pedas: _parseBool(json['pedas']),
      asin: _parseBool(json['asin']),
      barbeque: _parseBool(json['barbeque']),

      // ! Parse Total Harga
      total_harga: double.tryParse(json['total_harga']?.toString() ?? '0') ?? 0,
      status: json['status']?.toString() ?? 'unknown',
      productName: pName,
      productPhoto: pPhoto,
      userName: uName,
      userId: json['user_id'],
      kodePesanan: json['kode_pesanan'],
      tanggalPesanan: json['tanggal_pesanan'] != null
          ? DateTime.parse(json['tanggal_pesanan'])
          : null,
      subtotal: double.tryParse(json['subtotal']?.toString() ?? '0'),
      ongkir: double.tryParse(json['ongkir']?.toString() ?? '0'),
      totalBayar: double.tryParse(json['total_bayar']?.toString() ?? '0'),
      alamatKirim: json['alamat_kirim'],
      kotaTujuan: json['kota_tujuan'],
      catatan: json['catatan'],
      details: json['details'],
    );
  }

  static bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value == true || value == 1 || value == '1') return true;
    return false;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': user_id,
      'product_id': product_id,
      'total_barang': total_barang,
      'balado': balado,
      'keju': keju,
      'pedas': pedas,
      'asin': asin,
      'barbeque': barbeque,
      'total_harga': total_harga,
      'status': status,
      'user_id': userId,
      'kode_pesanan': kodePesanan,
      'tanggal_pesanan': tanggalPesanan?.toIso8601String(),
      'subtotal': subtotal,
      'ongkir': ongkir,
      'total_bayar': totalBayar,
      'alamat_kirim': alamatKirim,
      'kota_tujuan': kotaTujuan,
      'catatan': catatan,
    };
  }
}
