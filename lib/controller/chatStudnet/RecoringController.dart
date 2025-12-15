// import 'package:daliluna_altaalimi/core/constant/color.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter/cupertino.dart';
//
// import 'dart:io';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:record/record.dart';
//
// class RecorderController extends GetxController {
//   final AudioRecorder _audioRecorder = AudioRecorder();
//   var isRecording = false.obs;
//
//   RxString recordingPath = ''.obs;
//   RxString currentDuration = '00:00'.obs;
//   DateTime? _startTime;
//
//   Future<void> startRecording() async {
//     final permissionGranted = await _audioRecorder.hasPermission();
//     if (permissionGranted) {
//       try {
//         Directory appDir = await getApplicationDocumentsDirectory();
//         recordingPath.value =
//             '${appDir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
//
//         await _audioRecorder.start(const RecordConfig(),
//             path: recordingPath.value);
//         isRecording.value = true;
//
//         _startTime = DateTime.now();
//         updateDuration();
//       } catch (e) {
//         print('Error starting recording: $e');
//       }
//     } else {
//       print('Permission to record audio was denied.');
//     }
//   }
//
//   Future<void> stopRecording() async {
//     try {
//       // الحصول على المسار قبل الإيقاف
//       final path = recordingPath.value;
//
//       // إيقاف التسجيل
//       await _audioRecorder.stop();
//
//       // التأكد من وجود الملف
//       final file = File(path);
//       if (await file.exists()) {
//         // إضافة تأخير بسيط لضمان اكتمال الكتابة
//         await Future.delayed(Duration(milliseconds: 200));
//       }
//
//       isRecording.value = false;
//       currentDuration.value = '00:00';
//     } catch (e) {
//       print('Error stopping recording: $e');
//     }
//   }
//
//   void deleteRecording() {
//     recordingPath.value = '';
//     isRecording.value = false;
//     currentDuration.value = '00:00';
//   }
//
//   void updateDuration() {
//     if (_startTime != null && isRecording.value) {
//       final now = DateTime.now();
//       final duration = now.difference(_startTime!);
//       final durationInSeconds = duration.inSeconds;
//       final minutes = (durationInSeconds ~/ 60).toString().padLeft(2, '0');
//       final seconds = (durationInSeconds % 60).toString().padLeft(2, '0');
//       currentDuration.value = '$minutes:$seconds';
//
//       Future.delayed(const Duration(seconds: 1), updateDuration);
//     }
//   }
// }
//
// class AudioPlayerWidget extends StatefulWidget {
//   final String audioUrl;
//
//   const AudioPlayerWidget({Key? key, required this.audioUrl}) : super(key: key);
//
//   @override
//   _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
// }
//
// class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   bool _isPlaying = false;
//   Duration _duration = Duration.zero;
//   Duration _position = Duration.zero;
//   bool _isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeAudio();
//
//     _audioPlayer.onDurationChanged.listen((newDuration) {
//       setState(() => _duration = newDuration);
//     });
//
//     _audioPlayer.onPositionChanged.listen((newPosition) {
//       setState(() => _position = newPosition);
//     });
//
//     _audioPlayer.onPlayerComplete.listen((_) {
//       setState(() {
//         _isPlaying = false;
//         _position = Duration.zero;
//       });
//     });
//   }
//
//   Future<void> _initializeAudio() async {
//     try {
//       await _audioPlayer.setSourceUrl(widget.audioUrl);
//
//       final duration = await _audioPlayer.getDuration();
//
//       if (duration != null) {
//         setState(() {
//           _duration = duration;
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       print("Error initializing audio: $e");
//       setState(() => _isLoading = false);
//     }
//   }
//
//   void _togglePlayPause() async {
//     if (_isPlaying) {
//       await _audioPlayer.pause();
//     } else {
//       await _audioPlayer.stop();
//       await _audioPlayer.setSourceUrl(widget.audioUrl);
//       await _audioPlayer.play(UrlSource(widget.audioUrl));
//     }
//     setState(() => _isPlaying = !_isPlaying);
//   }
//
//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 250,
//       child: Row(
//         children: [
//           IconButton(
//             icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow,
//                 color: AppColor.PrimaryColor),
//             onPressed: _togglePlayPause,
//           ),
//           Expanded(
//             child: Slider(
//               min: 0,
//               max: _duration.inSeconds.toDouble(),
//               value: _position.inSeconds
//                   .toDouble()
//                   .clamp(0, _duration.inSeconds.toDouble()),
//               onChanged: (value) async {
//                 final newPosition = Duration(seconds: value.toInt());
//                 await _audioPlayer.seek(newPosition);
//                 setState(() => _position = newPosition);
//               },
//             ),
//           ),
//           _isLoading
//               ? CircularProgressIndicator()
//               : Text(
//                   _isPlaying
//                       ? "${_position.inMinutes}:${(_position.inSeconds % 60).toString().padLeft(2, '0')}"
//                       : "${_duration.inMinutes}:${(_duration.inSeconds % 60).toString().padLeft(2, '0')}",
//                   style: TextStyle(fontSize: 14),
//                 ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:async';

