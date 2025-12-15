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
      dataList = await ApiService.fetchNotifications();
      dataList.forEach((element) {
        notfs.add(element);
      });
      isLoading.value = true;

      return notfs;
    } catch (error) {}
  }
}
