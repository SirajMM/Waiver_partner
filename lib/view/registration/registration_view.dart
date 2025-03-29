import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:waiver_driver/backend/model/registration/registration_model.dart';
import 'package:waiver_driver/controller/registration/registration_controller.dart';
import 'package:waiver_driver/core/colors/app_colors.dart';
import 'package:waiver_driver/core/constants/enums/enums.dart';
import 'package:waiver_driver/core/constants/get_storage_constants.dart';
import 'package:waiver_driver/core/widgets/app_bar/app_bar.dart';
import 'package:waiver_driver/core/widgets/app_buttons/app_buttons.dart';
import 'package:waiver_driver/core/widgets/error_page/error_page.dart';
import 'package:waiver_driver/core/widgets/test_fields/app_test_form_field_calender.dart';
import 'package:waiver_driver/core/widgets/test_fields/app_text_form_fields.dart';
import 'package:waiver_driver/helper/validator/validators/validators.dart';
import 'package:waiver_driver/view/loading_animation/loading_animation.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: ""),
      body: GetX<RegistrationController>(
        builder: (controller) {
          return controller.isLoading.value
              ? const LoadingBarsAnimation()
              : controller.isError.value
                  ? const ErrorPage()
                  : Form(
                      key: RegistrationController.to.registrationFormKey,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.sp),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // padding: EdgeInsets.symmetric(horizontal: 15.sp),
                            children: [
                              SizedBox(
                                height: 20.sp,
                              ),
                              Text(
                                "Welcome new Waiver partner! Drive forward",
                                style: TextStyle(
                                    height: 1,
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 12.sp,
                              ),
                              Text(
                                "Please enter the partner details",
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    height: 1,
                                    fontWeight: FontWeight.w200),
                              ),
                              SizedBox(
                                height: 30.sp,
                              ),
                              AppTextFormField(
                                controller: RegistrationController
                                    .to.controllerFullName,
                                header: 'Full Name',
                                placeHolder: "e.g. Alex",
                                validator: (value) => Validators.isEmpty(
                                  value: value,
                                ),
                              ),
                              SizedBox(
                                height: 12.sp,
                              ),
                              AppTextFormField(
                                controller:
                                    RegistrationController.to.controllerEmail,
                                header: 'Email Address',
                                placeHolder: "e.g. alex@gmail.com",
                                validator: (value) => Validators.isEMail(
                                  value: value,
                                ),
                                textInputType: TextInputType.emailAddress,
                              ),
                              SizedBox(
                                height: 12.sp,
                              ),
                              AppDropDownFormField(
                                header: 'Gender',
                                placeHolder: 'Select',
                                itemList: RegistrationController.to.genderList,
                                onChange: (GenderModel? gender) {
                                  RegistrationController.to.selectedGender =
                                      gender;
                                },
                                value: RegistrationController.to.selectedGender,
                                label: (GenderModel gender) => gender.label,
                              ),
                              SizedBox(
                                height: 12.sp,
                              ),
                              !RegistrationController.to.isFleet()
                                  ? Column(
                                      children: [
                                        AppDatePickerFormField(
                                          header:
                                              'Date of Birth as per Documents',
                                          placeHolder: "Select",
                                          initialDate: DateTime.now().subtract(
                                              const Duration(days: 365 * 23)),
                                          startDate: DateTime.now().subtract(
                                              const Duration(days: 365 * 85)),
                                          lastDate: DateTime.now().subtract(
                                              const Duration(days: 365 * 23)),
                                          validator: (value) =>
                                              Validators.isEmpty(value: value),
                                          controller: RegistrationController
                                              .to.controllerDateOfBirth,
                                        ),
                                        SizedBox(
                                          height: 12.sp,
                                        ),
                                      ],
                                    )
                                  : const SizedBox(),
                              AppTextFormField(
                                controller: RegistrationController
                                    .to.controllerAlternativeNumber,
                                header: 'Alternative Number',
                                maxLength: 10,
                                placeHolder: " e.g. xxxxxxxxxx",
                                validator: (value) => Validators.isMobile(
                                  value: value,
                                ),
                                textInputType: TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                              SizedBox(
                                height: 12.sp,
                              ),
                              AppTextFormField(
                                controller: RegistrationController
                                    .to.controllerWhatsAppNumber,
                                header: 'Whatsapp Number',
                                maxLength: 10,
                                placeHolder: " e.g. xxxxxxxxxx",
                                validator: (value) => Validators.isMobile(
                                  value: value,
                                ),
                                textInputType: TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                              // SizedBox(
                              //   height: 12.sp,
                              // ),
                              // AppDropDownFormField(
                              //   header: 'State',
                              //   placeHolder: 'Select',
                              //   itemList: RegistrationController.to.statesList,
                              //   onChange: (StatesModel? state) {
                              //
                              //     RegistrationController.to.selectedState = state;
                              //     print(state?.id);
                              //     RegistrationController.to.getAllDistricts();
                              //   },
                              //   value: RegistrationController.to.selectedState,
                              //   label: (StatesModel state) => state.name,
                              // ),
                              SizedBox(
                                height: 12.sp,
                              ),
                              GetX<RegistrationController>(
                                  builder: (controller) {
                                switch (
                                    controller.districtDropDownState.value) {
                                  case DropDownState.hidden:
                                    return const SizedBox();
                                  case DropDownState.loading:
                                    return LoadingAnimationDots(
                                      height: 50.sp,
                                    );
                                  case DropDownState.loaded:
                                    return Column(
                                      children: [
                                        AppDropDownFormField(
                                          header: 'District',
                                          placeHolder: 'Select',
                                          itemList: RegistrationController
                                              .to.districtsList,
                                          onChange: (DistrictModel? district) {
                                            RegistrationController
                                                .to.selectedDistrict = district;
                                          },
                                          value: RegistrationController
                                              .to.selectedDistrict,
                                          label: (DistrictModel district) =>
                                              district.name,
                                        ),
                                        SizedBox(
                                          height: 12.sp,
                                        ),
                                      ],
                                    );
                                }
                              }),
                              SizedBox(
                                height: 12.sp,
                              ),
                              AppTextFormField(
                                controller:
                                    RegistrationController.to.controllerAddress,
                                header: 'Address as per Documents',
                                placeHolder: "e.g. 221b baker street",
                                validator: (value) => Validators.isEmpty(
                                  value: value,
                                ),
                                maxLInes: 5,
                                minLines: 1,
                              ),
                              SizedBox(
                                height: 12.sp,
                              ),
                              RegistrationController.to.userTypeCode !=
                                      UserTypeCode.fleet
                                  ? Column(
                                      children: [
                                        AppDropDownFormField(
                                          header:
                                              'Experience in driving (Years)',
                                          placeHolder: 'Select',
                                          itemList: RegistrationController
                                              .to.yearsOfDrivingExperience,
                                          onChange: (WorkExperience?
                                              yearsOfDrivingExperience) {
                                            RegistrationController.to
                                                    .selectedYearsOfDrivingExperience =
                                                yearsOfDrivingExperience;
                                          },
                                          value: RegistrationController.to
                                              .selectedYearsOfDrivingExperience,
                                          label: (WorkExperience
                                                  yearsOfDrivingExperience) =>
                                              (yearsOfDrivingExperience
                                                          .experience ??
                                                      0)
                                                  .toString(),
                                        ),
                                        SizedBox(
                                          height: 12.sp,
                                        ),
                                        AppDropDownFormField(
                                          header:
                                              'Where you wish to work with us',
                                          placeHolder: 'Select',
                                          itemList: RegistrationController
                                              .to.statesList,
                                          onChange: (StatesModel? statesList) {
                                            RegistrationController.to
                                                .selectStatelist = statesList;
                                          },
                                          value: RegistrationController
                                              .to.selectStatelist,
                                          label: (StatesModel statesList) =>
                                              statesList.name,
                                        ),
                                        SizedBox(
                                          height: 12.sp,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Vehicle Types",
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: 15.sp,
                                                  color: AppColors.black,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 7.sp,
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
                                            children: RegistrationController
                                                .to.vehicleTypes
                                                .map((vehicle) =>
                                                    SelectVehicleTypeListingItem(
                                                      vehicle: vehicle,
                                                    ))
                                                .toList(),
                                          ),
                                        ),
                                        GetX<RegistrationController>(
                                            builder: (controller) {
                                          return controller
                                                  .showVehicleTypeError.value
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 2.sp,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Please select at least one vehicle type",
                                                          style: TextStyle(
                                                              fontSize: 12.sp,
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              : const SizedBox();
                                        }),
                                        SizedBox(
                                          height: 12.sp,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Familiar transmission types?",
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: 15.sp,
                                                  color: AppColors.black,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
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
                                            title: const Text(
                                                "Familiar transmission types"),
                                            children: RegistrationController
                                                .to.transmissionTypes
                                                .map((transmission) =>
                                                    SelectTransmissionTypeListingItem(
                                                      transmissionType:
                                                          transmission,
                                                    ))
                                                .toList(),
                                          ),
                                        ),
                                        GetX<RegistrationController>(
                                            builder: (controller) {
                                          return controller
                                                  .showTransmissionTypeError
                                                  .value
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 2.sp,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Please select at least one familiar transmission type",
                                                          style: TextStyle(
                                                              fontSize: 12.sp,
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              : const SizedBox();
                                        }),
                                        // AppDropDownFormField(
                                        //   header:
                                        //       'Familiar transmission types?',
                                        //   placeHolder: 'Select',
                                        //   itemList: RegistrationController
                                        //       .to.transmissionTypes,
                                        //   onChange:
                                        //       (Transmission? transmissionType) {
                                        //     RegistrationController.to
                                        //             .selectedTransmissionType =
                                        //         transmissionType;
                                        //   },
                                        //   value: RegistrationController
                                        //       .to.selectedTransmissionType,
                                        //   label: (Transmission?
                                        //           transmissionType) =>
                                        //       transmissionType?.name,
                                        // ),
                                        SizedBox(
                                          height: 12.sp,
                                        ),
                                        AppDatePickerFormField(
                                          header: 'License validity date?',
                                          placeHolder: "Select",
                                          initialDate: DateTime.now().add(
                                            const Duration(days: 28 * 6),
                                          ),
                                          startDate: DateTime.now().add(
                                            const Duration(days: 28 * 6),
                                          ),
                                          lastDate: DateTime.now().add(
                                            const Duration(days: 365 * 25),
                                          ),
                                          validator: (value) =>
                                              Validators.isEmpty(value: value),
                                          controller: RegistrationController
                                              .to.controllerLicenseValidityDate,
                                        ),
                                        SizedBox(
                                          height: 12.sp,
                                        ),
                                      ],
                                    )
                                  : const SizedBox(),
                              // const TermsAndConditions(),
                              // const PrivacyPolicy(),
                              SizedBox(
                                height: 25.sp,
                              ),
                              GetX<RegistrationController>(
                                  builder: (controller) {
                                return BlueButton(
                                  text: "Continue",
                                  isLoading:
                                      controller.isRegisterButtonLoading.value,
                                  onTap: () =>
                                      RegistrationController.to.register(),
                                );
                              }),
                              SizedBox(
                                height: 45.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
        },
      ),
    );
  }
}

class SelectVehicleTypeListingItem extends StatelessWidget {
  VehicleType vehicle;
  SelectVehicleTypeListingItem({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GetX<RegistrationController>(builder: (controller) {
          return Checkbox(
              value: vehicle.isSelected?.value,
              onChanged: (value) {
                vehicle.isSelected?.value = value ?? false;
                controller.showVehicleTypeError.value = false;
              });
        }),
        Text(vehicle.name ?? "")
      ],
    );
  }
}

