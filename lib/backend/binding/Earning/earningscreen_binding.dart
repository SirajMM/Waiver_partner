import 'package:get/get.dart';
import 'package:waiver_driver/controller/earning/earning_controller.dart';

class EarningscreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EarningController(parser: Get.find()));
  }
}