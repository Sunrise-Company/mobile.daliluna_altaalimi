import 'package:daliluna_altaalimi/controller/videoPlayerController.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InlineVideoPlayer extends StatelessWidget {
  final String videoUrl;

  const InlineVideoPlayer({Key? key, required this.videoUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VideoPlayerControllerX>(
      init: VideoPlayerControllerX(videoUrl),
      tag: videoUrl,
      builder: (controller) {
        return _buildPlayer(controller);
      },
    );
  }

  Widget _buildPlayer(VideoPlayerControllerX controller) {
    return Obx(() {
      if (!controller.isInitialized.value) {
        return Center(child: CircularProgressIndicator());
      }

      return Chewie(controller: controller.chewieController!);
    });
  }
}
