import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waiver_driver/backend/api/api_services/api_services.dart';
import 'package:waiver_driver/backend/api/api_services/urls.dart';
import 'package:waiver_driver/backend/model/profile/profile_model.dart' as profileModel;
import 'package:waiver_driver/backend/model/registration/registration_model.dart';
import 'package:waiver_driver/backend/parser/Profile/profilescreen_parser.dart';
import 'package:waiver_driver/core/constants/get_storage_constants.dart';
import 'package:waiver_driver/core/widgets/snackbar/snackbar.dart';
import 'package:waiver_driver/helper/validator/app_extensions/app_extensions.dart';
import 'package:waiver_driver/main.dart';

// class ProfileControllerBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut(() => ProfileController());
//   }
// }

class ProfileController extends GetxController {
  ProfilescreenParser parser;

  ProfileController({required this.parser});
  @override
  void onInit() async {
    super.onInit();
    // Get.put(ApiServices(appBaseUrl: AppUrls.base));
    try {
      isLoading.value = true;
      await getProfile();

      isLoading.value = false;
      // isError.value = false;
    } catch (error) {
      print('crashed');
      print(error);
      isError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  String profileImage = "";
  Future<void> getProfile() async {
    profileModel.GetProfileResponseModel response = await ApiServices.getProfile();
    // profileImage = response.data?.profileImage ?? "";
    controllerFullName.text = response.data?.fullname ?? "";
    controllerEmail.text = response.data?.email ?? "";
    selectedGender = genderList.firstWhereOrNull((element) => (element.code) == (response.data?.gender));
    controllerEmail.text = response.data?.email ?? "";
    controllerDateOfBirth.text = (response.data?.dob ?? "")
        .changeDateFormat(fromFormat: "yyyy-MM-dd", toFormat: "dd / MMM / yyyy");
    controllerAlternativeNumber.text = response.data?.alternativePhone ?? "";
    controllerWhatsAppNumber.text = response.data?.whatsappPhone ?? "";
    state = response.data?.state?.name ?? "";
    district = response.data?.district?.name ?? "";
    workingLocation = response.data?.workLocation?.name ?? "";
    transmissionType = response.data?.transmissionType ?? [];
    experience = response.data?.drivingExperience?.experience.toString();
    // selectedState = statesList.firstWhereOrNull(
    //     (element) => (element.id) == (response.data?.state?.id));
    // getAllDistricts(districtsID: response.data?.district?.id);
    controllerAddress.text = response.data?.address ?? "";

    // selectedYearsOfDrivingExperience =
    //     yearsOfDrivingExperience.firstWhereOrNull((element) =>
    //         (element.id) == (response.data?.drivingExperience?.id));
    // selectedWorkingLocation = workingLocations.firstWhereOrNull(
    //     (element) => (element.id) == (response.data?.workLocation?.id));
    vehicleTypes = response.data?.vehicleType ?? [];
    // for (var item in vehicleTypes) {
    //   for (var item2 in response.data?.vehicleType ?? []) {
    //     if (item.id == item2.id) {
    //       item.isSelected?.value = true;
    //     } else {
    //       item.isSelected?.value = false;
    //     }
    //     print(item.isSelected?.value);
    //   }
    // }

    // selectedTransmissionType = transmissionTypes.firstWhereOrNull(
    //     (element) => (element.id) == (response.data?.transmissionType?.id));
    response.data?.licenseValidity != null
        ? controllerLicenseValidityDate.text = (response.data?.licenseValidity ?? "")
            .changeDateFormat(fromFormat: "yyy-MM-dd", toFormat: "dd / MMM / yyy")
        : null;

    profileModel.ProfileImageModel imageResponse =
        await ApiServices.getProfilePhoto(queryParameter: {"document_type": "PPO"});
    profileImage = imageResponse.data?.files?.firstOrNull?.file ?? "";
  }

  String userTypeCode = box.read(BoxKeys.userTypeCode) ?? "";

  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  List<GenderModel> genderList = [
    GenderModel(label: "Male", code: "M"),
    GenderModel(label: "Female", code: "F"),
    GenderModel(label: "Other", code: "O")
  ];
  Future<void> getAllStates() async {
    GetAllStatesResponseModel response = await ApiServices.getAllStates();
    statesList = response.data ?? [];
  }

  Future<void> getWorkLocation() async {
    GetAllWorkLocationsResponseModel response = await ApiServices.getWorkLocation();
    workingLocations = response.data ?? [];
  }

  Future<void> getVehicleTypes() async {
    GetVehicleTypeResponseModel response = await ApiServices.getVehicleTypes();
    // vehicleTypes = response.data ?? [];
  }

  Future<void> getTransmissionTypes() async {
    GetTransmissionTypeResponseModel response = await ApiServices.getTransmissionTypes();
    transmissionTypes = response.data ?? [];
  }

  Future<void> getWorkExperience() async {
    GetAllWorkExperienceResponseModel response = await ApiServices.getWorkExperience();
    yearsOfDrivingExperience = response.data ?? [];
  }

  Future<void> getAllDistricts({required int? districtsID}) async {
    try {
      GetAllDistrictsResponseModel response =
          await ApiServices.getAllDistricts(queryParameter: {"state": (selectedState!.id).toString()});
      districtsList = response.data ?? [];
      if (districtsList.isEmpty) {
        Get.showSnackbar(GetSnackBar(
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            messageText: AppSnackBar(
                text: "There are no Serviceable Districts in ${selectedState!.name ?? ""}")));
      } else {
        selectedDistrict = districtsList.firstWhereOrNull((element) => element.id == districtsID);
      }
    } catch (error) {
      print(error);
      Get.showSnackbar(const GetSnackBar(
          duration: Duration(seconds: 5),
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.zero,
          messageText: AppSnackBar(text: "OOPS6 Something went wrong")));
    }
  }

  static ProfileController get to => Get.find();
  TextEditingController controllerFullName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerAlternativeNumber = TextEditingController();
  TextEditingController controllerWhatsAppNumber = TextEditingController();
  TextEditingController controllerDateOfBirth = TextEditingController();
  TextEditingController controllerAddress = TextEditingController();
  TextEditingController controllerLicenseValidityDate = TextEditingController();
  List<StatesModel> statesList = [];
  List<DistrictModel> districtsList = [];
  List<WorkExperience> yearsOfDrivingExperience = [];
  List<WorkLocation> workingLocations = [];
  List<profileModel.State> vehicleTypes = [];
  List<Transmission> transmissionTypes = [];
  GenderModel? selectedGender;
  StatesModel? selectedState;
  String? state;
  String? district;
  String? workingLocation;
  List<Transmission>? transmissionType;
  String? experience;
  DistrictModel? selectedDistrict;
  WorkExperience? selectedYearsOfDrivingExperience;
  WorkLocation? selectedWorkingLocation;
  List<VehicleType?>? selectedVehicleType;
  Transmission? selectedTransmissionType;

  GlobalKey<FormState> changeEmailFormKey = GlobalKey();
  GlobalKey<FormState> changeAlternativeNumber = GlobalKey();
  GlobalKey<FormState> changeWhatsAppNumber = GlobalKey();
  GlobalKey<FormState> changeLicenseValidityDateNumber = GlobalKey();
  RxBool isSaveChangeButtonLoading = false.obs;
  saveChangeEmail() async {
    if (changeEmailFormKey.currentState?.validate() ?? false) {
      try {
        profileModel.UpdateProfileResponseModel response =
            await ApiServices.upDateProfile(body: {"email": controllerEmail.text});
        Get.back();
        Get.showSnackbar(GetSnackBar(
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            messageText: AppSnackBar(text: response.message ?? "")));
      } catch (error) {
        Get.showSnackbar(const GetSnackBar(
            duration: Duration(seconds: 5),
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            messageText: AppSnackBar(text: "OOPS1 Somethin1g went wrong")));
      } finally {
        isSaveChangeButtonLoading.value = false;
      }

      Get.back();
    }
  }

  saveChangeAlternativeNumber() async {
    if (changeAlternativeNumber.currentState?.validate() ?? false) {
      try {
        profileModel.UpdateProfileResponseModel response = await ApiServices.upDateProfile(
            body: {"alternative_phone": controllerAlternativeNumber.text});
        Get.back();
        Get.showSnackbar(GetSnackBar(
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            messageText: AppSnackBar(text: response.message ?? "")));
      } catch (error) {
        Get.showSnackbar(const GetSnackBar(
            duration: Duration(seconds: 5),
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            messageText: AppSnackBar(text: "OOPS2 Something went wrong")));
      } finally {
        isSaveChangeButtonLoading.value = false;
      }

      Get.back();
    }
  }

  saveChangeWhatsAppNumber() async {
    if (changeWhatsAppNumber.currentState?.validate() ?? false) {
      try {
        profileModel.UpdateProfileResponseModel response =
            await ApiServices.upDateProfile(body: {"whatsapp_phone": controllerWhatsAppNumber.text});
        Get.back();
        Get.showSnackbar(GetSnackBar(
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            messageText: AppSnackBar(text: response.message ?? "")));
      } catch (error) {
        Get.showSnackbar(const GetSnackBar(
            duration: Duration(seconds: 5),
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            messageText: AppSnackBar(text: "OOPS3 Something went wrong")));
      } finally {
        isSaveChangeButtonLoading.value = false;
      }

      Get.back();
    }
  }

  saveChangeLicenseValidityDateNumber() async {
    if (changeLicenseValidityDateNumber.currentState?.validate() ?? false) {
      try {
        profileModel.UpdateProfileResponseModel response = await ApiServices.upDateProfile(
            body: {"license_validity": controllerLicenseValidityDate.text.changeDateFormat()});
        Get.back();
        Get.showSnackbar(GetSnackBar(
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            messageText: AppSnackBar(text: response.message ?? "")));
      } catch (error) {
        Get.showSnackbar(const GetSnackBar(
            duration: Duration(seconds: 5),
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            messageText: AppSnackBar(text: "OOPS4 Something went wrong")));
      } finally {
        isSaveChangeButtonLoading.value = false;
      }

      Get.back();
    }
  }
}
