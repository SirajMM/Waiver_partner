import 'package:get/get.dart';
import 'package:waiver_driver/controller/rating/rating_controller.dart';


class RatingscreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RatingController(parser: Get.find()));
  }
}