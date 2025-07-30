import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/home/home_controller.dart';
import '../../../core/colors/app_colors.dart';
import '../../../core/constants/enums/enums.dart';
import '../../../core/constants/get_storage_constants.dart';
import '../../../core/themes/assets/icons.dart';
import '../../../core/widgets/app_buttons/app_buttons.dart';
import '../home_view.dart';

class ReadyToGoToDestinationWidget extends StatelessWidget {
  const ReadyToGoToDestinationWidget({
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppConstants.formatSecondsToHrAndMin(
                          HomeController.to.timeToDropOffLocation ?? 0),
                      // "${(HomeController.to.timeToDropOffLocation ?? 0) > 3600 ? Duration(seconds: HomeController.to.timeToDropOffLocation ?? 0).inHours.toStringAsFixed(2) : Duration(seconds: HomeController.to.timeToDropOffLocation ?? 0).inMinutes.toStringAsFixed(2)} mins",
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
                Container(
                  padding: EdgeInsets.all(5.sp),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.sp),
                      border: Border.all(color: AppColors.grey155)),
                  child: Row(
                    children: [
                      Image.asset(
                        AppIcons.startAndStop,
                        height: 90.sp,
                      ),
                      SizedBox(
                        width: 20.sp,
                      ),
                      SizedBox(
                        width: 275.sp,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              HomeController.to.pickUpLocation ?? "",
                              style: TextStyle(fontSize: 16.sp),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Container(
                              width: 200,
                              color: Get.theme.indicatorColor.withOpacity(.05),
                              height: 2.sp,
                              margin: EdgeInsets.symmetric(vertical: 12.sp),
                            ),
                            Text(
                              HomeController.to.dropOffLocation ?? "",
                              style: TextStyle(fontSize: 16.sp),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.sp,
                ),
                BlueButton(
                    text: "Start Trip",
                    onTap: () {
                      HomeController.to.driverState.value =
                          DriverState.goingToDestination;
                      HomeController.to.openMap(
                          latitude: HomeController.to.endLocationLat,
                          longitude: HomeController.to.endLocationLong);
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
