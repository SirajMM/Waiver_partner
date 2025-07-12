import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:waiver_driver/backend/model/fleet_home_page/fleet_home_page_model.dart';
import 'package:waiver_driver/controller/fleet_home_page/fleet_home_page_controller.dart';
import 'package:waiver_driver/core/colors/app_colors.dart';
import 'package:waiver_driver/core/constants/get_storage_constants.dart';
import 'package:waiver_driver/core/themes/assets/icons.dart';
import 'package:waiver_driver/core/widgets/app_bar/app_bar.dart';
import 'package:waiver_driver/core/widgets/app_buttons/app_buttons.dart';
import 'package:waiver_driver/core/widgets/circle_with_gradient/circle_with_gradient.dart';

import '../../controller/left_menu_fleet/left_menu_fleet_controller.dart';
import '../../helper/router/app_routes/route.dart';
import '../left_menu_fleet/left_menu_fleet_view.dart';

class FleetHomePageScreen extends StatelessWidget {
  const FleetHomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.transparent,
        elevation: 0,
        isExtended: true,
        onPressed: () => Get.toNamed(AppRoutes1.addVehicle),
        label: BlueButton(
          width: Get.width - 60.sp,
          prefixIcon: CircleWithIcon(
            color: Get.theme.primaryColor,
            height: 25.sp,
            child: Icon(
              Icons.add,
              color: AppColors.blue,
            ),
          ),
          text: "Add New Vehicle",
        ),
      ),
      appBar: appBar(title: "Fleet", showMenuButton: true),
      drawer: const LeftMenuFleet(),
      body: Obx(
        () => RefreshIndicator(
          onRefresh: () async {
            await FleetHomePageController.to.getVehicles();
          },
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: 15.sp,
              vertical: 25.sp,
            ),
            children: FleetHomePageController.to.fleet.reversed
                .toList()
                .map(
                  (fleet) => FleetRegistrationListingItem(
                    fleet: fleet,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class FleetRegistrationListingItem extends StatelessWidget {
  final FleetVehicle fleet;
  final RxBool isButtonLoading = false.obs;
  FleetRegistrationListingItem({super.key, required this.fleet});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.sp),
      margin: EdgeInsets.only(bottom: 20.sp),
      decoration: BoxDecoration(
        color: AppColors.grey249,
        borderRadius: BorderRadius.circular(8.sp),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${fleet.brand ?? ""} ${fleet.name ?? ""}",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    fleet.registrationNumber ?? "",
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.grey93,
                    ),
                  )
                ],
              ),
              GetX<FleetHomePageController>(builder: (controller) {
                return FleetRegistrationStatusButton(
                  text: fleet.status?.value == VehicleApprovalStatus.pending
                      ? "Pending"
                      : fleet.status?.value == VehicleApprovalStatus.blocked
                          ? "Blocked"
                          : "Active",
                  color: fleet.status?.value == VehicleApprovalStatus.pending
                      ? AppColors.golden
                      : fleet.status?.value == VehicleApprovalStatus.blocked
                          ? AppColors.red
                          : AppColors.green40,
                );
              })
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 15.sp),
            height: 1.5.sp,
            width: 280.sp,
            color: AppColors.grey155,
          ),
          !(fleet.isValid ?? false)
              ? Column(
                  children: [
                    FleetRegistrationItem(
                      text: fleet.proof?.isEmpty ?? false
                          ? "Add  Vehicle details"
                          : " View Vehicle details",
                      onTap: () => Get.toNamed(
                          AppRoutes1.getAddVehicleProofInRoute(),
                          arguments: fleet),
                    ),
                    Container(
                      height: 1.sp,
                      margin: EdgeInsets.symmetric(vertical: 10.sp),
                      width: 300.sp,
                      color: AppColors.grey155,
                    ),
                  ],
                )
              : SizedBox(),
          GetX<FleetHomePageController>(builder: (controller) {
            return fleet.status?.value == VehicleApprovalStatus.blocked
                ? SizedBox.shrink()
                : (fleet.driver?.driverId ?? "") == ""
                    ? FleetRegistrationItem(
                        text: "Add Driver",
                        onTap: () => Get.toNamed(
                            AppRoutes1.getAddDriverInRoute(),
                            arguments: fleet),
                      )
                    : GestureDetector(
                        onTap: () => Get.toNamed(AppRoutes1.driverProfile,
                            arguments: fleet),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  fleet.driver?.driverName ?? "",
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.black10),
                                ),
                                Text(
                                  fleet.driver?.driverId ?? "",
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColors.black10),
                                ),
                                SizedBox(
                                  height: 20.sp,
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: AppColors.grey122,
                            )
                          ],
                        ),
                      );
          }),
          SizedBox(height: 10.h),
          GetX<FleetHomePageController>(builder: (controller) {
            return fleet.status?.value == VehicleApprovalStatus.active
                // true
                ? Row(
                    children: [
                      GetX<FleetHomePageController>(builder: (controller) {
                        return RedButton(
                            height: 30.sp,
                            width: 100.sp,
                            fontSize: 14.sp,
                            text: "Block vehicle",
                            isLoading: isButtonLoading.value,
                            onTap: () async {
                              isButtonLoading.value = true;
                              await FleetHomePageController.to
                                  .blockUser(vehicle: fleet);
                              isButtonLoading.value = false;
                            });
                      }),
                    ],
                  )
                : SizedBox();
          })
        ],
      ),
    );
  }
}

