import 'package:get/get.dart';

class ReceiptControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReceiptController());
  }
}

class ReceiptController extends GetxController {
  static ReceiptController get to => Get.find();
}
