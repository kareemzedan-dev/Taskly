import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_file/open_file.dart';
import 'package:taskly/config/routes/routes_manager.dart';
import 'package:taskly/core/components/custom_button.dart';
import 'package:taskly/features/attachments/presentation/manager/download_attachments_view_model/download_attachments_states.dart';
import 'package:taskly/features/attachments/presentation/manager/download_attachments_view_model/download_attachments_view_model.dart';
import 'package:taskly/features/freelancer/presentation/cubit/add_earnings_view_model/add_earnings_view_model.dart';
import 'package:taskly/features/freelancer/presentation/cubit/update_order_status_view_model/update_order_status_view_model.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/view_model/get_commission_view_model/get_commission_view_model.dart';
import 'package:taskly/features/messages/presentation/manager/subscribe_to_messages_view_model/subscribe_to_messages_view_model.dart';
import 'package:taskly/features/messages/presentation/widgets/admin_message_card.dart';
import 'package:taskly/features/messages/presentation/widgets/chat_input_field.dart';
import 'package:taskly/features/shared/presentation/views/widgets/message_bubble.dart';
import 'package:taskly/features/messages/presentation/widgets/order_status_card.dart';
import 'package:taskly/features/profile/presentation/manager/profile_view_model/profile_view_model.dart';

import '../../../../core/components/confirmation_dialog.dart';
import '../../../../core/di/di.dart';
import '../../../attachments/presentation/manager/upload_attachments_view_model/upload_attachments_view_model.dart';
import '../../../client/presentation/views/tabs/my_jobs/presentation/views/pdf_viewer_view.dart';
import '../../../reviews/presentation/manager/get_user_reviews_view_model/get_user_reviews_states.dart';
import '../../../reviews/presentation/manager/get_user_reviews_view_model/get_user_reviews_view_model.dart';
import '../../../reviews/presentation/manager/submit_rating_view_model/submit_rating_view_model.dart';
import '../../../reviews/presentation/widgets/rating_bottom_sheet.dart';
import '../../../shared/domain/entities/order_entity/order_entity.dart';
import '../../../shared/presentation/manager/subscribe_to_order_record_view_model/subscribe_to_order_record_states.dart';
import '../../../shared/presentation/manager/subscribe_to_order_record_view_model/subscribe_to_order_record_view_model.dart';
import '../manager/get_messages_view_model/get_messages_view_model.dart';
import '../manager/get_messages_view_model/get_messages_view_model_states.dart';
import '../manager/send_message_view_model/send_message_view_model.dart';
import '../manager/subscribe_to_messages_view_model/subscribe_to_messages_states.dart';
import 'message_shimmer.dart';

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
  String? clientAvatar;
  String? freelancerAvatar;
  bool isLoadingAvatars = true;

  @override
  void initState() {
    super.initState();
    _loadAvatars();
  }

  Future<void> _loadAvatars() async {
    final profileVm = getIt<ProfileViewModel>();

    final results = await Future.wait([
      profileVm.fetchUserInfo(widget.currentUserId, "freelancer"),
      profileVm.fetchUserInfo(widget.receiverId, "client"),
    ]);

    setState(() {
      freelancerAvatar = results[0]?.profileImage;
      clientAvatar = results[1]?.profileImage;
      isLoadingAvatars = false;
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  void _showRatingBottomSheet(OrderEntity order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BlocProvider(
          create: (_) => getIt<SubmitRatingViewModel>(),
          child: RatingBottomSheet(
            order: order,
            currentUserId: widget.currentUserId,
            receiverId: widget.receiverId,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    context.read<SubscribeToMessagesViewModel>().unsubscribe();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingAvatars) {
      return const Center(child: CircularProgressIndicator());
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              getIt<GetMessagesViewModel>()..getOrderMessages(widget.order.id),
        ),
        BlocProvider(
          create: (context) => getIt<SubscribeToMessagesViewModel>()
            ..subscribeToMessages(widget.order.id),
        ),
        BlocProvider(
          create: (context) => getIt<SubscribeOrdersRecordViewModel>()
            ..subscribe(widget.order.id),
        ),
        BlocProvider(create: (_) => getIt<UpdateOrderStatusViewModel>()),
        BlocProvider(
          create: (_) => getIt<GetUserReviewsViewModel>()
            ..getUserReviews(widget.currentUserId,
                widget.currentUserId == widget.order.clientId ? 'client' : 'freelancer'),
        ),

      ],
      child: Column(
        children: [
          BlocBuilder<SubscribeOrdersRecordViewModel, OrderViewModelState>(
            builder: (context, state) {
              final orderData =
                  state is OrderSuccess ? state.order : widget.order;
              final viewModel = context.read<SubscribeOrdersRecordViewModel>();

              final adminMessage = viewModel.getAdminMessage(orderData);
              final buttonText = viewModel.getActionButtonText(
                  orderData, widget.currentUserId);
              final freelancerRatingButton =
                  orderData.status.name == "Completed" &&
                      widget.currentUserId == widget.order.freelancerId;
              return Column(
                children: [
                  OrderStatusCard(
                    price: orderData.budget ?? 0,
                    status: orderData.status.name,
                    message: "",
                    buttonText: buttonText,
                    onButtonPressed: buttonText != null
                        ? () {
                            if (buttonText ==
                                "Pay Now ${widget.order.budget}SAR") {
                              Navigator.pushNamed(
                                context,
                                RoutesManager.clientPaymentsView,
                                arguments: {'orderEntity': widget.order},
                              );
                            } else if (buttonText == "submit delivery") {
                              showConfirmationDialog(
                                context: context,
                                title: "Submit Delivery",
                                message:
                                    "Are you sure you want to submit the delivery?",
                                onConfirm: () {
                                  context
                                      .read<UpdateOrderStatusViewModel>()
                                      .updateOrderStatus(
                                          orderData.id, "Waiting");
                                },
                                onCancel: () {},
                              );
                            } else if (buttonText == "work received") {
                              showConfirmationDialog(
                                context: context,
                                title: "Confirmation",
                                message:
                                    "Are you sure you have received the work?",
                                onConfirm: () {
                                  context
                                      .read<UpdateOrderStatusViewModel>()
                                      .updateOrderStatus(
                                          orderData.id, "Completed");

                                  context
                                      .read<AddEarningsViewModel>()
                                      .addEarnings(
                                        orderData.freelancerId!,
                                        orderData.budget!,
                                      );
                                  _showRatingBottomSheet(orderData);
                                },
                              );
                            }
                          }
                        : null,
                  ),
                  if (freelancerRatingButton)
                    BlocBuilder<GetUserReviewsViewModel, GetUserReviewsStates>(
                      builder: (context, reviewState) {
                        if (reviewState is GetUserReviewsLoading) {
                          return const CircularProgressIndicator();
                        }

                        if (reviewState is GetUserReviewsSuccess) {
                          // تحقق هل فيه تقييم بنفس orderId
                          final hasRated = reviewState.reviewsList.any(
                                (r) => r.orderId == orderData.id,
                          );

                          if (hasRated) {
                            // ✅ المستخدم قيّم بالفعل — منخفي الزرار
                            return const SizedBox.shrink();
                          } else {
                            // 🚀 المستخدم لسه ما قيّمش
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomButton(
                                title: "Rate Client",
                                ontap: () {
                                  _showRatingBottomSheet(orderData);
                                },
                              ),
                            );
                          }
                        }

                        return const SizedBox.shrink();
                      },
                    ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AdminMessageCard(message: adminMessage),
                  ),
                ],
              );
            },
          ),

          /// 🟢 Messages
          Expanded(
            child:
                BlocBuilder<GetMessagesViewModel, GetMessagesViewModelStates>(
              builder: (context, oldState) {
                List messages = [];
                if (oldState is GetMessagesViewModelStatesLoading) {
                  return const MessageShimmer();
                }
                if (oldState is GetMessagesViewModelStatesSuccess) {
                  messages = oldState.messages;

                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => _scrollToBottom());
                }

                return BlocBuilder<SubscribeToMessagesViewModel,
                    SubscribeToMessagesStates>(
                  builder: (context, newState) {
                    if (newState is SubscribeToMessagesStatesSuccess) {
                      for (var msg in newState.messages) {
                        if (!messages.any((m) => m.id == msg.id)) {
                          messages.add(msg);
                        }
                      }
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (_scrollController.hasClients) {
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        }
                      });
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        final isCurrentUser =
                            msg.senderId == widget.currentUserId;

                        /// ✅ Text Message
                        if (msg.messageType == "text") {
                          return MessageBubble(
                            sender: isCurrentUser
                                ? SenderType.freelancer
                                : SenderType.client,
                            message: msg.content ?? "",
                            avatarUrl: isCurrentUser
                                ? (freelancerAvatar ?? "")
                                : (clientAvatar ?? ""),
                            time:
                                "${msg.createdAt.hour}:${msg.createdAt.minute.toString().padLeft(2, '0')} ${msg.createdAt.hour < 12 ? "AM" : "PM"}",
                          );
                        }

                        /// ✅ Image Message
                        else if (msg.messageType == "image" &&
                            msg.attachment != null &&
                            msg.attachment!.isNotEmpty) {
                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => Dialog(
                                  child:
                                      Image.network(msg.attachment!.first.url),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                msg.attachment!.first.url,
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        } else if (msg.messageType == "file" &&
                            msg.attachment != null &&
                            msg.attachment!.isNotEmpty) {
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 4.h),
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                  color: Colors.grey.shade300, width: 1),
                            ),
                            width: 220.w,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.insert_drive_file,
                                    color: Colors.blue, size: 20.sp),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    msg.attachment!.first.name ?? "Attachment",
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.remove_red_eye,
                                      color: Colors.orange, size: 20.sp),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FileViewerView(
                                                  filePath:
                                                      msg.attachment!.first.url,
                                                  isNetwork: true,
                                                )));
                                  },
                                ),
                                BlocConsumer<DownloadAttachmentsViewModel,
                                    DownloadAttachmentsStates>(
                                  listener: (context, state) {
                                    if (state
                                        is DownloadAttachmentsStatesSuccess) {
                                      OpenFile.open(state.file.path);
                                    } else if (state
                                        is DownloadAttachmentsStatesError) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "Failed to download ${msg.attachment!.first.name}"),
                                        ),
                                      );
                                    }
                                  },
                                  builder: (context, state) {
                                    final isLoading = state
                                        is DownloadAttachmentsStatesLoading;

                                    return isLoading
                                        ? SizedBox(
                                            width: 20.sp,
                                            height: 20.sp,
                                            child:
                                                const CircularProgressIndicator(
                                                    strokeWidth: 2),
                                          )
                                        : IconButton(
                                            icon: Icon(Icons.download,
                                                color: Colors.green,
                                                size: 20.sp),
                                            onPressed: () {
                                              context
                                                  .read<
                                                      DownloadAttachmentsViewModel>()
                                                  .downloadAttachments(
                                                    msg.attachment!.first.url,
                                                    msg.attachment!.first
                                                            .name ??
                                                        "attachment",
                                                  );
                                            },
                                          );
                                  },
                                ),
                              ],
                            ),
                          );
                        } else if (msg.messageType == "voice" &&
                            msg.attachment != null &&
                            msg.attachment!.isNotEmpty) {
                          final voiceUrl = msg.attachment!.first.url;
                          final player = AudioPlayer();

                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 4.h),
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                  color: Colors.grey.shade300, width: 1),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                StreamBuilder<PlayerState>(
                                  stream: player.onPlayerStateChanged,
                                  builder: (context, snapshot) {
                                    final isPlaying =
                                        snapshot.data == PlayerState.playing;

                                    return IconButton(
                                      icon: Icon(
                                        isPlaying
                                            ? Icons.pause_circle
                                            : Icons.play_circle_fill,
                                        color: isPlaying
                                            ? Colors.red
                                            : Colors.blue,
                                        size: 30.sp,
                                      ),
                                      onPressed: () async {
                                        if (isPlaying) {
                                          await player.pause();
                                        } else {
                                          await player
                                              .play(UrlSource(voiceUrl));
                                        }
                                      },
                                    );
                                  },
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  "Voice message",
                                  style: TextStyle(
                                      fontSize: 14.sp, color: Colors.black87),
                                ),
                              ],
                            ),
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    );
                  },
                );
              },
            ),
          ),

          MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => getIt<SendMessageViewModel>(),
              ),
              BlocProvider(
                create: (_) => getIt<UploadAttachmentsViewModel>(),
              ),
            ],
            child: ChatInputField(
              orderId: widget.order.id,
              currentUserId: widget.currentUserId,
              receiverId: widget.receiverId,
            ),
          ),

          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
