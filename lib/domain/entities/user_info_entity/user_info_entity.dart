
class UserInfoResponseEntity {
  final UserInfoEntity? user;
  final String? message;

  UserInfoResponseEntity({
    this.user,
    this.message,
  });
}

class UserInfoEntity {
  final String id;
  final String? fullName;
  final String email;
  final String? phoneNumber;
  final String role;
  final String? profileImage;
  final String? bio;
  final List<String>? skills;
  final double? hourlyRate;
  final double ? rating;
  final DateTime? createdAt;

  UserInfoEntity({
    required this.id,
    this.fullName,
    required this.email,
    this.phoneNumber,
    required this.role,
    this.profileImage,
    this.bio,
    this.skills,
    this.rating,
    this.hourlyRate,
    this.createdAt,
  });
}
