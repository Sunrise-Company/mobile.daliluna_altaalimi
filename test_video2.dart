import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() async {
  await testVideo('zp8ji_vMaKY', 'Video with error');
  print('---');
  await testVideo('plZXk9ykqUk', 'Video that works');
}

Future<void> testVideo(String id, String label) async {
  final yt = YoutubeExplode();
  print('Testing [$label] $id ...');
  try {
    final video = await yt.videos.get(id);
    print('  Title: ${video.title}');
    print('  IsLive: ${video.isLive}');
    print('  Engagement: ${video.engagement}');
    
    final manifest = await yt.videos.streamsClient.getManifest(
      id,
      ytClients: [
        YoutubeApiClient.safari,
        YoutubeApiClient.androidVr,
      ],
    );
    print('  Muxed streams: ${manifest.muxed.length}');
    print('  Audio streams: ${manifest.audioOnly.length}');
    print('  Video streams: ${manifest.videoOnly.length}');
    print('  SUCCESS!');
  } catch (e) {
    print('  ERROR: $e');
  } finally {
    yt.close();
  }
}
