import 'dart:collection';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/model/answeModle.dart';
import '../../data/model/audioModel.dart';
import '../../data/model/submitModel.dart';
import '../../data/model/testModel.dart';
import '../../linkapi.dart';
import '../../view/screen/exam/startexam.dart';
import 'mainEamController.dart';

class StartExamControllerss extends GetxController {
  PageController pageController = PageController(initialPage: 0);
  AudioPlayer player = AudioPlayer();
  var activePage = 0.obs;
  var isload = false.obs;
  var issubmit = false.obs;
  TestModel testmodel = new TestModel();
  var check = [].obs;
  var questionlist = <Questions>[].obs;
  var answerlist = <AnswerModel>[].obs;
  var audioList = <AudioModel>[].obs;
  var isplaying = [].obs;
  var positions = [].obs;
  var durations = [].obs;
  var type;
  var usertype;
  var isConnection = true.obs;
  RxBool isloded = false.obs;

  final List<Widget> pages = [];
  final List<Submit> answer = [];
  late int duration = 0;
  Map<String, List<String>> transformSubmitListToMap(List<Submit> submits) {
    Map<String, List<String>> result = {};

    for (var submit in submits) {
      result[submit.id] = submit.answer;
    }

    return result;
  }

  @override
  void onInit() {
    fetchquiz();
    // player.onAudioPositionChanged.listen((newPosition) {
    //   print(activePage.value);
    //   positions()[activePage.value] = newPosition.inMilliseconds;
    //   positions.refresh();
    // });

    super.onInit();
  }

  @override
  void dispose() {
    player.dispose();
    player.release();
    super.dispose();
  }

