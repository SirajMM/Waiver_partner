import 'package:flutter/material.dart';
import 'package:flutter_custom_utils/flutter_custom_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waiver_driver/core/themes/assets/icons.dart';

import '../../backend/api/api_services/api_services.dart';
import '../../backend/model/left_menu_driver/left_menu_driver_model.dart';

import '../../controller/left_menu_driver/left_menu_driver_controller.dart';
import '../../controller/left_menu_fleet/left_menu_fleet_controller.dart';
import '../../core/constants/get_storage_constants.dart';
import '../../core/widgets/app_buttons/app_buttons.dart';
import '../../helper/router/app_routes/app_routes.dart';
import '../../helper/router/app_routes/route.dart';
import '../../main.dart';
import '../fleet_home_page/fleet_home_page_view.dart';

class LeftMenuFleet extends StatelessWidget {
  const LeftMenuFleet({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LeftMenuControllerFleet());
    return Container(
      width: Get.width * .7,
      height: Get.height,
      padding: EdgeInsets.symmetric(horizontal: 25.sp),
      decoration: BoxDecoration(
        color: Get.theme.primaryColor,
      ),
      child: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(
            height: 20.sp,
          ),
          Row(
            children: [
              Builder(
                builder: (context) {
                  return BackArrow(
                    onTap: () => Get.back(),
                  );
                },
              ),
            ],
          ),
          SizedBox(
            height: 25.sp,
          ),
          Text(
            "Menu",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 30.sp,
            ),
          ),
          SizedBox(
            height: 25.sp,
          ),
          const LeftMenuProfileItem(),
          SizedBox(
            height: 30.sp,
          ),
          LeftMenuItem(
            item: LeftMenuControllerFleet.to.notification,
            onTap: () => Get.toNamed(AppRoutes1.notification),
          ),
          SizedBox(
            height: 30.sp,
          ),
          LeftMenuItem(
            item: LeftMenuControllerFleet.to.setting,
            onTap: () => Get.toNamed(AppRoutes1.setting),
          ),
          SizedBox(
            height: 30.sp,
          ),
          LeftMenuItem(
            item: LeftMenuControllerFleet.to.help,
            onTap: () async {
              final Uri whatsapp = Uri.parse('https://wa.me/+918714034112');
              launchUrl(whatsapp);
            },
          ),
          const Divider().cPadSymmetric(v: 20.sp),
          // LeftMenuItem(
          //   item: LeftMenuControllerFleet.to.switchToDiver,
          //   onTap: () async {
          //     try {
          //       await ApiServices.logout(body: {});
          //     } finally {
          //       await box.erase();
          //       await box.write(BoxKeys.userTypeCode, UserTypeCode.driver);
          //       Get.put(ApiServices(appBaseUrl: ''));
          //       Get.toNamed(AppRoutes1.signIn, arguments: UserType.driver);
          //     }
          //   },
          // ),
          SizedBox(
            height: 30.sp,
          ),
          LeftMenuItem(
            item: LeftMenuControllerFleet.to.logOut,
            onTap: () => Get.bottomSheet(LogoutBottomSheet()),
          ),
          SizedBox(
            height: 100.sp,
          ),
          Center(
            child: Obx(() => Text(
                  'Version: ${LeftMenuControllerDriver.to.version.value}+${LeftMenuControllerDriver.to.buildNumber.value}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black
                        .withOpacity(0.3), // Makes the text semi-transparent
                    fontWeight: FontWeight
                        .w300, // Lighter font weight for subtle appearance
                    letterSpacing:
                        0.3, // Slight letter spacing for a refined look
                  ),
                )),
          )
        ],
      ),
    );
  }
}

class LeftMenuProfileItem extends StatelessWidget {
  const LeftMenuProfileItem({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.offAndToNamed(AppRoutes1.profile),
      child: Container(
        color: Get.theme.primaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Image.asset(
                      AppIcons.user,
                      height: 20.sp,
                      color: Get.theme.indicatorColor,
                    ),
                    SizedBox(
                      width: 10.sp,
                    ),
                    Text(
                      "My Profile",
                      style: TextStyle(
                        fontSize: 16.sp,
                        height: 1,
                      ),
                    ),
                  ],
                ),
                SvgPicture.asset(
                  AppIcons.arrowRight,
                  height: 18.sp,
                  color: Get.theme.indicatorColor,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LeftMenuItem extends StatelessWidget {
  final LeftMenuItemModel item;
  final void Function()? onTap;
  const LeftMenuItem({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Get.theme.primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image.asset(
                  item.icon,
                  color: Get.theme.indicatorColor,
                  height: 20.sp,
                ),
                SizedBox(
                  width: 10.sp,
                ),
                Text(
                  item.text,
                  style: TextStyle(
                    fontSize: 16.sp,
                    height: 1,
                  ),
                ),
              ],
            ),
            SvgPicture.asset(
              AppIcons.arrowRight,
              height: 18.sp,
              color: Get.theme.indicatorColor,
            )
          ],
        ),
      ),
    );
  }
}
