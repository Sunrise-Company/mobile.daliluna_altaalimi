import 'dart:math' as math;
import 'package:daliluna_altaalimi/download_service.dart';
import 'package:daliluna_altaalimi/view/widget/comments_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:daliluna_altaalimi/controller/youtube_player_controller.dart';
import 'package:daliluna_altaalimi/view/widget/youtube_player/player_control_bar.dart';
import 'package:daliluna_altaalimi/view/widget/youtube_player/download_progress_widget.dart';
import 'package:daliluna_altaalimi/view/widget/youtube_player/video_player_container.dart';

class YoutubePlayerScreen extends GetView<YoutubePlayerController> {
  const YoutubePlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<YoutubePlayerController>(
      builder: (ctrl) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, _) {
                if (didPop) return;
                if (ctrl.isFullScreen) {
                  ctrl.toggleFullScreen();
                  return;
                }
                ctrl.restoreSystemUI();
                Get.back();
              },
              child: StreamBuilder<Map<String, DownloadTask>>(
                stream: ctrl.downloadService.progressStream,
                initialData: const {},
                builder: (context, snapshot) {
                  final task = snapshot.data?[ctrl.videoId];
                  final isDownloading =
                      task?.status == DownloadStatus.downloading ||
                      task?.status == DownloadStatus.merging;

                  return Stack(
                    children: [
                      // ── المحتوى أسفل المشغّل (شريط التحكم والتعليقات) ──
                      if (!ctrl.isFullScreen)
                        SafeArea(
                          child: Column(
                            children: [
                              // مساحة محجوزة وهمية بنفس حجم المشغّل تماماً
                              const AspectRatio(
                                aspectRatio: 16 / 9,
                                child: SizedBox(),
                              ),
                              PlayerControlBar(
                                ctrl: ctrl,
                                isDownloading: isDownloading,
                              ),
                              if (task != null &&
                                  (task.status == DownloadStatus.downloading ||
                                      task.status == DownloadStatus.merging ||
                                      task.status == DownloadStatus.paused))
                                Container(
                                  color: Colors.white,
                                  child: DownloadProgressWidget(
                                    progress: task.progress,
                                    statusText: task.statusText,
                                    status: task.status,
                                    onPause:
                                        task.status ==
                                                DownloadStatus.downloading ||
                                            task.status ==
                                                DownloadStatus.merging
                                        ? () => ctrl.downloadService
                                              .pauseDownload(ctrl.videoId)
                                        : null,
                                    onResume:
                                        task.status == DownloadStatus.paused
                                        ? () => ctrl.downloadService
                                              .resumeDownload(ctrl.videoId)
                                        : null,
                                    onCancel: () => ctrl.downloadService
                                        .cancelDownload(ctrl.videoId),
                                  ),
                                ),
                              Expanded(
                                child: Container(
                                  color: Colors.white,
                                  child: CommentsWidget(
                                    lessonId: ctrl.lessonId.toString(),
                                    type: ctrl.type,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      // ── المشغّل ──
                      SafeArea(
                        top: !ctrl.isFullScreen,
                        bottom: !ctrl.isFullScreen,
                        left: !ctrl.isFullScreen,
                        right: !ctrl.isFullScreen,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final screenSize = MediaQuery.of(context).size;
                              final maxDim = math.max(
                                screenSize.width,
                                screenSize.height,
                              );
                              final minDim = math.min(
                                screenSize.width,
                                screenSize.height,
                              );

                              final targetWidth = ctrl.isFullScreen
                                  ? maxDim
                                  : minDim;
                              final targetHeight = ctrl.isFullScreen
                                  ? minDim
                                  : (minDim * 9 / 16);

                              return OverflowBox(
                                alignment: Alignment.topCenter,
                                maxWidth: double.infinity,
                                maxHeight: double.infinity,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 350),
                                  curve: Curves.easeInOutCubic,
                                  width: ctrl.isFullScreen ? maxDim : minDim,
                                  height: ctrl.isFullScreen
                                      ? minDim
                                      : (minDim * 9 / 16),
                                  child: ctrl.localVideoPath != null
                                      ? VideoPlayerContainer(ctrl: ctrl)
                                      : FittedBox(
                                          fit: BoxFit.fill,
                                          child: SizedBox(
                                            width: targetWidth,
                                            height: targetHeight,
                                            child: VideoPlayerContainer(
                                              ctrl: ctrl,
                                            ),
                                          ),
                                        ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      // ── زر التصغير اليدوي ──
                      Positioned(
                        top: 24,
                        left: 24,
                        child: SafeArea(
                          child: AnimatedOpacity(
                            opacity: ctrl.isFullScreen ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 350),
                            child: IgnorePointer(
                              ignoring: !ctrl.isFullScreen,
                              child: Material(
                                color: Colors.black.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(30),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(30),
                                  onTap: ctrl.toggleFullScreen,
                                  child: const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Icon(
                                      Icons.fullscreen_exit_rounded,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
