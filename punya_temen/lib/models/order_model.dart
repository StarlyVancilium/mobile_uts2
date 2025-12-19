class OrderModel {
  final int id;
  final int user_id;
  final int product_id;
  final int total_barang;
  final bool balado;
  final bool keju;
  final bool pedas;
  final bool asin;
  final bool barbeque;
  final int total_harga;
  final String status;

  // ! Data Relasi
  final String? productName;
  final String? productPhoto;
  final String? userName;

  OrderModel({
    required this.id,
    required this.user_id,
    required this.product_id,
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
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
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

    return OrderModel(
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
      total_harga:
          (double.tryParse(json['total_harga']?.toString() ?? '0') ?? 0)
              .toInt(),
      status: json['status']?.toString() ?? 'unknown',
      productName: pName,
      productPhoto: pPhoto,
      userName: uName,
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
    };
  }
}