class Admin {
  final int? id;
  final String username;
  final String nama;
  final String email;

  Admin({
    this.id,
    required this.username,
    required this.nama,
    required this.email,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json['id'],
      username: json['username'],
      nama: json['nama'],
      email: json['email'],
    );
  }
}
