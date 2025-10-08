import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/view_model/get_order_view_model.dart/get_order_view_model.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/view_model/get_order_view_model.dart/get_order_view_model_states.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/views/widgets/order_states_card.dart';

import '../../../../../../../../shared/domain/entities/order_entity/order_entity.dart';
import 'empty_state_animation.dart';
class OrderStatusCardListView extends StatelessWidget {
  const OrderStatusCardListView({
    super.key,
    required this.animationPath,
    required this.message,
    required this.filter,
  });

  final String animationPath;
  final String message;
  final OrderStatusFilter filter;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetOrderViewModel, GetOrderViewModelStates>(
      builder: (context, state) {
        if (state is GetOrderViewModelStatesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GetOrderViewModelStatesSuccess) {

          final filteredOrders = state.orderEntity.where((order) {
            switch (filter) {
              case OrderStatusFilter.pending:
                return order.status == OrderStatus.Pending ||
                    order.status == OrderStatus.Accepted ||
                    order.status == OrderStatus.Paid;
              case OrderStatusFilter.inProgress:
                return order.status == OrderStatus.InProgress;
              case OrderStatusFilter.completed:
                return order.status == OrderStatus.Completed;
              case OrderStatusFilter.cancelled:
                return order.status == OrderStatus.Cancelled;
            }
          }).toList();

          if (filteredOrders.isEmpty) {
            return Center(
              child: EmptyStateAnimation(
                animationPath: animationPath,
                message: message,
              ),
            );
          }

          return ListView.separated(
            itemCount: filteredOrders.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: OrderStatesCard(order: filteredOrders[index]),
              );
            },
          );
        }
        return Container();
      },
    );
  }
}

enum OrderStatusFilter { pending, inProgress, completed, cancelled }
