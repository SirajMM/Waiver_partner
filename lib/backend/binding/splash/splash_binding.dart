import 'package:get/get.dart';
import 'package:waiver_driver/controller/splash/splash_controller.dart';

import '../../../controller/Connectivity/network_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SplashController>(SplashController());
    Get.put<NetworkController>(NetworkController(), permanent: true);
  }
}
