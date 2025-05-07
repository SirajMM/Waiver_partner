import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waiver_driver/backend/model/fleet_home_page/fleet_home_page_model.dart';
import 'package:waiver_driver/controller/fleet_home_page/fleet_home_page_controller.dart';
import 'package:waiver_driver/core/widgets/snackbar/snackbar.dart';


import '../../backend/api/api_services/api_services.dart';
import '../../helper/router/app_routes/route.dart';




class AddDriverControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddDriverController());
  }
}

class AddDriverController extends GetxController {
  static AddDriverController get to => Get.find();

  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  RxBool isButtonLoading = false.obs;

  GlobalKey<FormState> formKeyForAddDriver = GlobalKey();

  TextEditingController controllerDriverName = TextEditingController();
  TextEditingController controllerDriverId = TextEditingController();
  FleetVehicle? vehicle;

  @override
  void onInit() async {
    super.onInit();
    vehicle = Get.arguments;
    print(vehicle?.driver?.id);
    isChangeDriver = vehicle?.driver?.id != null;
    controllerDriverName.text = vehicle?.driver?.driverName ?? "";
    controllerDriverId.text = vehicle?.driver?.driverId ?? "";
  }

  bool isChangeDriver = false;

  Future<void> addDriver() async {
    try {
      isButtonLoading.value = true;
      if (formKeyForAddDriver.currentState?.validate() ?? false) {
        var data = await ApiServices.vehicleDriver(body: {
          "vehicle_id": vehicle?.id,
          "driver_name": controllerDriverName.text,
          "driver_id": controllerDriverId.text,
        });
        Get.offAllNamed(AppRoutes1.getFleetHomePageInRoute());
    // Get.back();
        Get.showSnackbar(
          GetSnackBar(
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            messageText: AppSnackBar(
              text: data.message,
            ),
          ),
        );
      }
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          duration: Duration(seconds: 5),
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.zero,
          messageText: const AppSnackBar(
            text: "Try again later",
          ),
        ),
      );
    } finally {
      isButtonLoading.value = false;
      isLoading.value = false;
    }
  }

  Future<void> changeDriver() async {
    try {
      isButtonLoading.value = true;
      if (formKeyForAddDriver.currentState?.validate() ?? false) {
        log(controllerDriverName.text);
        var data = await ApiServices.vehicleDriver(body: {
          "vehicle_id": vehicle?.id,
          "driver_name": controllerDriverName.text,
          "driver_id": controllerDriverId.text,
        });
        FleetHomePageController.to.onInit();
        Get.back();
        Get.back();
        Get.showSnackbar(
          GetSnackBar(
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            messageText: AppSnackBar(
              text: data.message,
            ),
          ),
        );
      }
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          duration: Duration(seconds: 5),
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.zero,
          messageText: const AppSnackBar(
            text: "Try again later",
          ),
        ),
      );
    } finally {
      isButtonLoading.value = false;
      isLoading.value = false;
    }
  }
}
