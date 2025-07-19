import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waiver_driver/backend/model/profile/profile_model.dart'
    as profileModel;
import 'package:waiver_driver/backend/model/registration/registration_model.dart';
import 'package:waiver_driver/controller/profile/profile_controller.dart';
import 'package:waiver_driver/core/colors/app_colors.dart';
import 'package:waiver_driver/core/constants/get_storage_constants.dart';
import 'package:waiver_driver/core/themes/assets/icons.dart';
import 'package:waiver_driver/core/widgets/app_bar/app_bar.dart';
import 'package:waiver_driver/core/widgets/app_buttons/app_buttons.dart';
import 'package:waiver_driver/core/widgets/app_network_image/app_network_image.dart';
import 'package:waiver_driver/core/widgets/circle_with_gradient/circle_with_gradient.dart';
import 'package:waiver_driver/core/widgets/error_page/error_page.dart';
import 'package:waiver_driver/core/widgets/test_fields/app_test_form_field_calender.dart';
import 'package:waiver_driver/core/widgets/test_fields/app_text_form_fields.dart';
import 'package:waiver_driver/helper/validator/validators/validators.dart';
import 'package:waiver_driver/main.dart';
import 'package:waiver_driver/view/loading_animation/loading_animation.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(title: "Profile", actions: [
          GestureDetector(
              onTap: () async {
                final Uri whatsapp = Uri.parse(
                    'https://api.whatsapp.com/send?phone=918943099085&text=Hi');
                launchUrl(whatsapp);
              },
              // =>
              //     Get.toNamed(AppRoutes.help),
              child: Container(
                  margin: EdgeInsets.all(10.sp),
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: AppColors.grey155, width: 1.5.sp),
                      shape: BoxShape.circle),
                  padding: EdgeInsets.all(5.sp),
                  child: Image.asset(
                    AppIcons.customerSupport,
                    color: Get.theme.indicatorColor,
                  )))
        ]),
        body: GetX<ProfileController>(builder: (controller) {
          return controller.isLoading.value
              ? const LoadingBarsAnimation()
              : controller.isError.value
                  ? const ErrorPage()
                  : SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.sp),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 24.sp,
                            ),
                            box.read(BoxKeys.userTypeCode) == UserTypeCode.fleet
                                ? SizedBox()
                                : const ProfilePhoto(),
                            SizedBox(
                              height: 24.sp,
                            ),
                            AppTextFormField(
                              readOnly: true,
                              controller:
                                  ProfileController.to.controllerFullName,
                              header: "Full Name",
                            ),
                            SizedBox(
                              height: 12.sp,
                            ),
                            AppTextFormField(
                              controller: ProfileController.to.controllerEmail,
                              header: 'Email Address',
                              placeHolder: "e.g. alex@gmail.com",
                              validator: (value) => Validators.isEMail(
                                value: value,
                              ),
                              textInputType: TextInputType.emailAddress,
                              readOnly: true,
                              icon: BlueButton(
                                text: "Edit",
                                fontSize: 12.sp,
                                onTap: () => Get.bottomSheet(
                                    const ChangeEmailBottomSheet()),
                              ),
                            ),
                            SizedBox(
                              height: 12.sp,
                            ),
                            AppDropDownFormField(
                              header: 'Gender',
                              readOnly: true,
                              placeHolder: 'Select',
                              itemList: ProfileController.to.genderList,
                              onChange: (GenderModel? gender) {
                                ProfileController.to.selectedGender = gender;
                              },
                              value: ProfileController.to.selectedGender,
                              label: (GenderModel? gender) => gender?.label,
                            ),
                            SizedBox(height: 12.sp.h),
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
                                  ProfileController.to.controllerDateOfBirth,
                            ),
                            SizedBox(
                              height: 12.sp,
                            ),
                            Text("Registered Phone Number",
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600)),
                            SizedBox(
                              height: 7.sp,
                            ),
                            Container(
                              height: 45.sp,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColors.grey155),
                              child: Center(
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 14.sp,
                                    ),
                                    Text(
                                      ProfileController.to.regPhoneNumber ?? "",
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          color: AppColors.grey93),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 12.sp,
                            ),
                            AppTextFormField(
                              controller: ProfileController
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
                              icon: BlueButton(
                                text: "Edit",
                                fontSize: 12.sp,
                                onTap: () => Get.bottomSheet(
                                    const ChangeAlternativeNumberBottomSheet()),
                              ),
                            ),
                            SizedBox(
                              height: 12.sp,
                            ),
                            AppTextFormField(
                              controller:
                                  ProfileController.to.controllerWhatsAppNumber,
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
                              icon: BlueButton(
                                text: "Edit",
                                fontSize: 12.sp,
                                onTap: () => Get.bottomSheet(
                                    const ChangeWhatAppNumberBottomSheet()),
                              ),
                            ),
                            SizedBox(
                              height: 12.sp,
                            ),
                            Text("State",
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600)),
                            SizedBox(
                              height: 7.sp,
                            ),
                            Container(
                              height: 45.sp,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColors.grey155),
                              child: Center(
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 14.sp,
                                    ),
                                    Text(
                                      ProfileController.to.state ?? "",
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          color: AppColors.grey93),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            // AppDropDownFormField(
                            //   header: 'State',
                            //   placeHolder: 'Select',
                            //   readOnly: true,
                            //   itemList: ProfileController.to.statesList,
                            //   onChange: (StatesModel? state) {
                            //     ProfileController.to.selectedState = state;
                            //   },
                            //   value: ProfileController.to.selectedState,
                            //   label: (StatesModel state) => state.name,
                            // ),
                            SizedBox(
                              height: 12.sp,
                            ),
                            // AppDropDownFormField(
                            //   header: 'District',
                            //   readOnly: true,
                            //   placeHolder: 'Select',
                            //   itemList: ProfileController.to.districtsList,
                            //   onChange: (DistrictModel? district) {
                            //     ProfileController.to.selectedDistrict = district;
                            //   },
                            //   value: ProfileController.to.selectedDistrict,
                            //   label: (DistrictModel? district) => district?.name,
                            // ),
                            Text("District",
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600)),
                            SizedBox(
                              height: 7.sp,
                            ),
                            Container(
                              height: 45.sp,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColors.grey155),
                              child: Center(
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 14.sp,
                                    ),
                                    Text(
                                      ProfileController.to.district ?? "",
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          color: AppColors.grey93),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 12.sp,
                            ),
                            AppTextFormField(
                              controller:
                                  ProfileController.to.controllerAddress,
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
                            ProfileController.to.userTypeCode !=
                                    UserTypeCode.fleet
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // AppDropDownFormField(
                                      //   readOnly: true,
                                      //   header: 'Experience in driving (Years)',
                                      //   placeHolder: 'Select',
                                      //   itemList: ProfileController
                                      //       .to.yearsOfDrivingExperience,
                                      //   onChange: (WorkExperience?
                                      //       yearsOfDrivingExperience) {
                                      //     ProfileController.to
                                      //             .selectedYearsOfDrivingExperience =
                                      //         yearsOfDrivingExperience;
                                      //   },
                                      //   value: ProfileController
                                      //       .to.selectedYearsOfDrivingExperience,
                                      //   label: (WorkExperience
                                      //           yearsOfDrivingExperience) =>
                                      //       yearsOfDrivingExperience.experience
                                      //           .toString(),
                                      // ),
                                      Text("Experience in driving (Years)",
                                          style: TextStyle(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w600)),
                                      SizedBox(
                                        height: 7.sp,
                                      ),
                                      Container(
                                        height: 45.sp,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: AppColors.grey155),
                                        child: Center(
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 14.sp,
                                              ),
                                              Text(
                                                ProfileController
                                                        .to.experience ??
                                                    "",
                                                style: TextStyle(
                                                    fontSize: 16.sp,
                                                    color: AppColors.grey93),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 12.sp,
                                      ),
                                      // AppDropDownFormField(
                                      //   readOnly: true,
                                      //   header: 'Where you wish to work with us',
                                      //   placeHolder: 'Select',
                                      //   itemList:
                                      //       ProfileController.to.workingLocations,
                                      //   onChange: (WorkLocation? workingLocation) {
                                      //     ProfileController
                                      //             .to.selectedWorkingLocation =
                                      //         workingLocation;
                                      //   },
                                      //   value: ProfileController
                                      //       .to.selectedWorkingLocation,
                                      //   label: (WorkLocation workingLocation) =>
                                      //       workingLocation.name,
                                      // ),
                                      Text("Work Location",
                                          style: TextStyle(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w600)),
                                      SizedBox(
                                        height: 7.sp,
                                      ),
                                      Container(
                                        height: 45.sp,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: AppColors.grey155),
                                        child: Center(
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 14.sp,
                                              ),
                                              Text(
                                                ProfileController
                                                        .to.workingLocation ??
                                                    "",
                                                style: TextStyle(
                                                    fontSize: 16.sp,
                                                    color: AppColors.grey93),
                                              )
                                            ],
                                          ),
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
                                          title: const Text("Vehicle Types"),
                                          children: ProfileController
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
                                      // AppDropDownFormField(
                                      //   readOnly: true,
                                      //   header: 'Familiar transmission type?',
                                      //   placeHolder: 'Select',
                                      //   itemList:
                                      //       ProfileController.to.transmissionTypes,
                                      //   onChange: (Transmission? transmissionType) {
                                      //     ProfileController
                                      //             .to.selectedTransmissionType =
                                      //         transmissionType;
                                      //   },
                                      //   value: ProfileController
                                      //       .to.selectedTransmissionType,
                                      //   label: (Transmission? transmissionType) =>
                                      //       transmissionType?.name,
                                      // ),
                                      // Text("Familiar Transmission type",
                                      //     style: TextStyle(
                                      //         fontSize: 15.sp,
                                      //         fontWeight: FontWeight.w600)),
                                      // SizedBox(
                                      //   height: 7.sp,
                                      // ),
                                      // Container(
                                      //   height: 45.sp,
                                      //   decoration: BoxDecoration(
                                      //       borderRadius:
                                      //           BorderRadius.circular(8),
                                      //       color: AppColors.grey155),
                                      //   child: Center(
                                      //     child: Row(
                                      //       children: [
                                      //         SizedBox(
                                      //           width: 14.sp,
                                      //         ),
                                      //         Text(
                                      //           ProfileController
                                      //                   .to.transmissionType ??
                                      //               "",
                                      //           style: TextStyle(
                                      //               fontSize: 16.sp,
                                      //               color: AppColors.grey93),
                                      //         )
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
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
                                          children: ProfileController
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
                                      AppDatePickerFormField(
                                        readOnly: true,
                                        readOnlyCallBack: () => Get.bottomSheet(
                                            const ChangeLicenseValidityDateBottomSheet()),
                                        header: 'License validity date?',
                                        placeHolder: "Select",
                                        startDate: DateTime.now(),
                                        lastDate: DateTime.now().add(
                                            const Duration(days: 365 * 25)),
                                        validator: (value) =>
                                            Validators.isEmpty(value: value),
                                        controller: ProfileController
                                            .to.controllerLicenseValidityDate,
                                        icon: BlueButton(
                                          text: "Edit",
                                          fontSize: 12.sp,
                                          onTap: () => Get.bottomSheet(
                                              const ChangeLicenseValidityDateBottomSheet()),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30.sp,
                                      ),

                                      ProfileController
                                                  .to.has_Vehicle_Assigned ==
                                              true
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Assinged Vehicle :-",
                                                    style: TextStyle(
                                                        fontSize: 17.sp,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                                SizedBox(
                                                  height: 20.sp,
                                                ),
                                                Text("Vehicle Name",
                                                    style: TextStyle(
                                                        fontSize: 15.sp,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                                SizedBox(
                                                  height: 7.sp,
                                                ),
                                                Container(
                                                  height: 45.sp,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      color: AppColors.grey155),
                                                  child: Center(
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 14.sp,
                                                        ),
                                                        Text(
                                                          ProfileController
                                                                  .to
                                                                  .vehicleDetails
                                                                  ?.name ??
                                                              "",
                                                          style: TextStyle(
                                                              fontSize: 16.sp,
                                                              color: AppColors
                                                                  .grey93),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 12.sp,
                                                ),
                                                Text("Brand",
                                                    style: TextStyle(
                                                        fontSize: 15.sp,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                                SizedBox(
                                                  height: 7.sp,
                                                ),
                                                Container(
                                                  height: 45.sp,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      color: AppColors.grey155),
                                                  child: Center(
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 14.sp,
                                                        ),
                                                        Text(
                                                          ProfileController
                                                                  .to
                                                                  .vehicleDetails
                                                                  ?.brand ??
                                                              "",
                                                          style: TextStyle(
                                                              fontSize: 16.sp,
                                                              color: AppColors
                                                                  .grey93),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 12.sp,
                                                ),
                                                Text("Registration Number ",
                                                    style: TextStyle(
                                                        fontSize: 15.sp,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                                SizedBox(
                                                  height: 7.sp,
                                                ),
                                                Container(
                                                  height: 45.sp,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      color: AppColors.grey155),
                                                  child: Center(
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 14.sp,
                                                        ),
                                                        Text(
                                                          ProfileController
                                                                  .to
                                                                  .vehicleDetails
                                                                  ?.registrationNumber ??
                                                              "",
                                                          style: TextStyle(
                                                              fontSize: 16.sp,
                                                              color: AppColors
                                                                  .grey93),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 12.sp,
                                                ),
                                                Text("Transmission Type",
                                                    style: TextStyle(
                                                        fontSize: 15.sp,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                                SizedBox(
                                                  height: 7.sp,
                                                ),
                                                Container(
                                                  height: 45.sp,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      color: AppColors.grey155),
                                                  child: Center(
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 14.sp,
                                                        ),
                                                        Text(
                                                          ProfileController.to.getTransmissionTypeName(
                                                              ProfileController
                                                                  .to
                                                                  .transmissionType,
                                                              ProfileController
                                                                  .to
                                                                  .vehicleDetails
                                                                  ?.transmissionType),
                                                          style: TextStyle(
                                                              fontSize: 16.sp,
                                                              color: AppColors
                                                                  .grey93),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : const SizedBox(),

                                      SizedBox(
                                        height: 30.sp,
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                            BlueButton(
                              text: "Help",
                              // onTap: () => Get.back(),
                              onTap: () async {
                                final Uri whatsapp = Uri.parse(
                                    'https://api.whatsapp.com/send?phone=918943099085&text=Hi');
                                launchUrl(whatsapp);
                              },
                            ),
                            SizedBox(
                              height: 30.sp,
                            ),
                          ],
                        ),
                      ),
                    );
        }));
  }
}

class ChangeEmailBottomSheet extends StatelessWidget {
  const ChangeEmailBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.sp),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.sp),
            topRight: Radius.circular(8.sp),
          )),
      child: ListView(
        shrinkWrap: true,
        children: [
          Text(
            "Email Address",
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 15.sp,
          ),
          Form(
            key: ProfileController.to.changeEmailFormKey,
            child: AppTextFormField(
              controller: ProfileController.to.controllerEmail,
              header: 'Email Address',
              placeHolder: "e.g. muhammed@gmail.com",
              validator: (value) => Validators.isEMail(
                value: value,
              ),
              textInputType: TextInputType.emailAddress,
              icon: CircleWithIcon(
                height: 25,
                onTap: () => Get.back(),
                color: AppColors.black,
                child: Icon(
                  Icons.close,
                  size: 15.sp,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 25.sp,
          ),
          GetX<ProfileController>(builder: (controller) {
            return BlueButton(
              text: "Save Change",
              isLoading: controller.isSaveChangeButtonLoading.value,
              onTap: () => ProfileController.to.saveChangeEmail(),
            );
          })
        ],
      ),
    );
  }
}

