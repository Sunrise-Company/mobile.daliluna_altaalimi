import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() async {
  final yt = YoutubeExplode();
  final videoId = 'zp8ji_vMaKY';
  try {
    print('Fetching video details...');
    final video = await yt.videos.get(videoId);
    print('Title: \${video.title}');
    
    print('Fetching stream manifest...');
    final manifest = await yt.videos.streamsClient.getManifest(
      videoId,
      ytClients: [
        YoutubeApiClient.safari,
        YoutubeApiClient.androidVr,
      ],
    );
    
    print('Success! Manifest has \${manifest.muxed.length} muxed streams.');
    print('Muxed: \${manifest.muxed.map((e) => e.videoResolution.height).toList()}');
    print('AudioOnly: \${manifest.audioOnly.length}');
    print('VideoOnly: \${manifest.videoOnly.length}');
  } catch (e) {
    print('Error: \$e');
  } finally {
    yt.close();
  }
}
