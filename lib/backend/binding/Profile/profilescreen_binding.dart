import 'package:get/get.dart';
import 'package:waiver_driver/controller/profile/profile_controller.dart';

class ProfilescreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProfileController(parser: Get.find()));
  }
}