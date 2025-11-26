// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:responsive_builder/responsive_builder.dart';
// import 'package:daliluna_altaalimi/core/constant/color.dart';
//
// class CustomTextFromFields extends StatelessWidget {
//   final String label;
//   final IconData? preIcon;
//   final IconData? sufIcon;
//   final TextEditingController? controller;
//   final void Function()? onTap;
//   final String? Function(String?)? validator;
//   final TextInputType? keyboardType;
//   final bool? obscureText;
//   final bool readOnly;
//   final bool? showCursor;
//   final void Function()? onTapFun;
//   final String? errorText;
//   final List<TextInputFormatter>? inputFormatters;
//   const CustomTextFromFields(
//       {super.key,
//       required this.label,
//       required this.preIcon,
//       required this.controller,
//       this.sufIcon,
//       this.onTap,
//       this.obscureText,
//       this.validator,
//       required this.keyboardType,
//       required this.readOnly,
//       this.showCursor,
//       this.onTapFun,
//       this.errorText,
//       this.inputFormatters});
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       inputFormatters: inputFormatters,
//       onTap: onTapFun,
//       showCursor: showCursor,
//       readOnly: readOnly,
//       validator: validator,
//       maxLines: 1,
//       cursorColor: AppColor.DeepPurple,
//       cursorHeight: 20,
//       cursorWidth: 1,
//       keyboardType: keyboardType,
//       style: TextStyle(color: AppColor.PrimaryColor),
//       controller: controller,
//       obscureText: obscureText == null || obscureText == false ? false : true,
//       decoration: InputDecoration(
//         errorText: errorText,
//         errorBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: AppColor.DeepPurple),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(color: AppColor.DeepPurple, width: 1.5),
//         ),
//         errorStyle: TextStyle(color: AppColor.SecondryColor),
//         labelText: label,
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(color: AppColor.DeepPurple, width: 1.5),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: AppColor.DeepPurple),
//         ),
//         filled: true,
//         fillColor: AppColor.SecondryColor2.withOpacity(0.5),
//         labelStyle: TextStyle(
//             fontSize: getValueForScreenType<double>(
//               context: context,
//               mobile: 13,
//               tablet: 15,
//             ),
//             color: AppColor.DeepPurple),
//         prefixIcon: Icon(
//           preIcon,
//           color: AppColor.DeepPurple,
//         ),
//         suffixIcon: InkWell(
//           onTap: onTap,
//           child: Icon(
//             sufIcon,
//             color: AppColor.DeepPurple,
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';

class CustomTextFromFields extends StatelessWidget {
  final String label;
  final IconData? preIcon;
  final IconData? sufIcon;
  final TextEditingController? controller;
  final void Function()? onTap;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final bool readOnly;
  final bool? showCursor;
  final void Function()? onTapFun;
  final String? errorText;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextFromFields({
    super.key,
    required this.label,
    required this.preIcon,
    required this.controller,
    this.sufIcon,
    this.onTap,
    this.obscureText,
    this.validator,
    required this.keyboardType,
    required this.readOnly,
    this.showCursor,
    this.onTapFun,
    this.errorText,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // اجعل كل المحتوى من اليمين
      child: TextFormField(
        inputFormatters: inputFormatters,
        onTap: onTapFun,
        showCursor: showCursor,
        readOnly: readOnly,
        validator: validator,
        maxLines: 1,
        cursorColor: AppColor.PrimaryColor,
        cursorHeight: 22,
        cursorWidth: 2,
        textAlign: TextAlign.right,
        keyboardType: keyboardType,
        style: TextStyle(
          color: AppColor.PrimaryColor,
          fontSize: getValueForScreenType<double>(
            context: context,
            mobile: 14,
            tablet: 16,
          ),
        ),
        controller: controller,
        obscureText: obscureText ?? false,
        decoration: InputDecoration(
          errorText: errorText,
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: AppColor.PrimaryColor, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: AppColor.PrimaryColor, width: 2),
          ),
          errorStyle: TextStyle(color: AppColor.SecondryColor),
          labelText: label,
          labelStyle: TextStyle(
            fontSize: getValueForScreenType<double>(
              context: context,
              mobile: 14,
              tablet: 16,
            ),
            color: AppColor.PrimaryColor,
            fontWeight: FontWeight.w600,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          contentPadding: EdgeInsets.symmetric(
            vertical: getValueForScreenType<double>(
              context: context,
              mobile: 18,
              tablet: 22,
            ),
            horizontal: getValueForScreenType<double>(
              context: context,
              mobile: 20,
              tablet: 25,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: AppColor.PrimaryColor, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
              color: AppColor.PrimaryColor.withOpacity(0.7),
              width: 1.5,
            ),
          ),
          prefixIcon: preIcon != null
              ? Icon(preIcon, color: AppColor.PrimaryColor)
              : null,
          suffixIcon: sufIcon != null
              ? InkWell(
                  onTap: onTap,
                  child: Icon(sufIcon, color: AppColor.PrimaryColor),
                )
              : null,
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 40,
          ),
          suffixIconConstraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 40,
          ),
        ),
      ),
    );
  }
}
