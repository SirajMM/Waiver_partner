import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../colors/app_colors.dart';

class AppSnackBar extends StatelessWidget {
  final String? text;

  const AppSnackBar({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 20.sp),
      margin: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.circular(15.sp),
      ),
      child: Text(
        text ?? "",
        style: TextStyle(color: AppColors.white),
      ),
    );
  }
}
