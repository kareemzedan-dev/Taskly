import 'dart:convert';

import 'package:taskly/features/messages/domain/entities/message_entity.dart';
import 'package:taskly/features/attachments/data/models/attachments_dm/attachments_dm.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    super.orderId,
    super.paymentId,
    required super.senderId,
    required super.receiverId,
    required super.messageType,
    super.content,
    super.attachment,
    required super.status,
    super.deliveredAt,
    super.seenAt,
    required super.createdAt,
    required super.updatedAt,
    required super.senderType,
    required super.receiverType,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      orderId: json['order_id'] as String?,
      paymentId: json['payment_id'] as String?,
      senderId: json['sender_id'] as String,
      receiverId: json['receiver_id'] as String,
      messageType: json['message_type'] as String,
      content: json['content'] as String?,
      attachment: json['attachment'] != null
          ? (() {
        final raw = json['attachment'];
        if (raw is String) {
          // decode string → list
          final decoded = jsonDecode(raw);
          if (decoded is List) {
            return decoded
                .map((a) => AttachmentModel.fromJson(a as Map<String, dynamic>))
                .toList();
          }
        } else if (raw is List) {
          // already list
          return raw
              .map((a) => AttachmentModel.fromJson(a as Map<String, dynamic>))
              .toList();
        }
        return null;
      })()
          : null,

      status: json['status'] as String,
      deliveredAt: json['delivered_at'] != null
          ? DateTime.parse(json['delivered_at'] as String)
          : null,
      seenAt: json['seen_at'] != null
          ? DateTime.parse(json['seen_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      senderType: json['sender_type'] as String,
      receiverType: json['receiver_type'] as String,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'paymentId': paymentId,
      'senderId': senderId,
      'receiverId': receiverId,
      'messageType': messageType,
      'content': content,
      'attachment': attachment?.map((a) => a.toJson()).toList(),
      'status': status,
      'deliveredAt': deliveredAt?.toIso8601String(),
      'seenAt': seenAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'senderType': senderType,
      'receiverType': receiverType,
    };
  }

  MessageEntity toEntity() => this;
}
