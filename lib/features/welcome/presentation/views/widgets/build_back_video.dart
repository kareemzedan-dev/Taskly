import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

SizedBox buildBackVideo(VideoPlayerController controller) {
  return SizedBox.expand(
    child:
        controller.value.isInitialized
            ? FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: controller.value.size.width,
                height: controller.value.size.height,
                child: VideoPlayer(controller),
              ),
            )
            : Container(color: Colors.black),
  );
}
