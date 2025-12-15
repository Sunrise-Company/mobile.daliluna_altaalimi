import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:daliluna_altaalimi/core/constant/routes.dart';
import 'package:daliluna_altaalimi/core/services/apiservices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterController extends GetxController {
  late TextEditingController usernameAr;
  late TextEditingController usernameEn;
  late TextEditingController mothersName;
  late TextEditingController fathersName;
  late TextEditingController address;
  late TextEditingController password;
  late TextEditingController confirmPassword;
  late TextEditingController phone;
  late TextEditingController birthday;

  String? id;
  getDeviceDetails() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    id = androidInfo.id; // Corrected line

    update();
    // print('Device ID: ${id}');
  }

  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  bool isshowpassword = true;
  bool isshowconfirmPassword = true;
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  String? gender;
  void onClickRadioButton(value) {
    gender = value;
    update();
  }

  var countryselectedValue = ''.obs;
  updateSelectedValue(String value) {
    countryselectedValue.value = value;
  }

  bool isChecked = false;

  void toggleCheckbox(bool value) {
    isChecked = value;
    update();
  }

  showPassword() {
    isshowpassword = isshowpassword == true ? false : true;
    update();
  }

  showconfirmPassword() {
    isshowconfirmPassword = isshowconfirmPassword == true ? false : true;
    update();
  }

  goToPrivacyPolicy() {
    Get.toNamed(AppRoute.privacyPolicy);
  }

  Map<String, String> data = Map();
  getdata() {
    data = {
      "arabic_name": usernameAr.text,
      "english_name": usernameEn.text,
      "father_name": fathersName.text,
      "mother_name": mothersName.text,
      "gender": gender.toString(),
      "country": countryselectedValue.toString(),
      "birth_date": birthday.text,
      "address": address.text,
      "password": password.text,
      "confirm_password": confirmPassword.text,
      "phone": phone.text,
      "device_id": id.toString(),
    };
  }

  bool load = false;
  register() async {
    await getDeviceDetails();
    load = true;
    update();
    await getdata();
    await getdata();
    String responseData = await ApiService.registerStudent(data);
    load = false;
    Get.offAllNamed(AppRoute.homePage);
    update();
    if (responseData == true) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLogin', true);

      update();
    }
  }

  saveToken(String token) async {
    String responseData = await ApiService.saveToken(token);
    if (responseData == true) {
      update();
    }
  }

  Map<String, dynamic> appPolicy = {
    'app_policy': {'id': '', 'app_policy': ''},
  };
  void fetchAppPolicy() async {
    try {
      appPolicy = await ApiService.fetchAppPolicy();

      update();
    } catch (error) {}
  }

  @override
  void onInit() {
    fetchAppPolicy();
    usernameAr = TextEditingController();
    usernameEn = TextEditingController();
    mothersName = TextEditingController();
    fathersName = TextEditingController();
    address = TextEditingController();
    password = TextEditingController();
    confirmPassword = TextEditingController();
    phone = TextEditingController();
    birthday = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    usernameAr.dispose();
    usernameEn.dispose();
    mothersName.dispose();
    fathersName.dispose();
    address.dispose();
    password.dispose();
    confirmPassword.dispose();
    phone.dispose();
    birthday.dispose();
    super.dispose();
  }

  @override
  void onClose() {
    usernameAr.dispose();
    usernameEn.dispose();
    mothersName.dispose();
    fathersName.dispose();
    address.dispose();
    password.dispose();
    confirmPassword.dispose();
    phone.dispose();
    birthday.dispose();
    super.onClose();
  }
}
