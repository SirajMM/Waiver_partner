import 'package:get/get.dart';

class FleetRegistrationControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FleetRegistrationController());
  }
}

class FleetRegistrationController extends GetxController {
  static FleetRegistrationController get to => Get.find();
}
