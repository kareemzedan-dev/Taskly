import 'package:taskly/features/client/domain/entities/home/user_info_entity.dart';

class UserInfoViewModelStates {

}

class UserInfoViewModelInitial extends UserInfoViewModelStates {}

class UserInfoViewModelLoading extends UserInfoViewModelStates {}

class UserInfoViewModelSuccess extends UserInfoViewModelStates {
  final UserInfoEntity userInfoEntity;

  UserInfoViewModelSuccess(this.userInfoEntity);
}

class UserInfoViewModelError extends UserInfoViewModelStates {
  final String errorMessage;

  UserInfoViewModelError(this.errorMessage);
}