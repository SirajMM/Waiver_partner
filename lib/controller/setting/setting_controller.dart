import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waiver_driver/backend/model/setting/setting_model.dart';
import 'package:waiver_driver/backend/parser/Settings/settings_parser.dart';
import 'package:waiver_driver/core/themes/assets/icons.dart';
import 'package:waiver_driver/core/widgets/snackbar/snackbar.dart';
import 'package:waiver_driver/helper/router/app_routes/route.dart';

import 'package:waiver_driver/main.dart';

import '../../backend/api/api_services/api_services.dart';
import '../../helper/router/app_routes/app_routes.dart';

import '../../view/loading_animation/loading_animation.dart';

// class SettingControllerBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut(() => SettingController());
//   }
// }

class SettingController extends GetxController {
  SettingsParser parser;

  SettingController({required this.parser});

  static SettingController get to => Get.find();
  void onInit() {
    darkMode.value = Get.theme == ThemeData.dark;
  }

  SettingItemModel preferencesItem = SettingItemModel(
    header: "Preferences",
    text: "Manage preferences",
    icon: AppIcons.preferences,
  );
  SettingItemModel darkModeItem = SettingItemModel(
    header: "Dark Mode",
    text: "Switch dark mode",
    icon: AppIcons.darkMode,
  );
  SettingItemModel logoutItem = SettingItemModel(
    header: "Logout",
    text: "Logout your account",
    icon: AppIcons.logout,
  );
  SettingItemModel deleteAccountItem = SettingItemModel(
    header: "Delete Account",
    text: "Delete all your data",
    icon: AppIcons.delete,
  );

  // changeDarkMode() async {
  //   Get.back();
  //   Get.changeTheme(box.read(BoxKeys.darkMode) == "1"
  //       ? AppTheme.darkTheme
  //       : AppTheme.lightTheme);
  //
  //   if (box.read(BoxKeys.darkMode) == "1") {
  //     box.write(BoxKeys.darkMode, "0");
  //   } else {
  //     box.write(BoxKeys.darkMode, "1");
  //   }
  //   if (box.read(BoxKeys.userTypeCode) == UserTypeCode.fleet) {
  //     Get.offAllNamed(AppRoutes.fleetHomePage);
  //   } else {
  //     Get.offAllNamed(AppRoutes.home);
  //   }
  // }

  logoutUser() {
    Get.showOverlay(
      loadingWidget: const LoadingBarsAnimation(),
      asyncFunction: () async => logout(),
    );
  }

  RxBool darkMode = false.obs;

  logout() async {
    try {
      var response = await ApiServices.logout(body: {});
    } finally {
      await FirebaseMessaging.instance.deleteToken();
      await box.erase();
      Get.offAllNamed(AppRoutes.driverTypeSelection);
    }
  }

  deleteAccount() async {
    try {
      var response = await ApiServices.deleteAccount(body: {});
      if (response.status == 200) {
        await FirebaseMessaging.instance.deleteToken();
        await box.erase();
        // Clear entire navigation stack
        Get.offAllNamed(AppRoutes1.getDriverTypeSelectionRoute());
      } else {
        Get.showSnackbar(
          GetSnackBar(
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            messageText: AppSnackBar(
              text: response.message ?? "",
            ),
          ),
        );
      }
    } catch (error) {
      Get.showSnackbar(
        const GetSnackBar(
          duration: Duration(seconds: 5),
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.zero,
          messageText: AppSnackBar(
            text: "OOPS Something went wrong",
          ),
        ),
      );
    }
  }

  deleteUser() {
    Get.showOverlay(
      loadingWidget: const LoadingBarsAnimation(),
      asyncFunction: () async => deleteAccount(),
    );
  }
}
