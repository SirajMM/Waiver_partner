import 'package:get/get.dart';
import 'package:waiver_driver/controller/rating/rating_controller.dart';
import 'package:waiver_driver/controller/registration/registration_controller.dart';

class RatingscreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RatingController(parser: Get.find()));
  }
}