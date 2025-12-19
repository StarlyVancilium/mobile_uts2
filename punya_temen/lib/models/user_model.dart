class UserModel {
  final int? id;
  final String name;
  final String email;
  final String role;
  final String status;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
  });

  /// Untuk response LOGIN
  factory UserModel.fromLoginResponse(Map<String, dynamic> json) {
    final user = json['user'];

    return UserModel(
      id: user['id'],
      name: user['name'],
      email: user['email'],
      role: user['role'],
      status: user['status'],
    );
  }

  /// Untuk response LIST USER
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      status: json['status'],
    );
  }
}
