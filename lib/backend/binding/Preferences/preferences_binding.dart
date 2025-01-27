import 'package:get/get.dart';
import 'package:waiver_driver/controller/preferences/preferences_controller.dart';

class PreferencesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PreferencesController(parser: Get.find()));
  }
}