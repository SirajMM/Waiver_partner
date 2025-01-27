import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_utils/flutter_custom_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waiver_driver/backend/api/api_services/api_services.dart';
import 'package:waiver_driver/backend/model/left_menu_driver/left_menu_driver_model.dart';
import 'package:waiver_driver/core/colors/app_colors.dart';
import 'package:waiver_driver/core/constants/get_storage_constants.dart';
import 'package:waiver_driver/core/themes/assets/icons.dart';
import 'package:waiver_driver/core/widgets/app_buttons/app_buttons.dart';
import 'package:waiver_driver/helper/router/app_routes/app_routes.dart';

import 'package:waiver_driver/main.dart';
import 'package:waiver_driver/view/loading_animation/loading_animation.dart';

import '../../controller/left_menu_driver/left_menu_driver_controller.dart';
import '../../helper/router/app_routes/route.dart';



class LeftMenuDriver extends StatelessWidget {
  const LeftMenuDriver({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LeftMenuControllerDriver());
    return Container(
      width: Get.width * .7,
      height: Get.height,
      padding: EdgeInsets.symmetric(horizontal: 25.sp),
      color: Get.theme.primaryColor,
      child: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(
            height: 20.sp,
          ),
          Row(
            children: [
              Builder(builder: (context) {
                return BackArrow(onTap: () => Get.back());
              }),
            ],
          ),
          SizedBox(
            height: 25.sp,
          ),
          Text(
            "Menu",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30.sp),
          ),
          SizedBox(
            height: 25.sp,
          ),
          const LeftMenuProfileItem(),
          SizedBox(
            height: 14.sp,
          ),
          // LeftMenuItem(
          //   item: LeftMenuControllerDriver.to.myEarning,
          //   onTap: () => Get.toNamed(AppRoutes1.getEraningScreenInRoute()),
          // ),
          SizedBox(
            height: 30.sp,
          ),
          LeftMenuItem(
            item: LeftMenuControllerDriver.to.bankDetails,
            onTap: () => Get.toNamed(AppRoutes1.getViewBankAccountScreenInRoute()),
          ),
          SizedBox(
            height: 30.sp,
          ),
          LeftMenuItem(
            item: LeftMenuControllerDriver.to.rating,
            onTap: () => Get.toNamed(AppRoutes1.getRatingScreenInRoute()),
          ),
          SizedBox(
            height: 30.sp,
          ),
          LeftMenuItem(
            item: LeftMenuControllerDriver.to.myRides,
            onTap: () => Get.toNamed(AppRoutes1.getMyRideScreenInRoute()),
          ),
          SizedBox(
            height: 30.sp,
          ),
          // LeftMenuItem(
          //   item: LeftMenuControllerDriver.to.referAndEarn,
          //   onTap: () => Get.toNamed(AppRoutes.referAndEarn),
          // ),
          // SizedBox(
          //   height: 30.sp,
          // ),
          LeftMenuItem(
            item: LeftMenuControllerDriver.to.notification,
            onTap: () => Get.toNamed(AppRoutes1.getNotificationInRoute()),
          ),
          SizedBox(
            height: 30.sp,
          ),
          LeftMenuItem(
            item: LeftMenuControllerDriver.to.setting,
            onTap: () {
              Scaffold.of(context).openEndDrawer();
              Get.toNamed(AppRoutes1.getSettingsScreeenInRoute());
            },
          ),
          SizedBox(
            height: 30.sp,
          ),
          LeftMenuItem(
            item: LeftMenuControllerDriver.to.help,
            onTap: () async
              {
                final Uri whatsapp= Uri.parse('https://api.whatsapp.com/send?phone=918943099085&text=Hi');
                launchUrl(whatsapp);
              }
          ),
          const Divider().cPadSymmetric(v: 20.sp),
        ( box.read(BoxKeys.userTypeCode))== UserTypeCode.chauffeur?SizedBox():
          LeftMenuItem(
            item: LeftMenuControllerDriver.to.switchToDiver,
            onTap: () async {
              Get.showOverlay(
                  asyncFunction: () async {
                    try {
                      await ApiServices.logout(body: {});
                    } finally {
                      await FirebaseMessaging.instance.deleteToken();
                      await box.erase();
                      await box.write(BoxKeys.userTypeCode, UserTypeCode.fleet);
                      Get.offAllNamed(AppRoutes1.getSignInRoute(),
                          arguments: UserType.fleet);
                    }
                  },
                  loadingWidget: LoadingBarsAnimation());
            },
          ),
          ( box.read(BoxKeys.userTypeCode))== UserTypeCode.chauffeur?SizedBox(): SizedBox(
            height: 30.sp,
          ),
          LeftMenuItem(
            item: LeftMenuControllerDriver.to.logOut,
            onTap: () =>Get.bottomSheet(const LogoutBottomSheet()),
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
      onTap: () => Get.offAndToNamed(AppRoutes1.getProfileScreenInRoute()),
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
                      color: Get.theme.indicatorColor,
                      height: 20.sp,
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
                  color: Get.theme.indicatorColor,
                  height: 18.sp,
                )
              ],
            ),
            SizedBox(
              height: 5.sp,
            ),
            Container(
              padding: EdgeInsets.only(left: 30.sp),
              child: Text(
                "#${box.read(BoxKeys.userID) ?? ""}",
                style: TextStyle(
                    fontSize: 12.sp,
                    color: Get.theme.indicatorColor.withOpacity(0.5)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LeftMenuItem extends StatelessWidget {
  LeftMenuItemModel item;
  void Function()? onTap;
  LeftMenuItem({super.key, required this.item, required this.onTap});

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
              color: Get.theme.indicatorColor,
              height: 18.sp,
            )
          ],
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
            onTap: () => LeftMenuControllerDriver.to.logoutUser(),
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