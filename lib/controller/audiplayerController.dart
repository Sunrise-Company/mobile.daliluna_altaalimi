import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class AudioController extends GetxController {
  final _audioPlayer = AudioPlayer();
  var duration = Duration.zero.obs;
  var position = Duration.zero.obs;
  var isPlaying = false.obs;
  var currentPlayingUrl = ''.obs;
  String format(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }

  var currentUrl = ''.obs;
  var currentPlayingIndex = -1.obs;
  void playAudio(String url, int index) async {
    if (isPlaying.value && currentPlayingIndex == index) {
      // If the same audio is being played, pause it
      await _audioPlayer.pause();
    } else {
      if (isPlaying.value) {
        await _audioPlayer.stop();
      }
      await _audioPlayer.play(UrlSource(url));
      currentPlayingIndex = index;
    }
    update();
  }

  // currentPlayingUrl.value = url;

  void seekAudio(double value) async {
    final position = Duration(seconds: value.toInt());
    await _audioPlayer.seek(position);
    await _audioPlayer.resume();
    update();
  }

  void updatePosition(Duration newPosition) {
    position.value = newPosition;
    update();
  }

  @override
  void onInit() {
    super.onInit();

    // _audioPlayer.onPlayerStateChanged.listen((state) {
    //   isPlaying.value = state == PlayerState.PLAYING;
    // });

    _audioPlayer.onDurationChanged.listen((newDuration) {
      duration.value = newDuration;
    });
    // _audioPlayer.onAudioPositionChanged.listen((newPosition) {
    //   updatePosition(newPosition);
    // });
    //   _audioPlayer.onAudioPositionChanged.listen((newPosition) {
    //     position.value = newPosition;
    //   });
    update();
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    _audioPlayer.pause();
    super.onClose();
  }
}
