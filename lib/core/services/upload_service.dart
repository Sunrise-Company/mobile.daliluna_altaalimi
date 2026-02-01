import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

class UploadService extends GetxService {
  final _dio = dio.Dio();

  Future<dynamic> uploadFile({
    required String url,
    required Map<String, String> fields,
    File? file,
    required Map<String, String> headers,
    Function(double)? onProgress,
  }) async {
    try {
      final formData = dio.FormData();

      // Add fields
      fields.forEach((key, value) {
        formData.fields.add(MapEntry(key, value));
      });

      if (file != null) {
        String fileName = file.path.split('/').last;
        String fileType = fileName.split('.').last.toLowerCase();

        // Add file
        formData.files.add(MapEntry(
          'file',
          await dio.MultipartFile.fromFile(
            file.path,
            filename: fileName,
          ),
        ));

        // Add type field logic as before
        if (!fields.containsKey('type')) {
          formData.fields.add(MapEntry('type', fileType));
        }
      }

      final response = await _dio.post(
        url,
        data: formData,
        options: dio.Options(
          headers: headers,
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
        onSendProgress: (int sent, int total) {
          if (onProgress != null && total > 0) {
            double progress = sent / total;
            // print('Upload Progress: ${(progress * 100).toInt()}%'); // Debug log
            onProgress(progress);
          }
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(
            'Failed to upload file: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