  void previousQuestion() {
    if (activePage.value > 0) {
      activePage.value--;
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  void nextQuestion() {
    if (activePage.value < questionlist.length - 1) {
      activePage.value++;
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  itemChange(String key, int index) {
    print(check[index]()[key].toString());
    check.refresh();
    check[index]()[key] == true
        ? check[index]()[key] = false
        : check[index]()[key] = true;

    check.refresh();

    update();
  }

  submit() async {
    try {
      issubmit(true);

      for (int i = 0; i < check.length; i++) {
        // print(questionlist[i].quesType);
        if (questionlist[i].quesType == 1) {
          int k =
              jsonDecode(questionlist[i].option!.myOptions.toString()).length;
          final List<String> list = [];
          for (int j = 0; j < k; j++) {
            if (check[i]()[jsonDecode(
                    questionlist[i].option!.myOptions.toString())[j]] ==
                true) {
              list.add(
                  jsonDecode(questionlist[i].option!.myOptions.toString())[j]);
            }
          }

          Submit w = Submit(id: questionlist[i].id.toString(), answer: list);
          answer.add(w);
        }
        // ignore: unused_local_variable
        var res = jsonEncode(answer);
        print("-----------------------------------");
        // print(jsonDecode(res)[0]['id']);
      }

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var res;
      String? student_id = localStorage.getString('student_id');

      print(jsonEncode(answer));
      print(Get.arguments['id']);
      print("answerrrrrrrrr$answer");
      // print(localStorage.getString('student_id').toString());
      Map<String, List<String>> transformedData =
          transformSubmitListToMap(answer);

      // print("امتحانات");
      print(student_id.toString());
      res = await http.post(
          Uri.parse(AppLink.server + "/dashboard/student/main_exam/submit"),
          body: {
            "student_id": student_id.toString(),
            "content_id": Get.arguments['id'].toString(),
            'answer': jsonEncode(transformedData)
          });
      print(jsonEncode(transformedData));
      print(res.statusCode);

      print(AppLink.server + "/dashboard/student/main_exam/submit");
      var body = json.decode(res.body);
      print(body);
      print(res.statusCode);

      print(Get.arguments['id'].toString());
      if (body['status'] == 1) {
        issubmit(false);
        Get.snackbar('', '',
            titleText: Text(
              'تم الارسال  بنجاح',
              style: TextStyle(
                  // color: AppColor.DeepPurple,
                  ),
              textAlign: TextAlign.right,
            ));
        // isload(true);
        isloded.value = false;
        fetchquiz();
        // Get.close(3);
        MainExamControllerss controllerss = Get.put(MainExamControllerss());
        controllerss.dataListExam.value = [];
        controllerss.isloded.value = false;
        controllerss.MainExam();
        Get.toNamed(
          '/homepage',
        );
        // Get.close(3);
      } else if (body['status'] == 5) {
        issubmit(false);

        Get.snackbar('', '',
            titleText: Text(
              'لا يمكن التقديم مرتين',
              style: TextStyle(
                  // color: AppColor.DeepPurple,
                  ),
              textAlign: TextAlign.right,
            ));
        // Get.close(3);
      } else if (body['status'] == 6) {
        issubmit(false);

        Get.snackbar('', '',
            titleText: Text(
              "انتهى الوقت",
              style: TextStyle(
                  // color: AppColor.DeepPurple,
                  ),
              textAlign: TextAlign.right,
            ));
        // Get.close(3);
      } else {
        issubmit(false);

        Get.snackbar("خطأ", " لم يتم الارسال ");

        // Get.close(3);
      }
    } catch (e) {
      print(e);
    }
  }

  fetchquiz() async {
    // isload(true);
    isloded.value = false;

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? student_id = localStorage.getString('student_id');
    // usertype = localStorage.get('type');
    print("uuuuuuser");
    print(usertype);
    var examid = Get.arguments['id'];
    type = Get.arguments['type'];

    var respons;
    print(student_id);
    print(examid);

    print("الامتحانات");
    respons = await http.get(Uri.parse(AppLink.server +
        "/dashboard/student/main_exam/start/" +
        examid.toString() +
        "/" +
        student_id.toString()));
    // }
    print('' +
        "dashboard/student/main_exam/start/" +
        examid.toString() +
        "/" +
        student_id.toString());
    print(respons.body);
    print(respons.statusCode);

    print("/////////");
    var body = json.decode(respons.body);
    if (respons.statusCode == 200) {
      isloded.value = true;
      print(isload);
      if (body['status'] == 0) {
        // Get.back();
        Get.back();

        Get.snackbar("لا يمكن التقديم", 'لم يتم اضافة الاسئلة ');
// Get.toNamed('/homepage');

        return;
      } else if (body['status'].toString() == '6') {
        Get.back();
        // Get.back();

        Get.snackbar("لا يمكن التقديم", 'لقد انتهى وقتك للتقديم');
// Get.toNamed(ظ'/homepage');
        // return;
      }

      testmodel = TestModel.fromJson(body);
      questionlist(testmodel.questions);
      duration =
          ((int.parse(testmodel.exam_period.toString()) * 60 - 10)).toInt();
      print("///////////*****/");
      print(duration);

      for (int i = 0; i < questionlist.length; i++) {
        print(i);
        AnswerModel answerModel = new AnswerModel();
        AudioModel audioModel = new AudioModel();
        answerModel.questionid = questionlist[i].id;
        var iaplay$i = false.obs;
        var position$i = 0;
        var duration$i = 100;
        durations.add(duration$i);

        answerModel.answer = [];
        if (questionlist[i].section != null) {
          if (questionlist[i].section!.type == 2) {
            audioModel.url = questionlist[i].section!.content.toString();

            player.onDurationChanged.listen((Duration d) {
              durations()[i] = d.inMilliseconds;
              durations.refresh;
              print(durations[i]);
            });
          } else {
            audioModel.duration = 0;
            audioModel.url = "";
          }
        } else {
          audioModel.duration = 0;
          audioModel.url = "";
        }
        audioList.add(audioModel);
        answerlist.add(answerModel);
        isplaying.add(iaplay$i);
        positions.add(position$i);

        print(questionlist[i].quesType);
        if (questionlist[i].quesType == 1) {
          print("مؤتمت");
          //اتمتة
          var check$i = HashMap().obs;
          for (int j = 0;
              j <
                  jsonDecode(questionlist[i].option!.myOptions.toString())
                      .length;
              j++) {
            // print(
            //     jsonDecode(questionlist[i].option!.myOptions.toString()).length);
            // print(jsonDecode(questionlist[i].option!.myOptions.toString())[j]
            //     .toString());
            // print('this is the content ');
            // print(questionlist[i].section!.title);
            // print(questionlist[i].section!.type);
            check$i()[
                jsonDecode(questionlist[i].option!.myOptions.toString())[j]
                    .toString()] = false;
          }
          check.add(check$i);
          int checkl = check.length - 1;

          pages.add(StartExam(type: 1, index: i, ckechid: checkl));
        } else {
          print("غير مؤتمت");
          var check$i = HashMap().obs;
          check$i()["answer$i"] = " ";
          check.add(check$i);
          pages.add(StartExam(type: 2, index: i, ckechid: 0));
        }
      }
    } else {
      print("oooo");
    }
    isload(false);
  }
}
