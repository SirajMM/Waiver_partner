import 'package:get/get.dart';
import 'package:waiver_driver/controller/fleet_home_page/fleet_home_page_controller.dart';

class FleetHomePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FleetHomePageController(parser: Get.find()));
  }
}