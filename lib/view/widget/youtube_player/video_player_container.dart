import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:chewie/chewie.dart';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:daliluna_altaalimi/controller/youtube_player_controller.dart';
import 'player_ui_changed_screen.dart';

class VideoPlayerContainer extends StatelessWidget {
  final YoutubePlayerController ctrl;

  const VideoPlayerContainer({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    if (ctrl.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    Widget? localPlayer;
    if (ctrl.localVideoPath != null) {
      if (Platform.isIOS) {
        localPlayer = ctrl.chewieController != null
            ? Chewie(controller: ctrl.chewieController!)
            : null;
      } else {
        localPlayer = ctrl.betterPlayerController != null
            ? BetterPlayer(
                key: ctrl.betterPlayerKey,
                controller: ctrl.betterPlayerController!
              )
            : null;
      }
    }

    if (ctrl.localVideoPath == null && ctrl.uiChangedDetected) {
      return PlayerUiChangedScreen(ctrl: ctrl);
    }

    return Padding(
      padding: EdgeInsets.zero,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (localPlayer != null)
            localPlayer
          else if (ctrl.localVideoPath == null)
            AnimatedOpacity(
              opacity: ctrl.isPlayerReady ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: ctrl.webViewController != null
                  ? WebViewWidget(controller: ctrl.webViewController!)
                  : const SizedBox(),
            )
          else
            const Center(child: CircularProgressIndicator(color: Colors.white)),
          if (ctrl.localVideoPath == null && !ctrl.isPlayerReady)
            const CircularProgressIndicator(color: Colors.white),
        ],
      ),
    );
  }
}
