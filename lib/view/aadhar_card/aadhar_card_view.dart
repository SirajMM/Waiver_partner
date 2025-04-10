import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:waiver_driver/backend/api/api_services/urls.dart';
import 'package:waiver_driver/controller/aadhar_card/aadhar_card_controller.dart';
import 'package:waiver_driver/core/colors/app_colors.dart';
import 'package:waiver_driver/core/constants/enums/enums.dart';
import 'package:waiver_driver/core/widgets/app_bar/app_bar.dart';
import 'package:waiver_driver/core/widgets/app_buttons/app_buttons.dart';
import 'package:waiver_driver/core/widgets/circle_with_gradient/circle_with_gradient.dart';
import 'package:waiver_driver/core/widgets/error_page/error_page.dart';
import 'package:waiver_driver/core/widgets/test_fields/app_text_form_fields.dart';
import 'package:waiver_driver/core/widgets/upload_image_template/upload_image_template.dart';
import 'package:waiver_driver/helper/validator/validators/validators.dart';
import 'package:waiver_driver/view/loading_animation/loading_animation.dart';

import '../../backend/api/api_services/api_services.dart';
import '../profile_photo/profile_photo_view.dart';

class AadharCardScreen extends StatelessWidget {
  const AadharCardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ApiServices(appBaseUrl: AppUrls.base));
    return Scaffold(
        appBar: appBar(title: ""),
        body: GetX<AadharCardController>(builder: (controller) {
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
                          controller.text ?? "",
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
                          controller.subtext ?? "",
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
                        // SizedBox(
                        //   height: 180.sp,
                        //   child:
                        //       GetX<AadharCardController>(builder: (controller) {
                        //     return ListView(
                        //       shrinkWrap: true,
                        //       scrollDirection: Axis.horizontal,
                        //       children: (controller.imageList.length !=
                        //                   controller.maxImages
                        //               ? [
                        //                   UpLoadImageTemplate(
                        //                       height: 180.sp,
                        //                       width: 270.sp,
                        //                       placeHolder: "Add Proof",
                        //                       isRectangle: true,
                        //                       image:  "",
                        //                       onTap: (ImageSource source) =>
                        //                           controller.uploadPhoto(
                        //                               source: source))
                        //                 ]
                        //               : <Widget>[]) +
                        //           controller.imageList
                        //               .map((element) => UpLoadImageTemplate(
                        //                   height: 180.sp,
                        //                   width: 270.sp,
                        //                   closeOnTap: () => controller.imageList
                        //                       .remove(element),
                        //                   placeHolder: "",
                        //                   isRectangle: true,
                        //                   image: element.file ?? "",
                        //                   onTap: (ImageSource source) =>
                        //                       controller.uploadPhoto(
                        //                           source: source)))
                        //               .toList(),
                        //     );
                        //   }),
                        // ),
                        // Modify this part of your AadharCardScreen to show loading indicator
                        SizedBox(
                          height: 180.sp,
                          child:
                              GetX<AadharCardController>(builder: (controller) {
                            return ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: <Widget>[
                                if (controller.imageList.length !=
                                    controller.maxImages)
                                  Stack(
                                    children: [
                                      UpLoadImageTemplate(
                                          height: 180.sp,
                                          width: 270.sp,
                                          placeHolder: "Add Proof",
                                          isRectangle: true,
                                          image: "",
                                          onTap: (ImageSource source) =>
                                              controller.isUploading.value
                                                  ? null
                                                  : controller.uploadPhoto(
                                                      source: source)),
                                      if (controller.isUploading.value)
                                        Positioned.fill(
                                          child: Container(
                                            height: 180.sp,
                                            width: 270.sp,
                                            color:
                                                Colors.black.withOpacity(0.0),
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(AppColors.blue),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ...controller.imageList
                                    .map((element) => Stack(
                                          children: [
                                            UpLoadImageTemplate(
                                                height: 180.sp,
                                                width: 270.sp,
                                                closeOnTap: () => controller
                                                        .isUploading.value
                                                    ? null
                                                    : controller.imageList
                                                        .remove(element),
                                                placeHolder: "",
                                                isRectangle: true,
                                                image: element.file ?? "",
                                                onTap: (ImageSource source) =>
                                                    controller.isUploading.value
                                                        ? null
                                                        : controller
                                                            .uploadPhoto(
                                                                source:
                                                                    source)),
                                            if (controller.isUploading.value)
                                              Positioned.fill(
                                                child: Container(
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                                  Color>(
                                                              AppColors.blue),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ))
                                    .toList(),
                              ],
                            );
                          }),
                        ),
                        GetX<AadharCardController>(builder: (controller) {
                          return controller.showErrorMessage.value
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 5.sp,
                                    ),
                                    Text(
                                      controller.errorMessage.value,
                                      style: TextStyle(color: AppColors.red),
                                    ),
                                  ],
                                )
                              : const SizedBox();
                        }),
                        (controller.status.value == ApprovalStatus.rejected)
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20.sp,
                                  ),
                                  const Text(
                                      "Your documents has been rejected because :"),
                                  Text(
                                    controller.rejection?.reason ?? "",
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
                        (controller.status.value == ApprovalStatus.rejected)
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: Get.width * .43,
                                    child: BlueButton(
                                      text: "Appeal",
                                      onTap: () => Get.bottomSheet(
                                          const AppealForRejectionBottomSheet(),
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
                                      onTap: () => AadharCardController.to
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
                                  onTap: () =>
                                      AadharCardController.to.uploadDocument(),
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
                        SizedBox(
                          height: 30.sp,
                        ),
                      ],
                    );
        }));
  }
}

class AppealForRejectionBottomSheet extends StatelessWidget {
  const AppealForRejectionBottomSheet({super.key});

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
          const Text("Your documents has been rejected because :"),
          Text(
            AadharCardController.to.rejection?.reason ?? "",
            style: TextStyle(color: AppColors.red),
          ),
          Form(
            key: AadharCardController.to.formKeyRejection,
            child: AppTextFormField(
              controller: AadharCardController.to.userResponseToRejection,
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
            onTap: () => AadharCardController.to.documentRejectionResponse(),
          )
        ],
      ),
    );
  }
}
