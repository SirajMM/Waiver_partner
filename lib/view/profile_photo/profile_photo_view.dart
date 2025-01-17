import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:waiver_driver/controller/profile_photo/profile_photo_controller.dart';
import 'package:waiver_driver/core/colors/app_colors.dart';
import 'package:waiver_driver/core/widgets/app_bar/app_bar.dart';
import 'package:waiver_driver/core/widgets/app_buttons/app_buttons.dart';
import 'package:waiver_driver/core/widgets/circle_with_gradient/circle_with_gradient.dart';
import 'package:waiver_driver/core/widgets/upload_image_template/upload_image_template.dart';


class ProfilePhotoScreen extends StatelessWidget {
  const ProfilePhotoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(title: ""),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 15.sp),
          children: [
            SizedBox(
              height: 20.sp,
            ),
            Text(
              "Profile Photo",
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
                GetX<ProfilePhotoController>(builder: (controller) {
                  return UpLoadImageTemplate(
                      height: 170.sp,
                      width: 170.sp,
                      image: controller.profilePhoto.value,
                      onTap: (ImageSource source) =>
                          controller.uploadPhoto(source: source));
                }),
              ],
            ),
            GetX<ProfilePhotoController>(builder: (controller) {
              return controller.showErrorMessageProfilePhoto.value
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
              height: 60.sp,
            ),
            BlueButton(
              text: "Upload",
              onTap: () => ProfilePhotoController.to.uploadDocument(),
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

class ChauffeurProofInstructionItem extends StatelessWidget {
  String text;
  ChauffeurProofInstructionItem({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleWithIcon(
          height: 20.sp,
          color: AppColors.green40,
          child: Icon(
            Icons.check,
            size: 16.sp,
            color: AppColors.white,
          ),
        ),
        SizedBox(
          width: 10.sp,
        ),
        SizedBox(
          width: Get.width * 0.8,
          child: Text(
            text,
            style: TextStyle(fontSize: 16.sp, color: AppColors.black),
          ),
        )
      ],
    );
  }
}
