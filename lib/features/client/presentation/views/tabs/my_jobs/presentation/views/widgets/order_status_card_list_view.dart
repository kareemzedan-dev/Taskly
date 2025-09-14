import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/cubit/get_order_view_model.dart/get_order_view_model.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/cubit/get_order_view_model.dart/get_order_view_model_states.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/views/widgets/order_states_card.dart';

class OrderStatusCardListView extends StatelessWidget {
  const OrderStatusCardListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<GetOrderViewModel, GetOrderViewModelStates>(
         
        builder: (context, state) {
          if (state is GetOrderViewModelStatesLoading) {
              return Center(
                  child: LoadingAnimationWidget.inkDrop(
                    size: 60,
                    color: ColorsManager.primary,
                  ),
                );
          } else if (state is GetOrderViewModelStatesSuccess) {
            return ListView.separated(
              separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Divider(color: Colors.grey , thickness: 1,),
              ),
              itemCount: state.orderEntity.length,
              itemBuilder:
                  (context, index) =>
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OrderStatesCard(order: state.orderEntity[index]),
                      ),
            );
          } else if (state is GetOrderViewModelStatesError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
    );
  }
}
