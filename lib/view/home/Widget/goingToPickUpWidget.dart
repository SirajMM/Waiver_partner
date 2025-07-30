import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:waiver_driver/controller/home/home_controller.dart';
import 'package:waiver_driver/core/colors/app_colors.dart';
import 'package:waiver_driver/core/constants/get_storage_constants.dart';
import 'package:waiver_driver/core/widgets/circle_with_gradient/circle_with_gradient.dart';
import 'package:waiver_driver/view/home/home_view.dart';

import '../../../core/themes/assets/icons.dart';
import '../../../core/widgets/app_buttons/app_buttons.dart';

class Going_To_Pick_screen extends StatelessWidget {
  const Going_To_Pick_screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Recenter(),
          Container(
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
            child: Column(
              // physics: NeverScrollableScrollPhysics(),
              // shrinkWrap: true,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 30.sp,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppConstants.formatSecondsToHrAndMin(
                              HomeController.to.timeToDropOffLocation ?? 0),
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
                    IconButton(
                        onPressed: () => Get.bottomSheet(CancelOrder()),
                        icon: Icon(Icons.close))
                  ],
                ),
                SizedBox(
                  height: 20.sp,
                ),
                Text(
                  "Picking up ${HomeController.to.passengerName ?? "Passenger"}",
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20.sp,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 50.sp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          HomeController.to.makePhoneCall();
                        },
                        child: BottomSheetWhileDrivingItem(
                            icon: CircleWithIcon(
                                height: 35.sp,
                                color: AppColors.blue,
                                padding: EdgeInsets.all(8.sp),
                                child: Image.asset(AppIcons.phone)),
                            text: "Call"),
                      ),
                      // BottomSheetWhileDrivingItem(
                      //     icon: CircleWithIcon(
                      //         height: 35.sp,
                      //         color: AppColors.blue,
                      //         padding: EdgeInsets.all(8.sp),
                      //         child: Image.asset(AppIcons.message)),
                      //     text: "Message"),
                      BottomSheetWhileDrivingItem(
                        icon: CircleWithIcon(
                            height: 35.sp,
                            color: AppColors.blue,
                            padding: EdgeInsets.all(8.sp),
                            child: Image.asset(AppIcons.navigation)),
                        text: "Navigate",
                        onTap: () => HomeController.to.openMap(
                            latitude: HomeController.to.startLocationLat,
                            longitude: HomeController.to.startLocationLong),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.sp,
                ),
                BlueButton(
                  text: "Arrived at Pick Up",
                  onTap: () {
                    Get.defaultDialog(
                        backgroundColor: Colors.white,
                        title: 'Confirm',
                        middleText: 'Did you reached PickUp Location ?',
                        confirm: BlueButton(
                          text: "Yes",
                          height: 40.h,
                          width: 100.sp,
                          onTap: () {
                            Get.back();
                            HomeController.to.reachedPickUpLocation();
                          },
                        ),
                        cancel: WhiteButton(
                          height: 40.h,
                          width: 100.sp,
                          text: "No",
                          onTap: Get.back,
                        ));
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
