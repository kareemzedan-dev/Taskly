import 'package:taskly/domain/entities/user_info_entity/user_info_entity.dart';

class ClientInfoViewModelStates {

}

class ClientInfoViewModelInitial extends ClientInfoViewModelStates {}

class ClientInfoViewModelLoading extends ClientInfoViewModelStates {}

class ClientInfoViewModelSuccess extends ClientInfoViewModelStates {
  final  UserInfoEntity userInfoEntity;

  ClientInfoViewModelSuccess(this.userInfoEntity);
}

class ClientInfoViewModelError extends ClientInfoViewModelStates {
  final String errorMessage;

  ClientInfoViewModelError(this.errorMessage);
}