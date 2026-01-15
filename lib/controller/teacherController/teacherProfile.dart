import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherProfileController extends GetxController {
  var arabicName = ''.obs;
  var image = ''.obs;
  var education = ''.obs;
  var description = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadTeacherData();
  }

  Future<void> loadTeacherData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    arabicName.value = prefs.getString('arabic_name') ?? 'اسم غير متوفر';
    image.value =
        prefs.getString('image') ??
        'assets/images/default_teacher.jpg'; // Default image if not found
    education.value = prefs.getString('education') ?? 'تعليم غير متوفر';
    description.value = prefs.getString('description') ?? 'وصف غير متوفر';
  }
}
