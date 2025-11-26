// import 'package:flutter/material.dart';
// import 'package:badges/badges.dart' as badges;
// import 'package:responsive_builder/responsive_builder.dart';
// import 'package:daliluna_altaalimi/core/constant/color.dart';
//
// class CustomCardSubject extends StatelessWidget {
//   final String text;
//   final void Function() onTap;
//   final void Function() onTapShop;
//   const CustomCardSubject(
//       {super.key,
//       required this.text,
//       required this.onTap,
//       required this.onTapShop});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(
//         right: getValueForScreenType<double>(
//           context: context,
//           mobile: 20,
//           tablet: 40,
//         ),
//         left: getValueForScreenType<double>(
//           context: context,
//           mobile: 20,
//           tablet: 40,
//         ),
//         bottom: getValueForScreenType<double>(
//           context: context,
//           mobile: 35,
//           tablet: 45,
//         ),
//         top: getValueForScreenType<double>(
//           context: context,
//           mobile: 10,
//           tablet: 15,
//         ),
//       ),
//       child: badges.Badge(
//         badgeAnimation: badges.BadgeAnimation.rotation(
//           animationDuration: Duration(seconds: 5),
//           colorChangeAnimationDuration: Duration(seconds: 5),
//           loopAnimation: false,
//           curve: Curves.fastOutSlowIn,
//           colorChangeAnimationCurve: Curves.easeInCubic,
//         ),
//         position: badges.BadgePosition.topEnd(
//             top: getValueForScreenType<double>(
//               context: context,
//               mobile: -25,
//               tablet: -40,
//             ),
//             end: 20),
//         showBadge: true,
//         ignorePointer: false,
//         badgeStyle: const badges.BadgeStyle(
//             badgeColor: AppColor.DeepPurple,
//             borderRadius: BorderRadius.zero,
//             borderSide: BorderSide.none,
//             shape: badges.BadgeShape.twitter),
//         badgeContent: InkWell(
//           onTap: onTap,
//           child: Container(
//               width: getValueForScreenType<double>(
//                 context: context,
//                 mobile: 35,
//                 tablet: 70,
//               ),
//               height: getValueForScreenType<double>(
//                 context: context,
//                 mobile: 35,
//                 tablet: 70,
//               ),
//               decoration: BoxDecoration(
//                   color: AppColor.White,
//                   borderRadius: BorderRadius.circular(50),
//                   border: Border.all(
//                     color: AppColor.DeepPurple,
//                     width: getValueForScreenType<double>(
//                       context: context,
//                       mobile: 1.5,
//                       tablet: 3,
//                     ),
//                   )),
//               child: Center(
//                   child: Text(
//                 'PDF',
//                 style: TextStyle(
//                   fontSize: getValueForScreenType<double>(
//                     context: context,
//                     mobile: 10,
//                     tablet: 15,
//                   ),
//                 ),
//               ))),
//         ),
//         child: InkWell(
//           onTap: onTap,
//           child: Container(
//             width: double.infinity,
//             padding: EdgeInsets.all(
//               getValueForScreenType<double>(
//                 context: context,
//                 mobile: 15,
//                 tablet: 35,
//               ),
//             ),
//             decoration: BoxDecoration(
//                 boxShadow: [
//                   BoxShadow(
//                       color: AppColor.PrimaryColor.withOpacity(0.5),
//                       offset: Offset(0, 25),
//                       blurRadius: 3,
//                       spreadRadius: -10)
//                 ],
//                 borderRadius: BorderRadius.circular(20),
//                 color: AppColor.BackGround,
//                 border: Border.all(
//                   color: AppColor.PrimaryColor.withOpacity(0.5),
//                   width: getValueForScreenType<double>(
//                     context: context,
//                     mobile: 1,
//                     tablet: 2,
//                   ),
//                 )),
//             child: Center(
//                 child: Text(
//               text,
//               style: TextStyle(
//                 fontSize: getValueForScreenType<double>(
//                   context: context,
//                   mobile: 13,
//                   tablet: 17,
//                 ),
//               ),
//             )),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';

class CustomCardSubject extends StatelessWidget {
  final String text;
  final void Function() onTap;
  final void Function() onTapShop;

  const CustomCardSubject({
    super.key,
    required this.text,
    required this.onTap,
    required this.onTapShop,
  });

  @override
  Widget build(BuildContext context) {
    final double iconSize = getValueForScreenType<double>(
      context: context,
      mobile: 25,
      tablet: 40,
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getValueForScreenType<double>(
          context: context,
          mobile: 20,
          tablet: 40,
        ),
        vertical: getValueForScreenType<double>(
          context: context,
          mobile: 10,
          tablet: 15,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColor.PrimaryColor,
              offset: const Offset(0, 5),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
          border: Border.all(
            color: AppColor.PrimaryColor.withOpacity(0.5),
            width: getValueForScreenType<double>(
              context: context,
              mobile: 1,
              tablet: 2,
            ),
          ),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: getValueForScreenType<double>(
              context: context,
              mobile: 15,
              tablet: 30,
            ),
            vertical: getValueForScreenType<double>(
              context: context,
              mobile: 8,
              tablet: 15,
            ),
          ),
          title: Text(
            text,
            style: TextStyle(
              fontSize: getValueForScreenType<double>(
                context: context,
                mobile: 14,
                tablet: 18,
              ),
              color: AppColor.PrimaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: badges.Badge(
            showBadge: true,
            position: badges.BadgePosition.topEnd(top: -5, end: -5),
            badgeContent: const SizedBox.shrink(), // فقط لإبقاء التنسيق
            badgeStyle: const badges.BadgeStyle(badgeColor: Colors.transparent),
            child: CircleAvatar(
              backgroundColor: AppColor.PrimaryColor.withOpacity(0.15),
              radius: iconSize / 1.8,
              child: Icon(
                Icons.book_rounded,
                color: AppColor.PrimaryColor,
                size: iconSize,
              ),
            ),
          ),
          trailing: InkWell(
            onTap: onTapShop,
            borderRadius: BorderRadius.circular(50),
            child: Container(
              padding: EdgeInsets.all(
                getValueForScreenType<double>(
                  context: context,
                  mobile: 8,
                  tablet: 12,
                ),
              ),
              decoration: BoxDecoration(
                color: AppColor.SecondryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.picture_as_pdf_rounded,
                color: Colors.white,
                size: getValueForScreenType<double>(
                  context: context,
                  mobile: 18,
                  tablet: 28,
                ),
              ),
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
