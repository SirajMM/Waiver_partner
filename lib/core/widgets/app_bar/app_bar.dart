import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../app_buttons/app_buttons.dart';

AppBar appBar({
  required String title,
  bool? showMenuButton,
  List<Widget>? actions,
  centerTitle = false,
}) {
  return AppBar(
    forceMaterialTransparency: true,
    leading: (showMenuButton ?? false)
        ? Builder(
            builder: (context) => Container(
              margin: EdgeInsets.all(10.sp),
              child: MenuButton(
                onTap: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          )
        : Container(
            margin: EdgeInsets.all(10.sp),
            child: BackArrow(
              onTap: () => Get.back(),
            ),
          ),
    // automaticallyImplyLeading: false,
    actions: actions,
    centerTitle: centerTitle,
    title: Text(
      title,
      style: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
