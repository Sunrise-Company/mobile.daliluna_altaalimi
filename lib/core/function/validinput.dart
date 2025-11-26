import 'package:get/get.dart';

validInput(String val, int min, int max, String type) {
  if (type == "username") {
    if (!GetUtils.isUsername(val)) {
      return "الاسم غير صالح";
    }
  }
  if (type == "address") {
    if (!GetUtils.isUsername(val)) {
      return "العنوان غير صالح";
    }
  }
  if (type == "date") {
    if (!GetUtils.isDateTime(val)) {
      return "التاريخ مطلوب";
    }
  }
  if (type == "email") {
    if (!GetUtils.isEmail(val)) {
      return "not valid email";
    }
  }

  if (type == "phone") {
    if (!GetUtils.isPhoneNumber(val)) {
      return "رقم الهاتف غير صالح";
    }
  }

  if (val.isEmpty) {
    return "هذاالحقل مطلوب ولا يمكن أن يكون فارغ";
  }

  if (val.length < min) {
    return "لا يمكن أن يكون أقل من $min";
  }

  if (val.length > max) {
    return "لا يمكن أن يكون أكبر من $max";
  }
}
