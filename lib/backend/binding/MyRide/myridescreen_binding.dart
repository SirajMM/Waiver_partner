import 'package:get/get.dart';
import 'package:waiver_driver/controller/my_rides/my_rides_controller.dart';

class MyrideScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MyRidesController(parser: Get.find()));
  }
}