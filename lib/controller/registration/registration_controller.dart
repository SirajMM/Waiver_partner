import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waiver_driver/backend/model/registration/registration_model.dart';
import 'package:waiver_driver/backend/parser/Registration/registration_parser.dart';
import 'package:waiver_driver/core/widgets/snackbar/snackbar.dart';
import 'package:waiver_driver/helper/router/app_routes/route.dart';
import 'package:waiver_driver/helper/validator/app_extensions/app_extensions.dart';

import 'package:waiver_driver/main.dart';

import '../../backend/api/api_services/api_services.dart';
import '../../core/constants/enums/enums.dart';
import '../../core/constants/get_storage_constants.dart';


// class RegistrationControllerBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut(() => RegistrationController());
//   }
// }

class RegistrationController extends GetxController {
  RegistrationParser parser;
  RegistrationController({required this.parser});

  static RegistrationController get to => Get.find();

  String? userTypeCode;
  bool isFleet() => userTypeCode == UserTypeCode.fleet;

  @override
  void onInit() async {
    super.onInit();

    try {
      isLoading.value = true;
      userTypeCode = box.read(BoxKeys.userTypeCode) ?? "";
      await Future.wait(userTypeCode != UserTypeCode.fleet
          ? [
              getAllStates(),
              getWorkExperience(),
              getWorkLocation(),
              getTransmissionTypes(),
              getVehicleTypes(),
              // getAllDistricts(),
            ]
          : [
              getAllStates(),
            ]);
      isLoading.value = false;
      isError.value = false;
    } catch (error) {
      isError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  RxBool isLoading = false.obs;
  RxBool isError = false.obs;

  GlobalKey<FormState> registrationFormKey = GlobalKey();
  TextEditingController controllerFullName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerAlternativeNumber = TextEditingController();
  TextEditingController controllerWhatsAppNumber = TextEditingController();
  TextEditingController controllerDateOfBirth = TextEditingController();
  TextEditingController controllerAddress = TextEditingController();
  TextEditingController controllerLicenseValidityDate = TextEditingController();
  List<GenderModel> genderList = [
    GenderModel(label: "Male", code: "M"),
    GenderModel(label: "Female", code: "F"),
    GenderModel(label: "Other", code: "O")
  ];
  GenderModel? selectedGender;
  List<StatesModel> statesList = [];
  List<DistrictModel> districtsList = [];
  List<WorkExperience> yearsOfDrivingExperience = [];
  List<WorkLocation> workingLocations = [];
  List<VehicleType> vehicleTypes = [];
  List<Transmission> transmissionTypes = [];

  StatesModel? selectedState;
  DistrictModel? selectedDistrict;
  WorkExperience? selectedYearsOfDrivingExperience;
  WorkLocation? selectedWorkingLocation;
  StatesModel? selectStatelist;
  VehicleType? selectedVehicleType;
  Transmission? selectedTransmissionType;

  RxBool isAgreedToTermsAndConditions = true.obs;
  RxBool isAgreedToPrivacyPolicy = true.obs;
  RxBool showTermsAndConditionsError = false.obs;
  RxBool showVehicleTypeError = false.obs;
  RxBool showTransmissionTypeError = false.obs;
  RxBool showPrivacyPolicyError = false.obs;

  Future<void> getAllStates() async {
    GetAllStatesResponseModel response = await ApiServices.getAllStates();
    statesList = response.data ?? [];
  }

  Future<void> getWorkLocation() async {
    GetAllWorkLocationsResponseModel response =
        await ApiServices.getWorkLocation();
    workingLocations = response.data ?? [];
  }

  Future<void> getVehicleTypes() async {
    GetVehicleTypeResponseModel response = await ApiServices.getVehicleTypes();
    vehicleTypes = response.data ?? [];
  }

  Future<void> getTransmissionTypes() async {
    GetTransmissionTypeResponseModel response =
        await ApiServices.getTransmissionTypes();
    transmissionTypes = response.data ?? [];
  }

  Future<void> getWorkExperience() async {
    GetAllWorkExperienceResponseModel response =
        await ApiServices.getWorkExperience();
    yearsOfDrivingExperience = response.data ?? [];
  }

  Rx<DropDownState> districtDropDownState = DropDownState.hidden.obs;
  Future<void> getAllDistricts() async {
    try {
      districtDropDownState.value = DropDownState.loading;
      selectedDistrict = null;
      GetAllDistrictsResponseModel response = await ApiServices.getAllDistricts(
          queryParameter: {"state": (53).toString()});
      districtsList = response.data ?? [];
      if (districtsList.isEmpty) {
        districtDropDownState.value = DropDownState.hidden;
        Get.showSnackbar(
          GetSnackBar(
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            messageText: AppSnackBar(
              text:
                  "There are no Serviceable Districts in ${selectedState!.name ?? ""}",
            ),
          ),
        );
      } else {
        districtDropDownState.value = DropDownState.loaded;
      }
    } catch (error) {
      print(error);
      Get.showSnackbar(
        const GetSnackBar(
          duration: Duration(seconds: 5),
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.zero,
          messageText: AppSnackBar(
            text: "OOPS Something went wrong",
          ),
        ),
      );
      districtDropDownState.value = DropDownState.hidden;
    }
  }

  RxBool isRegisterButtonLoading = false.obs;
  register() async {
    try {
      isRegisterButtonLoading.value = true;
      if (!vehicleTypes.fold(
          false,
          (previousValue, element) =>
              previousValue || (element.isSelected?.value ?? false))) {
        showVehicleTypeError.value = true;
      }

      if (registrationFormKey.currentState?.validate() ?? false) {
        if (!isAgreedToTermsAndConditions.value) {
          showTermsAndConditionsError.value = true;
        }

        if (!isAgreedToPrivacyPolicy.value) {
          showPrivacyPolicyError.value = true;
        }

        if (isFleet()) {
          showVehicleTypeError.value = false;
          showTransmissionTypeError.value = false;
        }

        if (isAgreedToPrivacyPolicy.value &&
            isAgreedToTermsAndConditions.value &&
            !showVehicleTypeError.value &&
            !showTransmissionTypeError.value) {
          Map<String, dynamic> body = {
            "fullname": controllerFullName.text.trim(),
            "email": controllerEmail.text.trim(),
            "gender": selectedGender!.code,
            "alternative_phone": controllerAlternativeNumber.text.trim(),
            "whatsapp_phone": controllerWhatsAppNumber.text.trim(),
            "state": selectStatelist?.id,
            "district": selectedDistrict?.id.toString(),
            "address": controllerAddress.text.trim(),
            "work_location": selectedWorkingLocation?.id,
            "vehicle_type_ids": (vehicleTypes ?? [])
                .where((element) => element.isSelected?.value ?? false)
                .map((e) => e.id)
                .toList(),
            "transmission_type_ids": (transmissionTypes ?? [])
                .where((element) => element.isSelected?.value ?? false)
                .map((e) => e.id)
                .toList(),
          };

          if (userTypeCode != UserTypeCode.fleet) {
            body.addAll({
              "dob": controllerDateOfBirth.text.changeDateFormat(),
              "driving_experience": selectedYearsOfDrivingExperience!.id,
              "license_validity":
                  controllerLicenseValidityDate.text.changeDateFormat(),
            });
          }

          CreateDriverProfileResponseModel response =
              await ApiServices.createProfile(body: body);
          if (response.status == 200) {
            box.write(
              BoxKeys.userName,
              response.data?.fullname ?? "",
            );
            box.write(
              BoxKeys.userImage,
              response.data?.profileImage ?? "",
            );
            if (userTypeCode == UserTypeCode.fleet) {
              Get.offAllNamed(AppRoutes1.getFleetHomePageInRoute());
            } else {
              Get.offAllNamed(AppRoutes1.getChauffeurProofInRoute());
            }
          } else {
            Get.showSnackbar(
              const GetSnackBar(
                duration: Duration(seconds: 5),
                backgroundColor: Colors.transparent,
                padding: EdgeInsets.zero,
                messageText: AppSnackBar(
                  text: "OOPS Something went Wrong",
                ),
              ),
            );
          }
        }

        // Get.toNamed(AppRoutes.chauffeurProof, arguments: controllerFullName.text);
        // }
      }
    } catch (error) {
      print(error);
      Get.showSnackbar(
        const GetSnackBar(
          duration: Duration(seconds: 2),
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.zero,
          messageText: AppSnackBar(
            text: "OOPS something went wrong",
          ),
        ),
      );
    } finally {
      isRegisterButtonLoading.value = false;
    }
  }
}
