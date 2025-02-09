import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../controller/splash/splash_controller.dart';
import '../../core/colors/app_colors.dart';
import '../../core/themes/assets/icons.dart';
import '../../core/widgets/app_buttons/app_buttons.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SplashController splashController = Get.find();
    return Scaffold(
        bottomSheet: Container(
            margin: EdgeInsets.fromLTRB(15.sp, 0, 15.sp, 30.sp),
            height: 52.sp,
            child: GreenButton(
              text: "Allow Permission",
              onTap: () => splashController.requestLocPermission(),
            )),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(AppIcons.getLocationIcon),
            SizedBox(height: 28.sp),
            Text(
              "Location not enabled",
              style: TextStyle(
                  color: AppColors.black,
                  height: 1,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16.sp),
            Padding(
              padding: EdgeInsets.only(left: 37.sp, right: 37.sp),
              child: Text(
                "Share location permission helps us improve your ride booking and pickup experience",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.grey93,
                    fontSize: 16.sp,
                    height: 1,
                    fontWeight: FontWeight.w200),
              ),
            ),
          ],
        ));
  }
}
