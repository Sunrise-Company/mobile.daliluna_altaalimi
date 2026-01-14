// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:responsive_builder/responsive_builder.dart';
// import 'package:daliluna_altaalimi/core/constant/color.dart';
// import 'package:daliluna_altaalimi/linkapi.dart';
// import 'package:daliluna_altaalimi/view/widget/loadingimage.dart';
//
// class CustomCard extends StatelessWidget {
//   final String text;
//   final String? nameImage;
//   final void Function()? onTap;
//   // final bool? section;
//   const CustomCard({
//     super.key,
//     required this.text,
//     required this.onTap,
//     this.nameImage,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     // print(AppLink.image + "/" + nameImage);
//     return Container(
//       padding: EdgeInsets.all(
//         getValueForScreenType<double>(
//           context: context,
//           mobile: 10,
//           tablet: 20,
//         ),
//       ),
//       child: InkWell(
//         onTap: onTap,
//         child: Container(
//           decoration: BoxDecoration(
//             color: AppColor.BackGround2,
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               SizedBox(
//                   height: getValueForScreenType<double>(
//                     context: context,
//                     mobile: 90,
//                     tablet: 80,
//                   ),
//                   width: getValueForScreenType<double>(
//                     context: context,
//                     mobile: 110,
//                     tablet: 130,
//                   ),
//                   child: nameImage != null
//                       ? CachedNetworkImage(
//                           fit: BoxFit.fill,
//                           placeholder: (context, url) => LoadingImage(),
//                           errorWidget: (context, url, error) =>
//                               Icon(Icons.error),
//                           imageUrl: AppLink.image + "/" + nameImage!)
//                       : Text('')),
//               SizedBox(
//                 height: getValueForScreenType<double>(
//                   context: context,
//                   mobile: 10,
//                   tablet: 20,
//                 ),
//               ),
//               SizedBox(
//                 width: getValueForScreenType<double>(
//                   context: context,
//                   mobile: 200,
//                   tablet: 300,
//                 ),
//                 height: getValueForScreenType<double>(
//                   context: context,
//                   mobile: 40,
//                   tablet: 55,
//                 ),
//                 child: Card(
//                   elevation: 5,
//                   shadowColor: AppColor.SecondryColor,
//                   color: AppColor.BackGround,
//                   child: Center(
//                     child: Text(
//                       text,
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: getValueForScreenType<double>(
//                             context: context,
//                             mobile: 10,
//                             tablet: 17,
//                           ),
//                           color: AppColor.PrimaryColor),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/linkapi.dart';
import 'package:daliluna_altaalimi/view/widget/loadingimage.dart';

class CustomCard extends StatelessWidget {
  final String text;
  final String? nameImage;
  final void Function()? onTap;
  final String? subtitle;

  const CustomCard({
    super.key,
    required this.text,
    required this.onTap,
    this.nameImage,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final double imageSize = getValueForScreenType<double>(
      context: context,
      mobile: 60,
      tablet: 100,
    );

    return Padding(
      padding: EdgeInsets.all(
        getValueForScreenType<double>(context: context, mobile: 8, tablet: 16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Card(
          color: Colors.white,
          elevation: 4,
          shadowColor: AppColor.PrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            subtitle: subtitle != null
                ? Text(
                    subtitle!,
                    style: TextStyle(
                      color: AppColor.grey,
                      fontSize: getValueForScreenType<double>(
                        context: context,
                        mobile: 12,
                        tablet: 16,
                      ),
                    ),
                  )
                : null,
            contentPadding: EdgeInsets.symmetric(
              horizontal: getValueForScreenType<double>(
                context: context,
                mobile: 10,
                tablet: 20,
              ),
              vertical: getValueForScreenType<double>(
                context: context,
                mobile: 10,
                tablet: 15,
              ),
            ),
            leading: nameImage != null && nameImage!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      width: imageSize,
                      height: imageSize,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => LoadingImage(),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error, size: imageSize / 1.5),
                      imageUrl: AppLink.image + "/" + nameImage!,
                    ),
                  )
                : null,
            title: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: getValueForScreenType<double>(
                  context: context,
                  mobile: 14,
                  tablet: 22,
                ),
                color: AppColor.PrimaryColor,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: AppColor.SecondryColor,
              size: getValueForScreenType<double>(
                context: context,
                mobile: 16,
                tablet: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
