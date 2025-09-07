class FreelancerEntity {
  String? id;
  String? name;
  String? photo;
  String? email;
  String? phone;
  String? bio;
  List<String>? skills;
 String? role;
 double? hourlyRate;
 double? rating;
  FreelancerEntity({
    this.id,
    this.name,
    this.photo,
    this.email,
    this.phone,
    this.role,
    this.bio,
    this.hourlyRate,
    this.rating,
    this.skills
  });
}