import 'package:get/get.dart';
import 'package:waiver_driver/controller/setting/setting_controller.dart';

import '../../api/api_services/api_services.dart';
import '../../api/api_services/urls.dart';

class SettingScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiServices(appBaseUrl: AppUrls.base));
    Get.put(SettingController(parser: Get.find()));
  }
}
