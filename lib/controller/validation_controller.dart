import 'package:get/get.dart';

class ValidationController extends GetxController {
  void validateTextEn(String value, RxBool isValid) {
    final RegExp regExp = RegExp(r'^[a-zA-Z]+$');
    isValid.value = regExp.hasMatch(value);
  }

  void validateTextAr(String value, RxBool isValid) {
    final RegExp regExp = RegExp(
      r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]+',
    );
    isValid.value = regExp.hasMatch(value);
  }

  void validatePhoneNumber(String value, RxBool isValid) {
    final RegExp regExp = RegExp(r'^\+?[1-9]\d{1,14}$');
    isValid.value = regExp.hasMatch(value);
  }

  void validateEmail(String value, RxBool isValid) {
    final RegExp regExp = RegExp(
      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
    );
    isValid.value = regExp.hasMatch(value);
  }

  void validateNumber(String value, RxBool isValid) {
    final RegExp regExp = RegExp(r'^[0-9]+$');
    isValid.value = regExp.hasMatch(value);
  }

  void validateDate(String value, RxBool isValid) {
    final RegExp regExp = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    isValid.value = regExp.hasMatch(value);
  }
}
