import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:waiver_driver/core/colors/app_colors.dart';
import 'package:waiver_driver/core/themes/assets/images.dart';
import 'package:waiver_driver/core/widgets/app_bar/app_bar.dart';
import 'package:waiver_driver/core/widgets/app_buttons/app_buttons.dart';


class ReferAndEarnScreen extends StatelessWidget {
  const ReferAndEarnScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(title: "Refer Friends"),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 15.sp),
          children: [
            SizedBox(
              height: 30.sp,
            ),
            Image.asset(
              AppImages.referAFriend,
              height: 245.sp,
            ),
            SizedBox(
              height: 25.sp,
            ),
            Text(
              "Here’s ₹200 free on us!",
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 7.sp,
            ),
            Text(
              "Lorem ipsum dolor amet consectetur the cursus porttitor ultricies quis mission massa nibh suscipit.",
              style: TextStyle(fontSize: 14.sp, color: AppColors.grey93),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 40.sp,
            ),
            BlueButton(
              text: "Refer Now",
              onTap: () => Share.share("Referral Link"),
            ),
            SizedBox(
              height: 20.sp,
            ),
          ],
        ));
  }
}
