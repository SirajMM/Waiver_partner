import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waiver_driver/core/colors/app_colors.dart';
import 'package:waiver_driver/core/themes/assets/icons.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20.sp),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.black10, AppColors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 70.sp,
            ),Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(AppIcons.appLogo),
                SizedBox(
                  width: 10.sp,
                ),
                SvgPicture.asset(AppIcons.waiverText),
              ],
            ),
            Spacer(),
            Image.asset(
              AppIcons.fromDriverify,
              height: 50.sp,
            ),
          ],
        ),
      ),
    );
  }
}
