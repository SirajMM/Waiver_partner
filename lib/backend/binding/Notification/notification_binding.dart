import 'package:get/get.dart';
import 'package:waiver_driver/controller/notification/notification_controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NotificationController(parser: Get.find()));
  }
}