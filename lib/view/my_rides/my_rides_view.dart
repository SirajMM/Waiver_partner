import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:waiver_driver/backend/model/my_rides/my_rides_model.dart';
import 'package:waiver_driver/controller/my_rides/my_rides_controller.dart';
import 'package:waiver_driver/core/themes/assets/icons.dart';
import 'package:waiver_driver/core/widgets/app_bar/app_bar.dart';
import 'package:waiver_driver/core/widgets/circle_with_gradient/circle_with_gradient.dart';
import 'package:waiver_driver/core/widgets/empty_page/empty_page.dart';
import 'package:waiver_driver/core/widgets/error_page/error_page.dart';
import 'package:waiver_driver/helper/router/app_routes/app_routes.dart';

import '../../core/colors/app_colors.dart';
import '../../core/constants/get_storage_constants.dart';
import '../../core/widgets/app_network_image/app_network_image.dart';
import '../loading_animation/loading_animation.dart';

class MyRidesScreen extends StatelessWidget {
  const MyRidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(title: "My Rides"),
        body: GetX<MyRidesController>(builder: (controller) {
          return controller.isLoading.value
              ? const LoadingBarsAnimation()
              : controller.isError.value
                  ? const ErrorPage()
                  : controller.myRides.isEmpty
                      ? EmptyPage(text: "No Rides Found")
                      : ListView(
                          controller: MyRidesController.to.scrollController,
                          padding: EdgeInsets.symmetric(
                              vertical: 30.sp, horizontal: 15.sp),
                          children: [
                            GetX<MyRidesController>(builder: (controller) {
                              return Column(
                                children: MyRidesController.to.myRides
                                    .map((ride) =>
                                        MyRidesListingItem(ride: ride))
                                    .toList(),
                              );
                            }),
                            GetX<MyRidesController>(builder: (controller) {
                              return controller.isListCompeted.value
                                  ? LoadingBarsAnimation(
                                      height: 200.sp,
                                    )
                                  : const SizedBox();
                            })
                          ],
                        );
        }));
  }
}

class MyRidesListingItem extends StatelessWidget {
  final Ride ride;
  const MyRidesListingItem({
    super.key,
    required this.ride,
  });

  @override
  Widget build(BuildContext context) {
    String formatISTTime(String startTime) {
      DateTime dateTime = DateTime.parse(startTime).toLocal();
      String formattedDate =
          DateFormat('d MMM yyyy \'at\' h:mm a').format(dateTime);
      return formattedDate;
    }

    return LayoutBuilder(builder: (context, constraints) {
      double width = constraints.maxWidth;
      double imageSize = width * 0.12;
      return GestureDetector(
        child: Container(
          margin: EdgeInsets.only(bottom: 15.sp),
          decoration: BoxDecoration(
            color: Get.theme.indicatorColor.withOpacity(.05),
            borderRadius: BorderRadius.circular(8.sp),
          ),
          padding: EdgeInsets.all(16.sp),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 8.0.h, right: 8.h, top: 8.h, bottom: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.grey249,
                      child: AppNetworkImage(
                        imageUrl: ride.passenger_profile_image ?? "",
                        height: imageSize,
                        radius: 50,
                      ),
                    ),
                    SizedBox(width: 20.sp),
                    Row(
                      children: [
                        // Expanded(
                        //   child:
                        Text(
                          ride.passenger ?? "Passenger Name Not Available",
                          style: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(
                color: context.theme.dividerColor,
                thickness: 0.5,
                endIndent: 10.w,
                indent: 10.w,
              ),
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.0.h, right: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyRideTopItem(
                      icon: CircleWithIcon(
                        height: 30.sp,
                        color: Get.theme.indicatorColor,
                        child: Image.asset(
                          AppIcons.location,
                          color: Get.theme.primaryColor,
                          height: 15.sp,
                        ),
                      ),
                      text: "${ride.distance ?? ""} km  ",
                    ),
                    MyRideTopItem(
                      icon: CircleWithIcon(
                        height: 30.sp,
                        color: Get.theme.indicatorColor,
                        child: Image.asset(
                          AppIcons.clock,
                          color: Get.theme.primaryColor,
                          height: 15.sp,
                        ),
                      ),
                      text: AppConstants.formatSecondsToHrAndMin(
                          ride.duration ?? 0),
                    ),
                    MyRideTopItem(
                      icon: CircleWithIcon(
                        height: 30.sp,
                        color: Get.theme.indicatorColor,
                        child: Image.asset(
                          AppIcons.wallet,
                          color: Get.theme.primaryColor,
                          height: 15.sp,
                        ),
                      ),
                      text: "₹${ride.amount}" ?? "",
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.sp,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                    ),
                    child: Text(
                      "Date & Time : ",
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ),
                  ride.paidTime != null
                      ? Text(
                          formatISTTime(ride.paidTime!.toString()),
                          style: TextStyle(fontSize: 14.sp),
                        )
                      : const SizedBox()
                ],
              ),
              SizedBox(
                height: 18.sp,
              ),
              MyRideExpansionTile(
                start: ride.startLocation ?? "",
                stop: ride.endLocation ?? "",
              )
            ],
          ),
        ),
      );
    });
  }
}

class MyRideExpansionTile extends StatelessWidget {
  final String start;
  final String stop;
  const MyRideExpansionTile({
    super.key,
    required this.start,
    required this.stop,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.sp),
        border: Border.all(
          color: Get.theme.indicatorColor.withOpacity(.05),
          width: 1.5.sp,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 8.sp,
        vertical: 15.sp,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            AppIcons.startAndStop,
            height: 70.sp,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 230.sp,
                child: Text(
                  start,
                  style: TextStyle(fontSize: 14.sp),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 12.sp,
                  bottom: 5.sp,
                ),
                height: 1.5.sp,
                width: 250.sp,
                color: Get.theme.indicatorColor.withOpacity(.01),
              ),
              SizedBox(
                width: 230.sp,
                child: Text(
                  stop,
                  style: TextStyle(fontSize: 14.sp),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class MyRideTopItem extends StatelessWidget {
  Widget icon;
  String text;
  MyRideTopItem({
    super.key,
    required this.icon,
    required this.text,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon,
        SizedBox(
          width: 5.sp,
        ),
        Text(
          text,
          style: const TextStyle(fontSize: 14),
        )
      ],
    );
  }
}
