import 'package:taskly/features/client/domain/entities/home/user_info_entity.dart';

class FreelancerInfoViewModelStates {}

class FreelancerInfoViewModelInitial extends FreelancerInfoViewModelStates {}

class FreelancerInfoViewModelLoading extends FreelancerInfoViewModelStates {}

class FreelancerInfoViewModelSuccess extends FreelancerInfoViewModelStates {
  final UserInfoEntity userInfoEntity;

  FreelancerInfoViewModelSuccess(this.userInfoEntity);
}

class FreelancerInfoViewModelError extends FreelancerInfoViewModelStates {
  final String errorMessage;

  FreelancerInfoViewModelError(this.errorMessage);
}
