import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:waiver_driver/core/widgets/app_buttons/app_buttons.dart';
import '../../../helper/router/app_routes/app_routes.dart';
import '../../colors/app_colors.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key, this.isFleet = false});
  final bool isFleet;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: 40.sp, right: 40.sp, top: 96.sp, bottom: 100.sp),
      height: Get.height,
      width: Get.width,
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                "Something went wrong",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.grey122),
              ),
            ),
          ),
          BlueButton(
              text: "BACK TO HOME",
              onTap: () => Get.offAndToNamed(
                  isFleet ? AppRoutes.fleetHomePage : AppRoutes.home))
        ],
      ),
    );
  }
}
