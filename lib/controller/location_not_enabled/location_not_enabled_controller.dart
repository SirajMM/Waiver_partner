import 'package:get/get.dart';

class LocationNotEnabledControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LocationNotEnabledController());
  }
}

class LocationNotEnabledController extends GetxController {
  static LocationNotEnabledController get to => Get.find();
}
