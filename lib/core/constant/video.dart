import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class VideoService {
  final Dio _dio = Dio();


  Future<bool> downloadVideo(String videoUrl) async {
    try {
      final response = await _dio.get(
        videoUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      // Replace 'video.mp4' with your desired file name
      final file =
          await DefaultCacheManager().putFile('video.mp4', response.data);

      // ignore: unnecessary_null_comparison
      return file != null;
    } catch (e) {
      print('Error downloading video: $e');
      return false;
    }
  }
}
