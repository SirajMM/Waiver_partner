import 'package:get/get.dart';

class WaitingForAuthorizationControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WaitingForAuthorizationController());
  }
}

class WaitingForAuthorizationController extends GetxController {
  static WaitingForAuthorizationController get to => Get.find();
}
