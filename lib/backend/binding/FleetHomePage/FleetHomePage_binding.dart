import 'package:get/get.dart';
import 'package:waiver_driver/backend/api/api_services/urls.dart';
import 'package:waiver_driver/controller/fleet_home_page/fleet_home_page_controller.dart';

import '../../api/api_services/api_services.dart';

class FleetHomePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=>ApiServices(appBaseUrl: AppUrls.base));
    Get.lazyPut(() => FleetHomePageController(parser: Get.find()));
  }
}