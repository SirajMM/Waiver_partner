import 'package:get/get.dart';
import 'package:waiver_driver/controller/home/home_controller.dart';

import '../../../controller/profile/profile_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(() => HomeController(parser: Get.find()), permanent: true);
    Get.put(ProfileController(parser: Get.find()));
  }
}
