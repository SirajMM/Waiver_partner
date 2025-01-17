import 'package:get/get.dart';
import 'package:waiver_driver/controller/sign_in/sign_in_controller.dart';

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SignInController(parser: Get.find()));
  }
}
