class User {
  final int id;
  final String email;
  final String name;
  final String role;
  final String status;
  final String? alamat;
  final String? kota;
  final String? npm;
  final String? noTelp;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.status,
    this.alamat,
    this.kota,
    this.npm,
    this.noTelp,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'] as int,
        email: json['email'] as String,
        name: json['name'] as String,
        role: json['role'] as String,
        status: json['status'] as String,
        alamat: json['alamat'] as String?,
        kota: json['kota'] as String?,
        npm: json['npm'] as String?,
        noTelp: json['no_telp'] as String?);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'status': status,
      'alamat': alamat,
      'kota': kota,
      'npm': npm,
      'no_telp': noTelp
    };
  }
}
