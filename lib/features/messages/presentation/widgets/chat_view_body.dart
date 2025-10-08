import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskly/core/di/di.dart';
import 'package:taskly/features/shared/domain/entities/order_entity/order_entity.dart';
import '../manager/chat_avatars_view_model/chat_avatars_state.dart';
import '../manager/chat_avatars_view_model/chat_avatars_view_model.dart';
import '../widgets/chat_header_section.dart';
import '../widgets/chat_messages_list.dart';
import '../widgets/chat_input_section.dart';
import 'package:taskly/features/messages/presentation/manager/get_messages_view_model/get_messages_view_model.dart';
import 'package:taskly/features/messages/presentation/manager/subscribe_to_messages_view_model/subscribe_to_messages_view_model.dart';
import 'package:taskly/features/shared/presentation/manager/subscribe_to_order_record_view_model/subscribe_to_order_record_view_model.dart';
import 'package:taskly/features/freelancer/presentation/cubit/update_order_status_view_model/update_order_status_view_model.dart';
import 'package:taskly/features/reviews/presentation/manager/get_user_reviews_view_model/get_user_reviews_view_model.dart';

class ChatViewBody extends StatefulWidget {
  final OrderEntity order;
  final String currentUserId;
  final String receiverId;

  const ChatViewBody({
    super.key,
    required this.order,
    required this.currentUserId,
    required this.receiverId,
  });

  @override
  State<ChatViewBody> createState() => _ChatViewBodyState();
}

class _ChatViewBodyState extends State<ChatViewBody> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserRole = widget.currentUserId == widget.order.clientId ? 'client' : 'freelancer';
    final receiverUserRole = widget.receiverId == widget.order.clientId ? 'client' : 'freelancer';

    return BlocProvider(
      create: (_) => ChatAvatarsCubit(getIt())..loadAvatars(widget.currentUserId, widget.receiverId),
      child: BlocBuilder<ChatAvatarsCubit, ChatAvatarsState>(
        builder: (context, state) {
          if (state is ChatAvatarsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ChatAvatarsError) {
            return Center(child: Text(state.message));
          }

          final avatars = state as ChatAvatarsLoaded;

          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<GetMessagesViewModel>()..getOrderMessages(widget.order.id)),
              BlocProvider(create: (_) => getIt<SubscribeToMessagesViewModel>()..subscribeToMessages(widget.order.id)),
              BlocProvider(create: (_) => getIt<SubscribeOrdersRecordViewModel>()..subscribe(widget.order.id)),
              BlocProvider(create: (_) => getIt<UpdateOrderStatusViewModel>()),
              BlocProvider(create: (_) => getIt<GetUserReviewsViewModel>()
                ..getUserReviews(widget.currentUserId, currentUserRole)),
            ],
            child: Column(
              children: [
                ChatHeaderSection(order: widget.order, currentUserId: widget.currentUserId),
                Expanded(
                  child: ChatMessagesList(
                    currentUserId: widget.currentUserId,
                    scrollController: _scrollController,
                    freelancerAvatar: avatars.freelancerAvatar,
                    clientAvatar: avatars.clientAvatar,
                  ),
                ),
                ChatInputSection(
                  orderId: widget.order.id,
                  currentUserId: widget.currentUserId,
                  receiverId: widget.receiverId,
                  currentUserRole: currentUserRole,
                  receiverUserRole: receiverUserRole,
                  onMessageSent: _scrollToBottom,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}