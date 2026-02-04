import 'package:daliluna_altaalimi/data/model/comment_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:daliluna_altaalimi/core/constant/color.dart';

import 'package:daliluna_altaalimi/controller/comment_controller.dart';
import 'package:shimmer/shimmer.dart';

class CommentsWidget extends StatelessWidget {
  final String lessonId;
  final String type;
  const CommentsWidget({Key? key, required this.lessonId, required this.type})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CommentController controller = Get.put(
      CommentController(lessonId: lessonId, type: type),
      tag: lessonId,
    );
    timeago.setLocaleMessages('ar', timeago.ArMessages());

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: _buildHeader(controller),
          ),
          Divider(height: 1, color: Colors.grey.shade300),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return _buildLoadingShimmer();
                }
                // if (controller.error.isNotEmpty) {
                //   return Center(child: Text(controller.error.value));
                // }

                return RefreshIndicator(
                  onRefresh: () async {
                    controller.fetchComments(type);
                  },
                  child: controller.commentsList.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          controller: controller.scrollController,
                          padding: const EdgeInsets.only(
                            top: 16.0,
                            bottom: 16.0,
                          ),
                          itemCount: controller.commentsList.length,
                          itemBuilder: (context, index) {
                            final comment = controller.commentsList[index];
                            return _buildCommentItem(comment, controller);
                          },
                        ),
                );
              }),
            ),
          ),
          Obx(() {
            if (controller.isLoading.value) return SizedBox.shrink();
            return controller.isTeacher.value
                ? SizedBox.shrink()
                : _buildCommentInputField(controller);
          }),
        ],
      ),
    );
  }

  Widget _buildHeader(CommentController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "التعليقات",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColor.PrimaryColor,
          ),
        ),
        Obx(
          () => Text(
            "${controller.commentsList.length} تعليقات",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(radius: 22, backgroundColor: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 100, height: 14, color: Colors.white),
                    SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      height: 12,
                      color: Colors.white,
                    ),
                    SizedBox(height: 4),
                    Container(width: 200, height: 12, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.comment_bank_outlined,
              size: 70,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 16),
            Text(
              'لا توجد تعليقات بعد',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'كن أول من يشارك برأيه!',
              style: TextStyle(fontSize: 15, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentItem(Comment comment, CommentController controller) {
    bool isCurrentUser = controller.studentId == comment.userId.toString();
    return Container(
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? AppColor.PrimaryColor.withOpacity(0.05)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: isCurrentUser
                ? AppColor.PrimaryColor
                : AppColor.SecondryColor.withOpacity(0.8),
            child: Text(
              comment.userName.isNotEmpty ? comment.userName[0] : 'U',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.userName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  comment.commentText,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.75),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  timeago.format(comment.createdAt, locale: 'ar'),
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
          if (isCurrentUser)
            IconButton(
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
              onPressed: () => controller.confirmDelete(comment),
            ),
        ],
      ),
    );
  }

  Widget _buildCommentInputField(CommentController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.commentInputController,
                readOnly: !controller.isUserLoggedIn,
                onTap: controller.handleTextFieldTap,
                decoration: InputDecoration(
                  hintText: controller.isUserLoggedIn
                      ? 'أضف تعليقاً...'
                      : 'سجل دخول كطالب لإضافة تعليق',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            IconButton(
              style: IconButton.styleFrom(
                backgroundColor: AppColor.PrimaryColor,
                shape: CircleBorder(),
                padding: EdgeInsets.all(12),
              ),
              icon: Icon(Icons.send, color: Colors.white),
              onPressed: controller.handleSendButton,
            ),
          ],
        ),
      ),
    );
  }
}
