import 'package:get/get.dart';
import 'package:waiver_driver/controller/profile/profile_controller.dart';

import '../../api/api_services/api_services.dart';
import '../../api/api_services/urls.dart';

class ProfilescreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiServices(appBaseUrl: AppUrls.base));
    Get.put(ProfileController(parser: Get.find()));
  }
}
