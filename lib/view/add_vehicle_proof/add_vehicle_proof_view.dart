import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waiver_driver/controller/add_vehicle_proof/add_vehicle_proof_controller.dart';
import 'package:waiver_driver/core/colors/app_colors.dart';
import 'package:waiver_driver/core/widgets/app_bar/app_bar.dart';
import 'package:waiver_driver/core/widgets/app_buttons/app_buttons.dart';


import '../../helper/router/app_routes/route.dart';
import '../chauffeur_proof/chauffeur_proof_view.dart';


class AddVehicleProofScreen extends StatelessWidget {
  const AddVehicleProofScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.transparent,
        elevation: 0,
        isExtended: true,
        onPressed: () {
          AddVehicleProofController.to.submit();
        },
        label: BlueButton(
          width: Get.width - 60.sp,
          // prefixIcon: CircleWithIcon(
          //   color: AppColors.white,
          //   height: 25.sp,
          //   child: Icon(
          //     Icons.add,
          //     color: AppColors.blue,
          //   ),
          // ),
          text: "Submit",
        ),
      ),
      appBar: appBar(title: "Add vehicle proof"),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 25.sp),
        children: [
          const AddVehicleDetailsContainer(),
          SizedBox(
            height: 15.sp,
          ),
          const TermsAndConditionsAddVehicle()
        ],
      ),
    );
  }
}

class TermsAndConditionsAddVehicle extends StatelessWidget {
  const TermsAndConditionsAddVehicle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GetX<AddVehicleProofController>(builder: (controller) {
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
              onTap: ()async{
                final Uri termsConditions= Uri.parse('https://www.driverify.in/terms-conditions');
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
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        GetX<AddVehicleProofController>(
          builder: (controller) {
            return controller.showTermsAndConditionsError.value
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Please agree to Terms and Conditions",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.red,
                        ),
                      ),
                    ],
                  )
                : const SizedBox();
          },
        ),
      ],
    );
  }
}

class AddVehicleDetailsContainer extends StatelessWidget {
  const AddVehicleDetailsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey155),
        borderRadius: BorderRadius.circular(8.sp),
      ),
      child: Column(
        children: [
          AddProofItem(
            proof: AddVehicleProofController.to.registrationCertificate,
            onTap: () => Get.toNamed(
              AppRoutes1.aadharCard,
              arguments: AddVehicleProofController.to.registrationCertificate,
            ),
          ),
          Container(
            height: 1,
            color: AppColors.grey155,
          ),
          AddProofItem(
            proof: AddVehicleProofController.to.vehicleInsurance,
            onTap: () => Get.toNamed(
              AppRoutes1.aadharCard,
              arguments: AddVehicleProofController.to.vehicleInsurance,
            ),
          ),
          Container(
            height: 1,
            color: AppColors.grey155,
          ),
          AddProofItem(
            proof: AddVehicleProofController.to.vehiclePermit,
            onTap: () => Get.toNamed(
              AppRoutes1.aadharCard,
              arguments: AddVehicleProofController.to.vehiclePermit,
            ),
          ),
          Container(
            height: 1,
            color: AppColors.grey155,
          ),
          AddProofItem(
            proof: AddVehicleProofController.to.vehicleImage,
            onTap: () => Get.toNamed(
              AppRoutes1.aadharCard,
              arguments: AddVehicleProofController.to.vehicleImage,
            ),
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
