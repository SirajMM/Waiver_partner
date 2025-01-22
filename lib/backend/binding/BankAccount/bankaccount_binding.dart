import 'package:get/get.dart';
import 'package:waiver_driver/controller/bank_account/bank_account_controller.dart';

class BankaccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BankAccountController(parser: Get.find()));
  }
}