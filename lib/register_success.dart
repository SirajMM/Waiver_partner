import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:waiver_driver/core/colors/app_colors.dart';
import 'package:waiver_driver/core/widgets/app_buttons/app_buttons.dart';
import 'package:waiver_driver/helper/router/app_routes/app_routes.dart';

import 'package:waiver_driver/main.dart';

class SuccessFullRegister extends StatelessWidget {
  const SuccessFullRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Your Registration was Success full",
              style: TextStyle(
                fontSize: 20.sp,
                color: AppColors.grey93,
              ),
            ),
            SizedBox(
              height: 60.sp,
            ),
            BlueButton(
              width: 300.sp,
              text: "Logout",
              onTap: () {
                box.erase();
                Get.offAllNamed(
                  AppRoutes.driverTypeSelection,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
