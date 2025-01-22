import 'package:get/get.dart';
import 'package:waiver_driver/controller/waiting_for_authorization/waiting_for_authorization_controller.dart';

class WaitingForAuthorizationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WaitingForAuthorizationController(parser: Get.find()));
  }
}