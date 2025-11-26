import 'dart:developer';

import 'package:daliluna_altaalimi/controller/socketController/sockectController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:daliluna_altaalimi/core/constant/routes.dart';
import 'package:daliluna_altaalimi/linkapi.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class ApiService {
  static Future<List<dynamic>> fetchMainslider() async {
    final response = await http.get(Uri.parse(AppLink.app_main_slider));
    if (response.statusCode == 200) {
      print(response.body);
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> classData = data['app_sliders'];

      if (classData != null) {
        print("sssssssssssssssssssssssssssssssssssssssssssss$classData");

        return classData;
      } else {
        throw Exception('Classes data is null');
      }
    } else {
      throw Exception('Failed to fetch classes');
    }
  }

  static Future<List<dynamic>> fetchCities() async {
    final response = await http.get(Uri.parse(AppLink.cities));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> cities = data['cities'] ?? [];
      return cities;
    } else {
      throw Exception('Failed to fetch cities');
    }
  }

  static Future<Map<String, dynamic>> search(String query) async {
    try {
      final response = await http.post(
        Uri.parse('${AppLink.appMainSearch}?q=$query'),
      );
      log(response.body.toString());
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to search: ${response.statusCode}');
      }
    } catch (e) {
      log('Search error: $e');
      rethrow;
    }
  }

  static Future<List<dynamic>> fetchInstitutes(int cityId) async {
    final response = await http.get(Uri.parse('${AppLink.institutes}/$cityId'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> institutes = data['institutes'] ?? [];
      return institutes;
    } else {
      throw Exception('Failed to fetch institutes');
    }
  }

  static Future<List<dynamic>> fetchClasses(int instituteId) async {
    final response = await http.get(
      Uri.parse('${AppLink.classes}/$instituteId'),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> classData = data['classes'];

      if (classData != null) {
        print(classData);

        return classData;
      }
    } else {
      throw Exception('Failed to fetch classes');
    }
  }

  static Future<List<dynamic>> fetchmyClassess(student_id) async {
    final response = await http.get(
      Uri.parse(AppLink.myclasses + '/' + student_id.toString()),
    );
    if (response.statusCode == 200) {
      print('20000000');
      print(response.body);
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> classData = data['classes'];

      if (classData != null) {
        print(classData);

        return classData;
      } else {
        throw Exception('Classes data is null');
      }
    } else {
      throw Exception('Failed to fetch classes');
    }
  }

  static Future<List<dynamic>> fetchNotifications() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print('--------------------88');
    print(prefs.getString('student_id').toString());

    final response = await http.get(
      Uri.parse(
        AppLink.notifications + '/' + prefs.getString('student_id').toString(),
      ),
    );
    print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> classData = data['app_notifications'];

      if (classData != null) {
        print(classData);

        return classData;
      } else {
        throw Exception('Classes data is null');
      }
    } else {
      throw Exception('Failed to fetch classes');
    }
  }

  int id = Get.arguments['lessonid'];
  static Future<List<dynamic>> fetchSubjects() async {
    log('qqqqqqqqqqqqqqqqqq');
    print(Get.arguments['lessonid']);
    final response = await http.get(
      Uri.parse(AppLink.subjetcs + '/' + Get.arguments['lessonid'].toString()),
    );
    print(AppLink.subjetcs + '/' + Get.arguments['lessonid'].toString());
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> subjectData = data['lessons'];

      if (subjectData != null) {
        return subjectData;
      } else {
        throw Exception('Lessons data is null');
      }
    } else {
      throw Exception('Failed to fetch Lessons');
    }
  }

  static Future<List<dynamic>> fetchMySubjects(student_id) async {
    final response = await http.get(
      Uri.parse(
        AppLink.mysubjetcs +
            '/' +
            Get.arguments['lessonid'].toString() +
            '/' +
            student_id.toString(),
      ),
    );

    print(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> subjectData = data['lessons'];
      log("ssssssss" + subjectData.toString());
      print(subjectData);

      if (subjectData != null) {
        return subjectData;
      } else {
        throw Exception('Lessons data is null');
      }
    } else {
      throw Exception('Failed to fetch Lessons');
    }
  }

  static Future<List<dynamic>> fetchTachers() async {
    final response = await http.get(
      Uri.parse(
        AppLink.teachers + '/' + Get.arguments['subjetcsid'].toString(),
      ),
    );
    if (response.statusCode == 200) {
      print(AppLink.teachers + '/' + Get.arguments['subjetcsid'].toString());
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> teacherData = data['teachers'];

      if (teacherData != null) {
        return teacherData;
      } else {
        throw Exception('Teachers data is null');
      }
    } else {
      throw Exception('Failed to fetch Teachers');
    }
  }

  static Future<List<dynamic>> fetchMyTachers(student_id) async {
    final response = await http.get(
      Uri.parse(
        AppLink.myteachers +
            '/' +
            Get.arguments['subjetcsid'].toString() +
            '/' +
            student_id.toString(),
      ),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> teacherData = data['teachers'];

      if (teacherData != null) {
        return teacherData;
      } else {
        throw Exception('Teachers data is null');
      }
    } else {
      throw Exception('Failed to fetch Teachers');
    }
  }

  static Future<List<dynamic>> fetchSections(
    String classid,
    String subjectid,
    String teacherid,
  ) async {
    log(
      AppLink.sections +
          '/${classid.toString()}/${subjectid.toString()}/${teacherid.toString()}',
    );
    final response = await http.get(
      Uri.parse(
        AppLink.sections +
            '/${classid.toString()}/${subjectid.toString()}/${teacherid.toString()}',
      ),
    );
    print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> sectionData = data['data'];

      if (sectionData != null) {
        return sectionData;
      } else {
        throw Exception('Sections data is null');
      }
    } else {
      throw Exception('Failed to fetch Sections');
    }
  }

  static Future<List<dynamic>> fetchMySections(
    student_id,
    class_id,
    teacher_id,
  ) async {
    print(AppLink.mysections);
    final response = await http.get(
      Uri.parse(
        AppLink.mysections +
            '/' +
            Get.arguments['subjetcsid'] +
            '/' +
            student_id.toString() +
            '/' +
            Get.arguments['classid'].toString() +
            '/' +
            teacher_id,
      ),
    );
    log(
      AppLink.mysections +
          '/' +
          Get.arguments['subjetcsid'] +
          '/' +
          student_id.toString() +
          '/' +
          Get.arguments['classid'].toString() +
          '/' +
          teacher_id,
    );
    print(response.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);

      List<dynamic> sectionData = data['main_deps'];

      if (sectionData != null) {
        return sectionData;
      } else {
        throw Exception('Sections data is null');
      }
    } else {
      throw Exception('Failed to fetch Sections');
    }
  }

  static Future<List<dynamic>> fetchLessonSections() async {
    final response = await http.get(
      Uri.parse(
        AppLink.lessons +
            '/' +
            Get.arguments['sectionid'].toString() +
            '/' +
            Get.arguments['subjetcsid'].toString() +
            '/' +
            Get.arguments['teacher_id'].toString(),
      ),
    );
    log("lessssssssssssoons");
    log(
      AppLink.lessons +
          '/' +
          Get.arguments['sectionid'].toString() +
          '/' +
          Get.arguments['subjetcsid'].toString() +
          '/' +
          Get.arguments['teacher_id'].toString(),
    );
    print("Subjjjjjjjjjjjjjjjjjjjjjjjjjjjjjest");
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("sucessssssss");
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> lessonData = data['lesson_deps'];

      if (lessonData != null) {
        return lessonData;
      } else {
        throw Exception('Lessons data is null');
      }
    } else {
      throw Exception('Failed to fetch Lessons');
    }
  }

  static Future<List<dynamic>> fetchMyLessonSections(student_id) async {
    final response = await http.get(
      Uri.parse(
        AppLink.mylessons +
            '/' +
            Get.arguments['sectionid'].toString() +
            '/' +
            Get.arguments['subjetcsid'].toString() +
            '/' +
            Get.arguments['teacher_id'].toString() +
            '/' +
            student_id.toString(),
      ),
    );
    log(
      AppLink.mylessons +
          '/' +
          Get.arguments['sectionid'].toString() +
          '/' +
          Get.arguments['subjetcsid'].toString() +
          '/' +
          Get.arguments['teacher_id'].toString() +
          '/' +
          student_id.toString(),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> lessonData = data['lesson_deps'];

      if (lessonData != null) {
        return lessonData;
      } else {
        throw Exception('Lessons data is null');
      }
    } else {
      throw Exception('Failed to fetch Lessons');
    }
  }

  static Future<List<dynamic>> fetchUnits() async {
    final response = await http.get(
      Uri.parse(
        AppLink.units +
            '/' +
            Get.arguments['subjetcsid'].toString() +
            '/' +
            Get.arguments['teacher_id'].toString(),
      ),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> unitData = data['units'];

      if (unitData != null) {
        return unitData;
      } else {
        throw Exception('Units data is null');
      }
    } else {
      throw Exception('Failed to fetch Units');
    }
  }

  static Future<List<dynamic>> fetchMyUnits(String student_id) async {
    log('ssssssssssssssssssssssssssssss');
    final response = await http.get(
      Uri.parse(
        AppLink.myunits +
            '/' +
            Get.arguments['subjetcsid'].toString() +
            '/' +
            Get.arguments['teacher_id'].toString() +
            '/' +
            student_id.toString(),
      ),
    );
    log("saaaaaaas" + response.body.toString());

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> unitData = data['units'];

      if (unitData != null) {
        return unitData;
      } else {
        throw Exception('Units data is null');
      }
    } else {
      throw Exception('Failed to fetch Units');
    }
  }

  static Future<List<dynamic>> fetchLectures() async {
    final response = await http.get(
      Uri.parse(AppLink.lectures + "/" + Get.arguments['unitsid'].toString()),
    );
    print(AppLink.lectures + '/' + Get.arguments['unitsid'].toString());
    print(response.body);
    if (response.statusCode == 200) {
      print("7777777777777777777777777777");
      List<dynamic> lectureData = json.decode(response.body);

      if (lectureData != null) {
        return lectureData;
      } else {
        throw Exception('Lectures data is null');
      }
    } else {
      throw Exception('Failed to fetch Lectures');
    }
  }

  static Future<List<dynamic>> fetchMyLectures(student_id) async {
    print('0000000000hhhhhhhhhhhhhhhhhhhh00');
    print(Get.arguments['subject_id'].toString());
    log(Get.arguments['unitsid'].toString());
    print(
      AppLink.mylectures +
          "/" +
          Get.arguments['unitsid'].toString() +
          '/' +
          Get.arguments['subject_id'].toString() +
          '/' +
          student_id.toString(),
    );

    final response = await http.get(
      Uri.parse(
        AppLink.mylectures +
            "/" +
            Get.arguments['unitsid'].toString() +
            '/' +
            Get.arguments['subject_id'].toString() +
            '/' +
            student_id.toString(),
      ),
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      List<dynamic> lectureData = json.decode(response.body);

      if (lectureData != null) {
        return lectureData;
      } else {
        throw Exception('Lectures data is null');
      }
    } else {
      throw Exception('Failed to fetch Lectures');
    }
  }

  static Future fetchVideos(lectureID) async {
    final response = await http.get(
      Uri.parse(AppLink.app_lectures_files + "/" + lectureID.toString()),
    );

    log(AppLink.app_lectures_files + "/" + lectureID.toString());

    if (response.statusCode == 200) {
      List<dynamic> lectureData = json.decode(response.body)['videos'];
      log(json.decode(response.body).toString());
      if (lectureData != null) {
        return lectureData;
      } else {
        throw Exception('Lectures data is null');
      }
    } else {
      throw Exception('Failed to fetch Lectures');
    }
  }

  static Future<Map<String, dynamic>> fetchTeacherInfo() async {
    final response = await http.get(
      Uri.parse(
        AppLink.teacherInfo + "/" + Get.arguments['teacher_id'].toString(),
      ),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);

      if (data != null) {
        print('99999999999999999999999999999999999999999');
        return data;
      } else {
        throw Exception('teacherInfo data is null');
      }
    } else {
      throw Exception('Failed to fetch teacherInfo');
    }
  }

  static Future<String> registerStudent(Map body) async {
    print(body);
    try {
      final response = await http.post(
        Uri.parse(AppLink.registerStudent),
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Some token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        if (data['status'] == true) {
          prefs.setBool('isLogin', true);
          prefs.setString('student_id', data['student_id']?.toString() ?? '');
          prefs.setString('token', data['token']?.toString() ?? '');

          Sockectcontroller socket = Get.find();
          socket.connectToWebSocket();

          Get.offAndToNamed(AppRoute.homePage);
          return "تم التسجيل بنجاح";
        } else {
          Get.snackbar(
            "خطأ في التسجيل",
            data['message'] ?? "تحقق من بيانات التسجيل.",
            dismissDirection: DismissDirection.startToEnd,
          );
          return data['message']?.toString() ?? "فشل التسجيل";
        }
      } else {
        Get.snackbar(
          "خطأ في الاتصال",
          "حدث خطأ أثناء محاولة التسجيل. الرجاء المحاولة لاحقًا.",
          dismissDirection: DismissDirection.startToEnd,
        );
        throw Exception('فشل في التسجيل');
      }
    } catch (e) {
      print("خطأ أثناء التسجيل: $e");
      Get.snackbar(
        "خطأ غير متوقع",
        "حدث خطأ غير متوقع، الرجاء المحاولة لاحقًا.",
      );
      return "حدث خطأ غير متوقع";
    }
  }

  static Future<String> loginStudent(Map body) async {
    print(body);
    try {
      final response = await http.post(
        Uri.parse(AppLink.loginStudent),
        body: json.encode(body),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Some token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        if (data['status'] == true) {
          Get.snackbar(
            "تم تسجيل الدخول بنجاح",
            "أهلاً بك ",

            dismissDirection: DismissDirection.startToEnd,
          );
          prefs.setBool('isLogin', true);
          prefs.setString('student_id', data['student_id'].toString());
          prefs.setString('token', data['token']);

          Sockectcontroller socket = Get.find();
          socket.connectToWebSocket();

          Get.offAndToNamed(AppRoute.homePage);
          return "تم تسجيل الدخول بنجاح";
        } else {
          Get.snackbar(
            "خطأ في تسجيل الدخول",
            data['message'] ?? "تحقق من اسم المستخدم وكلمة المرور.",
            dismissDirection: DismissDirection.startToEnd,
          );
          return data['message'].toString();
        }
      } else {
        Get.snackbar(
          "خطأ في الاتصال",
          "حدث خطأ أثناء محاولة تسجيل الدخول. الرجاء المحاولة لاحقًا.",
          dismissDirection: DismissDirection.startToEnd,
        );
        throw Exception('فشل في تسجيل الدخول');
      }
    } catch (e) {
      print("خطأ أثناء تسجيل الدخول: $e");
      Get.snackbar(
        "خطأ غير متوقع",
        "حدث خطأ غير متوقع، الرجاء المحاولة لاحقًا.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return "حدث خطأ غير متوقع";
    }
  }

  static Future<String> saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await http.post(
      Uri.parse(AppLink.saveToken),
      body: json.encode({
        'token': token,
        'app_student_id': prefs.getString('student_id'),
      }),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Some token",
      },
    );
    print('000050705470407047064064=08=7-96=9');
    if (response.statusCode == 200) {
      print('save Token successssssssss');
      return '';
    } else {
      throw Exception('Failed to fetch teacherInfo');
    }
  }

  static Future fetchSectionVideos(int selectedItem) async {
    final response = await http.get(
      Uri.parse(AppLink.app_lesson_deps_files + "/" + selectedItem.toString()),
    );
    print(response.body);
    log(AppLink.app_lesson_deps_files + "/" + selectedItem.toString());
    print('111111111111111111111');
    if (response.statusCode == 200) {
      List<dynamic> lectureData = json.decode(response.body)['videos'];
      print('iiiiiiiiiiiiiii0');
      print(lectureData);

      if (lectureData != null) {
        return lectureData;
      } else {
        throw Exception('Lectures data is null');
      }
    } else {
      throw Exception('Failed to fetch Lectures');
    }
  }

  static Future fetchSectionFiles(int selectedItem) async {
    print('9999999999999');
    final response = await http.get(
      Uri.parse(AppLink.app_lesson_deps_files + "/" + selectedItem.toString()),
    );
    print(response.body);
    print('111111111111111111111');
    if (response.statusCode == 200) {
      print('2222222222222222');
      List<dynamic> lectureData = json.decode(response.body)['files'];
      print('iiiiiiiiiiiiiii0');
      print(lectureData);

      if (lectureData != null) {
        return lectureData;
      } else {
        throw Exception('Lectures data is null');
      }
    } else {
      throw Exception('Failed to fetch Lectures');
    }
  }

  static Future fetchCompanyInformations() async {
    final response = await http.get(
      Uri.parse(AppLink.app_company_informations),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      print(data);

      if (data != null) {
        print('99999999999999999999999999999999999999999');
        return data;
      } else {
        throw Exception('teacherInfo data is null');
      }
    } else {
      throw Exception('Failed to fetch teacherInfo');
    }
  }

  static Future fetchAppPolicy() async {
    final response = await http.get(Uri.parse(AppLink.app_policy));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);

      if (data != null) {
        print('99999999999999999999999999999999999999999');
        return data;
      } else {
        throw Exception('teacherInfo data is null');
      }
    } else {
      throw Exception('Failed to fetch teacherInfo');
    }
  }

  static Future fetchdeviceinfo() async {
    final response = await http.get(Uri.parse(AppLink.deviceinfo));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);

      if (data != null) {
        print('batoul================');
        return data;
      } else {
        throw Exception('device info data is null');
      }
    } else {
      throw Exception('Failed to fetch device info');
    }
  }

  static Future<String> app_basket_student_store(List body) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? student_id = prefs.getString('student_id');
    print(student_id);
    Map<String, dynamic> data = {};

    for (int i = 0; i < body.length; i++) {
      data['data[$i][id]'] = body[i]['id'].toString();
      data['data[$i][itemName]'] = body[i]['itemName'];
      data['data[$i][itemType]'] = body[i]['itemType'];
      data['data[$i][classId]'] = body[i]['classId'].toString();
      data['data[$i][subjectId]'] = body[i]['subjectId'].toString();
      data['data[$i][teacherId]'] = body[i]['teacherId'].toString();
      data['data[$i][maindepId]'] = body[i]['maindepId'].toString();
      data['data[$i][itemPrice]'] = body[i]['itemPrice'].toString();
    }
    print(data);
    final response = await http.post(
      Uri.parse(AppLink.app_basket_student_store + '/' + student_id.toString()),
      body: data,
    );
    print(json.encode(body));
    print(jsonDecode(response.body));
    print('baskettttttttttttttttttttttttt=08=7-96=9');
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      return jsonDecode(response.body)['status'];
    } else {
      throw Exception('Failed to fetch teacherInfo');
    }
  }
}
