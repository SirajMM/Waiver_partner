
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:waiver_driver/backend/model/add_vehicle/add_vehicle_model.dart';
import 'package:waiver_driver/backend/model/fleet_home_page/fleet_home_page_model.dart';
import 'package:waiver_driver/backend/model/registration/registration_model.dart';
import 'package:waiver_driver/controller/fleet_home_page/fleet_home_page_controller.dart';
import 'package:waiver_driver/core/widgets/snackbar/snackbar.dart';
import 'package:waiver_driver/helper/validator/app_extensions/app_extensions.dart';

import '../../backend/api/api_services/api_services.dart';

class AddVehicleControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddVehicleController());
  }
}

class AddVehicleController extends GetxController {
  static AddVehicleController get to => Get.find();

  @override
  void onInit() async {
    super.onInit();
    try {
      isLoading.value = true;
      await Future.wait([
        getVehicleTypes(),
        getTransmissionTypes(),
      ]);
      isError.value = false;
    } catch (error) {
      isError.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  VehicleType? selectedVehicleType;

  Transmission? selectedTransmissionType;

  TextEditingController controllerVehicleRegistrationNumber =
      TextEditingController();
  TextEditingController controllerVehicleBrand = TextEditingController();
  TextEditingController controllerVehicleName = TextEditingController();
  TextEditingController controllerVehiclePermitEndDate =
      TextEditingController();
  TextEditingController controllerVehicleInsuranceEndDate =
      TextEditingController();
  List<VehicleType> vehicleTypes = [];
  List<Transmission> transmissionTypes = [];

  Future<void> getVehicleTypes() async {
    GetVehicleTypeResponseModel response = await ApiServices.getVehicleTypes();
    vehicleTypes = response.data ?? [];
  }

  Future<void> getTransmissionTypes() async {
    GetTransmissionTypeResponseModel response =
        await ApiServices.getTransmissionTypes();
    transmissionTypes = response.data ?? [];
  }

  GlobalKey<FormState> formKeyForAddVehicle = GlobalKey();
  RxBool isButtonLoading = false.obs;
  addVehicle() async {
    if (formKeyForAddVehicle.currentState?.validate() ?? false) {
      try {
        isButtonLoading.value = true;
        AddVehicleResponseModel response = await ApiServices.addVehicle(body: {
          "registration_number": controllerVehicleRegistrationNumber.text,
          "brand": controllerVehicleBrand.text,
          "name": controllerVehicleName.text,
          "permit_end_date":
              controllerVehiclePermitEndDate.text.changeDateFormat(),
          "insurance_end_date":
              controllerVehicleInsuranceEndDate.text.changeDateFormat(),
          "vehicle_type": (selectedVehicleType?.id!).toString(),
          "transmission_type": (selectedTransmissionType?.id!).toString(),
        });
        if (response.status == 200) {
          response.data?.status?.value = "PDG";
          FleetHomePageController.to.fleet.add(response.data ?? FleetVehicle());
          Get.back();
        }
        Get.showSnackbar(
          GetSnackBar(
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            messageText: AppSnackBar(
              text: response.message,
            ),
          ),
        );
      } catch (error) {
        Get.showSnackbar(const GetSnackBar(
            duration: Duration(seconds: 5),
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            messageText: AppSnackBar(text: "OOPS Something went wrong")));
      } finally {
        isButtonLoading.value = false;
      }
    }
  }
}
