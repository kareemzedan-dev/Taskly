import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/core/helper/failures.dart';
import 'package:taskly/core/helper/shared_preferences.dart';
import 'package:taskly/features/client/domain/entities/home/user_info_entity.dart';
import 'package:taskly/features/client/domain/use_cases/home/home_use_case.dart';
import 'package:taskly/features/client/presentation/cubit/client_info_view_model/client_info_view_model_states.dart';
import 'package:taskly/features/freelancer/presentation/cubit/freelancer_info_view_model/freelancer_info_view_model_states.dart';

@injectable 
class FreelancerInfoViewModel extends Cubit<FreelancerInfoViewModelStates> {
  final HomeUseCase homeUseCase;
  FreelancerInfoViewModel(this.homeUseCase) : super(FreelancerInfoViewModelInitial());
  Future<Either<Failures, UserInfoEntity>> loadUserInfo({bool forceFetch = false}) async {
    if (!forceFetch) {
      final fullName = SharedPrefHelper.getString('fullName');
      final email = SharedPrefHelper.getString('email');
      final role = SharedPrefHelper.getString('role');

      if (fullName != null && email != null && role != null) {
        final cachedUser = UserInfoEntity(
          id: '',  
          fullName: fullName,
          email: email,
          role: role,
        );
        emit(FreelancerInfoViewModelSuccess(cachedUser));
        return Right(cachedUser); 
      }
    }

    return getUserInfo();
  }

  Future<Either<Failures, UserInfoEntity>> getUserInfo() async {
    try {
      emit(FreelancerInfoViewModelLoading());
      final result = await homeUseCase.call();
      result.fold(
        (failure) => emit(FreelancerInfoViewModelError(failure.message)),
        (user) async {
          emit(FreelancerInfoViewModelSuccess(user));

          await SharedPrefHelper.setString('fullName', user.fullName ?? '');
          await SharedPrefHelper.setString('email', user.email);
          await SharedPrefHelper.setString('role', user.role);
        },
      );
      return result;
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
