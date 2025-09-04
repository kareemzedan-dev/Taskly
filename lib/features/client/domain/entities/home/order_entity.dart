class OrderEntity {
  final String id;
  final String clientId;
  final String? freelancerId;
  final String title;
  final String? description;
  final String?Category ;
  final List<Attachment> attachments;
  final ServiceType serviceType;
  final double? budget;
  final OrderStatus status;
  final DateTime? deadline;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderEntity({
    required this.id,
    required this.clientId,
    this.freelancerId,
    required this.title,
    this.description,
    required this.Category ,
    this.attachments = const [],
    this.serviceType = ServiceType.public,
    this.budget,
    this.status = OrderStatus.pending,
    this.deadline,
    required this.createdAt,
    required this.updatedAt,
  });
}

enum ServiceType { public, private }

enum OrderStatus { pending, accepted, inProgress, completed, cancelled }

class Attachment {
  final String type;  
  final String url;

  Attachment({required this.type, required this.url});

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      type: json['type'] as String,
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'url': url,
    };
  }
}
