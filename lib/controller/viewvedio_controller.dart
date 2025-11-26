import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:video_player/video_player.dart';

class ViewVedioController extends GetxController {
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;

  @override
  void onInit() {
    super.onInit();
    initializePlayer();
  }

  @override
  void onClose() {
    videoPlayerController.dispose();
    chewieController!.dispose();
  }

  Future<void> initializePlayer() async {
    videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(
        "https://www.shutterstock.com/shutterstock/videos/1082598301/preview/stock-footage-dolphins-playing-in-the-blue-water-of-red-sea-underwater-shot-of-wild-dolphin-taking-breath.webm",
      ),
    );
    await Future.wait([videoPlayerController.initialize()]);
    chewieController = ChewieController(
      aspectRatio: videoPlayerController.value.aspectRatio,
      fullScreenByDefault: false,
      videoPlayerController: videoPlayerController,
      autoPlay: false,
      looping: true,
      allowedScreenSleep: false,
      allowFullScreen: false,
      materialProgressColors: ChewieProgressColors(
        playedColor: AppColor.DeepPurple,
        handleColor: AppColor.SecondryColor2,
        backgroundColor: AppColor.BackGround,
        bufferedColor: AppColor.BackGround,
      ),
      placeholder: Container(),
      autoInitialize: true,
      showControls: true,
    );
    update();
  }
}
