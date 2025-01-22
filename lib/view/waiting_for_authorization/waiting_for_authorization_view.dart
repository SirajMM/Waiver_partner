import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:waiver_driver/core/colors/app_colors.dart';
import 'package:waiver_driver/core/themes/assets/images.dart';
import 'package:waiver_driver/core/widgets/app_buttons/app_buttons.dart';
import 'package:waiver_driver/helper/router/app_routes/app_routes.dart';
import 'package:waiver_driver/helper/router/app_routes/route.dart';
import 'package:waiver_driver/main.dart';


class WaitingForAuthorizationScreen extends StatelessWidget {
  const WaitingForAuthorizationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 90.sp),
      children: [
        SvgPicture.asset(AppImages.waitingForAuthorization),
        SizedBox(
          height: 20.sp,
        ),
        Text(
          "Your application under\nverification",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 20.sp,
        ),
        Text(
          "Thank you for your submission. Our team is diligently reviewing your application and documents. Your patience during this process is appreciated, and we will provide updates promptly.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12.sp, color: AppColors.grey93),
        ),
        SizedBox(
          height: 70.sp,
        ),
        BlueButton(
          text: "Back to login",
          onTap: () {
            box.erase();
            Get.offAndToNamed(AppRoutes1.getDriverTypeSelectionRoute());
          },
        )
      ],
    ));
  }
}
