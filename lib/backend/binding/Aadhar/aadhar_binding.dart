import 'package:get/get.dart';
import 'package:waiver_driver/controller/aadhar_card/aadhar_card_controller.dart';

class AadharBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AadharCardController(parser: Get.find()));
  }
}