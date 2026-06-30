import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/controller/youtube_player_controller.dart';
import 'premium_action_button.dart';

class PlayerControlBar extends StatelessWidget {
  final YoutubePlayerController ctrl;
  final bool isDownloading;

  const PlayerControlBar({
    super.key,
    required this.ctrl,
    required this.isDownloading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: PremiumActionButton(
              icon: Icons.arrow_back_rounded,
              label: 'رجوع',
              onTap: () {
                ctrl.restoreSystemUI();
                Get.back();
              },
              color: AppColor.PrimaryColor,
            ),
          ),
          const SizedBox(width: 12),
          if (ctrl.localVideoPath == null && ctrl.isPlayerReady) ...[
            Expanded(
              child: ctrl.isFetchingQualities
                  ? _buildLoadingButton()
                  : PremiumActionButton(
                      icon: Icons.download_rounded,
                      label: 'تحميل',
                      onTap: isDownloading ? null : ctrl.downloadVideo,
                      color: AppColor.PrimaryColor,
                      isPrimary: true,
                    ),
            ),
            const SizedBox(width: 12),
          ] else if (ctrl.localVideoPath != null) ...[
            Expanded(
              child: PremiumActionButton(
                icon: Icons.delete_outline_rounded,
                label: 'حذف',
                onTap: ctrl.deleteVideo,
                color: Colors.redAccent,
                isWarning: true,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: PremiumActionButton(
              icon: ctrl.isFullScreen
                  ? Icons.fullscreen_exit_rounded
                  : Icons.fullscreen_rounded,
              label: ctrl.isFullScreen ? 'تصغير' : 'تكبير',
              onTap: ctrl.toggleFullScreen,
              color: AppColor.PrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingButton() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColor.SecondryColor2.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: AppColor.PrimaryColor,
          ),
        ),
      ),
    );
  }
}
