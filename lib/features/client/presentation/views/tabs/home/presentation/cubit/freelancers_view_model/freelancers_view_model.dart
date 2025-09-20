
import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/features/client/domain/use_cases/home/home_use_case.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/cubit/freelancers_view_model/freelancers_view_model_states.dart';

import '../../../../../../../../profile/domain/entities/user_info_entity/user_info_entity.dart';
@injectable
class FreelancersViewModel extends Cubit<FreelancersViewModelStates> {
  HomeUseCase homeUseCas;

  FreelancersViewModel(this.homeUseCas)
    : super(FreelancersViewModelStatesInitial());
  Future<Either<Failures, List<UserInfoEntity>>> getAllFreelancer() async {
    try {
      emit(FreelancersViewModelStatesLoading());
      final result = await homeUseCas.callGetFreelancer();

      result.fold(
        (failure) => emit(FreelancersViewModelStatesError(failure.message)),
        (freelancers) => emit(FreelancersViewModelStatesSuccess(freelancers)),
      );
      return result;
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
