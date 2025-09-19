
import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/domain/entities/order_entity/order_entity.dart';
import 'package:taskly/features/client/domain/entities/home/freelancer_entity.dart';
import 'package:taskly/features/client/domain/entities/home/service_response_entity.dart';

import '../../../../attachments/domain/entities/attachment_entity/attaachments_entity.dart';

abstract class HomeRepos {
 
  Future<Either<Failures,List<ServiceEntity>>> getServices();
  Future<Either<Failures,OrderEntity>> placeOrder(OrderEntity orderEntity);
  Future<Either<Failures, List<FreelancerEntity>>> getAllFreelancer();
  Future<Either<Failures, List<AttachmentEntity>>> uploadAttachments(List<File> files);
  Future<Either<Failures, void>> deleteAttachment(String attachmentId);
}