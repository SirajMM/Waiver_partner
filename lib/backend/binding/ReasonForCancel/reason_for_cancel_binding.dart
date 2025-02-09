import 'package:get/get.dart';
import 'package:waiver_driver/controller/reason_for_cancel/reason_for_cancel_controller.dart';

class ReasonForCancelBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ReasonForCancelController(parser: Get.find()));
  }
}