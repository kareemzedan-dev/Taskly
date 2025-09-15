class GoogleUserEntity {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String role; // admin, client, freelancer, etc.

  GoogleUserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.role,
  });
}

class GoogleAuthResponseEntity {
  final String? token;
  final GoogleUserEntity? user;
  final String? message;

  GoogleAuthResponseEntity({this.token, this.user, this.message});
}