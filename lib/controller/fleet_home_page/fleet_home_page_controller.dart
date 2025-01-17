import 'package:flutter/material.dart';
import 'package:flutter_custom_utils/util/utils.dart';
import 'package:get/get.dart';
import 'package:waiver_driver/backend/model/fleet_home_page/fleet_home_page_model.dart';
import 'package:waiver_driver/backend/model/setting/setting_model.dart';
import 'package:waiver_driver/core/widgets/snackbar/snackbar.dart';



import '../../backend/api/api_services/api_services.dart';
import '../../core/constants/get_storage_constants.dart';




class FleetHomePageControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FleetHomePageController());
  }
}

class FleetHomePageController extends GetxController {
  static FleetHomePageController get to => Get.find();
  RxList<FleetVehicle> fleet = <FleetVehicle>[].obs;

  @override
  void onInit() {
    super.onInit();
    getVehicles();
  }

  blockUser({required FleetVehicle vehicle}) async {
    LogoutResponseModel response =
        await ApiServices.blockVehicle(body: {"vehicle_id": vehicle.id});
    if (response.status == 200) {
      vehicle.status?.value = VehicleApprovalStatus.blocked;
    }
    Get.showSnackbar(GetSnackBar(
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.transparent,
      padding: EdgeInsets.zero,
      messageText: AppSnackBar(
        text: "${vehicle.name} blocked successfully",
      ),
    ));
  }

  Future<void> getVehicles() async {
    cLog('fleet vehicles list');
    GetVehicleListResponseModel response = await ApiServices.getVehicles();
    fleet.value = response.data ?? [];
  }
}
