import 'dart:convert';
import 'dart:developer';

import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/linkapi.dart';
import 'package:get/get.dart';
import 'package:daliluna_altaalimi/core/services/apiservices.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

  RxList mycart = [].obs;
  getcount() {
    return mycart;
  }

  RxBool isload = false.obs;
  Future<void> updateBasket(
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
    String instituteId, [
    String? unitId,
  ]) async {
    // 1️⃣ Check for duplicates
    if (_isItemDuplicate(itemId, teacherId, subjectId, classId)) {
      _showSnackbar('تنبيه', 'تم إضافة هذا العنصر بالفعل');
      return;
    }

    // 2️⃣ Check for different institute
    if (_hasInstituteConflict(instituteId)) {
      _showSnackbar(
        'تنبيه',
        ' لا يمكن الإضافة من أكثر من معهد اشتري من كل معهد على حدى',
      );
      return;
    }

    // 3️⃣ Check for Main Section vs Children conflict
    if (_hasMainSectionConflict(itemType, maindepId)) {
      _showSnackbar(
        'تنبيه',
        'لا يمكن إضافة هذا العنصر لأن القسم الرئيسي موجود بالسلة',
      );
      return;
    }

    if (_hasChildConflict(itemType, itemId)) {
      _showSnackbar(
        'تنبيه',
        'لا يمكن إضافة القسم لأن هناك أجزاء تابعة له في السلة',
      );
      return;
    }

    // 4️⃣ Check for Unit vs Lesson conflict
    if (_hasUnitLessonConflict(itemType, unitId, itemId)) {
      return; // Snackbar handled inside helper for specific messages
    }

    // ✅ Add to cart
    await _addItemToCart(
      itemId,
      itemType,
      itemName,
      itemPrice,
      teacherName,
      className,
      subjectName,
      teacherId,
      classId,
      subjectId,
      maindepId,
      instituteId,
      unitId,
    );
  }

  // --- Helper Methods ---

  bool _isItemDuplicate(
    String itemId,
    String teacherId,
    String subjectId,
    String classId,
  ) {
    return mycart.any(
      (element) =>
          element['id'] == itemId &&
          element['teacherId'] == teacherId &&
          element['subjectId'] == subjectId &&
          element['classId'] == classId,
    );
  }

  bool _hasInstituteConflict(String instituteId) {
    return mycart.isNotEmpty &&
        mycart.any((element) => element['instituteId'] != instituteId);
  }

  bool _hasMainSectionConflict(String itemType, String maindepId) {
    if (itemType == 'unit' || itemType == 'section' || itemType == 'lesson') {
      return mycart.any(
        (element) =>
            (element['itemType'] == 'section' ||
                element['itemType'] == 'main_dep') &&
            element['id'] == maindepId,
      );
    }
    return false;
  }

  bool _hasChildConflict(String itemType, String itemId) {
    if (itemType == 'section' || itemType == 'main_dep') {
      return mycart.any(
        (element) =>
            (element['itemType'] == 'unit' ||
                element['itemType'] == 'section' ||
                element['itemType'] == 'lesson') &&
            element['maindepId'] == itemId,
      );
    }
    return false;
  }

  bool _hasUnitLessonConflict(String itemType, String? unitId, String itemId) {
    if (itemType == 'lesson' && unitId != null) {
      bool parentUnitExists = mycart.any(
        (element) => element['itemType'] == 'unit' && element['id'] == unitId,
      );
      if (parentUnitExists) {
        _showSnackbar('تنبيه', 'لا يمكن إضافة الدرس لأن الوحدة موجودة بالسلة');
        return true;
      }
    } else if (itemType == 'unit') {
      bool childLessonExists = mycart.any(
        (element) =>
            element['itemType'] == 'lesson' && element['unitId'] == itemId,
      );
      if (childLessonExists) {
        _showSnackbar(
          'تنبيه',
          'لا يمكن إضافة الوحدة لأن هناك دروس تابعة لها في السلة',
        );
        return true;
      }
    }
    return false;
  }

  Future<void> _addItemToCart(
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
    String? unitId,
  ) async {
    // If instituteId is empty, try to get it from SharedPreferences
    String effectiveInstituteId = instituteId;
    if (effectiveInstituteId.isEmpty && this.instituteId.value.isEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final savedId = prefs.getInt('selected_institute_id');
      if (savedId != null) {
        effectiveInstituteId = savedId.toString();
      }
    }

    if (this.instituteId.value.isEmpty && effectiveInstituteId.isNotEmpty) {
      updateInstituteId(effectiveInstituteId);
    }
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
      'instituteId': effectiveInstituteId,
      'unitId': unitId,
    });
    count = count + itemPrice;
    update();
  }

  void _showSnackbar(String title, String message) {
    Get.snackbar(title, message, backgroundColor: AppColor.BackGround3);
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

  Future<void> updateInstituteId(newInstituteId) async {
    instituteId(newInstituteId.toString());
    await getAppinfo(); // انتظار حتى يتم جلب الرسالة
    update();
  }

  removeItem(int index) {
    count = count - (mycart[index]['itemPrice']);
    mycart.removeAt(index);

    update();
  }

  app_basket_student_store() async {
    String responseData = await ApiService.app_basket_student_store(mycart);
    return responseData;
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
      print('mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm${instituteId.value}');
      final response = await http.get(
        Uri.parse(
          AppLink.server + '/app_transfer_information/${instituteId.value}',
        ),
      );
      log(
        AppLink.server +
            '/app_transfer_information/${instituteId.value}  ' +
            "${response.body}",
      );
      log("${response.body}");
      if (response.statusCode == 200) {
        print('📥 Raw response body: "${response.body}"');

        // Check if response body is empty
        if (response.body.isEmpty) {
          throw Exception('Empty response body from server');
        }

        final responseData = jsonDecode(response.body);
        dataList.value = {'message': responseData['message'] ?? ''};
        isloded.value = true; // تم التحميل بنجاح
        update(); // إخبار GetX بالتحديث
        print('✅ Payment message loaded: ${responseData['message']}');
      } else {
        print(
          '⚠️ HTTP Error: ${response.statusCode}, Body: "${response.body}"',
        );
        throw Exception('Failed to load studentLesson: ${response.statusCode}');
      }
    } catch (error) {
      print(
        '❌ Error fetching payment info for institute ${instituteId.value}: $error',
      );
      dataList.value = {'message': ''}; // قيمة افتراضية فارغة
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
    fetchcompanyInformations();
    super.onInit();
  }
}
