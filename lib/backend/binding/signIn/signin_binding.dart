import 'package:get/get.dart';
import 'package:waiver_driver/controller/sign_in/sign_in_controller.dart';
import '../../api/api_services/api_services.dart';
import '../../api/api_services/urls.dart';

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiServices(appBaseUrl: AppUrls.base));
    Get.lazyPut(() => SignInController(parser: Get.find()));
  }
}
