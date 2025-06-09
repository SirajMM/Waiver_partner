import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/colors/app_colors.dart';
import '../../../view/loading_animation/loading_animation.dart';

class LoadingStateWidget extends StatelessWidget {
  const LoadingStateWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 20.sp),
      decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          boxShadow: [
            BoxShadow(
                color: AppColors.black.withOpacity(.1),
                offset: Offset(3, 3),
                blurRadius: 5,
                spreadRadius: 5)
          ],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.sp), topRight: Radius.circular(20.sp))),
      child: LoadingBarsAnimation(
        height: 200.sp,
      ),
    );
  }
}