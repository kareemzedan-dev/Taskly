import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taskly/features/attachments/presentation/manager/upload_attachments_view_model/upload_attachments_view_model.dart';
import 'package:taskly/features/messages/presentation/manager/send_message_view_model/send_message_view_model_states.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/di/di.dart';
import '../../../attachments/data/models/attachments_dm/attachments_dm.dart';
import '../../../attachments/presentation/manager/upload_attachments_view_model/upload_attachments_view_model_states.dart';
import '../../domain/entities/message_entity.dart';
import '../manager/send_message_view_model/send_message_view_model.dart';

class ChatInputField extends StatelessWidget {
  final String orderId;
  final String currentUserId;
  final String receiverId;

  const ChatInputField({
    super.key,
    required this.orderId,
    required this.currentUserId,
    required this.receiverId,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    var uuid = Uuid();
    String id = uuid.v4();
    return BlocProvider(
      create: (_) =>  getIt<SendMessageViewModel>(),
      child: BlocBuilder<SendMessageViewModel, SendMessageViewModelStates>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                BlocProvider(
                  create: (_) => getIt<UploadAttachmentsViewModel>(),
                  child: BlocListener<UploadAttachmentsViewModel, UploadAttachmentsViewModelStates>(
                    listener: (context, state) {
                      if (state is UploadAttachmentsViewModelStatesSuccess) {
                        final attachments = state.attachments
                            .map((e) => AttachmentModel.fromEntity(e))
                            .toList();


                        final firstAttachment = attachments.first;
                        final isImage = firstAttachment.type.startsWith("image/");
                        final messageType = isImage ? "image" : "file";

                        context.read<SendMessageViewModel>().sendMessage(
                          orderId,
                          MessageEntity(
                            id: const Uuid().v4(),
                            orderId: orderId,
                            senderId: currentUserId,
                            receiverId: receiverId,
                            paymentId: null,
                            messageType: messageType,
                            content: null,
                            attachment: attachments,
                            status: "sent",
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),
                          ),
                        );
                      }
                    },

                    child: BlocBuilder<UploadAttachmentsViewModel, UploadAttachmentsViewModelStates>(
                      builder: (context, state) {
                        if (state is UploadAttachmentsViewModelStatesLoading) {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        }
                        return IconButton(
                          icon: Icon(
                            FontAwesomeIcons.paperclip,
                            color: Colors.grey.shade500,
                          ),
                          onPressed: () {
                            context.read<UploadAttachmentsViewModel>().pickFilesFromDevice(
                              bucketName: "attachments",
                              singleFileMode: true,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),

                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: Colors.grey.shade100,
                      border: Border.all(color: Colors.grey.shade300, width: 2.w),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              CupertinoIcons.paperplane_fill,
                              color: Colors.grey.shade500,
                            ),
                            onPressed: () {
                              final text = _controller.text.trim();
                              if (text.isEmpty) return;

                              context.read<SendMessageViewModel>().sendMessage(
                                orderId,
                                MessageEntity(
                                  id: id, //it's sent from the data source implementation not from here
                                  orderId: orderId,
                                  senderId: currentUserId,
                                  receiverId: receiverId,
                                  paymentId:null ,
                                  messageType: "text",
                                  content: text,
                                  attachment: null,
                                  status: "sent",
                                  createdAt: DateTime.now(),
                                  updatedAt: DateTime.now(),
                                ),
                              );


                              _controller.clear();
                            },
                          ),
                          border: InputBorder.none,
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                        ),
                      ),
                    ),
                  ),
                ),
                if (state is SendMessageViewModelStatesLoading)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
