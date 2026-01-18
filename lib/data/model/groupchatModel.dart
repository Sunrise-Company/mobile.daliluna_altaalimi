import 'package:get/get.dart';

class ChatGroup {
  String id;
  String name;
  String lastMessage;
  String lastMessageTime;
  List<Student> members;
  RxList<Message> messages;

  ChatGroup({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.members,
    List<Message>? messages,
  }) : messages = (messages ?? []).obs;

  void addMessage(Message message) {
    messages.add(message);
    lastMessage = message.text;
    lastMessageTime = message.timestamp;
  }
}

class Student {
  String id;
  String name;
  String avatarUrl;

  Student({required this.id, required this.name, required this.avatarUrl});
}

class Message {
  String id;
  String senderId;
  String senderName;
  String text;
  String timestamp;

  Message({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.timestamp,
  });
}
