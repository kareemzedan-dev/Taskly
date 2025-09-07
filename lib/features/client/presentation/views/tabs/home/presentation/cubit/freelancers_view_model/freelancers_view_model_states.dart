import 'package:taskly/features/client/domain/entities/home/freelancer_entity.dart';

class FreelancersViewModelStates {}

class FreelancersViewModelStatesInitial extends FreelancersViewModelStates {}

class FreelancersViewModelStatesLoading extends FreelancersViewModelStates {}

class FreelancersViewModelStatesError extends FreelancersViewModelStates {
  final String message;
  FreelancersViewModelStatesError(this.message);
}

class FreelancersViewModelStatesSuccess extends FreelancersViewModelStates {
  final List<FreelancerEntity> freelancers;
  FreelancersViewModelStatesSuccess(this.freelancers);
}
