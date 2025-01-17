import 'package:get/get.dart';

class VehicleProofControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VehicleProofController());
  }
}

class VehicleProofController extends GetxController {
  static VehicleProofController get to => Get.find();
}
