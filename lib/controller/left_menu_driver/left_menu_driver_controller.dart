import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_utils/flutter_custom_utils.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:waiver_driver/backend/api/api_services/urls.dart';
import 'package:waiver_driver/backend/model/left_menu_driver/left_menu_driver_model.dart';
import 'package:waiver_driver/core/constants/get_storage_constants.dart';
import 'package:waiver_driver/core/themes/assets/icons.dart';
import 'package:waiver_driver/core/widgets/snackbar/snackbar.dart';
import 'package:waiver_driver/helper/router/app_routes/route.dart';

import '../../backend/api/api_services/api_services.dart';

import '../../main.dart';

import '../../view/loading_animation/loading_animation.dart';

class LeftMenuControllerDriver extends GetxController {
  @override
  void onInit() {
    Get.put(ApiServices(appBaseUrl: AppUrls.base));
    getAppVersion();
    super.onInit();
  }

  static LeftMenuControllerDriver get to => Get.find();

  final RxString version = ''.obs;
  final RxString buildNumber = ''.obs;

  LeftMenuItemModel myEarning = LeftMenuItemModel(
    icon: AppIcons.wallet,
    text: 'My Earning',
  );
  LeftMenuItemModel bankDetails = LeftMenuItemModel(
    icon: AppIcons.bankDetails,
    text: 'Bank Details',
  );
  LeftMenuItemModel rating = LeftMenuItemModel(
    icon: AppIcons.star,
    text: 'Rating',
  );
  LeftMenuItemModel myRides = LeftMenuItemModel(
    icon: AppIcons.clock,
    text: 'My Rides',
  );
  LeftMenuItemModel referAndEarn = LeftMenuItemModel(
    icon: AppIcons.referAndEarn,
    text: 'Refer And Earn',
  );
  LeftMenuItemModel notification = LeftMenuItemModel(
    icon: AppIcons.notification,
    text: 'Notification',
  );
  LeftMenuItemModel setting = LeftMenuItemModel(
    icon: AppIcons.setting,
    text: 'Settings',
  );
  LeftMenuItemModel help = LeftMenuItemModel(
    icon: AppIcons.help,
    text: 'Help',
  );
  LeftMenuItemModel logOut = LeftMenuItemModel(
    icon: AppIcons.logout,
    text: 'Logout',
  );
  LeftMenuItemModel switchToDiver = LeftMenuItemModel(
    icon: AppIcons.preferences,
    text: 'Switch To Fleet',
  );

  changeDarkMode() {}

  // Method to handle sharing the user ID
  void shareUserId() {
    final userId = box.read(BoxKeys.userID) ?? "";
    if (userId.isNotEmpty) {
      Share.share(userId);
    }
  }

  Future<void> getAppVersion() async {
    version.value = await box.read(BoxKeys.version) ?? "0.0";
    buildNumber.value = await box.read(BoxKeys.buildNumber) ?? "0.0";
  }

  logoutUser() {
    Get.showOverlay(
      loadingWidget: const LoadingBarsAnimation(),
      asyncFunction: () async => await logout(),
    );
  }

  Future<void> logout() async {
    try {
      Get.showOverlay(
          asyncFunction: () async {
            try {
              await ApiServices.logout(body: {});
            } finally {
              await FirebaseMessaging.instance.deleteToken();

              await box.erase();
              Get.offAllNamed(AppRoutes1.getDriverTypeSelectionRoute());
            }
          },
          loadingWidget: LoadingBarsAnimation());
    } catch (error) {
      Get.showSnackbar(
        GetSnackBar(
          duration: 5.cSeconds,
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.zero,
          messageText: const AppSnackBar(
            text: "OOPS Something went wrong",
          ),
          onTap: (snack) async {
            await box.erase();
            Get.offAndToNamed(AppRoutes1.getInitialRoute());
          },
        ),
      );
    }
  }
}