import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class RecorderController extends GetxController {
  final AudioRecorder _audioRecorder = AudioRecorder();
  var isRecording = false.obs;

  RxString recordingPath = ''.obs;
  RxString currentDuration = '00:00'.obs;
  DateTime? _startTime;

  Future<void> startRecording() async {
    final permissionGranted = await _audioRecorder.hasPermission();
    if (permissionGranted) {
      try {
        Directory appDir = await getApplicationDocumentsDirectory();
        recordingPath.value =
            '${appDir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _audioRecorder.start(
          const RecordConfig(),
          path: recordingPath.value,
        );
        isRecording.value = true;

        _startTime = DateTime.now();
        updateDuration();
      } catch (e) {}
    } else {}
  }

  Future<void> stopRecording() async {
    try {
      final path = recordingPath.value;
      await _audioRecorder.stop();

      final file = File(path);
      if (await file.exists()) {
        await Future.delayed(const Duration(milliseconds: 200));
      }

      isRecording.value = false;
      currentDuration.value = '00:00';
    } catch (e) {}
  }

  void deleteRecording() {
    recordingPath.value = '';
    isRecording.value = false;
    currentDuration.value = '00:00';
  }

  void updateDuration() {
    if (_startTime != null && isRecording.value) {
      final now = DateTime.now();
      final duration = now.difference(_startTime!);
      final durationInSeconds = duration.inSeconds;
      final minutes = (durationInSeconds ~/ 60).toString().padLeft(2, '0');
      final seconds = (durationInSeconds % 60).toString().padLeft(2, '0');
      currentDuration.value = '$minutes:$seconds';

      Future.delayed(const Duration(seconds: 1), updateDuration);
    }
  }
}

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;

  const AudioPlayerWidget({Key? key, required this.audioUrl}) : super(key: key);

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isLoading = true;

  late final StreamSubscription<Duration> _durationSub;
  late final StreamSubscription<Duration> _positionSub;
  late final StreamSubscription<void> _completeSub;

  @override
  void initState() {
    super.initState();
    _initializeAudio();

    _durationSub = _audioPlayer.onDurationChanged.listen((newDuration) {
      if (!mounted) return;
      setState(() => _duration = newDuration);
    });

    _positionSub = _audioPlayer.onPositionChanged.listen((newPosition) {
      if (!mounted) return;
      setState(() => _position = newPosition);
    });

    _completeSub = _audioPlayer.onPlayerComplete.listen((_) {
      if (!mounted) return;
      setState(() {
        _isPlaying = false;
        _position = Duration.zero;
      });
    });
  }

  Future<void> _initializeAudio() async {
    try {
      await _audioPlayer.setSourceUrl(widget.audioUrl);

      final duration = await _audioPlayer.getDuration();
      if (!mounted) return; // ✅ حماية بعد await
      if (duration != null) {
        setState(() {
          _duration = duration;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return; // ✅ حماية إضافية
      setState(() => _isLoading = false);
    }
  }

  void _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.stop();
      await _audioPlayer.setSourceUrl(widget.audioUrl);
      await _audioPlayer.play(UrlSource(widget.audioUrl));
    }
    if (!mounted) return; // ✅ تأكيد قبل setState
    setState(() => _isPlaying = !_isPlaying);
  }

  @override
  void dispose() {
    _durationSub.cancel();
    _positionSub.cancel();
    _completeSub.cancel();
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              color: AppColor.PrimaryColor,
            ),
            onPressed: _togglePlayPause,
          ),
          Expanded(
            child: Slider(
              min: 0,
              max: _duration.inSeconds.toDouble(),
              value: _position.inSeconds.toDouble().clamp(
                0,
                _duration.inSeconds.toDouble(),
              ),
              onChanged: (value) async {
                final newPosition = Duration(seconds: value.toInt());
                await _audioPlayer.seek(newPosition);
                if (!mounted) return;
                setState(() => _position = newPosition);
              },
            ),
          ),
          _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  _isPlaying
                      ? "${_position.inMinutes}:${(_position.inSeconds % 60).toString().padLeft(2, '0')}"
                      : "${_duration.inMinutes}:${(_duration.inSeconds % 60).toString().padLeft(2, '0')}",
                  style: const TextStyle(fontSize: 14),
                ),
        ],
      ),
    );
  }
}
