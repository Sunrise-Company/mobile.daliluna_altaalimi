
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
              fontSize: responsiveValue(
                context: context,
                mobile: 18,
                tablet: 25,
              ),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "المادة: ${controller.lesson_name.value} - الصف: ${controller.class_name.value}",
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 20),
          // _buildTimerDisplay(context),
        ],
      ),
    );
  }

  /// ⏰ الساعة التي تظهر المدة
  // Widget _buildTimerDisplay(BuildContext context) {
  //   final duration = controller.exam_period.value.toString();
  //   return Stack(
  //     alignment: Alignment.center,
  //     children: [
  //       SizedBox(
  //         height: responsiveValue(context: context, mobile: 100, tablet: 140),
  //         width: responsiveValue(context: context, mobile: 100, tablet: 140),
  //         child: CircularProgressIndicator(
  //           value: 1, // يمكن لاحقًا ربطها بنسبة الوقت الفعلي
  //           strokeWidth: 8,
  //           backgroundColor: Colors.white24,
  //           valueColor: AlwaysStoppedAnimation<Color>(AppColor.SecondryColor),
  //         ),
  //       ),
  //       Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           const Icon(Icons.timer, color: Colors.white, size: 30),
  //           Text(
  //             "$duration دقيقة",
  //             style: const TextStyle(
  //               color: Colors.white,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

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
                        backgroundColor: isCorrect
                            ? AppColor.DeepPurple
                            : Colors.grey[400],
                        child: Icon(
                          isCorrect ? Icons.check : Icons.close,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      title: Text(
                        option,
                        style: TextStyle(
                          color: isCorrect
                              ? AppColor.DeepPurple
                              : Colors.black87,
                          fontWeight: isCorrect
                              ? FontWeight.bold
                              : FontWeight.normal,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
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
