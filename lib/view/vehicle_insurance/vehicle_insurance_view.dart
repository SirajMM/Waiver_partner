import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:waiver_driver/controller/police_clearance_certificate/police_clearance_certificate_controller.dart';
import 'package:waiver_driver/controller/vehicle_insurance/vehicle_insurance_controller.dart';
import 'package:waiver_driver/core/colors/app_colors.dart';
import 'package:waiver_driver/core/widgets/app_bar/app_bar.dart';
import 'package:waiver_driver/core/widgets/app_buttons/app_buttons.dart';
import 'package:waiver_driver/core/widgets/circle_with_gradient/circle_with_gradient.dart';
import 'package:waiver_driver/core/widgets/upload_image_template/upload_image_template.dart';



import '../profile_photo/profile_photo_view.dart';


class VehicleInsuranceScreen extends StatelessWidget {
  const VehicleInsuranceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(title: ""),
        body: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 15.sp),
          children: [
            SizedBox(
              height: 20.sp,
            ),
            Text(
              "Vehicle Insurance",
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GetX<VehicleInsuranceController>(builder: (controller) {
                  return UpLoadImageTemplate(
                      width: 150.sp,
                      height: 270.sp,
                      image: controller.vehicleInsurance.value,
                      onTap: (ImageSource source) =>
                          controller.uploadPhoto(source: source));
                }),
              ],
            ),
            GetX<VehicleInsuranceController>(builder: (controller) {
              return controller.showErrorMessageVehicleInsurance.value
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5.sp,
                        ),
                        Text(
                          "Please upload a image for profile photo",
                          style: TextStyle(color: AppColors.red),
                        ),
                      ],
                    )
                  : const SizedBox();
            }),
            SizedBox(
              height: 40.sp,
            ),
            BlueButton(
              text: "Upload",
              onTap: () =>
                  PoliceClearanceCertificateController.to.uploadDocument(),
              prefixIcon: CircleWithIcon(
                height: 25.sp,
                color: AppColors.white,
                child: Icon(
                  Icons.add,
                  size: 20.sp,
                  color: AppColors.blue,
                ),
              ),
            )
          ],
        ));
  }
}
