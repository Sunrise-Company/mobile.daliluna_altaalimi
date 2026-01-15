import 'package:get/get.dart';

import '../../../data/model/groupchatModel.dart';

class chatListGroupController extends GetxController {
  var groups = <ChatGroup>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with some sample groups
    groups.addAll([
      ChatGroup(
        id: '1',
        name: 'رياضيات',
        lastMessage: 'مرحبا بالجميع!',
        lastMessageTime: '18:00 AM',
        members: [
          Student(
            name: 'خالد محمود',
            avatarUrl: 'assets/images/teacher2.jpg',
            id: '',
          ),
          Student(
            name: 'أحمد القيش',
            avatarUrl: 'assets/images/teacher.jpg',
            id: '',
          ),
          Student(
            name: 'جوليا الأسعد',
            avatarUrl: 'assets/images/teacher3.jpg',
            id: '',
          ),
        ],
      ),

      ChatGroup(
        id: '1',
        name: 'اللغة العربية',
        lastMessage: 'مرحبا بالجميع!',
        lastMessageTime: '18:00 AM',
        members: [
          Student(
            name: 'خالد محمود',
            avatarUrl: 'assets/images/teacher2.jpg',
            id: '',
          ),
          Student(
            name: 'أحمد القيش',
            avatarUrl: 'assets/images/teacher.jpg',
            id: '',
          ),
          Student(
            name: 'جوليا الأسعد',
            avatarUrl: 'assets/images/teacher3.jpg',
            id: '',
          ),
        ],
      ),
      // Add more sample groups as needed
    ]);
  }

  void addGroup(ChatGroup group) {
    groups.add(group);
  }

  void removeGroup(String groupId) {
    groups.removeWhere((group) => group.id == groupId);
  }
}
