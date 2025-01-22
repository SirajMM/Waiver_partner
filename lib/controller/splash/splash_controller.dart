import 'dart:async';

import 'package:get/get.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:waiver_driver/backend/parser/splash/splash_parser.dart';
import 'package:waiver_driver/helper/router/app_routes/route.dart';

import '../../core/constants/get_storage_constants.dart';
import '../../helper/no_internet_view.dart';
import '../../helper/router/app_routes/app_routes.dart';
import '../../main.dart';

// class SplashControllerBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.put(SplashController());
//   }
// }

class SplashController extends GetxController {
  @override
  void onInit() async {
    super.onInit();

    await Future.delayed(const Duration(seconds: 3), () {
      // String? token = "";

      String? token = box.read(BoxKeys.token);
      if ((token ?? "").isEmpty) {
        // Get.offAllNamed(AppRoutes1.driverTypeSelection);
        Get.offAllNamed(AppRoutes1.getDriverTypeSelectionRoute());
      } else {
        bool? isRegistered =
            box.read(BoxKeys.isRegistered) == "1" ? true : false;
        bool? isVerifed = box.read(BoxKeys.isVerified) == "1" ? true : false;
        String? userTypeCode = box.read(BoxKeys.userTypeCode);

        if (userTypeCode == UserTypeCode.fleet) {
          if (isRegistered ?? false) {
            Get.offAllNamed(AppRoutes.fleetHomePage);
          } else {
            // Get.offAllNamed(AppRoutes.driverTypeSelection);
            Get.offAllNamed(AppRoutes1.getDriverTypeSelectionRoute());
          }
        } else {
          if (isVerifed ?? false) {
            Get.offAllNamed(AppRoutes.home);
          } else if (isRegistered ?? false) {
            Get.offAllNamed(AppRoutes.chauffeurProof, arguments: userTypeCode);
          } else {
            // Get.offAllNamed(AppRoutes.driverTypeSelection);
            Get.offAllNamed(AppRoutes1.getDriverTypeSelectionRoute());
          }
        }
      }
    });
  }

  // Future<bool> isConnectedToInternet() async {
  //   subscription = Connectivity()
  //       .onConnectivityChanged
  //       .listen((List<ConnectivityResult> result) async {
  //     bool isConnected =
  //         await InternetConnectionChecker.createInstance().hasConnection;

  //     isInternetConnected.value = isConnected;
  //   });
  //   return isInternetConnected.value;
  // }

  // static SplashController get to => Get.find();
}
