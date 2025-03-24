// import 'dart:async';
// import 'dart:developer';
// import 'dart:io';

// import 'package:flutter/services.dart';
// import 'package:get/get.dart';

// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:location/location.dart';
// import 'package:waiver_driver/backend/parser/splash/splash_parser.dart';
// import 'package:waiver_driver/helper/router/app_routes/route.dart';

// import '../../core/constants/get_storage_constants.dart';
// import '../../helper/init/init.dart';
// import '../../helper/no_internet_view.dart';
// import '../../helper/router/app_routes/app_routes.dart';
// import '../../main.dart';

// // class SplashControllerBinding extends Bindings {
// //   @override
// //   void dependencies() {
// //     Get.put(SplashController());
// //   }
// // }

// class SplashController extends GetxController implements GetxService {
//   @override
//   void onInit() async {
//     // await MainBinding().dependencies();
//     super.onInit();

//     await Future.delayed(const Duration(seconds: 3), () async {});
//     final token = box.read(BoxKeys.token);
//     log('Token: ${token ?? "No Token"}');

//     final PermissionStatus permissionGranted = await Location().hasPermission();
//     bool serviceEnabled = await Location().serviceEnabled();

//     if (!serviceEnabled) {
//       serviceEnabled = await Location().requestService();
//       if (!serviceEnabled) {
//         print("Location services are disabled.");
//         closeApp();
//         return;
//       }
//     }
//     log('Permission Status: $permissionGranted');
//     log('Service Enabled: $serviceEnabled');

//     if (permissionGranted == PermissionStatus.denied ||
//         permissionGranted == PermissionStatus.deniedForever ||
//         !serviceEnabled) {
//       log('Permission not granted or service disabled. Redirecting...');
//       Get.offAllNamed(AppRoutes1.getgetLocationInRoute());
//     } else {
//       log('All permissions granted. Proceeding...');
//       route(token);
//     }
//     // });
//   }

//   Future<void> requestLocPermission() async {
//     if (!await Location().serviceEnabled()) {
//       if (!await Location().requestService()) {
//         return;
//       }
//     }

//     var permissionGranted = await Location().hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await Location().requestPermission();
//     }

//     if (permissionGranted == PermissionStatus.granted) {
//       final token = box.read(BoxKeys.token);
//       route(token);
//     }
//   }

//   Future<void> route(token) async {
//     if ((token ?? "").isEmpty) {
//       // Get.offAllNamed(AppRoutes1.driverTypeSelection);
//       Get.offAllNamed(AppRoutes1.getDriverTypeSelectionRoute());
//     } else {
//       bool? isRegistered = box.read(BoxKeys.isRegistered) == "1" ? true : false;
//       bool? isVerifed = box.read(BoxKeys.isVerified) == "1" ? true : false;
//       String? userTypeCode = box.read(BoxKeys.userTypeCode);

//       if (userTypeCode == UserTypeCode.fleet) {
//         if (isRegistered ?? false) {
//           Get.offAllNamed(AppRoutes1.getFleetHomePageInRoute());
//         } else {
//           // Get.offAllNamed(AppRoutes.driverTypeSelection);
//           Get.offAllNamed(AppRoutes1.getDriverTypeSelectionRoute());
//         }
//       } else {
//         if (isVerifed ?? false) {
//           Get.offAllNamed(AppRoutes1.getHomeInRoute());
//         } else if (isRegistered ?? false) {
//           Get.offAllNamed(AppRoutes1.getChauffeurProofInRoute(),
//               arguments: userTypeCode);
//         } else {
//           // Get.offAllNamed(AppRoutes.driverTypeSelection);
//           Get.offAllNamed(AppRoutes1.getDriverTypeSelectionRoute());
//         }
//       }
//     }
//   }

//   void closeApp() {
//     if (Platform.isAndroid) {
//       SystemNavigator.pop(); // Close app on Android
//     } else if (Platform.isIOS) {
//       exit(0); // Close app on iOS
//     }
//   }
// }

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
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

// Binding to ensure SplashController is initialized only once
// class SplashControllerBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.put(SplashController(), permanent: true); // Ensures it's not recreated
//   }
// }

class SplashController extends GetxController implements GetxService {
  @override
  void onInit() async {
    super.onInit();

    // Delayed execution for splash screen
    await Future.delayed(const Duration(seconds: 3));

    final token = box.read(BoxKeys.token);
    log('Token: ${token ?? "No Token"}');

    final PermissionStatus permissionGranted = await Location().hasPermission();
    bool serviceEnabled = await Location().serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await Location().requestService();
      if (!serviceEnabled) {
        print("Location services are disabled.");
        closeApp();
        return;
      }

      // Prevent multiple redirections
      // if (Get.currentRoute != AppRoutes1.getgetLocationInRoute()) {
      //   Get.offAllNamed(AppRoutes1.getgetLocationInRoute());
      // }
      route(token);
      // return;
    }

    log('Permission Status: $permissionGranted');
    log('Service Enabled: $serviceEnabled');

    if (permissionGranted == PermissionStatus.denied ||
        permissionGranted == PermissionStatus.deniedForever ||
        !serviceEnabled) {
      log('Permission not granted or service disabled. Redirecting...');

      // Prevent unnecessary multiple calls
      if (Get.currentRoute != AppRoutes1.getgetLocationInRoute()) {
        Get.offAllNamed(AppRoutes1.getgetLocationInRoute());
      }
    } else {
      // await AppConstants.locationData?.getLocation().then((location) {
      //   currentPosition.value = Position(
      //     latitude: location.latitude ?? 0.0, // Default to 0.0 if null
      //     longitude: location.longitude ?? 0.0, // Default to 0.0 if null
      //     timestamp: DateTime.now(), // Set current timestamp
      //     accuracy: location.accuracy ?? 0.0,
      //     altitude: location.altitude ?? 0.0,
      //     heading: location.heading ?? 0.0,
      //     speed: location.speed ?? 0.0,
      //     speedAccuracy: location.speedAccuracy ?? 0.0,
      //     altitudeAccuracy: 0.0,
      //     headingAccuracy: 0.0,
      //   );
      // });

      // AppConstants.currentPosition = currentPosition.value;
      log('All permissions granted. Proceeding...');
      route(token);
    }
  }

  Rx<Position?> currentPosition = Rx<Position?>(null);
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

  Future<void> route(token) async {
    if ((token ?? "").isEmpty) {
      Get.offAllNamed(AppRoutes1.getDriverTypeSelectionRoute());
    } else {
      bool? isRegistered = box.read(BoxKeys.isRegistered) == "1";
      bool? isVerified = box.read(BoxKeys.isVerified) == "1";
      String? userTypeCode = box.read(BoxKeys.userTypeCode);

      if (userTypeCode == UserTypeCode.fleet) {
        if (isRegistered) {
          Get.offAllNamed(AppRoutes1.getFleetHomePageInRoute());
        } else {
          Get.offAllNamed(AppRoutes1.getDriverTypeSelectionRoute());
        }
      } else {
        if (isVerified) {
          Get.offAllNamed(AppRoutes1.getHomeInRoute());
        } else if (isRegistered) {
          Get.offAllNamed(AppRoutes1.getChauffeurProofInRoute(),
              arguments: userTypeCode);
        } else {
          Get.offAllNamed(AppRoutes1.getDriverTypeSelectionRoute());
        }
      }
    }
  }

  void closeApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop(); // Close app on Android
    } else if (Platform.isIOS) {
      exit(0); // Close app on iOS
    }
  }
}
