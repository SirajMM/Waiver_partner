import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:location/location.dart';
import 'package:waiver_driver/backend/parser/splash/splash_parser.dart';
import 'package:waiver_driver/helper/router/app_routes/route.dart';

import '../../core/constants/get_storage_constants.dart';
import '../../helper/init/init.dart';
import '../../helper/no_internet_view.dart';
import '../../helper/router/app_routes/app_routes.dart';
import '../../main.dart';

// class SplashControllerBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.put(SplashController());
//   }
// }

class SplashController extends GetxController implements GetxService {
  @override
  void onInit() async {
    await MainBinding().dependencies();
    super.onInit();

    // await Future.delayed(const Duration(seconds: 3), () async {
    // String? token = "";

    // String? token = box.read(BoxKeys.token);

    await Future.delayed(const Duration(seconds: 3), () async {
      final token = box.read(BoxKeys.token);
      log('Token: ${token ?? "No Token"}');

      final PermissionStatus permissionGranted =
          await Location().hasPermission();
      final bool serviceEnabled = await Location().serviceEnabled();

      log('Permission Status: $permissionGranted');
      log('Service Enabled: $serviceEnabled');

      if (permissionGranted == PermissionStatus.denied ||
          permissionGranted == PermissionStatus.deniedForever ||
          !serviceEnabled) {
        log('Permission not granted or service disabled. Redirecting...');
        Get.offAllNamed(AppRoutes1.getgetLocationInRoute());
      } else {
        log('All permissions granted. Proceeding...');
        route(token);
      }
    });
  }

  Future<void> requestLocPermission() async {
    if (!await Location().serviceEnabled()) {
      if (!await Location().requestService()) {
        return;
      }
    }

    var permissionGranted = await Location().hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await Location().requestPermission();
    }

    if (permissionGranted == PermissionStatus.granted) {
      final token = box.read(BoxKeys.token);
      route(token);
    }
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

  Future<void> route(token) async {
    if ((token ?? "").isEmpty) {
      // Get.offAllNamed(AppRoutes1.driverTypeSelection);
      Get.offAllNamed(AppRoutes1.getDriverTypeSelectionRoute());
    } else {
      bool? isRegistered = box.read(BoxKeys.isRegistered) == "1" ? true : false;
      bool? isVerifed = box.read(BoxKeys.isVerified) == "1" ? true : false;
      String? userTypeCode = box.read(BoxKeys.userTypeCode);

      if (userTypeCode == UserTypeCode.fleet) {
        if (isRegistered ?? false) {
          Get.offAllNamed(AppRoutes1.getFleetHomePageInRoute());
        } else {
          // Get.offAllNamed(AppRoutes.driverTypeSelection);
          Get.offAllNamed(AppRoutes1.getDriverTypeSelectionRoute());
        }
      } else {
        if (isVerifed ?? false) {
          Get.offAllNamed(AppRoutes1.getHomeInRoute());
        } else if (isRegistered ?? false) {
          Get.offAllNamed(AppRoutes1.getChauffeurProofInRoute(),
              arguments: userTypeCode);
        } else {
          // Get.offAllNamed(AppRoutes.driverTypeSelection);
          Get.offAllNamed(AppRoutes1.getDriverTypeSelectionRoute());
        }
      }
    }
  }
}
