import 'package:daliluna_altaalimi/core/services/download_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DownloadIcon extends StatelessWidget {
  final Map<String, dynamic> videoData;
  final DownloadController _downloadController = Get.find<DownloadController>();

  DownloadIcon({Key? key, required this.videoData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // استخراج معرّف فريد ومستقر للفيديو
    final String videoId = (videoData['id']?.toString() ?? videoData['name'])
        .replaceAll(RegExp(r'[^A-Za-z0-9]'), '_');
    final List<dynamic>? files = videoData['files'];

    // في حال كان للفيديو دقات متعددة، نضيف الدقة إلى المعرف ليكون فريدًا لكل ملف
    // سنعتمد على أن المستخدم سيختار الدقة، وهنا نتحقق من جميع الدقات الممكنة

    // هذه الدالة ستبحث عن أي ملف محمل يطابق المعرف الأساسي للفيديو
    String getDownloadedVersionId() {
      for (var key in _downloadController.downloadStatusMap.keys) {
        if (key.startsWith(videoId) &&
            _downloadController.downloadStatusMap[key]?.state.value ==
                DownloadState.downloaded) {
          return key;
        }
      }
      return videoId; // ارجع المعرف الأساسي إذا لم يتم العثور على نسخة محملة
    }

    return Obx(() {
      final effectiveId = getDownloadedVersionId();
      final status = _downloadController.downloadStatusMap[effectiveId];
      final state = status?.state.value ?? DownloadState.none;
      final progress = status?.progress.value ?? 0.0;

      switch (state) {
        case DownloadState.downloading:
          return SizedBox(
            width: 40,
            height: 40,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: progress < 0
                      ? null
                      : progress, // مؤشر غير محدد إذا كانت القيمة -1
                  strokeWidth: 3,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                ),
                Text(
                  progress < 0 ? '' : '${(progress * 100).toInt()}%',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        case DownloadState.downloaded:
          return IconButton(
            icon: Icon(
              Icons.delete_forever,
              color: Colors.red.shade700,
              size: 30,
            ),
            onPressed: () {
              // عرض نافذة تأكيد قبل الحذف
              Get.defaultDialog(
                title: 'تأكيد الحذف',
                middleText: 'هل أنت متأكد من رغبتك في حذف هذا الفيديو؟',
                textConfirm: 'حذف',
                textCancel: 'إلغاء',
                confirmTextColor: Colors.white,
                onConfirm: () {
                  _downloadController.deleteVideo(effectiveId);
                  Get.back();
                },
              );
            },
          );
        case DownloadState.failed:
          return IconButton(
            icon: Icon(Icons.replay, color: Colors.orange.shade700, size: 30),
            onPressed: () => _downloadController.startDownload(videoData),
          );
        case DownloadState.none:
        default:
          return IconButton(
            icon: Icon(
              Icons.download_for_offline_outlined,
              color: Colors.deepPurple,
              size: 30,
            ),
            onPressed: () => _downloadController.startDownload(videoData),
          );
      }
    });
  }
}
