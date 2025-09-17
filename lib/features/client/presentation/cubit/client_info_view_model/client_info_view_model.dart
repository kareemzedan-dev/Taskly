import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/core/cache/shared_preferences.dart';
import 'package:taskly/core/utils/strings_manager.dart';
import 'package:taskly/features/client/presentation/cubit/client_info_view_model/client_info_view_model_states.dart';

import '../../../../profile/domain/entities/user_info_entity/user_info_entity.dart';
import '../../../../profile/domain/use_cases/profile/profile_use_case.dart';

@injectable 
class ClientInfoViewModel extends Cubit<ClientInfoViewModelStates> {
 final ProfileUseCase profileUseCase;
  ClientInfoViewModel(this.profileUseCase) : super(ClientInfoViewModelInitial());
  final List<String> searchHintTexts = [
  "Find top freelancers",
  "Search by category",
  "Discover trending jobs",
  "Explore recent projects",
  "Search by skill or service",
];

  // Future<Either<Failures, UserInfoEntity>> loadUserInfo({bool forceFetch = false}) async {
  //   if (!forceFetch) {
  //     final fullName = SharedPrefHelper.getString('fullName');
  //     final email = SharedPrefHelper.getString('email');
  //     final role = SharedPrefHelper.getString('role');
  //
  //     if (fullName != null && email != null && role != null) {
  //       final cachedUser = UserInfoEntity(
  //         id: '',
  //         fullName: fullName,
  //         email: email,
  //         role: role,
  //       );
  //       emit(ClientInfoViewModelSuccess(cachedUser));
  //       return Right(cachedUser);
  //     }
  //   }
  //
  //   return getUserInfo(
  //
  //   );
  // }

  Future<Either<Failures, UserInfoEntity>> getUserInfo(
      String id,
      String role,
      ) async {
    try {
      emit(ClientInfoViewModelLoading());
      final result = await profileUseCase.callUserInfo(
        id,
        role,
      );
      result.fold(
        (failure) => emit(ClientInfoViewModelError(failure.message)),
        (user) async {
          emit(ClientInfoViewModelSuccess(user));

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