class SelectTransmissionTypeListingItem extends StatelessWidget {
  Transmission transmissionType;
  SelectTransmissionTypeListingItem(
      {super.key, required this.transmissionType});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GetX<RegistrationController>(builder: (controller) {
          return Checkbox(
              value: transmissionType.isSelected?.value,
              onChanged: (value) {
                transmissionType.isSelected?.value = value ?? false;
                controller.showTransmissionTypeError.value = false;
              });
        }),
        Text(transmissionType.name ?? "")
      ],
    );
  }
}

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GetX<RegistrationController>(builder: (controller) {
              return Checkbox(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: controller.isAgreedToTermsAndConditions.value,
                  onChanged: (isAgreed) {
                    controller.isAgreedToTermsAndConditions.value =
                        !controller.isAgreedToTermsAndConditions.value;
                    controller.showTermsAndConditionsError.value = false;
                  });
            }),
            SizedBox(
              width: 5.sp,
            ),
            Text(
              "Lorem ipsum dolor sit amet",
              style: TextStyle(fontSize: 16.sp, color: AppColors.grey93),
            )
          ],
        ),
        GetX<RegistrationController>(builder: (controller) {
          return controller.showTermsAndConditionsError.value
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Please agree to Terms and Conditions",
                      style: TextStyle(fontSize: 14.sp, color: AppColors.red),
                    ),
                  ],
                )
              : const SizedBox();
        })
      ],
    );
  }
}

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GetX<RegistrationController>(builder: (controller) {
              return Checkbox(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: controller.isAgreedToPrivacyPolicy.value,
                  onChanged: (isAgreed) {
                    controller.isAgreedToPrivacyPolicy.value =
                        !controller.isAgreedToPrivacyPolicy.value;
                    controller.showPrivacyPolicyError.value = false;
                  });
            }),
            SizedBox(
              width: 5.sp,
            ),
            Text(
              "Lorem ipsum dolor sit amet",
              style: TextStyle(fontSize: 16.sp, color: AppColors.grey93),
            )
          ],
        ),
        GetX<RegistrationController>(builder: (controller) {
          return controller.showPrivacyPolicyError.value
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Please agree to Privacy Policy",
                      style: TextStyle(fontSize: 14.sp, color: AppColors.red),
                    ),
                  ],
                )
              : const SizedBox();
        })
      ],
    );
  }
}
