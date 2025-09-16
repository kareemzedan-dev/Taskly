
import '../../../domain/entities/home/attaachments_entity.dart';

class AttachmentModel extends AttachmentEntity {
  const AttachmentModel({
    required super.id,
    required super.name,
    required super.url,
    required super.size,
    required super.type,
  });

  factory AttachmentModel.fromJson(Map<String, dynamic> json) {
    return AttachmentModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      url: json['url'] ?? '',
      size: json['size'] ?? 0,
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'size': size,
      'type': type,
    };
  }
}