class ChangeAlternativeNumberBottomSheet extends StatelessWidget {
  const ChangeAlternativeNumberBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.sp),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.sp),
            topRight: Radius.circular(8.sp),
          )),
      child: ListView(
        shrinkWrap: true,
        children: [
          Text(
            "Alternative Number",
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 15.sp,
          ),
          Form(
            key: ProfileController.to.changeAlternativeNumber,
            child: AppTextFormField(
              controller: ProfileController.to.controllerAlternativeNumber,
              header: '',
              maxLength: 10,
              placeHolder: " e.g. xxxxxxxxxx",
              validator: (value) => Validators.isMobile(
                value: value,
              ),
              textInputType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              icon: CircleWithIcon(
                height: 25,
                onTap: () => Get.back(),
                color: AppColors.black,
                child: Icon(
                  Icons.close,
                  size: 15.sp,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 25.sp,
          ),
          GetX<ProfileController>(builder: (controller) {
            return BlueButton(
              text: "Save Change",
              isLoading: controller.isSaveChangeButtonLoading.value,
              onTap: () => ProfileController.to.saveChangeAlternativeNumber(),
            );
          })
        ],
      ),
    );
  }
}

class ChangeWhatAppNumberBottomSheet extends StatelessWidget {
  const ChangeWhatAppNumberBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.sp),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.sp),
            topRight: Radius.circular(8.sp),
          )),
      child: ListView(
        shrinkWrap: true,
        children: [
          Text(
            "WhatApp Number",
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 15.sp,
          ),
          Form(
            key: ProfileController.to.changeWhatsAppNumber,
            child: AppTextFormField(
              controller: ProfileController.to.controllerWhatsAppNumber,
              header: '',
              maxLength: 10,
              placeHolder: " e.g. xxxxxxxxxx",
              validator: (value) => Validators.isMobile(
                value: value,
              ),
              textInputType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              icon: CircleWithIcon(
                height: 25,
                onTap: () => Get.back(),
                color: AppColors.black,
                child: Icon(
                  Icons.close,
                  size: 15.sp,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 25.sp,
          ),
          GetX<ProfileController>(builder: (controller) {
            return BlueButton(
              text: "Save Change",
              isLoading: controller.isSaveChangeButtonLoading.value,
              onTap: () => ProfileController.to.saveChangeWhatsAppNumber(),
            );
          })
        ],
      ),
    );
  }
}

