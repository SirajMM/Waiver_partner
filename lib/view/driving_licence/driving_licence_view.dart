import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:waiver_driver/controller/driving_licence/driving_licence_controller.dart';
import 'package:waiver_driver/core/colors/app_colors.dart';
import 'package:waiver_driver/core/widgets/app_bar/app_bar.dart';
import 'package:waiver_driver/core/widgets/app_buttons/app_buttons.dart';
import 'package:waiver_driver/core/widgets/circle_with_gradient/circle_with_gradient.dart';
import 'package:waiver_driver/core/widgets/error_page/error_page.dart';
import 'package:waiver_driver/core/widgets/test_fields/app_text_form_fields.dart';
import 'package:waiver_driver/core/widgets/upload_image_template/upload_image_template.dart';
import 'package:waiver_driver/helper/validator/validators/validators.dart';

import '../loading_animation/loading_animation.dart';
import '../profile_photo/profile_photo_view.dart';


class DrivingLicenceScreen extends StatelessWidget {
  const DrivingLicenceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(title: ""),
        body: GetX<DrivingLicenceController>(builder: (controller) {
          return controller.isLoading.value
              ? const LoadingBarsAnimation()
              : controller.isError.value
                  ? const ErrorPage()
                  : ListView(
                      padding: EdgeInsets.symmetric(horizontal: 15.sp),
                      children: [
                        SizedBox(
                          height: 20.sp,
                        ),
                        Text(
                          "Driving Licence",
                          style: TextStyle(
                              color: AppColors.black,
                              height: 1,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 12.sp,
                        ),
                        Text(
                          "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumyLorem ipsum dolor sit amet, consetetur.",
                          style: TextStyle(
                              color: AppColors.grey93,
                              fontSize: 16.sp,
                              height: 1,
                              fontWeight: FontWeight.w200),
                        ),
                        SizedBox(
                          height: 30.sp,
                        ),
                        ChauffeurProofInstructionItem(
                          text: "Photocopies and printout are not acceptable",
                        ),
                        SizedBox(
                          height: 8.sp,
                        ),
                        ChauffeurProofInstructionItem(
                          text:
                              "Uploaded document should be less than 10MB and it should belong to JPG, JPEG, PNG, PDF type only",
                        ),
                        SizedBox(
                          height: 30.sp,
                        ),
                        SizedBox(
                          height: 180.sp,
                          child: GetX<DrivingLicenceController>(
                              builder: (controller) {
                            return ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: [
                                    UpLoadImageTemplate(
                                        height: 180.sp,
                                        width: 270.sp,
                                        placeHolder: "Add Proof",
                                        isRectangle: true,
                                        image: "",
                                        onTap: (ImageSource source) =>
                                            controller.uploadPhoto(
                                                source: source,
                                                isFrontSide: true))
                                  ] +
                                  controller.imageList
                                      .map((element) => UpLoadImageTemplate(
                                          height: 180.sp,
                                          width: 270.sp,
                                          closeOnTap: () => controller.imageList
                                              .remove(element),
                                          placeHolder: "",
                                          isRectangle: true,
                                          image: element.file ?? "",
                                          onTap: (ImageSource source) =>
                                              controller.uploadPhoto(
                                                  source: source,
                                                  isFrontSide: true)))
                                      .toList(),
                            );
                          }),
                        ),
                        GetX<DrivingLicenceController>(builder: (controller) {
                          return controller.showErrorMessageDrivingLicence.value
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 5.sp,
                                    ),
                                    Text(
                                      controller
                                          .errorMessageDrivingLicence.value,
                                      style: TextStyle(color: AppColors.red),
                                    ),
                                  ],
                                )
                              : const SizedBox();
                        }),
                        controller.isRejected
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20.sp,
                                  ),
                                  const Text(
                                      "Your aadhar card has been rejected because :"),
                                  Text(
                                    controller.rejectionReason,
                                    style: TextStyle(color: AppColors.red),
                                  ),
                                  SizedBox(
                                    height: 40.sp,
                                  )
                                ],
                              )
                            : SizedBox(
                                height: 60.sp,
                              ),
                        controller.isRejected
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: Get.width * .43,
                                    child: BlueButton(
                                      text: "Appeal",
                                      onTap: () => Get.bottomSheet(
                                          const AppealForRejectionBottomSheetDrivingLisence(),
                                          isScrollControlled: true),
                                      prefixIcon: CircleWithIcon(
                                        height: 25.sp,
                                        color: AppColors.white,
                                        child: Icon(
                                          Icons.upload,
                                          size: 20.sp,
                                          color: AppColors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: Get.width * .43,
                                    child: BlueButton(
                                      text: "Upload",
                                      onTap: () => DrivingLicenceController.to
                                          .uploadDocument(),
                                      prefixIcon: CircleWithIcon(
                                        height: 25.sp,
                                        color: AppColors.white,
                                        child: Icon(
                                          Icons.add,
                                          size: 20.sp,
                                          color: AppColors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(
                                width: Get.width * .43,
                                child: BlueButton(
                                  text: "Upload",
                                  onTap: () => DrivingLicenceController.to
                                      .uploadDocument(),
                                  prefixIcon: CircleWithIcon(
                                    height: 25.sp,
                                    color: AppColors.white,
                                    child: Icon(
                                      Icons.add,
                                      size: 20.sp,
                                      color: AppColors.blue,
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    );
        }));
  }
}

class AppealForRejectionBottomSheetDrivingLisence extends StatelessWidget {
  const AppealForRejectionBottomSheetDrivingLisence({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      margin: EdgeInsets.all(10.sp),
      padding: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
          color: AppColors.white, borderRadius: BorderRadius.circular(10.sp)),
      child: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(
            height: 20.sp,
          ),
          const Text("Your aadhar card has been rejected because :"),
          Text(
            DrivingLicenceController.to.rejectionReason,
            style: TextStyle(color: AppColors.red),
          ),
          Form(
            key: DrivingLicenceController.to.uploadProofLisenceFormKey,
            child: AppTextFormField(
              controller: DrivingLicenceController.to.userResponseToRejection,
              header: "Appeal",
              placeHolder: "eg : Uploaded new photos",
              maxLength: 200,
              maxLInes: 5,
              validator: (value) => Validators.isEmpty(value: value),
            ),
          ),
          SizedBox(
            height: 20.sp,
          ),
          BlueButton(
            text: "Appeal",
            onTap: () =>
                DrivingLicenceController.to.documentRejectionResponse(),
          )
        ],
      ),
    );
  }
}
