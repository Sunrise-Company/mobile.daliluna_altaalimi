import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:daliluna_altaalimi/controller/youtube_player_controller.dart';

class PlayerUiChangedScreen extends StatelessWidget {
  final YoutubePlayerController ctrl;

  const PlayerUiChangedScreen({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0D0D0D),
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF4444).withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.construction_rounded,
                    color: Color(0xFFFF6B6B),
                    size: 40,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'المشغّل يحتاج تحديثاً',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'الفريق التقني يعمل على حل هذه المشكلة في أقرب وقت.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 14,
                    height: 1.7,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 32),
                TextButton(
                  onPressed: () {
                    ctrl.restoreSystemUI();
                    Get.back();
                  },
                  child: Text(
                    'رجوع',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 14,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
