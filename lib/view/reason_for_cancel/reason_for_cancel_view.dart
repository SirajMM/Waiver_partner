import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:waiver_driver/controller/reason_for_cancel/reason_for_cancel_controller.dart';
import 'package:waiver_driver/core/colors/app_colors.dart';
import 'package:waiver_driver/core/widgets/app_bar/app_bar.dart';
import 'package:waiver_driver/core/widgets/app_buttons/app_buttons.dart';

import '../loading_animation/loading_animation.dart';

class ReasonForCancelScreen extends StatelessWidget {
  const ReasonForCancelScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ReasonForCancelController controller = Get.find();
    return Scaffold(
      appBar: appBar(
        title: "Cancel Trip",
        centerTitle: true,
      ),
      body: GetX<ReasonForCancelController>(
        builder: (controller) {
          return controller.isLoading.value
              ? const LoadingBarsAnimation()
              : ListView(
                  shrinkWrap: true,
                  children: [
                    Column(
                      children: (controller.reasons ?? [])
                          .map((reason) => ListTile(
                                leading: Icon(
                                  controller.selectedReasonForCancel.value ==
                                          reason
                                      ? Icons.check_circle
                                      : Icons.circle_outlined,
                                  color: controller
                                              .selectedReasonForCancel.value ==
                                          reason
                                      ? AppColors.green33
                                      : AppColors.black,
                                ),
                                title: Text(reason.reason ?? ' '),
                                onTap: () {
                                  controller.selectedReasonForCancel.value =
                                      reason;
                                },
                              ))
                          .toList(),
                    ),
                    SizedBox(
                      height: 30.sp,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: BlueButton(
                        width: 150.sp,
                        text: "Cancel Ride",
                        onTap: () => ReasonForCancelController.to.cancelRide(),
                      ),
                    )
                  ],
                );
        },
      ),
    );
  }
}
