import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:waiver_driver/backend/model/registration/registration_model.dart';
import 'package:waiver_driver/controller/driver_profile/driver_profile_controller.dart';
import 'package:waiver_driver/core/widgets/app_bar/app_bar.dart';
import 'package:waiver_driver/core/widgets/app_buttons/app_buttons.dart';
import 'package:waiver_driver/core/widgets/error_page/error_page.dart';
import 'package:waiver_driver/core/widgets/test_fields/app_test_form_field_calender.dart';
import 'package:waiver_driver/core/widgets/test_fields/app_text_form_fields.dart';
import 'package:waiver_driver/helper/router/app_routes/app_routes.dart';
import 'package:waiver_driver/helper/validator/validators/validators.dart';
import 'package:waiver_driver/view/loading_animation/loading_animation.dart';

import '../../backend/model/driver_profile/driver_profile_model.dart';

import '../../core/colors/app_colors.dart';
import '../../core/widgets/app_network_image/app_network_image.dart';

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(title: "Driver Profile"),
        body: GetX<DriverProfileController>(builder: (controller) {
          return controller.isLoading.value
              ? const LoadingBarsAnimation()
              : controller.isError.value
                  ? const ErrorPage(isFleet: true)
                  : ListView(
                      padding: EdgeInsets.symmetric(horizontal: 15.sp),
                      children: [
                        SizedBox(
                          height: 24.sp,
                        ),
                        const ProfilePhotoDriverProfile(),
                        SizedBox(
                          height: 24.sp,
                        ),
                        AppTextFormField(
                          readOnly: true,
                          controller:
                              DriverProfileController.to.controllerFullName,
                          header: "Full Name",
                        ),
                        SizedBox(
                          height: 12.sp,
                        ),
                        AppTextFormField(
                          controller:
                              DriverProfileController.to.controllerEmail,
                          header: 'Email Address',
                          placeHolder: "e.g. alex@gmail.com",
                          textInputType: TextInputType.emailAddress,
                          readOnly: true,
                        ),
                        SizedBox(
                          height: 12.sp,
                        ),
                        AppDropDownFormField(
                          header: 'Gender',
                          readOnly: true,
                          placeHolder: 'Select',
                          itemList: DriverProfileController.to.genderList,
                          onChange: (GenderModel? gender) {
                            DriverProfileController.to.selectedGender = gender;
                          },
                          value: DriverProfileController.to.selectedGender,
                          label: (GenderModel? gender) => gender?.label,
                        ),
                        SizedBox(
                          height: 12.sp,
                        ),
                        AppDatePickerFormField(
                          readOnly: true,
                          header: 'Date of Birth as per Documents',
                          placeHolder: "Select",
                          initialDate: DateTime.now()
                              .subtract(const Duration(days: 365 * 20)),
                          startDate: DateTime.now()
                              .subtract(const Duration(days: 365 * 85)),
                          lastDate: DateTime.now()
                              .subtract(const Duration(days: 365 * 20)),
                          validator: (value) =>
                              Validators.isEmpty(value: value),
                          controller:
                              DriverProfileController.to.controllerDateOfBirth,
                        ),
                        SizedBox(
                          height: 12.sp,
                        ),
                        AppTextFormField(
                          controller: DriverProfileController
                              .to.controllerAlternativeNumber,
                          header: 'Alternative Number',
                          maxLength: 10,
                          placeHolder: " e.g. xxxxxxxxxx",
                          validator: (value) => Validators.isMobile(
                            value: value,
                          ),
                          readOnly: true,
                          textInputType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                        SizedBox(
                          height: 12.sp,
                        ),
                        AppTextFormField(
                          controller: DriverProfileController
                              .to.controllerWhatsAppNumber,
                          header: 'Whatsapp Number',
                          maxLength: 10,
                          placeHolder: " e.g. xxxxxxxxxx",
                          validator: (value) => Validators.isMobile(
                            value: value,
                          ),
                          textInputType: TextInputType.phone,
                          readOnly: true,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                        SizedBox(
                          height: 12.sp,
                        ),
                        AppDropDownFormField(
                          header: 'State',
                          placeHolder: 'Select',
                          readOnly: true,
                          itemList: DriverProfileController.to.statesList,
                          onChange: (StatesModel? state) {
                            DriverProfileController.to.selectedState = state;
                          },
                          value: DriverProfileController.to.selectedState,
                          label: (StatesModel state) => state.name,
                        ),
                        SizedBox(
                          height: 12.sp,
                        ),
                        AppDropDownFormField(
                          header: 'District',
                          readOnly: true,
                          placeHolder: 'Select',
                          itemList: DriverProfileController.to.districtsList,
                          onChange: (DistrictModel? district) {
                            DriverProfileController.to.selectedDistrict =
                                district;
                          },
                          value: DriverProfileController.to.selectedDistrict,
                          label: (DistrictModel? district) => district?.name,
                        ),
                        SizedBox(
                          height: 12.sp,
                        ),

                        Theme(
                          data: ThemeData(
                              dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            backgroundColor: AppColors.white,
                            collapsedBackgroundColor:
                            AppColors.white,
                            collapsedShape:
                            RoundedRectangleBorder(
                              side: BorderSide(
                                  color: AppColors.grey155),
                              borderRadius:
                              BorderRadius.circular(8.sp),
                            ),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: AppColors.grey155),
                              borderRadius:
                              BorderRadius.circular(8.sp),
                            ),
                            childrenPadding: EdgeInsets.zero,
                            title: const Text("Vehicle Types"),
                            children: DriverProfileController
                                .to.vehicleTypes
                                .map((vehicle) =>
                                SelectVehicleTypeListingItemProfile(
                                  vehicle: vehicle,
                                ))
                                .toList(),
                          ),
                        ),
                        SizedBox(
                          height: 12.sp,
                        ),
                        Theme(
                          data: ThemeData(
                              dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            backgroundColor: AppColors.white,
                            collapsedBackgroundColor:
                            AppColors.white,
                            collapsedShape:
                            RoundedRectangleBorder(
                              side: BorderSide(
                                  color: AppColors.grey155),
                              borderRadius:
                              BorderRadius.circular(8.sp),
                            ),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: AppColors.grey155),
                              borderRadius:
                              BorderRadius.circular(8.sp),
                            ),
                            childrenPadding: EdgeInsets.zero,
                            title:
                            const Text("Transmission Types"),
                            children: DriverProfileController
                                .to.transmissionType!
                                .map((transmission) =>
                                SelectTransmissionTypeListingItemProfile(
                                  transmission: transmission,
                                ))
                                .toList(),
                          ),
                        ),

                        SizedBox(
                          height: 12.sp,
                        ),
                        AppTextFormField(
                          controller:
                              DriverProfileController.to.controllerAddress,
                          header: 'Address as per Documents',
                          placeHolder: "e.g. Alex",
                          validator: (value) => Validators.isEmpty(
                            value: value,
                          ),
                          maxLInes: 5,
                          minLines: 1,
                          readOnly: true,
                        ),
                        SizedBox(
                          height: 12.sp,
                        ),
                        SizedBox(
                          height: 30.sp,
                        ),
                        BlueButton(
                          text: "Change Driver",
                          onTap: () => Get.toNamed(AppRoutes.addDriver,
                              arguments: Get.arguments),
                        ),
                        SizedBox(
                          height: 30.sp,
                        ),
                      ],
                    );
        }));
  }
}

class ProfilePhotoDriverProfile extends StatelessWidget {
  const ProfilePhotoDriverProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppNetworkImage(
          imageUrl: DriverProfileController.to.profileImage ?? "",
          height: 130.sp,
          width: 130.sp,
          radius: 70.sp,
          isProfile: true,
        ),
      ],
    );
  }
}
class SelectVehicleTypeListingItemProfile extends StatelessWidget {
  Statemodel vehicle;
  SelectVehicleTypeListingItemProfile({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
            value: true,
            onChanged: (value) {
              // vehicle.isSelected?.value = value ?? false;
              // controller.showVehicleTypeError.value = false;
            }),
        Text(vehicle.name ?? "")
      ],
    );
  }
}

class SelectTransmissionTypeListingItemProfile extends StatelessWidget {
  Transmission transmission;
  SelectTransmissionTypeListingItemProfile(
      {super.key, required this.transmission});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
            value: true,
            onChanged: (value) {
              // vehicle.isSelected?.value = value ?? false;
              // controller.showVehicleTypeError.value = false;
            }),
        Text(transmission.name ?? "")
      ],
    );
  }
}