import 'dart:convert';

import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/linkapi.dart';
import 'package:get/get.dart';
import 'package:daliluna_altaalimi/core/services/apiservices.dart';
import 'package:http/http.dart' as http;

class BasketController extends GetxController {
  RxInt count = 0.obs;

  RxString teacherName = ''.obs;
  RxString className = ''.obs;
  RxString subjectName = ''.obs;
  RxString teacherId = ''.obs;
  RxString classId = ''.obs;
  RxString subjectId = ''.obs;
  RxString maindepId = ''.obs;

  RxList mycart = [].obs;
  getcount() {
    return mycart;
  }

  RxBool isload = false.obs;

  //   updateBasket(
  //       String itemId,
  //       String itemType,
  //       String itemName,
  //       int itemPrice,
  //       String teacherName,
  //       String className,
  //       String subjectName,
  //       String teacherId,
  //       String classId,
  //       String subjectId,
  //       String maindepId) {
  //     print(count);
  // // print()
  //     mycart.add({
  //       'id': itemId,
  //       'itemType': itemType,
  //       'itemName': itemName,
  //       'itemPrice': itemPrice,
  //       'teacherName': teacherName,
  //       'className': className,
  //       'subjectName': subjectName,
  //       'teacherId': teacherId,
  //       'classId': classId,
  //       'subjectId': subjectId,
  //       'maindepId': maindepId
  //     });
  //     print(mycart);
  //     count = count + itemPrice;
  //     update();
  //   }
  updateBasket(
    String itemId,
    String itemType,
    String itemName,
    int itemPrice,
    String teacherName,
    String className,
    String subjectName,
    String teacherId,
    String classId,
    String subjectId,
    String maindepId,
  ) {
    print(count);

    bool itemExists = mycart.any(
      (element) =>
          element['id'] == itemId &&
          element['teacherId'] == teacherId &&
          element['subjectId'] == subjectId &&
          element['classId'] == classId,
    );

    if (!itemExists) {
      mycart.add({
        'id': itemId,
        'itemType': itemType,
        'itemName': itemName,
        'itemPrice': itemPrice,
        'teacherName': teacherName,
        'className': className,
        'subjectName': subjectName,
        'teacherId': teacherId,
        'classId': classId,
        'subjectId': subjectId,
        'maindepId': maindepId,
      });
      print(mycart);
      count = count + itemPrice;
      update();
    } else {
      print("العنصر موجود بالفعل لنفس الأستاذ والمادة");

      Get.snackbar(
        'تنبيه',
        '!تم إضافة هذا العنصر بالفعل   ',
        backgroundColor: AppColor.BackGround3,
      );
    }
  }

  updateteacherName(newteacherName) {
    teacherName(newteacherName);
    update();
  }

  updateclassName(newclassName) {
    className(newclassName);
    update();
  }

  updatelessonName(newsubjectName) {
    subjectName(newsubjectName);
    update();
  }

  updateteacherId(newteacherId) {
    teacherId(newteacherId.toString());
    update();
  }

  updateclassId(newclassId) {
    classId(newclassId.toString());
    update();
  }

  updatelessonId(newsubjectId) {
    subjectId(newsubjectId.toString());
    update();
  }

  updatemaindepId(newmaindepId) {
    maindepId(newmaindepId.toString());
    update();
  }

  removeItem(int index) {
    count = count - (mycart[index]['itemPrice']);
    mycart.removeAt(index);

    update();
  }

  app_basket_student_store() async {
    print('rrrrrrrrrrrrrrr');
    String responseData = await ApiService.app_basket_student_store(mycart);
    print(responseData);
    return responseData;
    // if (true) {
    //   print('8888888888888');
    //   Get.back();
    //   update();
    // }
  }

  Map<String, dynamic> companyInformations = {
    'app_company_informations': {
      'id': '',
      'description': '',
      'website': '',
      'facebook': '',
      'title': '',
    },
  };

  var isloded = false.obs;
  RxMap<String, dynamic> dataList = <String, dynamic>{}.obs;

  Future<void> getAppinfo() async {
    isloded.value = false;
    try {
      final response = await http.get(
        Uri.parse(AppLink.server + '/app_transfer_information'),
      );

      print("Baskeeeeeeeeeeeeeeeeeeeeeet");
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Response Data: $responseData');
        dataList.value = responseData['app_transfer_information'];
        print('Data List: $dataList');
        isloded.value = true;
        update();
      } else {
        throw Exception('Failed to load studentLesson: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching studentLesson: $error');
      isloded.value = true;
      update();
      // Handle errors appropriately, e.g., show a message to the user
    }
  }

  void fetchcompanyInformations() async {
    try {
      companyInformations = await ApiService.fetchCompanyInformations();
      print(companyInformations);
      update();
    } catch (error) {
      print('Error fetching classes: $error');
    }
  }

  @override
  void onInit() {
    getAppinfo();
    fetchcompanyInformations();
    super.onInit();
  }
}
