import 'package:get/get.dart';
import 'package:daliluna_altaalimi/controller/pdfs_controller.dart';

class PdfsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PdfsController());
  }
}
