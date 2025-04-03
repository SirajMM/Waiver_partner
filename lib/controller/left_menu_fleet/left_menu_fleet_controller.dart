import 'package:get/get.dart';

import 'package:waiver_driver/core/themes/assets/icons.dart';

import '../../backend/api/api_services/api_services.dart';
import '../../backend/model/left_menu_driver/left_menu_driver_model.dart';
import '../../helper/router/app_routes/app_routes.dart';

class LeftMenuControllerFleet extends GetxController {
  static LeftMenuControllerFleet get to => Get.find();

  LeftMenuItemModel myEarning = LeftMenuItemModel(
    icon: AppIcons.wallet,
    text: 'My Profile',
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
    text: 'Switch To Driver',
  );
  logout() async {
    try {
      await ApiServices.logout(body: {});
    } finally {
      Get.offAllNamed(AppRoutes.welcome);
    }
  }
}
