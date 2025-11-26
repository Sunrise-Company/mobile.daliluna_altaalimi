// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:responsive_builder/responsive_builder.dart';
// import 'package:shimmer/shimmer.dart';
//
// import '../../../controller/exam/examSlotiounsController.dart';
// import '../../../core/constant/color.dart';
// import '../../widget/GetValueForScreen.dart';
// import '../../widget/loading.dart';
//
// class SoltionsScreen extends GetView<FetchSoltoinsExamControllerss> {
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         return true;
//       },
//       child: Directionality(
//         textDirection: TextDirection.rtl,
//         child: Scaffold(
//           backgroundColor:Colors.white,
//           // appBar: PreferredSize(
//           //   preferredSize: Size.fromHeight(
//           //     getValueForScreenType<double>(
//           //       context: context,
//           //       mobile: 55,
//           //       tablet: 100,
//           //     ),
//           //   ),
//           //   child: AppBar(
//           //     titleSpacing: getValueForScreenType<double>(
//           //       context: context,
//           //       mobile: 30,
//           //       tablet: 50,
//           //     ),
//           //     elevation: 0,
//           //     flexibleSpace: Container(
//           //       decoration: BoxDecoration(
//           //         gradient: LinearGradient(
//           //           begin: Alignment.topCenter,
//           //           end: Alignment.bottomRight,
//           //           colors: <Color>[AppColor.DeepPurple, AppColor.PrimaryColor],
//           //         ),
//           //       ),
//           //     ),
//           //     title: const Text(
//           //       "حلول الامتحان",
//           //       style: TextStyle(color: AppColor.White),
//           //     ),
//           //   ),
//           // ),
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
//               backgroundColor: AppColor.PrimaryColor,
//               title:
//               Shimmer.fromColors(
//                 baseColor: Colors.white,
//                 highlightColor: AppColor.SecondryColor,
//                 child:  Text(
//                   "حلول الامتحان",
//                   style:  TextStyle(fontSize: responsiveValue( context: context,
//                     mobile: 20,
//                     tablet: 35,), fontWeight: FontWeight
//                       .bold),
//                 ),),
//             ),
//           ),
//
//           body: SingleChildScrollView(
//             physics: BouncingScrollPhysics(),
//             child: Obx(() => controller.isloded.value
//                 ? Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Column(
//                       // crossAxisAlignment: CrossAxisAlignment.c,
//                       children: [
//                         SizedBox(height: 30),
//                         // Uncoacademyv3ent and modify below to display exam details
//                         _buildExamDetails(),
//                         _buildScoreSuacademyv3ary(),
//                         _buildQuestionList(),
//                       ],
//                     ),
//                   )
//                 : Loading()),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Uncoacademyv3ent and modify this method to display exam details
//   Widget _buildExamDetails() {
//     return Padding(
//       padding: const EdgeInsets.all(15.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Text(
//             "المادة: ${controller.lesson_name.value}",
//             style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 5),
//           Text(
//             " ${controller.examname.value}",
//             style: TextStyle(fontSize: 17),
//           ),
//           SizedBox(height: 5),
//           Text(
//             "الصف: ${controller.class_name.value}",
//             style: TextStyle(fontSize: 17),
//           ),
//           SizedBox(height: 5),
//           Text(
//             "المدة: ${controller.exam_period.value.toString()}",
//             style: TextStyle(fontSize: 17),
//           ),
//           SizedBox(height: 5),
//           // Add more details as needed
//         ],
//       ),
//     );
//   }
//
//   Widget _buildScoreSuacademyv3ary() {
//     return Padding(
//       padding: const EdgeInsets.all(15.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         textDirection: TextDirection.rtl,
//         children: [
//           Text(
//             "علامة الطالب: ${controller.student_result.value.toString()}",
//             style: TextStyle(
//               color: AppColor.DeepPurple,
//               fontWeight: FontWeight.bold,
//               fontSize: 15,
//             ),
//           ),
//           Text(
//             "العلامة النهائية: ${controller.content_mark.value.toString()}",
//             style: TextStyle(
//               color: AppColor.DeepPurple,
//               fontWeight: FontWeight.bold,
//               fontSize: 15,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildQuestionList() {
//     return ListView.builder(
//       scrollDirection: Axis.vertical,
//       physics: NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       itemCount: controller.dataListExam.length,
//       itemBuilder: (context, index) {
//         final question = controller.dataListExam[index];
//         final myOptions = json
//             .decode(question['option']['myOptions']); // Decode the JSON string
//         final correctAnswers =
//             json.decode(question['answer']); // Decode the correct answer(s)
//
//         return Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Container(
//             decoration: BoxDecoration(
//               color: AppColor.BackGround2,
//               boxShadow: [
//                 BoxShadow(
//                   color: AppColor.DeepPurple,
//                   offset: Offset(0, 4),
//                   blurRadius: 7.0,
//                   spreadRadius: 0.7,
//                 ),
//               ],
//               borderRadius: BorderRadius.circular(35.0),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Text(
//                       question['question_form'] + '؟' ?? '',
//                       style: TextStyle(color: Colors.black, fontSize: 20),
//                     ),
//                   ),
//                   // Display the options
//                   Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: myOptions.map<Widget>((option) {
//                         bool isCorrect = correctAnswers
//                             .contains(option); // Check if the option is correct
//                         return Container(
//                           width: MediaQuery.of(context).size.width * .8,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           child: Card(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                             color: isCorrect
//                                 ? AppColor.DeepPurple2
//                                 : Colors.white, // Color the correct answer
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text(
//                                 option,
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 18,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   ),
//
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                           width: MediaQuery.of(context).size.width * .4,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color: Color.fromARGB(255, 247, 221,
//                                 137), // Define the color for the shadow
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(2.0),
//                             child: Center(
//                               child: Text(
//                                 question['mark'].toString() +
//                                     '/' +
//                                     question['deserved_mark'].toString(),
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                 ),
//                               ),
//                             ),
//                           )),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shimmer/shimmer.dart';
import '../../../controller/exam/examSlotiounsController.dart';
import '../../../core/constant/color.dart';
import '../../widget/GetValueForScreen.dart';
import '../../widget/loading.dart';

