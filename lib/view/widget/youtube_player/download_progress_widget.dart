import 'package:flutter/material.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/download_service.dart';

class DownloadProgressWidget extends StatelessWidget {
  final double progress;
  final String statusText;
  final DownloadStatus status;
  final VoidCallback? onPause;
  final VoidCallback? onResume;
  final VoidCallback? onCancel;

  const DownloadProgressWidget({
    super.key,
    required this.progress,
    required this.statusText,
    required this.status,
    this.onPause,
    this.onResume,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDownloading =
        status == DownloadStatus.downloading ||
        status == DownloadStatus.merging;
    final bool isPaused = status == DownloadStatus.paused;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: AppColor.PrimaryColor.withValues(alpha: 0.03),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
        border: Border.all(
          color: isPaused
              ? Colors.orange.withValues(alpha: 0.4)
              : AppColor.BackGround,
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // أيقونة الحالة
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (isPaused ? Colors.orange : AppColor.PrimaryColor)
                      .withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isPaused
                      ? Icons.pause_circle_outline_rounded
                      : Icons.cloud_download_rounded,
                  color: isPaused ? Colors.orange : AppColor.PrimaryColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              // النص
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isPaused ? 'متوقف مؤقتاً' : 'جاري التنزيل...',
                      style: TextStyle(
                        color: isPaused
                            ? Colors.orange.shade700
                            : AppColor.PrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        letterSpacing: 0.2,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      statusText,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Cairo',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // نسبة التقدم
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: (isPaused ? Colors.orange : AppColor.SecondryColor)
                      .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${(progress * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: isPaused
                        ? Colors.orange.shade700
                        : AppColor.PrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // شريط التقدم
          Stack(
            children: [
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.BackGround2,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress.clamp(0.0, 1.0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isPaused
                          ? [Colors.orange.shade300, Colors.orange.shade600]
                          : [AppColor.SecondryColor, AppColor.PrimaryColor],
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color:
                            (isPaused ? Colors.orange : AppColor.PrimaryColor)
                                .withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // أزرار الإجراء
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (isPaused && onResume != null) ...[
                // زر الاستئناف
                _ActionButton(
                  label: 'استمرار',
                  icon: Icons.play_arrow_rounded,
                  color: AppColor.PrimaryColor,
                  onTap: onResume!,
                ),
                const SizedBox(width: 8),
              ] else if (isDownloading && onPause != null) ...[
                // زر الإيقاف المؤقت
                _ActionButton(
                  label: 'إيقاف مؤقت',
                  icon: Icons.pause_rounded,
                  color: Colors.orange.shade600,
                  onTap: onPause!,
                ),
                const SizedBox(width: 8),
              ],
              // زر الإلغاء دائماً ظاهر
              if (onCancel != null)
                _ActionButton(
                  label: 'إلغاء',
                  icon: Icons.close_rounded,
                  color: Colors.red.shade400,
                  onTap: onCancel!,
                  outlined: true,
                ),
            ],
          ),
        ],
      ),
    ));
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool outlined;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: outlined ? Colors.transparent : color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: color.withValues(alpha: outlined ? 0.5 : 0.0),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
