
import '../../../../../../../../profile/domain/entities/user_info_entity/user_info_entity.dart';

class FreelancersViewModelStates {}

class FreelancersViewModelStatesInitial extends FreelancersViewModelStates {}

class FreelancersViewModelStatesLoading extends FreelancersViewModelStates {}

class FreelancersViewModelStatesError extends FreelancersViewModelStates {
  final String message;
  FreelancersViewModelStatesError(this.message);
}

class FreelancersViewModelStatesSuccess extends FreelancersViewModelStates {
  final List<UserInfoEntity> freelancers;
  FreelancersViewModelStatesSuccess(this.freelancers);
}
