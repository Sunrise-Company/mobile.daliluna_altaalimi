import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/linkapi.dart';
import 'package:daliluna_altaalimi/view/widget/loadingimage.dart';

//
// class CustomCardHome extends StatelessWidget {
//   final String text;
//   final String? nameImage;
//   final void Function()? onTap;
//
//   const CustomCardHome({
//     super.key,
//     required this.text,
//     required this.onTap,
//     this.nameImage,
//   });
//
//   @override
//   Widget build(BuildContext context) {
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
//             borderRadius: BorderRadius.circular(20),
//             color: AppColor.BackGround2,
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(
//                   height: getValueForScreenType<double>(
//                     context: context,
//                     mobile: 60,
//                     tablet: 80,
//                   ),
//                   width: getValueForScreenType<double>(
//                     context: context,
//                     mobile: 80,
//                     tablet: 100,
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
//                   mobile: 20,
//                   tablet: 30,
//                 ),
//               ),
//               SizedBox(
//                 width: getValueForScreenType<double>(
//                   context: context,
//                   mobile: 150,
//                   tablet: 300,
//                 ),
//                 height: getValueForScreenType<double>(
//                   context: context,
//                   mobile: 35,
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
//                             mobile: 8,
//                             tablet: 12,
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
class CustomCardHome extends StatelessWidget {
  final String name;
  final String? image;
  final void Function()? onTap;

  CustomCardHome({required this.name, this.image, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              AppColor.DeepPurple2,
              AppColor.DeepPurple.withOpacity(0.9),
              AppColor.PrimaryColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.PrimaryColor.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: image != null
                    ? ClipOval(
                        // borderRadius: BorderRadius.circular(25),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: AppLink.image + "/" + image!,
                          // "${AppLink.baseUrl}/storage/classimages/tZSTIImSEDQ3SY0mdgIQFDawF58wulwUP0IoTpVs.jpg"
                          placeholder: (context, url) => const LoadingImage(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error, color: Colors.white),
                        ),
                      )
                    : const Icon(
                        Icons.image_not_supported,
                        color: Colors.white70,
                      ),
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4,
                ),
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: getValueForScreenType<double>(
                      context: context,
                      mobile: 11,
                      tablet: 16,
                    ),
                    height: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
