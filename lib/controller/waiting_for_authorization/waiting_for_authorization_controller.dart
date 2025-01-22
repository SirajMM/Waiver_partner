import 'package:get/get.dart';
import 'package:waiver_driver/backend/parser/WaitingForAuthorization/waitingforauthorization_parser.dart';

// class WaitingForAuthorizationControllerBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut(() => WaitingForAuthorizationController());
//   }
// }

class WaitingForAuthorizationController extends GetxController {
  WaitingForAuthorizationParser parser;
  WaitingForAuthorizationController({required this.parser});
  static WaitingForAuthorizationController get to => Get.find();
}
