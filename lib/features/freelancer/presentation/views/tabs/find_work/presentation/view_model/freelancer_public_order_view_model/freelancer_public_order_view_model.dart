import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/core/cache/shared_preferences.dart';
import 'package:taskly/core/utils/strings_manager.dart';
import 'package:taskly/features/shared/domain/entities/order_entity/order_entity.dart';
import '../../../../../../../domain/use_cases/fetch_public_orders_use_case/fetch_public_orders_use_case.dart';
import '../../../../../../../domain/use_cases/subscribe_to_public_orders_use_case/subscribe_to_public_orders_use_case.dart';
import 'freelancer_public_order_states.dart';

@injectable
class FreelancerPublicOrdersViewModel extends Cubit<FreelancerPublicOrdersState> {
  final FetchPublicOrdersUseCase freelancerOrderUseCase;
  final SubscribeToPublicOrdersUseCase subscribeToPublicOrdersUseCase;

  StreamSubscription<List<OrderEntity>>? _ordersSubscription;

  final List<OrderEntity> _allOrders = []; // كل الأوردرات
  List<OrderEntity> _filteredOrders = []; // الأوردرات بعد البحث

  FreelancerPublicOrdersViewModel(
      this.freelancerOrderUseCase,
      this.subscribeToPublicOrdersUseCase
      ) : super(FreelancerPendingOrdersInitial());

  /// جلب الأوردرات والاشتراك في التحديثات اللحظية
  Future<void> fetchAndSubscribePendingOrders() async {
    emit(FreelancerPendingOrdersLoading());

    final freelancerId = SharedPrefHelper.getString(StringsManager.idKey)!;

    final result = await freelancerOrderUseCase.fetchPublicOrders(freelancerId);

    result.fold(
          (_) {},
          (orders) {
        _allOrders
          ..clear()
          ..addAll(orders.where((o) => o.serviceType.name.toLowerCase() == 'public'));
      },
    );

    // ترتيب الأوردرات: الأحدث فوق
    _allOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    _filteredOrders = List.from(_allOrders);

    emit(FreelancerPendingOrdersSuccess(List.from(_filteredOrders)));

    // الاشتراك في الوقت الحقيقي
    _ordersSubscription = subscribeToPublicOrdersUseCase
        .subscribeToPublicOrders(freelancerId)
        .listen(
          (orders) {
        print("📥 Orders from stream: ${orders.length}");

        _allOrders
          ..clear()
          ..addAll(
            orders.where((o) => o.serviceType.name.toLowerCase() == 'public'),
          );

        // ترتيب حسب الأحدث
        _allOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        _filteredOrders = List.from(_allOrders);

        emit(FreelancerPendingOrdersSuccess(List.from(_filteredOrders)));
      },
      onError: (error) {
        emit(FreelancerPendingOrdersError('Real-time subscription error: $error'));
      },
    );
  }

  /// فلترة الأوردرات حسب البحث
  void searchOrders(String query) {
    if (query.isEmpty) {
      _filteredOrders = List.from(_allOrders);
    } else {
      _filteredOrders = _allOrders.where((order) {
        final title = order.title.toLowerCase();
        final serviceName = order.serviceType.name.toLowerCase();
        return title.contains(query.toLowerCase()) ||
            serviceName.contains(query.toLowerCase());
      }).toList();
    }

    emit(FreelancerPendingOrdersSuccess(List.from(_filteredOrders)));
  }

  @override
  Future<void> close() {
    _ordersSubscription?.cancel();
    return super.close();
  }
}
