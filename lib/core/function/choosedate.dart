import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';

selectDate(BuildContext context, selectedDate, controller) async {
  final pickedDate = await showRoundedDatePicker(
    height: Get.height / 2.5,
    theme: ThemeData(primaryColor: AppColor.DeepPurple.withOpacity(0.5)),
    styleYearPicker: MaterialRoundedYearPickerStyle(
      textStyleYearSelected: TextStyle(
        color: AppColor.PrimaryColor.withOpacity(0.6),
      ),
    ),
    styleDatePicker: MaterialRoundedDatePickerStyle(
      textStyleCurrentDayOnCalendar: TextStyle(
        color: AppColor.PrimaryColor.withOpacity(0.6),
      ),
      textStyleButtonNegative: TextStyle(
        color: AppColor.SecondryColor,
        fontWeight: FontWeight.bold,
      ),
      textStyleButtonPositive: TextStyle(
        color: AppColor.PrimaryColor,
        fontWeight: FontWeight.bold,
      ),
      decorationDateSelected: BoxDecoration(
        color: AppColor.SecondryColor.withOpacity(0.6),
        borderRadius: BorderRadius.circular(50),
      ),
      textStyleDayOnCalendarSelected: TextStyle(
        color: AppColor.White,
        fontWeight: FontWeight.bold,
      ),
      textStyleDayButton: TextStyle(color: AppColor.White, fontSize: 25),
      textStyleYearButton: TextStyle(
        color: AppColor.White,
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    ),
    context: context,
    initialDate: selectedDate.value,
    firstDate: DateTime(1900),
    lastDate: DateTime(DateTime.now().year + 1),
    borderRadius: 16,
  );
  if (pickedDate != null) {
    // selectedDate.value = pickedDate;
    // controller.text = pickedDate.toString();
    selectedDate.value = pickedDate;
    final formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
    controller.text = formattedDate.toString();
  }
}
