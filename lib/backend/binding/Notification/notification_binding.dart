import 'package:get/get.dart';
import 'package:waiver_driver/controller/notification/notification_controller.dart';

import '../../api/api_services/api_services.dart';
import '../../api/api_services/urls.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiServices(appBaseUrl: AppUrls.base));
    Get.put(NotificationController(parser: Get.find()));
  }
}
