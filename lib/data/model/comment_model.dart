import 'dart:convert';

import 'dart:convert';

// Your Comment class is correct!
class Comment {
  final int id;
  final int userId;
  final String commentText;
  final DateTime createdAt;
  final String userName;

  Comment({
    required this.id,
    required this.userId,
    required this.commentText,
    required this.createdAt,
    required this.userName,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] == null
          ? 0
          : (json['id'] is int ? json['id'] : int.parse(json['id'].toString())),
      userId: json['user_id'] == null
          ? 0
          : (json['user_id'] is int
              ? json['user_id']
              : int.parse(json['user_id'].toString())),
      commentText: json['comment_text'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      userName: json['user'] != null
          ? json['user']['arabic_name']
          : 'مستخدم غير معروف',
    );
  }
}
