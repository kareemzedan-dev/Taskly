
import '../../../domain/entities/user_info_entity/user_info_entity.dart';

class UserInfoResponseModel extends UserInfoResponseEntity {
  UserInfoResponseModel({super.user, super.message});

  factory UserInfoResponseModel.fromJson(Map<String, dynamic> json) {
    return UserInfoResponseModel(
      user: json['user'] != null ? UserInfoDm.fromJson(json['user']) : null,
      message: json['message'],
    );
  }
}

class UserInfoDm extends UserInfoEntity {
  UserInfoDm({
    required super.id,
    super.fullName,
    required super.email,
    super.phoneNumber,
    required super.role,
    super.profileImage,
    super.bio,
    super.skills,
    super.hourlyRate,
    super.rating,
    super.createdAt,
    super.billingInfo,
    super.balance,
  });

  factory UserInfoDm.fromJson(Map<String, dynamic> json) {
    return UserInfoDm(
      id: json['uuid'] ?? json['id'] ?? '',   // fallback to empty string
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'],
      role: json['role'] ?? '',
      profileImage: json['profile_image'],
      bio: json['bio'],
      skills: json['skills'] != null
          ? List<String>.from(json['skills'])
          : [],
      hourlyRate: json['hourly_rate'] != null
          ? (json['hourly_rate'] as num).toDouble()
          : null,
      rating: json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : 0.0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      billingInfo: json['billing_info'] != null
          ? BillingInfo.fromJson(json['billing_info'])
          : null,
      balance: json['balance'] != null
          ? (json['balance'] as num).toDouble()
          : 0.0,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'uuid': id,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'role': role,
      'profile_image': profileImage,
      'bio': bio,
      'skills': skills,
      'rating': rating,
      'hourly_rate': hourlyRate,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  UserInfoDm copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? role,
    String? profileImage,
    String? bio,
    List<String>? skills,
    double? hourlyRate,
    double? rating,
    DateTime? createdAt,
    BillingInfo? billingInfo,
    double? balance,
  }) {
    return UserInfoDm(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      profileImage: profileImage ?? this.profileImage,
      bio: bio ?? this.bio,
      skills: skills ?? this.skills,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      billingInfo: billingInfo ?? this.billingInfo,
      balance: balance ?? this.balance,
    );
  }
}
