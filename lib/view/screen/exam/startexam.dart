// import 'dart:convert';
//
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../controller/exam/startExamController.dart';
// import '../../../core/constant/color.dart';
// import '../../../linkapi.dart';
//
// class StartExam extends GetView<StartExamControllerss> {
//   int type;
//   int index;
//   dynamic ckechid;
//   final yourScrollController = ScrollController();
//   final yourScrollController2 = ScrollController();
//
//   StartExam({required this.type, required this.index, required this.ckechid});
//   @override
//   Widget build(BuildContext context) {
//     final List<dynamic> options;
//     String answer;
//     if (type == 1) {
//       options = jsonDecode(
//           controller.questionlist[index].option!.myOptions.toString());
//     } else {
//       options = [];
//     }
//
//     MediaQueryData queryData;
//
//     queryData = MediaQuery.of(context);
//     var width = queryData.size.width;
//     return Obx(() => SafeArea(
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Padding(
//                     padding: const EdgeInsets.all(10),
//                     child: Scrollbar(
//                         controller: yourScrollController2,
//                         radius: Radius.circular(8),
//                         thickness: 6,
//                         scrollbarOrientation: ScrollbarOrientation.right,
//                         thumbVisibility: true,
//                         child: SingleChildScrollView(
//                           controller: yourScrollController2,
//                           physics: ScrollPhysics(),
//                           scrollDirection: Axis.vertical,
//                           child: Column(
//                             children: [
//                               controller.questionlist[index].section == null
//                                   ? Text("")
//                                   : controller.questionlist[index].section!
//                                               .type ==
//                                           0
//                                       ? SizedBox(
//                                           height: 100,
//                                           child: Scrollbar(
//                                             controller: yourScrollController,
//                                             radius: Radius.circular(8),
//                                             thickness: 6,
//                                             thumbVisibility: true,
//                                             child: SingleChildScrollView(
//                                               controller: yourScrollController,
//                                               child: Padding(
//                                                 padding: EdgeInsets.all(7.0),
//                                                 child: Container(
//                                                   width: double.infinity,
//                                                   child: controller
//                                                               .questionlist[
//                                                                   index]
//                                                               .lesson!
//                                                               .isEnglish ==
//                                                           '1'
//                                                       ? Text(
//                                                           controller
//                                                               .questionlist[
//                                                                   index]
//                                                               .section!
//                                                               .content
//                                                               .toString(),
//                                                           textAlign:
//                                                               TextAlign.left,
//                                                           style: TextStyle(
//                                                               color:
//                                                                   Colors.black,
//                                                               fontSize: 15,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w600),
//                                                         )
//                                                       : Text(
//                                                           controller
//                                                               .questionlist[
//                                                                   index]
//                                                               .section!
//                                                               .content
//                                                               .toString(),
//                                                           textAlign:
//                                                               TextAlign.right,
//                                                           style: TextStyle(
//                                                               color:
//                                                                   Colors.black,
//                                                               fontSize: 15,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w600),
//                                                         ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         )
//                                       : controller.questionlist[index].section!
//                                                   .type ==
//                                               3
//                                           ? SizedBox(
//                                               height: 250,
//                                               child: Scrollbar(
//                                                   controller:
//                                                       yourScrollController,
//                                                   radius: Radius.circular(8),
//                                                   thickness: 6,
//                                                   thumbVisibility: true,
//                                                   child: SingleChildScrollView(
//                                                       controller:
//                                                           yourScrollController,
//                                                       child: Image.network(
//                                                         AppLink.image +
//                                                             controller
//                                                                 .questionlist[
//                                                                     index]
//                                                                 .section!
//                                                                 .content
//                                                                 .toString(),
//                                                       ))))
//                                           : controller.questionlist[index]
//                                                       .section?.type ==
//                                                   2
//                                               ? Row(
//                                                   children: [
//                                                     CircleAvatar(
//                                                       radius: 20,
//                                                       backgroundColor:
//                                                           AppColor.BackGround2,
//                                                       child: IconButton(
//                                                           icon: Icon(
//                                                             controller.isplaying[
//                                                                         index] ==
//                                                                     true
//                                                                 ? Icons.stop
//                                                                 : Icons
//                                                                     .play_arrow,
//                                                             color: Colors.white,
//                                                           ),
//                                                           onPressed: () async {
//                                                             if (controller
//                                                                         .isplaying[
//                                                                     index] ==
//                                                                 true) {
//                                                               controller
//                                                                       .isplaying[
//                                                                   index](false);
//                                                               await controller
//                                                                   .player
//                                                                   .pause();
//                                                             } else {
//                                                               controller
//                                                                       .isplaying[
//                                                                   index](true);
//                                                               await controller.player.play(UrlSource(AppLink
//                                                                       .image +
//                                                                   controller
//                                                                       .questionlist[
//                                                                           index]
//                                                                       .section!
//                                                                       .content
//                                                                       .toString()));
//                                                             }
//                                                           }),
//                                                     ),
//                                                     Obx(
//                                                       () {
//                                                         return Slider(
//                                                           activeColor: AppColor
//                                                               .BackGround2,
//                                                           inactiveColor:
//                                                               Colors.grey,
//                                                           value: double.parse(
//                                                               controller
//                                                                   .positions[
//                                                                       index]
//                                                                   .toString()),
//                                                           min: 0,
//                                                           max: double.parse(
//                                                               controller
//                                                                   .durations[
//                                                                       index]
//                                                                   .toString()),
//                                                           onChanged:
//                                                               (Value) async {
//                                                             controller
//                                                                     .positions()[
//                                                                 index] = Value;
//
//                                                             await controller
//                                                                 .player
//                                                                 .seek(Duration(
//                                                                     milliseconds:
//                                                                         Value
//                                                                             .toInt()));
//                                                           },
//                                                         );
//                                                       },
//                                                     )
//                                                   ],
//                                                 )
//                                               : Text(""),
//                               SizedBox(
//                                 height: 15,
//                               ),
//                               Text(
//                                 controller.questionlist[index].questionForm
//                                         .toString() +
//                                     "؟",
//                                 style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 17,
//                                     fontWeight: FontWeight.w600),
//                               ),
//                               type == 1
//                                   ? ListView.builder(
//                                       scrollDirection: Axis.vertical,
//                                       physics: ScrollPhysics(
//                                           parent: ScrollPhysics()),
//                                       shrinkWrap: true,
//                                       itemCount: options.length,
//                                       itemBuilder: (context, ind) {
//                                         return Obx(() {
//                                           final isSelected = controller.check[
//                                                   index]()[options[ind]] ??
//                                               false;
//                                           return Container(
//                                             height: 60,
//                                             decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(15),
//                                             ),
//                                             child: Card(
//                                               shape: RoundedRectangleBorder(
//                                                 borderRadius:
//                                                     BorderRadius.circular(15),
//                                               ),
//                                               child: CheckboxListTile(
//                                                   value: isSelected,
//                                                   onChanged: (newValue) {
//                                                     controller.itemChange(
//                                                         options[ind], index);
//                                                   },
//                                                   title: Text(
//                                                     options[ind],
//                                                     style: TextStyle(
//                                                         fontSize: 15,
//                                                         fontWeight:
//                                                             FontWeight.w400),
//                                                   ),
//                                                   controlAffinity:
//                                                       ListTileControlAffinity
//                                                           .leading,
//                                                   activeColor:
//                                                       AppColor.DeepPurple),
//                                             ),
//                                           );
//                                         });
//                                       },
//                                     )
//                                   : TextField(
//                                       onChanged: (value) {
//                                         controller.check[index]()[
//                                             "answer$index"] = value;
//                                         print(controller
//                                             .check[index]()["answer$index"]);
//                                       },
//                                       keyboardType: TextInputType.multiline,
//                                       maxLines: 8,
//                                       decoration: InputDecoration(
//                                         hintText: "أدخل الجواب",
//                                         hintStyle: TextStyle(
//                                             fontFamily: "Cairo-",
//                                             color: Colors.black),
//                                         errorBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                               color: AppColor.BackGround2,
//                                               width: 1.5),
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(15)),
//                                         ),
//                                         focusedErrorBorder: OutlineInputBorder(
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(25)),
//                                           borderSide: BorderSide(
//                                               width: 1.5,
//                                               color: AppColor.DeepPurple),
//                                         ),
//                                         enabledBorder: OutlineInputBorder(
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(15)),
//                                           borderSide: new BorderSide(
//                                               color: AppColor.DeepPurple,
//                                               width: 1.5),
//                                         ),
//                                         focusedBorder: OutlineInputBorder(
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(25)),
//                                           borderSide: BorderSide(
//                                               width: 1.5,
//                                               color: AppColor.DeepPurple),
//                                         ),
//                                       ),
//                                     ),
//                             ],
//                           ),
//                         ))),
//
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     if (index == controller.questionlist.length - 1)
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           foregroundColor: Colors.white,
//                           backgroundColor: AppColor.DeepPurple,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                         ),
//                         onPressed: () {
//                           controller.submit();
//                         },
//                         child: Text(
//                           'إنهاء الامتحان',
//                           style: TextStyle(
//                             fontSize: 17,
//                           ),
//                         ),
//                       ),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         // primary: ThirdColor,
//                         backgroundColor: AppColor.BackGround2,
//                         // onPrimary: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                       ),
//                       onPressed: index == 0
//                           ? null
//                           : () {
//                               controller.previousQuestion();
//                             },
//                       child: Text('السابق',
//                           style: TextStyle(
//                               fontSize: 17, color: AppColor.DeepPurple)),
//                     ),
//                     if (index < controller.questionlist.length - 1)
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           foregroundColor: Colors.white,
//                           backgroundColor: AppColor.DeepPurple,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(5),
//                             // side: BorderSide(
//                             //   // color: Color.fromARGB(255, 131, 129, 129),
//                             //   width: 2,
//                             // ),
//                           ),
//                         ),
//                         onPressed: index == controller.questionlist.length - 1
//                             ? null
//                             : () {
//                                 controller.nextQuestion();
//                               },
//                         child: Text('التالي', style: TextStyle(fontSize: 17)),
//                       ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }
// }
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
  final yourScrollController2 = ScrollController();

  StartExam({required this.type, required this.index, required this.ckechid});

  @override
  Widget build(BuildContext context) {
    final List<dynamic> options = type == 1
        ? jsonDecode(
            controller.questionlist[index].option!.myOptions.toString(),
          )
        : [];

    return Obx(
      () => SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // القسم / محتوى الصورة / الصوت
                    if (controller.questionlist[index].section != null)
                      ..._buildSectionContent(index),

                    const SizedBox(height: 15),

                    Text(
                      controller.questionlist[index].questionForm.toString() +
                          "؟",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: responsiveValue(
                          context: context,
                          mobile: 20,
                          tablet: 30,
                        ),
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // الخيارات
                    if (type == 1)
                      // ListView.builder(
                      //   shrinkWrap: true,
                      //   physics: const NeverScrollableScrollPhysics(),
                      //   itemCount: options.length,
                      //   itemBuilder: (context, ind) {
                      //     final isSelected =
                      //         controller.check[index]()[options[ind]] ?? false;
                      //     final optionLabel = String.fromCharCode(65 + ind); // A, B, C
                      //     return Container(
                      //       margin: const EdgeInsets.symmetric(vertical: 6),
                      //       child: Card(
                      //         color: isSelected
                      //             ? AppColor.DeepPurple.withOpacity(0.1) // خلفية خفيفة عند التحديد
                      //             : Colors.white, // اللون العادي
                      //         shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(12),
                      //           side: BorderSide(
                      //             color: isSelected
                      //                 ? AppColor.DeepPurple
                      //                 : Colors.grey.withOpacity(0.3),
                      //             width: 1.5,
                      //           ),
                      //         ),
                      //         elevation: isSelected ? 4 : 1, // ظل بسيط للخيار المحدد
                      //         child: ListTile(
                      //           onTap: () {
                      //             controller.itemChange(options[ind], index);
                      //           },
                      //           leading: CircleAvatar(
                      //             radius: 14,
                      //             backgroundColor:
                      //             isSelected ? AppColor.DeepPurple : Colors.grey[300],
                      //             child: isSelected
                      //                 ? const Icon(Icons.check, color: Colors.white, size: 16)
                      //                 : Text(
                      //               optionLabel,
                      //               style: const TextStyle(
                      //                 color: Colors.black,
                      //                 fontWeight: FontWeight.bold,
                      //               ),
                      //             ),
                      //           ),
                      //           title: Text(
                      //             options[ind],
                      //             textAlign: TextAlign.right,
                      //             style: TextStyle(
                      //               fontSize: 16,
                      //               color: isSelected
                      //                   ? AppColor.DeepPurple
                      //                   : Colors.black, // تغيّر لون النص عند الاختيار
                      //               fontWeight: isSelected
                      //                   ? FontWeight.w600
                      //                   : FontWeight.normal, // زيادة سماكة النص عند التحديد
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     );
                      //
                      //     // return Container(
                      //     //   margin: const EdgeInsets.symmetric(vertical: 6),
                      //     //   child: Card(
                      //     //     shape: RoundedRectangleBorder(
                      //     //       borderRadius: BorderRadius.circular(12),
                      //     //       side: BorderSide(
                      //     //         color: isSelected
                      //     //             ? AppColor.DeepPurple
                      //     //             : Colors.grey.withOpacity(0.3),
                      //     //         width: 1.5,
                      //     //       ),
                      //     //     ),
                      //     //     child: ListTile(
                      //     //       onTap: () {
                      //     //         controller.itemChange(options[ind], index);
                      //     //       },
                      //     //       leading: CircleAvatar(
                      //     //         radius: 14,
                      //     //         backgroundColor: isSelected
                      //     //             ? AppColor.DeepPurple
                      //     //             : Colors.grey[300],
                      //     //         child: isSelected
                      //     //             ? const Icon(Icons.check,
                      //     //             color: Colors.white, size: 16)
                      //     //             : Text(
                      //     //           optionLabel,
                      //     //           style: const TextStyle(
                      //     //             color: Colors.black,
                      //     //             fontWeight: FontWeight.bold,
                      //     //           ),
                      //     //         ),
                      //     //       ),
                      //     //       title: Text(
                      //     //         options[ind],
                      //     //         textAlign: TextAlign.right,
                      //     //         style: const TextStyle(fontSize: 16),
                      //     //       ),
                      //     //     ),
                      //     //   ),
                      //     // );
                      //   },
                      // )
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: options.length,
                        itemBuilder: (context, ind) {
                          final optionLabel = String.fromCharCode(
                            65 + ind,
                          ); // A, B, C...

                          return Obx(() {
                            final isSelected =
                                controller.check[index]()[options[ind]] ??
                                false;

                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: Card(
                                color: isSelected
                                    ? AppColor.DeepPurple2
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: isSelected
                                        ? AppColor.DeepPurple
                                        : Colors.grey.withOpacity(0.3),
                                    width: 1.5,
                                  ),
                                ),
                                elevation: isSelected ? 4 : 1,
                                child: ListTile(
                                  onTap: () {
                                    controller.itemChange(options[ind], index);
                                  },
                                  leading: CircleAvatar(
                                    radius: 14,
                                    backgroundColor: isSelected
                                        ? AppColor.DeepPurple
                                        : Colors.grey[300],
                                    child: isSelected
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 16,
                                          )
                                        : Text(
                                            optionLabel,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                  title: Text(
                                    options[ind],
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: isSelected
                                          ? AppColor.DeepPurple
                                          : Colors.black,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                    ),
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
                        maxLines: 8,
                        decoration: InputDecoration(
                          hintText: "أدخل الجواب",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: AppColor.DeepPurple,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: AppColor.DeepPurple,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // أزرار السابق / التالي / إنهاء الامتحان
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (index == controller.questionlist.length - 1)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: AppColor.SecondryColor,
                        padding: EdgeInsets.symmetric(
                          vertical: responsiveValue(
                            context: context,
                            mobile: 12,
                            tablet: 20,
                          ),
                          horizontal: responsiveValue(
                            context: context,
                            mobile: 20,
                            tablet: 40,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        controller.submit();
                      },
                      child: const Text(
                        'إنهاء ',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.BackGround2,
                      padding: EdgeInsets.symmetric(
                        vertical: responsiveValue(
                          context: context,
                          mobile: 12,
                          tablet: 20,
                        ),
                        horizontal: responsiveValue(
                          context: context,
                          mobile: 20,
                          tablet: 40,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: index == 0 ? null : controller.previousQuestion,
                    child: Text(
                      'السابق',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  if (index < controller.questionlist.length - 1)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: responsiveValue(
                            context: context,
                            mobile: 12,
                            tablet: 20,
                          ),
                          horizontal: responsiveValue(
                            context: context,
                            mobile: 20,
                            tablet: 40,
                          ),
                        ),
                        foregroundColor: Colors.white,
                        backgroundColor: AppColor.SecondryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: index == controller.questionlist.length - 1
                          ? null
                          : controller.nextQuestion,
                      child: const Text(
                        'التالي',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSectionContent(int index) {
    final section = controller.questionlist[index].section!;
    switch (section.type) {
      case 0: // نص
        return [
          SizedBox(
            height: 100,
            child: Scrollbar(
              controller: yourScrollController,
              radius: const Radius.circular(8),
              thickness: 6,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: yourScrollController,
                child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Text(
                    section.content.toString(),
                    textAlign:
                        controller.questionlist[index].lesson!.isEnglish == '1'
                        ? TextAlign.left
                        : TextAlign.right,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ];
      case 2: // صوت
        return [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColor.BackGround2,
                child: IconButton(
                  icon: Icon(
                    controller.isplaying[index] ? Icons.stop : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    if (controller.isplaying[index]) {
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
              ),
              Obx(
                () => Expanded(
                  child: Slider(
                    activeColor: AppColor.BackGround2,
                    inactiveColor: Colors.grey,
                    value: double.parse(controller.positions[index].toString()),
                    min: 0,
                    max: double.parse(controller.durations[index].toString()),
                    onChanged: (value) async {
                      controller.positions()[index] = value;
                      await controller.player.seek(
                        Duration(milliseconds: value.toInt()),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ];
      case 3: // صورة
        return [
          SizedBox(
            height: 250,
            child: Image.network(
              AppLink.image + section.content.toString(),
              fit: BoxFit.contain,
            ),
          ),
        ];
      default:
        return [];
    }
  }
}
