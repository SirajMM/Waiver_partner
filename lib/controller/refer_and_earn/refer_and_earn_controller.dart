import 'package:get/get.dart';

class ReferAndEarnControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReferAndEarnController());
  }
}

class ReferAndEarnController extends GetxController {
  static ReferAndEarnController get to => Get.find();
}
