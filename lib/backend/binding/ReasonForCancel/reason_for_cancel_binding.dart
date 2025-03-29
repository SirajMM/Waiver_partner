import 'package:get/get.dart';
import 'package:waiver_driver/controller/reason_for_cancel/reason_for_cancel_controller.dart';

import '../../api/api_services/api_services.dart';
import '../../api/api_services/urls.dart';

class ReasonForCancelBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiServices(appBaseUrl: AppUrls.base));
    Get.put(ReasonForCancelController(parser: Get.find()));
  }
}
