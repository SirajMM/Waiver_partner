import 'package:get/get.dart';
import 'package:waiver_driver/controller/home/home_controller.dart';

import '../../../controller/profile/profile_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProfileController(parser: Get.find()));
    Get.lazyPut(() => HomeController(parser: Get.find()));
  }
}