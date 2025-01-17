import 'package:get/get.dart';
import 'package:waiver_driver/controller/driver_type_selection/driver_type_selection_controller.dart';


class DriverTypeSelectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DriverTypeSelectionController());
  }
}