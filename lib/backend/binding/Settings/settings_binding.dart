import 'package:get/get.dart';
import 'package:waiver_driver/controller/setting/setting_controller.dart';

class SettingScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SettingController(parser: Get.find()));
  }
}
