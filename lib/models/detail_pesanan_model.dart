class DetailPesanan {
  final int? id;
  final int pesananId;
  final int produkId;
  final String namaProduk;
  final double hargaSatuan;
  final int jumlah;
  final double subtotal;

  DetailPesanan({
    this.id,
    required this.pesananId,
    required this.produkId,
    required this.namaProduk,
    required this.hargaSatuan,
    required this.jumlah,
    required this.subtotal,
  });

  factory DetailPesanan.fromJson(Map<String, dynamic> json) {
    return DetailPesanan(
      id: json['id'],
      pesananId: json['pesanan_id'],
      produkId: json['produk_id'],
      namaProduk: json['nama_produk'],
      hargaSatuan: double.parse(json['harga_satuan'].toString()),
      jumlah: json['jumlah'],
      subtotal: double.parse(json['subtotal'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pesanan_id': pesananId,
      'produk_id': produkId,
      'nama_produk': namaProduk,
      'harga_satuan': hargaSatuan,
      'jumlah': jumlah,
      'subtotal': subtotal,
    };
  }
}