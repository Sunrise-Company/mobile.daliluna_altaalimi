import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:daliluna_altaalimi/controller/viewvedio_controller.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/view/widget/loadingvideo.dart';

class ViewVideo extends GetView<ViewVedioController> {
  const ViewVideo({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.BackGround2,
      body: Column(
        children: [
          GetBuilder<ViewVedioController>(
            init: ViewVedioController(),
            builder: (controller) => AspectRatio(
              aspectRatio: controller.videoPlayerController.value.aspectRatio,
              child:
                  controller.chewieController != null &&
                      controller
                          .chewieController!
                          .videoPlayerController
                          .value
                          .isInitialized
                  ? Chewie(controller: controller.chewieController!)
                  : LoadingVedio(),
            ),
          ),
        ],
      ),
    );
  }
}
