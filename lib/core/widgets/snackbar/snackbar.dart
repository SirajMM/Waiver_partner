import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../colors/app_colors.dart';
import '../../constants/get_storage_constants.dart';

class AppSnackBar extends StatelessWidget {
  final String? text;

  const AppSnackBar({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 20.sp),
      margin: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        color: AppConstants.getColor(),
        borderRadius: BorderRadius.circular(15.sp),
      ),
      child: Text(
        text ?? "",
        style: TextStyle(color: AppConstants.getButtonTextColor()),
      ),
    );
  }
}
