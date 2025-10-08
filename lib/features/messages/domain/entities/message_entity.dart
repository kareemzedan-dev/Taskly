
import 'package:taskly/features/attachments/data/models/attachments_dm/attachments_dm.dart';

class MessageEntity   {
  final String id;
  final String? orderId;
  final String? paymentId;
  final String senderId;
  final String receiverId;
  final String messageType;
  final String? content;
  final List<AttachmentModel>? attachment;
  final String status;
  final DateTime? deliveredAt;
  final DateTime? seenAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String senderType;
  final String receiverType;

  const MessageEntity({
    required this.id,
    this.orderId,
    this.paymentId,
    required this.senderId,
    required this.receiverId,
    required this.messageType,
    this.content,
    this.attachment,
    required this.status,
    this.deliveredAt,
    this.seenAt,
    required this.createdAt,
    required this.updatedAt,
    required this.senderType,
    required this.receiverType,
  });

  @override
  List<Object?> get props => [
    id,
    orderId,
    paymentId,
    senderId,
    receiverId,
    messageType,
    content,
    attachment,
    status,
    deliveredAt,
    seenAt,
    createdAt,
    updatedAt,
    senderType,
    receiverType,
  ];


}
