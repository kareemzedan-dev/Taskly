import 'package:taskly/features/client/domain/entities/home/freelancer_entity.dart';

class FreelancerDm extends FreelancerEntity {
  FreelancerDm({
    super.id,
    super.name,
    super.email,
    super.phone,
    super.bio,
    super.photo,
    super.rating,
    super.hourlyRate,
    super.skills,
    super.role,
  });

  factory FreelancerDm.fromEntity(FreelancerEntity entity) {
    return FreelancerDm(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      bio: entity.bio,
      photo: entity.photo,
      rating: entity.rating,
      hourlyRate: entity.hourlyRate,
      skills: entity.skills,
      role: entity.role,
    );
  }

  factory FreelancerDm.fromJson(Map<String, dynamic> json) {
    return FreelancerDm(
      id: json['id'],
      name: json['full_name'],
      email: json['email'],
      phone: json['phone'],
      bio: json['bio'],
      photo: json['profile_image'],
      rating: json['rating'] ?? 0.0,
      hourlyRate: json['hourly_rate'],
      skills: List<String>.from(json['skills'] ?? []),
      role: json['role'],
    );
  }

  FreelancerDm copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? bio,
    String? photo,
    double? rating,
    double? hourlyRate,
    List<String>? skills,
    String? role,
  }) {
    return FreelancerDm(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      photo: photo ?? this.photo,
      rating: rating ?? this.rating,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      skills: skills ?? this.skills,
      role: role ?? this.role,
    );
  }
}
