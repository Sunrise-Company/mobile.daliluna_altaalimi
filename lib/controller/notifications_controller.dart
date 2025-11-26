import 'package:get/get.dart';
import 'package:daliluna_altaalimi/core/services/apiservices.dart';

class NotificationsController extends GetxController {
  @override
  void onInit() async {
    await fetchNotifications();

    super.onInit();
  }

  List<dynamic> dataList = [].obs;
  RxList<dynamic> notfs = [].obs;
  RxBool isLoading = false.obs;
  fetchNotifications() async {
    try {
      print('ooooooooooooooooooooo');
      dataList = await ApiService.fetchNotifications();
      dataList.forEach((element) {
        notfs.add(element);
      });
      isLoading.value = true;
      print(notfs);
      print('---------------');
      return notfs;
    } catch (error) {
      print('Error fetching classes: $error');
    }
  }
}
