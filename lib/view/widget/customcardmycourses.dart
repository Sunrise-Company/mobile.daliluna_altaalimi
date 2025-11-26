import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
//
// class CustomCardMyCourses extends StatelessWidget {
//   final String section;
//   final void Function()? onTap;
//   const CustomCardMyCourses({
//     super.key,
//     required this.onTap,
//     required this.section,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.all(
//           getValueForScreenType<double>(
//             context: context,
//             mobile: 20,
//             tablet: 40,
//           ),
//         ),
//         child: Container(
//           decoration: BoxDecoration(
//             color: AppColor.DeepPurple.withOpacity(0.5),
//             borderRadius: BorderRadius.circular(10),
//             boxShadow: [
//               BoxShadow(
//                 color: AppColor.PrimaryColor.withOpacity(0.5),
//                 blurRadius: 5,
//                 spreadRadius: 2,
//               ),
//             ],
//           ),
//           child: SizedBox(
//             height: getValueForScreenType<double>(
//               context: context,
//               mobile: 100,
//               tablet: 150,
//             ),
//             width: getValueForScreenType<double>(
//               context: context,
//               mobile: 100,
//               tablet: 150,
//             ),
//             child: Card(
//               color: AppColor.BackGround,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Text(
//                     section,
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: getValueForScreenType<double>(
//                         context: context,
//                         mobile: 12,
//                         tablet: 15,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//

class CustomListTileMyCourses extends StatelessWidget {
  final String section;
  final void Function()? onTap;

  const CustomListTileMyCourses({
    super.key,
    required this.section,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shadowColor: AppColor.PrimaryColor,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: AppColor.DeepPurple.withOpacity(0.8),
          child: const Icon(Icons.book_rounded, color: Colors.white),
        ),
        title: Text(
          section,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: getValueForScreenType<double>(
              context: context,
              mobile: 14,
              tablet: 17,
            ),
            color: AppColor.PrimaryColor,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          color: AppColor.SecondryColor,
        ),
      ),
    );
  }
}
