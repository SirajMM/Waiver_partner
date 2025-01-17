import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:waiver_driver/core/widgets/app_buttons/app_buttons.dart';

import '../../../helper/router/app_routes/app_routes.dart';
import '../../../main.dart';
import '../../colors/app_colors.dart';
import '../../constants/get_storage_constants.dart';


class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: 40.sp, right: 40.sp, top: 96.sp, bottom: 115.sp),
      height: Get.height,
      width: Get.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Something went wrong",
            style: TextStyle(
                fontSize: 25.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.grey122),
          ),
          BlueButton(
              text: "BACK TO HOME",
              onTap: () => Get.offAndToNamed(
                  box.read(BoxKeys.userType) == UserType.fleet
                      ? AppRoutes.fleetHomePage
                      : AppRoutes.home))
        ],
      ),
    );
  }
}
