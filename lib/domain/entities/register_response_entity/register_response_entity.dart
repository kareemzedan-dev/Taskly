import 'package:taskly/data/models/register_response_dm/register_response_dm.dart';

class RegisterResponseEntity {
  String? token;
  UserDm? user;
  String? message;

  RegisterResponseEntity({this.token, this.user, this.message});
}

class UserEntity {
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? role;  

  UserEntity({this.firstName, this.lastName, this.email, this.password, this.role});
}
