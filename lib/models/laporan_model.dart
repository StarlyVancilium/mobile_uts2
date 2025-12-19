class LaporanPenjualan {
  final DateTime tanggal;
  final int totalPesanan;
  final double totalPendapatan;
  final double rataPesanan;

  LaporanPenjualan({
    required this.tanggal,
    required this.totalPesanan,
    required this.totalPendapatan,
    required this.rataPesanan,
  });

  factory LaporanPenjualan.fromJson(Map<String, dynamic> json) {
    return LaporanPenjualan(
      tanggal: DateTime.parse(json['tanggal']),
      totalPesanan: json['total_pesanan'],
      totalPendapatan: double.parse(json['total_pendapatan'].toString()),
      rataPesanan: double.parse(json['rata_rata_pesanan'].toString()),
    );
  }
}