class FleetRegistrationItem extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  const FleetRegistrationItem(
      {super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: onTap,
          child: FleetRegistrationStatusButton(
            text: text,
            color: AppColors.blue,
          ),
        ),
        SvgPicture.asset(
          AppIcons.arrowRight,
          height: 15.sp,
        )
      ],
    );
  }
}

class FleetRegistrationListingItemActive extends StatelessWidget {
  final FleetVehicle fleet;
  const FleetRegistrationListingItemActive({super.key, required this.fleet});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.sp),
      margin: EdgeInsets.only(bottom: 20.sp),
      decoration: BoxDecoration(
        color: AppColors.grey249,
        borderRadius: BorderRadius.circular(8.sp),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${fleet.brand ?? ""} ${fleet.name ?? ""}",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    fleet.registrationNumber ?? "",
                    style: TextStyle(
                        fontSize: 11.sp,
                        color: Get.theme.indicatorColor.withOpacity(.5)),
                  )
                ],
              ),
              FleetRegistrationStatusButton(
                text: "Active",
                color: AppColors.green40,
              )
            ],
          ),
          Container(
              margin: EdgeInsets.symmetric(vertical: 15.sp),
              height: 1.5.sp,
              width: 280.sp,
              color: Get.theme.indicatorColor.withOpacity(.5)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: fleet.name == ""
                ? [
                    FleetRegistrationStatusButton(
                      text: "Add Driver",
                      color: AppColors.blue,
                    )
                  ]
                : [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fleet.name ?? "",
                          style: TextStyle(
                              fontSize: 14.sp, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "#${fleet.id}",
                          style: TextStyle(
                              fontSize: 11.sp,
                              color: Get.theme.indicatorColor.withOpacity(.5)),
                        )
                      ],
                    ),
                    SvgPicture.asset(
                      AppIcons.arrowRight,
                      height: 15.sp,
                    )
                  ],
          )
        ],
      ),
    );
  }
}

class FleetRegistrationListingItemBlocked extends StatelessWidget {
  final FleetVehicle fleet;
  const FleetRegistrationListingItemBlocked({super.key, required this.fleet});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.sp),
      margin: EdgeInsets.only(bottom: 20.sp),
      decoration: BoxDecoration(
        color: Get.theme.indicatorColor.withOpacity(.1),
        borderRadius: BorderRadius.circular(8.sp),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fleet.name ?? "",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    fleet.registrationNumber ?? "",
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.grey93,
                    ),
                  )
                ],
              ),
              FleetRegistrationStatusButton(
                text: "Blocked",
                color: AppColors.red,
              )
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 15.sp),
            height: 1.5.sp,
            width: 280.sp,
            color: AppColors.grey155,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: fleet.name == ""
                ? [
                    FleetRegistrationStatusButton(
                      text: "Add Driver",
                      color: AppColors.blue,
                    )
                  ]
                : [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fleet.name ?? "",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "#${fleet.id}",
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.grey93,
                          ),
                        )
                      ],
                    ),
                    SvgPicture.asset(
                      AppIcons.arrowRight,
                      height: 15.sp,
                    )
                  ],
          )
        ],
      ),
    );
  }
}

class FleetRegistrationStatusButton extends StatelessWidget {
  final String text;
  final Color color;
  const FleetRegistrationStatusButton({
    super.key,
    required this.text,
    required this.color,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 5.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.sp),
        color: color,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.sp,
        ),
      ),
    );
  }
}

class LogoutBottomSheet extends StatelessWidget {
  const LogoutBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.sp),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.sp),
            topRight: Radius.circular(8.sp),
          )),
      child: ListView(
        shrinkWrap: true,
        children: [
          Text(
            "Log out ?",
            style: TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.w600,
                fontSize: 20.sp),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 5.sp,
          ),
          Text(
            "Are you sure you want to log out?",
            style: TextStyle(color: AppColors.grey93, fontSize: 14.sp),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20.sp,
          ),
          RedButton(
            text: "Logout",
            onTap: () => LeftMenuControllerFleet.to.logoutUser(),
          ),
          SizedBox(
            height: 20.sp,
          ),
          WhiteButton(
            text: "Go Back",
            onTap: () => Get.back(),
          ),
        ],
      ),
    );
  }
}
