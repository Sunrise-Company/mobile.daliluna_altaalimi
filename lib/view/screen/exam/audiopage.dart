// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../controller/audiplayerController.dart';
// import '../../../core/constant/color.dart';
//
// class AudioPage extends StatelessWidget {
//   final String url;
//   int index;
//   AudioPage({required this.url, required this.index});
//
//   @override
//   Widget build(BuildContext context) {
//     final AudioController audioController = Get.put(AudioController());
//     print(url);
//
//     return Obx(() {
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: 20,
//                 backgroundColor: Colors.white,
//                 child: IconButton(
//                   onPressed: () {
//                     print(url);
//                     print(index);
//                     audioController.playAudio(url, index);
//                   },
//                   icon: Icon(
//                     audioController.currentPlayingIndex == index &&
//                             audioController.isPlaying.value
//                         ? Icons.pause
//                         : Icons.play_arrow,
//                     color: AppColor.DeepPurple,
//                   ),
//                 ),
//               ),
//               Expanded(
//                   child: Slider(
//                 min: 0,
//                 max: audioController.currentPlayingIndex == index &&
//                         audioController.isPlaying.value
//                     ? audioController.duration.value.inSeconds.toDouble()
//                     : 1000.0,
//                 value: audioController.position.value.inSeconds.toDouble(),
//                 onChanged: (value) =>
//                     audioController.currentPlayingIndex == index
//                         ? audioController.seekAudio(value)
//                         : {},
//                 activeColor: AppColor.DeepPurple,
//                 thumbColor: Colors.white,
//                 inactiveColor: Color.fromARGB(255, 209, 207, 207),
//               ))
//             ],
//           ),
//           audioController.currentPlayingIndex == index &&
//                   audioController.isPlaying.value
//               ? Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                         audioController.format(audioController.position.value)),
//                     Text(
//                         audioController.format(audioController.duration.value)),
//                   ],
//                 )
//               : Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text("00:00"),
//                     Text("00:00"),
//                   ],
//                 ),
//         ],
//       );
//     });
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/audiplayerController.dart';
import '../../../core/constant/color.dart';

class AudioPage extends StatelessWidget {
  final String url;
  final int index;

  AudioPage({required this.url, required this.index});

  @override
  Widget build(BuildContext context) {
    final AudioController audioController = Get.put(AudioController());

    return Obx(() {
      final bool isPlayingNow =
          audioController.currentPlayingIndex == index &&
          audioController.isPlaying.value;

      return Card(
        elevation: 4,
        shadowColor: AppColor.DeepPurple.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppColor.DeepPurple.withOpacity(0.8),
                          AppColor.DeepPurple.withOpacity(0.4),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.DeepPurple.withOpacity(0.2),
                          blurRadius: 6,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () {
                        audioController.playAudio(url, index);
                      },
                      icon: Icon(
                        isPlayingNow ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 7,
                        ),
                      ),
                      child: Slider(
                        min: 0,
                        max: isPlayingNow
                            ? audioController.duration.value.inSeconds
                                  .toDouble()
                            : 1000.0,
                        value: audioController.position.value.inSeconds
                            .clamp(0, audioController.duration.value.inSeconds)
                            .toDouble(),
                        onChanged: (value) {
                          if (isPlayingNow) {
                            audioController.seekAudio(value);
                          }
                        },
                        activeColor: AppColor.DeepPurple,
                        inactiveColor: Colors.grey.withOpacity(0.3),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isPlayingNow
                        ? audioController.format(audioController.position.value)
                        : "00:00",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    isPlayingNow
                        ? audioController.format(audioController.duration.value)
                        : "00:00",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
