import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/exam/startExamController.dart';
import '../../../core/constant/color.dart';
import '../../../linkapi.dart';
import '../../widget/GetValueForScreen.dart';

class StartExam extends GetView<StartExamControllerss> {
  final int type;
  final int index;
  final dynamic ckechid;

  final yourScrollController = ScrollController();

  StartExam({Key? key, required this.type, required this.index, required this.ckechid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine options based on type
    final List<dynamic> options = type == 1
        ? jsonDecode(controller.questionlist[index].option!.myOptions.toString())
        : [];

    return Obx(() {
      // Accessing reactive variables to ensure rebuilds
      // We also ensure this entire page rebuilds when data changes
      return Scaffold(
        backgroundColor: Colors.grey[50], // Light background for better contrast
        body: SafeArea(
          child: Column(
            children: [
              // 1. Header with Question Count
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColor.DeepPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "السؤال ${index + 1} من ${controller.questionlist.length}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColor.DeepPurple,
                        ),
                      ),
                    ),
                    // Optional: You could add a timer here if available in controller
                  ],
                ),
              ),

              // 2. Main Content Area
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Section Content (Image, Audio, Passage)
                      if (controller.questionlist[index].section != null)
                        _buildSectionContainer(index),

                      const SizedBox(height: 20),

                      // Question Text Card
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              offset: const Offset(0, 4),
                              blurRadius: 16,
                            ),
                          ],
                        ),
                        child: Text(
                          controller.questionlist[index].questionForm.toString() + "؟",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: responsiveValue(
                              context: context,
                              mobile: 18,
                              tablet: 24,
                            ),
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            height: 1.4,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Options Header
                      if (type == 1)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 15, right: 8),
                          child: Text(
                            "اختر الإجابة الصحيحة:",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                          ),
                        ),

                      // Options List or Text Field
                      if (type == 1)
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: options.length,
                          separatorBuilder: (context, i) => const SizedBox(height: 12),
                          itemBuilder: (context, ind) {
                            final optionLabel = String.fromCharCode(65 + ind); // A, B, C...

                            return Obx(() {
                              final isSelected = controller.check[index]()[options[ind]] ?? false;
                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    controller.itemChange(options[ind], index);
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeInOut,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColor.DeepPurple
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColor.DeepPurple
                                            : Colors.grey.shade300,
                                        width: isSelected ? 2 : 1.5,
                                      ),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: AppColor.DeepPurple.withOpacity(0.3),
                                                blurRadius: 8,
                                                offset: const Offset(0, 4),
                                              )
                                            ]
                                          : [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.05),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              )
                                            ],
                                    ),
                                    child: Row(
                                      children: [
                                        // Option Label (A, B, C)
                                        Container(
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? Colors.white.withOpacity(0.2)
                                                : Colors.grey.shade100,
                                            shape: BoxShape.circle,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            optionLabel,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: isSelected
                                                  ? Colors.white
                                                  : Colors.grey.shade700,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        // Option Content
                                        Expanded(
                                          child: Text(
                                            options[ind],
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.normal,
                                              color: isSelected
                                                  ? Colors.white
                                                  : Colors.black87,
                                            ),
                                          ),
                                        ),
                                        // Check Icon
                                        if (isSelected) ...[
                                          const SizedBox(width: 10),
                                          const Icon(
                                            Icons.check_circle,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                          },
                        )
                      else
                        TextField(
                          onChanged: (value) {
                            controller.check[index]()["answer$index"] = value;
                          },
                          keyboardType: TextInputType.multiline,
                          maxLines: 6,
                          style: const TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            hintText: "أدخل إجابتك هنا...",
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.all(20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: AppColor.DeepPurple,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // 3. Bottom Navigation Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    if (index != 0)
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: AppColor.DeepPurple, width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: controller.previousQuestion,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.arrow_forward_ios, size: 16, color: AppColor.DeepPurple),
                                const SizedBox(width: 8),
                                Text(
                                  'السابق',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.DeepPurple,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    else
                      const Spacer(),

                    const SizedBox(width: 16),

                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.DeepPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                            shadowColor: AppColor.DeepPurple.withOpacity(0.4),
                          ),
                          onPressed: index == controller.questionlist.length - 1
                              ? controller.submit
                              : controller.nextQuestion,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                index == controller.questionlist.length - 1
                                    ? 'إنهاء الامتحان'
                                    : 'السؤال التالي',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              if (index != controller.questionlist.length - 1) ...[
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_back_ios, size: 16, color: Colors.white),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // Helper widget to wrap section content
  Widget _buildSectionContainer(int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
         border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: _buildSectionContent(index),
      ),
    );
  }


  List<Widget> _buildSectionContent(int index) {
    final section = controller.questionlist[index].section!;
    switch (section.type) {
      case 0: // Text Content
        return [
          SizedBox(
            height: 150,
            child: Scrollbar(
              controller: yourScrollController,
              radius: const Radius.circular(8),
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: yourScrollController,
                child: Text(
                  section.content.toString(),
                  textAlign: controller.questionlist[index].lesson!.isEnglish == '1'
                      ? TextAlign.left
                      : TextAlign.right,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    height: 1.6,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ];
      case 2: // Audio Content
        return [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: AppColor.DeepPurple.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15)
            ),
            child: Row(
              children: [
                IconButton(
                  iconSize: 40,
                  icon: Icon(
                    controller.isplaying[index].value
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_filled,
                    color: AppColor.DeepPurple,
                  ),
                  onPressed: () async {
                    if (controller.isplaying[index].value) {
                      controller.isplaying[index](false);
                      await controller.player.pause();
                    } else {
                      controller.isplaying[index](true);
                      await controller.player.play(
                        UrlSource(AppLink.image + section.content.toString()),
                      );
                    }
                  },
                ),
                Expanded(
                  child: Obx(() => SliderTheme(
                    data: SliderTheme.of(Get.context!).copyWith(
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
                      overlayShape: RoundSliderOverlayShape(overlayRadius: 16),
                      activeTrackColor: AppColor.DeepPurple,
                      thumbColor: AppColor.DeepPurple,
                      inactiveTrackColor: Colors.grey[300],
                    ),
                    child: Slider(
                      value: double.parse(controller.positions[index].toString()),
                      min: 0,
                      max: double.parse(controller.durations[index].toString()),
                      onChanged: (val) async {
                         controller.positions()[index] = val;
                         // Optimization: No need to await seek for UI responsiveness usually, but kept for consistency
                         await controller.player.seek(Duration(milliseconds: val.toInt()));
                      },
                    ),
                  )),
                ),
              ],
            ),
          ),
        ];
      case 3: // Image Content
        return [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              AppLink.image + section.content.toString(),
              fit: BoxFit.contain,
              height: 250,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) =>
                  Container(
                    height: 250,
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  ),
            ),
          ),
        ];
      default:
        return [];
    }
  }
}
