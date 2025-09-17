
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
      id: json['uuid'],
      fullName: json['full_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      role: json['role'],
      profileImage: json['profile_image'],
      bio: json['bio'],
      skills: json['skills'] != null ? List<String>.from(json['skills']) : null,
      hourlyRate:
          json['hourly_rate'] != null
              ? (json['hourly_rate'] as num).toDouble()
              : null,
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : null,
      billingInfo: json['billing_info'] != null
          ? BillingInfo.fromJson(json['billing_info'])
          : null,
      balance: json['balance'] != null ? (json['balance'] as num).toDouble() : null,
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
}
