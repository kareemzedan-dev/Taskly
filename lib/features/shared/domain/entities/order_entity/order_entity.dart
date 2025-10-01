import '../../../../attachments/data/models/attachments_dm/attachments_dm.dart';

class OrderEntity {
  final String id;
  final String clientId;
  final String? freelancerId;
  final String title;
  final String? description;
  final String?category ;
  final List<AttachmentModel> attachments;
  final ServiceType serviceType;
  final double? budget;
  final OrderStatus status;
  final DateTime? deadline;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int ? offersCount;


  OrderEntity({
    required this.id,
    required this.clientId,
    this.freelancerId,
    required this.title,
    this.description,
    required this.category ,
    this.attachments = const [],
    this.serviceType = ServiceType.public,
    this.budget,
    this.status = OrderStatus.Pending,
    this.deadline,
    required this.createdAt,
    required this.updatedAt,
    required this.offersCount,
  });
}

enum ServiceType { public, private }

enum OrderStatus { Pending, Paid ,Accepted, InProgress,Waiting,Completed,  Cancelled }

