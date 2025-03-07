import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waiver_driver/backend/model/home/home_model.dart';
import 'package:waiver_driver/backend/model/reason_for_cancel/reason_for_cancel_model.dart';
import 'package:waiver_driver/backend/parser/ReasonForCancel/reason_for_cancel_parser.dart';
import 'package:waiver_driver/core/widgets/snackbar/snackbar.dart';

import '../../backend/api/api_services/api_services.dart';
import '../../backend/api/api_services/urls.dart';
import '../../core/constants/enums/enums.dart';
import '../../core/constants/get_storage_constants.dart';
import '../../helper/router/app_routes/app_routes.dart';

import '../home/home_controller.dart';

// class ReasonForCancelControllerBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut(() => ReasonForCancelController());
//   }
// }

class ReasonForCancelController extends GetxController {
  static ReasonForCancelController get to => Get.find();
  // fGet.put(ApiServices())" or "Get.lazyPut(()=>ApiServices())
  ReasonForCancelParser parser;
  ReasonForCancelController({required this.parser});

  @override
  Future<void> onInit() async {
    super.onInit();
    Get.put(ApiServices(appBaseUrl: AppUrls.base));

    try {
      isLoading.value = true;
      rideID = Get.arguments;
      await getReasonForCancel();
      isError.value = false;
    } catch (error) {
      isError.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  String? rideID;
  RxBool isLoading = false.obs;
  RxBool isError = false.obs;

  getReasonForCancel() async {
    var response = await ApiServices.reasonForCancel();
    reasons = response.data;
  }

  List<ReasonForCancel>? reasons = [];

  Rx<ReasonForCancel?> selectedReasonForCancel = Rx<ReasonForCancel?>(null);
  cancelRide() async {
    if (selectedReasonForCancel.value == null) {
      Get.showSnackbar(
        const GetSnackBar(
          duration: Duration(seconds: 5),
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.zero,
          messageText:
              AppSnackBar(text: "Must provide a reason for cancelling"),
        ),
      );
    } else {
      ChangeRideStatusModel response = await ApiServices.changeRideStatus(
        body: {
          "ride_id": rideID,
          "ride_status": RideStatus.cancelled,
          "cancel_id": selectedReasonForCancel.value?.id
        },
      );
      if (response.status == 200) {
        HomeController.to.startLocationLatMarker = 0.0;
        HomeController.to.startLocationLongMarker = 0.0;
        HomeController.to.driverState.value = DriverState.idle;
        Get.until((route) => route.settings.name == AppRoutes.home);
      }
    }
  }
}
