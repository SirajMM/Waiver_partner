import 'package:get/get.dart';
import 'package:waiver_driver/controller/view_bank_account/view_bank_account_controller.dart';

class ViewBankAccountScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ViewBankAccountController(parser: Get.find()));
  }
}