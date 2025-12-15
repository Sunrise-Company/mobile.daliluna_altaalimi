// ignore_for_file: must_be_iacademyv3utable

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:daliluna_altaalimi/controller/lessonvedio_controller.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/view/widget/loadingvideo.dart';
import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class LessonVedios extends GetView<LessonVediosController> {
  LessonVedios({super.key});
  late VideoPlayerController playercontroller;
  // ignore: unused_field
  late ChewieController _chewieController;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.BackGround2,
        body: SingleChildScrollView(
          child: Column(
            children: [
              GetBuilder<LessonVediosController>(
                init: LessonVediosController(),
                builder: (controller) => Center(
                  child: playercontroller.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: playercontroller.value.aspectRatio,
                          child: Chewie(
                            controller: _chewieController = ChewieController(
                              //  aspectRatio: Get.width/  Get.height,
                              fullScreenByDefault: false,
                              videoPlayerController: playercontroller,
                              autoPlay: false,
                              looping: true,
                              allowedScreenSleep: false,
                              materialProgressColors: ChewieProgressColors(
                                playedColor: AppColor.DeepPurple,
                                handleColor: AppColor.SecondryColor2,
                                backgroundColor: AppColor.BackGround,
                                bufferedColor: AppColor.BackGround,
                              ),

                              placeholder: Container(),
                              autoInitialize: false,
                              showControls: true,
                            ),
                          ),
                        )
                      : LoadingVedio(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
