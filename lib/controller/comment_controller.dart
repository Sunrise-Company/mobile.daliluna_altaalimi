import 'dart:convert';
import 'dart:developer';

import 'package:daliluna_altaalimi/linkapi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:daliluna_altaalimi/data/model/comment_model.dart';
import 'package:daliluna_altaalimi/core/constant/routes.dart';

class CommentController extends GetxController {
  final String lessonId;
  CommentController({required this.lessonId, required this.type});

  var isLoading = true.obs;
  var commentsList = <Comment>[].obs;
  var error = ''.obs;
  late ScrollController scrollController;
  late TextEditingController commentInputController;
  SharedPreferences? prefs;
  String? studentId;
  bool isUserLoggedIn = false;
  String type = '';
  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();

    commentInputController = TextEditingController();
    _loadUserDataAndFetchComments();
  }

  @override
  void onClose() {
    commentInputController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  Future<void> _loadUserDataAndFetchComments() async {
    prefs = await SharedPreferences.getInstance();
    studentId = prefs!.getString('student_id');
    isUserLoggedIn = prefs!.getBool('isLogin') ?? false;
    await fetchComments(type);
  }

  Future<void> fetchComments(type) async {
    final bool isInitialLoad = commentsList.isEmpty;

    try {
      if (isInitialLoad) {
        isLoading(true);
      }
      error('');
      final response = await http.get(
        Uri.parse('${AppLink.baseUrl}/api/app_comment/$lessonId/$type'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      log(
        "Fetch Response: ${AppLink.baseUrl}/api/app_comment/$lessonId/$type ${response.body}",
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final List commentsJson = data['comments'];
        var fetchedComments = commentsJson
            .map((json) => Comment.fromJson(json))
            .toList();

        fetchedComments.sort((a, b) => a.createdAt.compareTo(b.createdAt));

        commentsList.assignAll(fetchedComments);

        if (isInitialLoad && commentsList.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (scrollController.hasClients) {
              scrollController.jumpTo(
                scrollController.position.maxScrollExtent,
              );
            }
          });
        }
      } else {
        throw Exception('Failed to load comments');
      }
    } catch (e) {
      error('لا يوجد تعليقات بعد');
    } finally {
      isLoading(false);
    }
  }

  Future<void> _addComment() async {
    if (commentInputController.text.isEmpty) return;
    final commentText = commentInputController.text;
    commentInputController.clear();
    type.toString() == 'lesson_lecture_file'
        ? 'lesson_lecture_files_id'
        : 'lesson_dep_file_id';
    try {
      final response = await http.post(
        Uri.parse('${AppLink.baseUrl}/api/app_comment_store/store'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode({
          '${type.toString() == 'lesson_lecture_file' ? 'lesson_lecture_files_id' : 'lesson_dep_file_id'}':
              '$lessonId',
          'comment_text': '$commentText',
          'user_id': '$studentId',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);

        final newComment = Comment.fromJson({
          'id': responseData['comment']['id'],
          'user_id': responseData['comment']['user_id'],
          'comment_text': responseData['comment']['comment_text'],
          'created_at': responseData['comment']['created_at'],
          'user': {'arabic_name': 'أنت'},
        });

        commentsList.add(newComment);

        if (scrollController.hasClients) {
          Future.delayed(const Duration(milliseconds: 100), () {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          });
        }

        // Get.snackbar(
        //   'نجاح',
        //   'تم إرسال تعليقك بنجاح',
        //   backgroundColor: Colors.green,
        //   colorText: Colors.white,
        // );
      } else {
        commentInputController.text = commentText;
        throw Exception('Server error: ${response.body}');
      }
    } catch (e, stack) {
      commentInputController.text = commentText;
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء إرسال التعليق',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _deleteComment(Comment comment) async {
    try {
      final response = await http.delete(
        Uri.parse('${AppLink.baseUrl}/api/app_comment_delete/${comment.id}'),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        commentsList.removeWhere((c) => c.id == comment.id);
        Get.snackbar(
          'نجاح',
          'تم حذف تعليقك بنجاح',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw Exception('Failed to delete comment');
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء حذف التعليق',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void handleSendButton() {
    if (!isUserLoggedIn) {
      Get.toNamed(AppRoute.login);
    } else {
      _addComment();
    }
  }

  void handleTextFieldTap() {
    if (!isUserLoggedIn) {
      FocusManager.instance.primaryFocus?.unfocus();
      Get.toNamed(AppRoute.login);
    }
  }

  void confirmDelete(Comment comment) async {
    final shouldDelete = await Get.defaultDialog<bool>(
      title: "تأكيد الحذف",
      titleStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.black87,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange.shade600,
            size: 50,
          ),
          SizedBox(height: 16),
          Text(
            "هل أنت متأكد أنك تريد حذف هذا التعليق؟\nلا يمكن التراجع عن هذا الإجراء.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
        ],
      ),
      cancel: OutlinedButton(
        onPressed: () => Get.back(result: false),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black87,
          side: BorderSide(color: Colors.grey.shade400),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text("إلغاء"),
        ),
      ),
      confirm: ElevatedButton(
        onPressed: () => Get.back(result: true),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text("نعم، قم بالحذف"),
        ),
      ),
      radius: 15.0,
    );

    if (shouldDelete == true) {
      _deleteComment(comment);
    }
  }
}
