import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() async {
  final videoId = 'zp8ji_vMaKY';

  final List<List<YoutubeApiClient>> clientCombinations = [
    [YoutubeApiClient.ios],
    [YoutubeApiClient.android],
    [YoutubeApiClient.mweb],
    [YoutubeApiClient.safari],
    [YoutubeApiClient.androidVr],
    [YoutubeApiClient.ios, YoutubeApiClient.android],
    [YoutubeApiClient.android, YoutubeApiClient.safari],
    [YoutubeApiClient.mweb, YoutubeApiClient.ios],
    [YoutubeApiClient.safari, YoutubeApiClient.ios],
    [YoutubeApiClient.android, YoutubeApiClient.mweb],
    [YoutubeApiClient.ios, YoutubeApiClient.safari, YoutubeApiClient.android],
  ];

  final clientNames = [
    'ios',
    'android',
    'mweb',
    'safari',
    'androidVr',
    'ios + android',
    'android + safari',
    'mweb + ios',
    'safari + ios',
    'android + mweb',
    'ios + safari + android',
  ];

  for (int i = 0; i < clientCombinations.length; i++) {
    final yt = YoutubeExplode();
    final name = clientNames[i];
    try {
      final manifest = await yt.videos.streamsClient.getManifest(
        videoId,
        ytClients: clientCombinations[i],
      );
      print(
        '[$name] SUCCESS! Muxed:${manifest.muxed.length} Audio:${manifest.audioOnly.length} Video:${manifest.videoOnly.length}',
      );
    } catch (e) {
      print('[$name] FAIL: ${e.toString().split('\n').first}');
    } finally {
      yt.close();
    }
  }
}
