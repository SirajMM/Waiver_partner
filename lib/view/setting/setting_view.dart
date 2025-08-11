import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waiver_driver/backend/model/setting/setting_model.dart';
import 'package:waiver_driver/controller/setting/setting_controller.dart';
import 'package:waiver_driver/core/colors/app_colors.dart';
import 'package:waiver_driver/core/constants/get_storage_constants.dart';
import 'package:waiver_driver/core/themes/assets/icons.dart';
import 'package:waiver_driver/core/widgets/app_bar/app_bar.dart';
import 'package:waiver_driver/core/widgets/app_buttons/app_buttons.dart';
import 'package:waiver_driver/core/widgets/circle_with_gradient/circle_with_gradient.dart';
import 'package:waiver_driver/main.dart';

import '../../helper/router/app_routes/route.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(title: "Settings", actions: [
          GestureDetector(
              onTap: () async {
                final Uri whatsapp = Uri.parse(
                    'https://wa.me/message/DDC362JXDWX7D1');
                launchUrl(whatsapp);
              },
              child: Container(
                  margin: EdgeInsets.all(10.sp),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Get.theme.indicatorColor, width: 1.5.sp),
                      shape: BoxShape.circle),
                  padding: EdgeInsets.all(5.sp),
                  child: Image.asset(
                    AppIcons.customerSupport,
                    color: Get.theme.indicatorColor,
                  )))
        ]),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 13.sp),
          children: [
            SizedBox(
              height: 20.sp,
            ),
            SettingListingItem(
              setting: SettingController.to.preferencesItem,
              onTap: () => Get.toNamed(AppRoutes1.getPreferencesInRoute()),
            ),
            SizedBox(
              height: 15.sp,
            ),
            // SettingListingItem(
            //   setting: SettingController.to.darkModeItem,
            //   onTap: () => Get.bottomSheet(const DarkModeBottomSheet()),
            // ),
            // SizedBox(
            //   height: 15.sp,
            // ),
            SettingListingItem(
              setting: SettingController.to.logoutItem,
              onTap: () => Get.bottomSheet(const LogoutBottomSheet()),
            ),
            SizedBox(
              height: 15.sp,
            ),
            SettingListingItem(
                setting: SettingController.to.deleteAccountItem,
                onTap: () => Get.bottomSheet(const DeleteAccountBottomSheet())),
            SizedBox(
              height: 15.sp,
            ),
          ],
        ));
  }
}

// ignore: must_be_immutable
class SettingListingItem extends StatelessWidget {
  SettingItemModel setting;
  void Function() onTap;
  SettingListingItem({super.key, required this.setting, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 6.sp),
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.grey155, width: 1.5.sp),
            borderRadius: BorderRadius.circular(8.sp)),
        child: Row(
          children: [
            CircleWithIcon(
                height: 43.sp,
                color: AppColors.grey249,
                child: Image.asset(
                  setting.icon,
                  color: AppColors.black,
                  height: 25.sp,
                )),
            SizedBox(
              width: 12.sp,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  setting.header,
                  style:
                      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 2.sp,
                ),
                Text(
                  setting.text,
                  style: TextStyle(fontSize: 12.sp, color: AppColors.grey93),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class DarkModeBottomSheet extends StatelessWidget {
  const DarkModeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.sp),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.sp),
          topRight: Radius.circular(8.sp),
        ),
      ),
      child: ListView(
        shrinkWrap: true,
        children: [
          Text(
            "Dark Mode ?",
            style: TextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.w600,
              fontSize: 20.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 5.sp,
          ),
          Text(
            box.read(BoxKeys.darkMode) == "1"
                ? "Change App to Dark Mode"
                : "Change App to Light Mode",
            style: TextStyle(
              color: AppColors.grey93,
              fontSize: 14.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20.sp,
          ),
          BlueButton(
              text: box.read(BoxKeys.darkMode) == "1"
                  ? " Dark Mode"
                  : "Light Mode",
              onTap: () {}
              // SettingController.to.changeDarkMode(),
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
            onTap: () => SettingController.to.logoutUser(),
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

class DeleteAccountBottomSheet extends StatelessWidget {
  const DeleteAccountBottomSheet({super.key});

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
            "Delete Account ?",
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
            "Are you sure you want to delete your account?",
            style: TextStyle(color: AppColors.grey93, fontSize: 14.sp),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20.sp,
          ),
          RedButton(
              text: "Delete Account",
              onTap: () {
                Get.defaultDialog(
                    backgroundColor: Colors.white,
                    title: 'Confirm',
                    middleText: 'Did you Want to delete this account ?',
                    confirm: RedButton(
                      text: "Yes",
                      height: 40.h,
                      width: 100.sp,
                      onTap: () {
                        Get.back();
                        SettingController.to.deleteUser();
                      },
                    ),
                    cancel: WhiteButton(
                      height: 40.h,
                      width: 100.sp,
                      text: "No",
                      onTap: Get.back,
                    ));
              }),
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
