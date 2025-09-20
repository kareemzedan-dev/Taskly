import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/cubit/update_offer_status_view_model/update_offer_status_states.dart';

import '../../../../../../../domain/use_cases/my_jobs/my_jobs_use_cases.dart';
@injectable
class UpdateOfferStatusViewModel extends Cubit<UpdateOfferStatusStates> {
  UpdateOfferStatusViewModel(this.myJobsUseCases)
    : super(UpdateOfferStatusInitial());
  MyJobsUseCases myJobsUseCases;

  void updateOfferStatus(String offerId, String newStatus) async {
    try {
      emit(UpdateOfferStatusLoadingState());
      var result = await myJobsUseCases.updateOfferStatus(offerId, newStatus);
      result.fold(
        (l) => emit(UpdateOfferStatusErrorState(l.message)),
        (r) => emit(UpdateOfferStatusSuccessState("Offer status updated successfully")),
      );

    } catch (e) {
      emit(UpdateOfferStatusErrorState(e.toString()));
    }
  }


  void acceptOfferAndRejectOthers(String orderId, String offerId) async {
    try {
      emit(UpdateOfferStatusLoadingState());

      var result = await myJobsUseCases.acceptOfferAndRejectOthers(orderId, offerId);

      result.fold(
            (l) => emit(UpdateOfferStatusErrorState(l.message)),
            (r) => emit(UpdateOfferStatusSuccessState("Offer accepted successfully")),
      );
    } catch (e) {
      emit(UpdateOfferStatusErrorState(e.toString()));
    }
  }

}
