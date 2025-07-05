import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/home/home_controller.dart';
import '../../../core/colors/app_colors.dart';
import '../../../core/themes/assets/icons.dart';
import '../../../core/widgets/app_buttons/app_buttons.dart';
import '../../../core/widgets/circle_with_gradient/circle_with_gradient.dart';
import '../../../view/home/home_view.dart';

class GoingToDestinationWidget extends StatelessWidget {
  const GoingToDestinationWidget({
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
              topLeft: Radius.circular(20.sp),
              topRight: Radius.circular(20.sp))),
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${(HomeController.to.timeToDropOffLocation ?? 0) > 3600 ? Duration(seconds: HomeController.to.timeToDropOffLocation ?? 0).inHours.toStringAsFixed(2) : Duration(seconds: HomeController.to.timeToDropOffLocation ?? 0).inMinutes.toStringAsFixed(2)} mins",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(
                width: 20.sp,
              ),
              Text(
                "${HomeController.to.distanceToDropOffLocation} Km",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.sp,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.sp,
          ),
          Text(
            "Dropping off ${HomeController.to.passengerName ?? "Alex John"}",
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20.sp,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BottomSheetWhileDrivingItem(
                icon: CircleWithIcon(
                    height: 35.sp,
                    color: AppColors.blue,
                    padding: EdgeInsets.all(8.sp),
                    child: Image.asset(AppIcons.navigation)),
                text: "Navigate",
                onTap: () => HomeController.to.openMap(
                    latitude: HomeController.to.endLocationLat,
                    longitude: HomeController.to.endLocationLong),
              ),
              SizedBox(
                width: 40.sp,
              ),
              BottomSheetWhileDrivingItem(
                icon: CircleWithIcon(
                    height: 35.sp,
                    color: AppColors.blue,
                    // padding: EdgeInsets.all(8.sp),
                    child: Icon(
                      Icons.u_turn_right_rounded,
                      color: AppColors.white,
                    )),
                text: "Add Stop",
                onTap: () {
                  Get.bottomSheet(AddStopBottomSheet());
                },
              ),
            ],
          ),
          SizedBox(
            height: 20.sp,
          ),
          BlueButton(
            text: "Arrived at Destination",
            onTap: () {
              Get.defaultDialog(
                  backgroundColor: Colors.white,
                  title: 'Confirm',
                  middleText: 'Do you reached destination ?',
                  confirm: BlueButton(
                    text: "Yes",
                    height: 40.h,
                    width: 100.sp,
                    onTap: () {
                      Get.back();
                      HomeController.to.reachedDropOffLocation();
                    },
                  ),
                  cancel: WhiteButton(
                    height: 40.h,
                    width: 100.sp,
                    text: "No",
                    onTap: Get.back,
                  ));
            },
          ),
        ],
      ),
    );
  }
}
