import 'package:mobile_uts/models/detail_pesanan_model.dart';
import 'user_model.dart';

class Pesanan {
  final int? id;
  final int userId;
  final String kodePesanan;
  final DateTime tanggalPesanan;
  final String status;
  final double subtotal;
  final double ongkir;
  final double totalBayar;
  final String alamatKirim;
  final String? kotaTujuan;
  final String? catatan;
  final List<DetailPesanan>? details;
  final User? user;

  Pesanan({
    this.id,
    required this.userId,
    required this.kodePesanan,
    required this.tanggalPesanan,
    required this.status,
    required this.subtotal,
    required this.ongkir,
    required this.totalBayar,
    required this.alamatKirim,
    this.kotaTujuan,
    this.catatan,
    this.details,
    this.user,
  });

  factory Pesanan.fromJson(Map<String, dynamic> json) {
    return Pesanan(
      id: json['id'],
      userId: json['user_id'],
      kodePesanan: json['kode_pesanan'],
      tanggalPesanan: DateTime.parse(json['tanggal_pesanan']),
      status: json['status'],
      subtotal: double.parse(json['subtotal'].toString()),
      ongkir: double.parse(json['ongkir'].toString()),
      totalBayar: double.parse(json['total_bayar'].toString()),
      alamatKirim: json['alamat_kirim'],
      kotaTujuan: json['kota_tujuan'],
      catatan: json['catatan'],
      details: json['details'] != null
          ? (json['details'] as List)
              .map((detail) => DetailPesanan.fromJson(detail))
              .toList()
          : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'kode_pesanan': kodePesanan,
      'status': status,
      'subtotal': subtotal,
      'ongkir': ongkir,
      'total_bayar': totalBayar,
      'alamat_kirim': alamatKirim,
      'kota_tujuan': kotaTujuan,
      'catatan': catatan,
    };
  }
}