import 'package:get/get.dart';
import 'package:waiver_driver/controller/home/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController(parser: Get.find()));
  }
}