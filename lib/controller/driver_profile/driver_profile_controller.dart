import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waiver_driver/backend/model/driver_profile/driver_profile_model.dart';
import 'package:waiver_driver/backend/model/fleet_home_page/fleet_home_page_model.dart';
import 'package:waiver_driver/backend/model/registration/registration_model.dart';
import 'package:waiver_driver/core/constants/get_storage_constants.dart';
import 'package:waiver_driver/core/widgets/snackbar/snackbar.dart';
import 'package:waiver_driver/main.dart';
import '../../backend/api/api_services/api_services.dart';


class DriverProfileControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DriverProfileController());
  }
}

class DriverProfileController extends GetxController {
  static DriverProfileController get to => Get.find();

  Driver? driver;
  @override
  void onInit() async {
    super.onInit();
    try {
      isLoading.value = true;
      FleetVehicle vehicle = Get.arguments;
      driver = vehicle.driver;

      await Future.wait([getDriverProfile(), getAllStates()]);
      isError.value = false;
    } catch (error) {
      log(error.toString());
      isError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  RxBool isLoading = false.obs;
  RxBool isError = false.obs;

  TextEditingController controllerFullName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerDateOfBirth = TextEditingController();
  TextEditingController controllerAlternativeNumber = TextEditingController();
  TextEditingController controllerWhatsAppNumber = TextEditingController();
  TextEditingController controllerAddress = TextEditingController();
  List<StatesModel> statesList = [];
  List<DistrictModel> districtsList = [];
  List<Transmission>? transmissionType;
  List<Statemodel> vehicleTypes = [];
  GenderModel? selectedGender;
  StatesModel? selectedState;
  DistrictModel? selectedDistrict;
  String? profileImage;
  bool? has_Vehicle_Assigned;
  VehicleDetails? vehicleDetails;
  List<GenderModel> genderList = [
    GenderModel(label: "Male", code: "M"),
    GenderModel(label: "Female", code: "F"),
    GenderModel(label: "Other", code: "O")
  ];

  Future<void> getAllStates() async {
    GetAllStatesResponseModel response = await ApiServices.getAllStates();
    statesList = response.data ?? [];
  }

  Future<void> getAllDistricts({required int? districtsID}) async {
    try {
      GetAllDistrictsResponseModel response = await ApiServices.getAllDistricts(
          queryParameter: {"state": (selectedState!.id).toString()});
      districtsList = response.data ?? [];
      if (districtsList.isEmpty) {
        Get.showSnackbar(GetSnackBar(
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            messageText: AppSnackBar(
                text:
                    "There are no Serviceable Districts in ${selectedState!.name ?? ""}")));
      } else {
        selectedDistrict = districtsList
            .firstWhereOrNull((element) => element.id == districtsID);
      }
    } catch (error) {
      print(error);
      Get.showSnackbar(const GetSnackBar(
          duration: Duration(seconds: 5),
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.zero,
          messageText: AppSnackBar(text: "OOPS Something went wrong")));
    }
  }

  Future<void> getDriverProfile() async {
    GetDriverProfileResponseModel response = await ApiServices.driverProfile(
        queryParameter: {"driver_id": driver?.driverId});
    profileImage = response.data?.profileImage ?? "";
    controllerFullName.text = response.data?.fullname ?? "";
    controllerEmail.text = response.data?.email ?? "";
    selectedGender = genderList.firstWhereOrNull(
        (element) => (element.code) == (response.data?.gender));
    controllerEmail.text = response.data?.email ?? "";
    controllerDateOfBirth.text = (response.data?.dob ?? "");
    controllerAlternativeNumber.text = response.data?.alternativePhone ?? "";
    controllerWhatsAppNumber.text = response.data?.whatsappPhone ?? "";
    selectedState = statesList.firstWhereOrNull(
        (element) => (element.id) == (response.data?.state?.id));
    await getAllDistricts(districtsID: response.data?.district?.id);
    transmissionType = response.data?.transmissionType ?? [];
    vehicleTypes = response.data?.vehicleType ?? [];
    controllerAddress.text = response.data?.address ?? "";
    has_Vehicle_Assigned = response.data?.hasVehicleAssigned;
    vehicleDetails = response.data?.vehicleDetails;
  }
  Future <bool> hasAssigned()async{
    String userTypeCode = await box.read(BoxKeys.userTypeCode);
    if(userTypeCode==UserTypeCode.driver && has_Vehicle_Assigned==true){
      return true;
    }else{
      return false;
    }

  }

}
