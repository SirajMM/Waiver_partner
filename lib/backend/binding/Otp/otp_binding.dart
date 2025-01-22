
import 'package:get/get.dart';
import 'package:waiver_driver/controller/otp/otp_controller.dart';

class OtpBinging extends Bindings {
  @override
  void dependencies() {
    Get.put(OtpController(parser: Get.find()));
  }
}