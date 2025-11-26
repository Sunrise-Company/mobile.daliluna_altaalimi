// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:gradients/gradients.dart';
// import 'package:responsive_builder/responsive_builder.dart';

// import '../../core/constant/color.dart';

// class VideoNull extends StatelessWidget {
//   const VideoNull({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//         textDirection: TextDirection.rtl,
//         child: Scaffold(
//           appBar: PreferredSize(
//             preferredSize: Size.fromHeight(
//               getValueForScreenType<double>(
//                 context: context,
//                 mobile: 55,
//                 tablet: 100,
//               ),
//             ),
//             child: AppBar(
//               elevation: 0,
//               flexibleSpace: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradientPainter(
//                     begin: Alignment.topRight,
//                     end: Alignment.topCenter,
//                     colors: <Color>[
//                       AppColor.SecondryColor2,
//                       AppColor.DeepPurple
//                     ],
//                   ),
//                 ),
//               ),
//               title: const Text(
//                 "الفيديو",
//               ),
//             ),
//           ),
//           body: Center(
//               child: Text(
//             "لا يوجد فيديو",
//             style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
//           )),
//         ));
//   }
// }