class SoltionsScreen extends GetView<FetchSoltoinsExamControllerss> {
  const SoltionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            getValueForScreenType<double>(
              context: context,
              mobile: 55,
              tablet: 100,
            ),
          ),
          child: AppBar(
            elevation: 0,
            backgroundColor: AppColor.PrimaryColor,
            title: Shimmer.fromColors(
              baseColor: Colors.white,
              highlightColor: AppColor.SecondryColor,
              child: Text(
                "حلول الامتحان",
                style: TextStyle(
                  fontSize: responsiveValue(
                    context: context,
                    mobile: 20,
                    tablet: 35,
                  ),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        body: Obx(() {
          return controller.isloded.value
              ? SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildExamHeader(context),
                const SizedBox(height: 20),
                _buildScoreSummary(),
                const Divider(thickness: 1.2, height: 30),
                _buildQuestionList(),
                const SizedBox(height: 30),
              ],
            ),
          )
              : const Loading();
        }),
      ),
    );
  }

  /// 🧾 رأس الصفحة مع ساعة المدة
  Widget _buildExamHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColor.DeepPurple, AppColor.PrimaryColor],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColor.DeepPurple.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            controller.examname.value,
            style: TextStyle(
              color: Colors.white,
              fontSize: responsiveValue(context: context, mobile: 18, tablet: 25),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "المادة: ${controller.lesson_name.value} - الصف: ${controller.class_name.value}",
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 20),
          _buildTimerDisplay(context),
        ],
      ),
    );
  }

  /// ⏰ الساعة التي تظهر المدة
  Widget _buildTimerDisplay(BuildContext context) {
    final duration = controller.exam_period.value.toString();
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: responsiveValue(context: context, mobile: 100, tablet: 140),
          width: responsiveValue(context: context, mobile: 100, tablet: 140),
          child: CircularProgressIndicator(
            value: 1, // يمكن لاحقًا ربطها بنسبة الوقت الفعلي
            strokeWidth: 8,
            backgroundColor: Colors.white24,
            valueColor: AlwaysStoppedAnimation<Color>(AppColor.SecondryColor),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.timer, color: Colors.white, size: 30),
            Text(
              "$duration دقيقة",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  /// 🧮 العلامة
  Widget _buildScoreSummary() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColor.DeepPurple.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.emoji_events_rounded, color: Colors.amber, size: 26),
          const SizedBox(width: 10),
          Text(
            "علامتك: ${controller.student_result.value} / ${controller.content_mark.value}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  /// 📚 الأسئلة والأجوبة
  Widget _buildQuestionList() {
    return ListView.separated(
      separatorBuilder: (context, _) => const SizedBox(height: 25),
      itemCount: controller.dataListExam.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final question = controller.dataListExam[index];
        final myOptions = json.decode(question['option']['myOptions']);
        final correctAnswers = json.decode(question['answer']);
        final mark = "${question['mark']}/${question['deserved_mark']}";

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: AppColor.PrimaryColor,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // السؤال
              Text(
                "${index + 1}. ${question['question_form']}؟",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),

              // الأجوبة بتصميم جديد
              Column(
                children: List.generate(myOptions.length, (i) {
                  final option = myOptions[i];
                  final isCorrect = correctAnswers.contains(option);
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: isCorrect
                          ? AppColor.DeepPurple.withOpacity(0.15)
                          : Colors.grey[100],
                      border: Border.all(
                        color: isCorrect
                            ? AppColor.DeepPurple
                            : Colors.grey.withOpacity(0.3),
                        width: 1.3,
                      ),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                        isCorrect ? AppColor.DeepPurple : Colors.grey[400],
                        child: Icon(
                          isCorrect ? Icons.check : Icons.close,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      title: Text(
                        option,
                        style: TextStyle(
                          color: isCorrect ? AppColor.DeepPurple : Colors.black87,
                          fontWeight:
                          isCorrect ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 10),

              // علامة السؤال
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColor.SecondryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "العلامة: $mark",
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
