import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waiver_driver/controller/faq_details/faq_details_controller.dart';
import 'package:waiver_driver/core/colors/app_colors.dart';
import 'package:waiver_driver/core/widgets/app_bar/app_bar.dart';


class FaqDetailsScreen extends StatelessWidget {
  const FaqDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(title: "FAQs"),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 25.sp),
          children: [
            Text(
              FaqDetailsController.to.question,
              style: TextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp),
            ),
            SizedBox(
              height: 16.sp,
            ),
            Text(
              FaqDetailsController.to.answer,
              style: TextStyle(color: AppColors.grey93, fontSize: 12.sp),
            ),
          ],
        ));
  }
}
