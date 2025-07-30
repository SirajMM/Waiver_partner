import 'package:get/get.dart';
import 'package:waiver_driver/controller/login/login_controller.dart';

import '../../api/api_services/api_services.dart';
import '../../api/api_services/urls.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiServices(appBaseUrl: AppUrls.base));
    Get.lazyPut(() => LoginController(parser: Get.find()));
  }
}