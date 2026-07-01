import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() async {
  await testVideo('7NjdKqoRvSE', 'New video');
}

Future<void> testVideo(String id, String label) async {
  final yt = YoutubeExplode();
  print('Testing [$label] $id ...');
  try {
    final video = await yt.videos.get(id);
    print('  Title: ${video.title}');
    print('  IsLive: ${video.isLive}');
    print('  viewCount: ${video.engagement.viewCount}');
  } catch (e) {
    print('  ERROR getting video info: $e');
  }

  // Test all clients
  final List<List<YoutubeApiClient>> clients = [
    [YoutubeApiClient.android],
    [YoutubeApiClient.safari],
    [YoutubeApiClient.androidVr],
    [YoutubeApiClient.ios],
    [YoutubeApiClient.mweb],
    [YoutubeApiClient.android, YoutubeApiClient.safari],
    [YoutubeApiClient.safari, YoutubeApiClient.androidVr],
  ];
  final names = [
    'android',
    'safari',
    'androidVr',
    'ios',
    'mweb',
    'android+safari',
    'safari+androidVr',
  ];

  for (int i = 0; i < clients.length; i++) {
    final yt2 = YoutubeExplode();
    try {
      final manifest = await yt2.videos.streamsClient.getManifest(
        id,
        ytClients: clients[i],
      );
      print(
        '  [${names[i]}] SUCCESS Muxed:${manifest.muxed.length} Audio:${manifest.audioOnly.length} Video:${manifest.videoOnly.length}',
      );
    } catch (e) {
      print('  [${names[i]}] FAIL: ${e.toString().split('\n').first}');
    } finally {
      yt2.close();
    }
  }
  yt.close();
}
