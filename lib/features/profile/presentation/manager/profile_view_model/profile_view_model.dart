import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/features/profile/domain/use_cases/profile/profile_use_case.dart';
import 'package:taskly/features/profile/presentation/manager/profile_view_model/profile_view_model_states.dart';

import '../../../domain/entities/user_info_entity/user_info_entity.dart';
@injectable
class ProfileViewModel extends Cubit<ProfileViewModelStates>{
  ProfileViewModel(this.profileUseCase):super(ProfileViewModelStatesInitial());
  ProfileUseCase profileUseCase;

Future<void> getUserInfo(String userId, String role) async {
  try {
    if (isClosed) return;
    emit(ProfileViewModelStatesLoading());

    final result = await profileUseCase.callUserInfo(userId, role);

    if (isClosed) return;
    result.fold(
      (l) => emit(ProfileViewModelStatesError(l.message)),
      (r) => emit(ProfileViewModelStatesSuccess(r)),
    );
  } catch (e) {
    if (isClosed) return;
    emit(ProfileViewModelStatesError(e.toString()));
  }
}
  Future<UserInfoEntity?> fetchUserInfo(String userId, String role) async {
    final result = await profileUseCase.callUserInfo(userId, role);
    return result.fold(
          (l) => null, // في حالة error
          (r) => r,    // بيرجع الـ entity
    );
  }

}