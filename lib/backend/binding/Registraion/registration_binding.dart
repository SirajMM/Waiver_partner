import 'package:get/get.dart';
import 'package:waiver_driver/controller/registration/registration_controller.dart';

class RegistrationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RegistrationController(parser: Get.find()));
  }
}