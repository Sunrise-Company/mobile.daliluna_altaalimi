import 'dart:convert';
import 'package:daliluna_altaalimi/data/model/version_model.dart';
import 'package:daliluna_altaalimi/linkapi.dart';
import 'package:http/http.dart' as http;

class VersionService {
  static const String url = '${AppLink.server}/app_version_num';

  Future<VersionModel?> fetchVersion() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return VersionModel.fromJson(data);
    }
    return null;
  }
}
