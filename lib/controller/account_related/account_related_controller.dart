import 'package:get/get.dart';

class AccountRelatedControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AccountRelatedController());
  }
}

class AccountRelatedController extends GetxController {
  static AccountRelatedController get to => Get.find();
}
