import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waiver_driver/backend/model/registration_certificate/registration_certificate_model.dart';
import 'package:waiver_driver/controller/chauffeur_proof/chauffeur_proof_controller.dart';
import 'package:waiver_driver/core/colors/app_colors.dart';
import 'package:waiver_driver/core/constants/enums/enums.dart';
import 'package:waiver_driver/core/themes/assets/icons.dart';
import 'package:waiver_driver/core/widgets/app_bar/app_bar.dart';
import 'package:waiver_driver/core/widgets/app_buttons/app_buttons.dart';
import 'package:waiver_driver/core/widgets/circle_with_gradient/circle_with_gradient.dart';
import 'package:waiver_driver/core/widgets/error_page/error_page.dart';
import 'package:waiver_driver/helper/router/app_routes/route.dart';
import 'package:waiver_driver/view/loading_animation/loading_animation.dart';

import '../../backend/api/api_services/api_services.dart';
import '../../backend/api/api_services/urls.dart';

class ChauffeurProofScreen extends StatelessWidget {
  const ChauffeurProofScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
       Get.lazyPut(() => ApiServices(appBaseUrl: AppUrls.base));
    Get.put(ChauffeurProofController(parser: Get.find()));
    return Scaffold(
      appBar: appBar(title: ""),
      body: GetX<ChauffeurProofController>(
        builder: (controller) {
          return controller.isLoading.value
              ? const LoadingBarsAnimation()
              : controller.isError.value
                  ? const ErrorPage()
                  : RefreshIndicator(
                      onRefresh: () async {
                        controller.onInit();
                      },
                      child: ListView(
                        padding: EdgeInsets.symmetric(horizontal: 15.sp),
                        children: [
                          SizedBox(
                            height: 20.sp,
                          ),
                          Text(
                            "Welcome, ${ChauffeurProofController.to.chauffeurName}",
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
                            "Please complete the required steps and start driving with Waiver",
                            style: TextStyle(
                              color: AppColors.grey93,
                              fontSize: 16.sp,
                              height: 1,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                          SizedBox(
                            height: 30.sp,
                          ),
                          const ChauffeurProofItemList(),
                          SizedBox(
                            height: 15.sp,
                          ),
                          const TermsAndConditionsChauffeurProof(),
                          SizedBox(
                            height: 30.sp,
                          ),
                          BlueButton(
                            text: "Continue",
                            onTap: () =>
                                ChauffeurProofController.to.continueTo(),
                          ),
                        ],
                      ),
                    );
        },
      ),
    );
  }
}

class TermsAndConditionsChauffeurProof extends StatelessWidget {
  const TermsAndConditionsChauffeurProof({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GetX<ChauffeurProofController>(builder: (controller) {
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
            GestureDetector(
              onTap: () async {
                final Uri termsConditions =
                    Uri.parse('https://waiverapp.in/termsandconditions.html');
                launchUrl(termsConditions);
              },
              child: SizedBox(
                child: RichText(
                    text: TextSpan(
                        text: "I agree to the ",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.grey93,
                        ),
                        children: [
                      TextSpan(
                          text: "Terms and Condition",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColors.blue,
                          ))
                    ])),
              ),
            )
          ],
        ),
        GetX<ChauffeurProofController>(builder: (controller) {
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

class ChauffeurProofItemList extends StatelessWidget {
  const ChauffeurProofItemList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.sp),
          border: Border.all(color: AppColors.grey155)),
      child: Column(
        children: [
          AddProofItem(
              proof: ChauffeurProofController.to.profilePhoto,
              onTap: () async {
                // await ChauffeurProofController.to.isConnectedToInternet();
                // if (ChauffeurProofController.to.isInternetConnected.value) {
                Get.toNamed(AppRoutes1.getAadharCardInRoute(),
                    arguments: ChauffeurProofController.to.profilePhoto);
                // } else {
                //   Get.snackbar("No Internet", "Please check your connection!");
                // }
              }),
          Container(
            height: 1,
            color: AppColors.grey155,
          ),
          AddProofItem(
            proof: ChauffeurProofController.to.aadharCard,
            onTap: () => Get.toNamed(AppRoutes1.getAadharCardInRoute(),
                arguments: ChauffeurProofController.to.aadharCard),
          ),
          Container(
            height: 1,
            color: AppColors.grey155,
          ),
          AddProofItem(
            proof: ChauffeurProofController.to.drivingLicense,
            onTap: () => Get.toNamed(AppRoutes1.getAadharCardInRoute(),
                arguments: ChauffeurProofController.to.drivingLicense),
          ),
          Container(
            height: 1,
            color: AppColors.grey155,
          ),
          AddProofItem(
            proof: ChauffeurProofController.to.policeClearanceCertificate,
            onTap: () => Get.toNamed(AppRoutes1.getAadharCardInRoute(),
                arguments:
                    ChauffeurProofController.to.policeClearanceCertificate),
          ),
          Container(
            height: 1,
            color: AppColors.grey155,
          ),
          AddProofItem(
            proof: ChauffeurProofController.to.bankAccount,
            onTap: () => Get.toNamed(AppRoutes1.getBankAccountInRoute()),
          ),
          Container(
            height: 1,
            color: AppColors.grey155,
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class AddProofItem extends StatelessWidget {
  ProofModel proof;
  Function() onTap;

  AddProofItem({super.key, required this.proof, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        proof.status.value == ApprovalStatus.notUpload ||
                proof.status.value == ApprovalStatus.rejected ||
                true
            ? onTap()
            : null;
      },
      child: Container(
        color: AppColors.white,
        padding: EdgeInsets.all(16.sp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(proof.text,
                style: TextStyle(
                    color: AppColors.black,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600)),
            Obx(() {
              return ChauffeurProofItemContainer(
                status: proof.status.value,
              );
            })
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ChauffeurProofItemContainer extends StatelessWidget {
  ApprovalStatus status;

  ChauffeurProofItemContainer({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case ApprovalStatus.notUpload:
        return SvgPicture.asset(
          AppIcons.arrowRight,
          height: 15.sp,
        );
      case ApprovalStatus.waitingForApproval:
        return CircleWithIcon(
          height: 20.sp,
          color: AppColors.blue,
          child: Icon(
            Icons.timelapse,
            size: 16.sp,
            color: AppColors.white,
          ),
        );

      case ApprovalStatus.approved:
        return CircleWithIcon(
          height: 20.sp,
          color: AppColors.green40,
          child: Icon(
            Icons.check,
            size: 16.sp,
            color: AppColors.white,
          ),
        );
      case ApprovalStatus.rejected:
        return CircleWithIcon(
          height: 20.sp,
          color: AppColors.red,
          child: Icon(
            Icons.close,
            size: 16.sp,
            color: AppColors.white,
          ),
        );
    }
  }
}
