import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as p;
import '../../linkapi.dart';

class MainExamControllerss extends GetxController {
  RxBool isloded = false.obs;
  Future<void> launchInBrowser(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  RxList<dynamic> dataListExam = <dynamic>[].obs;
  // RxListString file=[].obs;
  RxList<File> file = <File>[].obs;
  RxList<String> basefile = <String>[].obs;
  RxList<String> extensions = <String>[].obs;
  FilePickerResult? result;

  void openfile() async {
    try {
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'doc'],
        allowMultiple: true,
      );

      for (int i = 0; i < result!.files.length; i++) {
        file.add(File(result!.files[i].path.toString()));
        extensions.add(
          p.extension(File(result!.files[i].path.toString()).path),
        );
      }
    } catch (e) {}
  }

  @override
  Future<void> onInit() async {
    MainExam();
    // ignore: unused_local_variable
    var localStorage = await SharedPreferences.getInstance();

    super.onInit();
  }

  postaddjustification(String itemid) async {
    try {
      // fileloading(true);

      isloded.value = false;

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var studentid = localStorage.get("student_id");

      // ignore: unused_local_variable
      List<String> fileNames = [];
      // ignore: unused_local_variable
      List<http.MultipartFile> multipartFiles = [];

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          'https://aasvs.com/' + "dashboard/student/upload_exam_files2",
        ),
      );

      request.fields['student_id'] = studentid.toString();
      request.fields['item_id'] = itemid.toString();

      for (var i = 0; i < file.length; i++) {
        var multipartFile = await http.MultipartFile.fromPath(
          'file[$i]',
          file[i].path,
        );

        request.files.add(multipartFile);
      }

      request.fields['extension'] = jsonEncode(extensions);

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var body = jsonDecode(responseBody);

      if (body['success'] == true) {
        Get.snackbar("تم", "تم ارسال الامتحان");
        basefile.clear();

        file.clear();
        extensions.clear();
        isloded.value = false;
        onInit();

        // Get.offNamed(AppRoutes.finalexam);
      } else {
        // fileloading(false);
        basefile.clear();

        file.clear();
        extensions.clear();
        Get.snackbar("خطأ", "يتعذر رفع الامتحان");
        // Get.offNamed(AppRoutes.lesson);
      }
    } catch (e) {
      // isConnection(false);
      Get.snackbar(
        'تنبيه',
        "لا يوجد اتصال بالانترنت",
        dismissDirection: DismissDirection.startToEnd,
        duration: Duration(minutes: 10),
        mainButton: TextButton(
          onPressed: () {
            Get.closeCurrentSnackbar();
            postaddjustification(itemid);
          },
          child: Text('إعادة', style: TextStyle(color: Colors.red)),
        ),
      );
    }
  }

  Future<void> MainExam() async {
    print("cccccccccc");
    isloded.value = false;
    dataListExam.value = [];
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? student_id = prefs.getString('student_id');
      // SharedPreferences prefss = await SharedPreferences.getInstance();
      // var groupsid = prefss.get('group_id');

      final response = await http.get(
        Uri.parse(
          AppLink.server +
              '/dashboard/student/main_exam/' +
              student_id.toString(),
        ),
      );
      print(
        AppLink.server +
            '/dashboard/student/main_exam/' +
            student_id.toString(),
      );

      if (response.statusCode == 200) {
        isloded.value = true;
        final responseData = jsonDecode(response.body);

        dataListExam.value = responseData['exams'];
        print(
          "dataListExaacademyv3academyv3academyv3academyv3academyv3academyv3academyv3academyv3academyv3academyv3academyv3academyv3academyv3academyv3academyv3academyv3m",
        );

        print(
          "dataListExaacademyv3academyv3academyv3academyv3academyv3academyv3academyv3academyv3academyv3academyv3academyv3academyv3academyv3academyv3academyv3academyv3m",
        );
        update();
      } else {
        throw Exception('Failed to load exam/');
      }
    } catch (e) {}
  }

  goToItem(String examid) {
    Get.toNamed('/test', arguments: {"id": examid});

    // dataList.clear();
  }

  goToSoltions(int examid) {
    Get.toNamed('/examsoltuions', arguments: {"id": examid});

    // dataList.clear();
  }
}
