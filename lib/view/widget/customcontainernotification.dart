// import 'package:flutter/material.dart';
// import 'package:responsive_builder/responsive_builder.dart';
//
// class CustomContainerNotification extends StatelessWidget {
//   final String text;
//   final Color? color;
//   const CustomContainerNotification(
//       {super.key, required this.text, this.color});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(
//         getValueForScreenType<double>(
//           context: context,
//           mobile: 20,
//           tablet: 40,
//         ),
//       ),
//       decoration:
//           BoxDecoration(borderRadius: BorderRadius.circular(20), color: color),
//       child: Text(
//           text,
//           style: TextStyle(
//             fontSize: getValueForScreenType<double>(
//               context: context,
//               mobile: 15,
//               tablet: 17,
//
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CustomContainerNotification extends StatelessWidget {
  final String text;
  final IconData icon; // أيقونة للإشعار
  const CustomContainerNotification({
    super.key,
    required this.text,
    this.icon = Icons.notifications, // قيمة افتراضية
  });

  @override
  Widget build(BuildContext context) {
    double padding = getValueForScreenType<double>(
      context: context,
      mobile: 30,
      tablet: 50,
    );

    double fontSize = getValueForScreenType<double>(
      context: context,
      mobile: 14,
      tablet: 18,
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: padding / 2),
      decoration: BoxDecoration(
        color: Colors.white, // لون الإشعار أبيض
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor.PrimaryColor, // ظل بنفسجي
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColor.SecondryColor, size: fontSize + 10),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.black, // نص أسود
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