class ChangeLicenseValidityDateBottomSheet extends StatelessWidget {
  const ChangeLicenseValidityDateBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.sp),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.sp),
            topRight: Radius.circular(8.sp),
          )),
      child: ListView(
        shrinkWrap: true,
        children: [
          Text(
            "License Validity Date",
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 15.sp,
          ),
          Form(
            key: ProfileController.to.changeLicenseValidityDateNumber,
            child: AppDatePickerFormField(
              header: 'License validity date?',
              placeHolder: "Select",
              startDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365 * 25)),
              validator: (value) => Validators.isEmpty(value: value),
              controller: ProfileController.to.controllerLicenseValidityDate,
              icon: CircleWithIcon(
                height: 25,
                onTap: () => Get.back(),
                color: AppColors.black,
                child: Icon(
                  Icons.close,
                  size: 15.sp,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 25.sp,
          ),
          GetX<ProfileController>(builder: (controller) {
            return BlueButton(
              text: "Save Change",
              isLoading: controller.isSaveChangeButtonLoading.value,
              onTap: () =>
                  ProfileController.to.saveChangeLicenseValidityDateNumber(),
            );
          })
        ],
      ),
    );
  }
}

class ProfilePhoto extends StatelessWidget {
  const ProfilePhoto({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppNetworkImage(
          imageUrl: ProfileController.to.profileImage,
          dontUseBaseUrl: true,
          height: 130.sp,
          width: 130.sp,
          radius: 70.sp,
          isProfile: true,
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class SelectVehicleTypeListingItemProfile extends StatelessWidget {
  profileModel.State vehicle;
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

// ignore: must_be_immutable
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
