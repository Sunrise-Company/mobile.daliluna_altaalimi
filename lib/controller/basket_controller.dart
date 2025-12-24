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
  //////////
  RxString instituteId = ''.obs;
  //  RxString InsName = ''.obs;

  RxList mycart = [].obs;
  getcount() {
    return mycart;
  }

  RxBool isload = false.obs;
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
    String instituteId,
  ) {
    // 1️⃣ هل العنصر نفسه موجود؟
    bool itemExists = mycart.any(
      (element) =>
          element['id'] == itemId &&
          element['teacherId'] == teacherId &&
          element['subjectId'] == subjectId &&
          element['classId'] == classId,
    );

    // 2️⃣ هل في عناصر من معهد مختلف؟
    bool existsDifferentInstitute =
        mycart.isNotEmpty &&
        mycart.any((element) => element['instituteId'] != instituteId);

    if (existsDifferentInstitute) {
      Get.snackbar(
        'تنبيه',
        ' لا يمكن الإضافة من أكثر من معهد اشتري من كل معهد على حدى',
        backgroundColor: AppColor.BackGround3,
      );
      return;
    }

    // 3️⃣ التحقق من تعارض الوحدات والأقسام (Units vs Sections)
    // إذا كان العنصر المضاف هو 'unit' أو 'section' (يعتبران أجزاء فرعية/Children)
    if (itemType == 'unit' || itemType == 'section') {
      // نتحقق مما إذا كان القسم الرئيسي (Parent) موجوداً في السلة
      bool mainSectionExists = mycart.any(
        (element) =>
            (element['itemType'] == 'section' ||
                element['itemType'] == 'main_dep') &&
            element['id'] == maindepId,
      );

      if (mainSectionExists) {
        Get.snackbar(
          'تنبيه',
          'لا يمكن إضافة هذا العنصر لأن القسم الرئيسي موجود بالسلة',
          backgroundColor: AppColor.BackGround3,
        );
        return;
      }
    }

    // إذا كان العنصر المضاف هو 'main_dep' أو 'section' (يعتبران أقسام رئيسية/Parents)
    if (itemType == 'section' || itemType == 'main_dep') {
      // نتحقق مما إذا كانت هناك وحدات تابعة له في السلة (Children)
      bool childExists = mycart.any(
        (element) =>
            (element['itemType'] == 'unit' ||
                element['itemType'] == 'section') &&
            element['maindepId'] == itemId,
      );

      if (childExists) {
        Get.snackbar(
          'تنبيه',
          'لا يمكن إضافة القسم لأن هناك أجزاء تابعة له في السلة',
          backgroundColor: AppColor.BackGround3,
        );
        return;
      }
    }

    if (itemExists) {
      Get.snackbar(
        'تنبيه',
        'تم إضافة هذا العنصر بالفعل',
        backgroundColor: AppColor.BackGround3,
      );
      return;
    }

    // ✅ الإضافة
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
      'instituteId': instituteId,
    });

    count = count + itemPrice;
    update();
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

  updateInstituteId(newInstituteId) {
    instituteId(newInstituteId.toString());
    getAppinfo();
    update();
  }

  removeItem(int index) {
    count = count - (mycart[index]['itemPrice']);
    mycart.removeAt(index);

    update();
  }

  app_basket_student_store() async {
    String responseData = await ApiService.app_basket_student_store(mycart);
    print('ccccccccccccccccccccccc$responseData');
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
        Uri.parse(
          AppLink.server + '/app_transfer_information/${instituteId.value}',
        ),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        dataList.value = {'message': responseData['message']};
      } else {
        throw Exception('Failed to load studentLesson: ${response.statusCode}');
      }
    } catch (error) {
      isloded.value = true;
      update();
    }
  }

  void fetchcompanyInformations() async {
    try {
      companyInformations = await ApiService.fetchCompanyInformations();

      update();
    } catch (error) {}
  }

  @override
  void onInit() {
    // getAppinfo();
    fetchcompanyInformations();
    super.onInit();
  }
}
