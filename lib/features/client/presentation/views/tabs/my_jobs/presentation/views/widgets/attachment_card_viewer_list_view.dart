import 'package:flutter/cupertino.dart';
import 'package:taskly/features/client/domain/entities/home/attaachments_entity.dart';

import '../../../../../../../data/models/home/attaachments_dm.dart';
import 'attachment_card_viewer.dart';

class AttachmentCardViewerListView extends StatelessWidget {
  final List<AttachmentModel> attachmentEntity;
  final bool isFreelancer;

  const AttachmentCardViewerListView({
    super.key,
    required this.attachmentEntity,
    required this.isFreelancer,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: attachmentEntity.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: AttachmentItemViewer(
              attachmentName: attachmentEntity[index].name,
              attachmentPath: attachmentEntity[index].url,
              isFreelancer: isFreelancer,
            ),
          );
        },
      ),
    );
  }
}
