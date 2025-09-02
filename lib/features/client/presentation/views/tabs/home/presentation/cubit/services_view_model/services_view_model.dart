import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/core/helper/failures.dart';
import 'package:taskly/features/client/domain/entities/home/service_response_entity.dart';
import 'package:taskly/features/client/domain/use_cases/home/home_use_case.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/cubit/services_view_model/services_view_model_states.dart';
@injectable
class ServicesViewModel extends Cubit<ServicesViewModelStates>{

  final HomeUseCase homeUseCase;

  ServicesViewModel(this.homeUseCase) : super(ServicesViewModelStatesInitial());
  Future<Either<Failures,List<ServiceEntity>>> getServices() async {
    try {
      emit(ServicesViewModelStatesLoading());
      final result = await homeUseCase.callServices();
      result.fold(
        (failure) => emit(ServicesViewModelStatesError(failure.message)),
        (services) => emit(ServicesViewModelStatesSuccess(services)),
      );
      return result;
      
    }catch(e){
      return Left(ServerFailure(e.toString()));
    }
  }

}