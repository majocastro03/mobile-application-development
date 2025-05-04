// Modelo de Usuario
class User {
  final String? id;
  final String email;
  final String fullName;
  final String photoUrl;
  final String phoneNumber;
  final String position;

  User({
    this.id,
    required this.email,
    required this.fullName,
    required this.photoUrl,
    required this.phoneNumber,
    required this.position,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      fullName: json['full_name'],
      photoUrl: json['photo_url'] ?? '',
      phoneNumber: json['phone'] ?? '',
      position: json['role'] ?? '',
    );
  }
}
