import 'package:get/get.dart';
import 'package:waiver_driver/controller/login/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController(parser: Get.find()));
  }
}