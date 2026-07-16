// // import 'dart:async';
// // import 'dart:developer';
// // import 'dart:io';

// // import 'package:flutter/services.dart';
// // import 'package:get/get.dart';

// // import 'package:connectivity_plus/connectivity_plus.dart';
// // import 'package:internet_connection_checker/internet_connection_checker.dart';
// // import 'package:location/location.dart';
// // import 'package:waiver_driver/backend/parser/splash/splash_parser.dart';
// // import 'package:waiver_driver/helper/router/app_routes/route.dart';

// // import '../../core/constants/get_storage_constants.dart';
// // import '../../helper/init/init.dart';
// // import '../../helper/no_internet_view.dart';
// // import '../../helper/router/app_routes/app_routes.dart';
// // import '../../main.dart';

// // // class SplashControllerBinding extends Bindings {
// // //   @override
// // //   void dependencies() {
// // //     Get.put(SplashController());
// // //   }
// // // }

// // class SplashController extends GetxController implements GetxService {
// //   @override
// //   void onInit() async {
// //     // await MainBinding().dependencies();
// //     super.onInit();

// //     await Future.delayed(const Duration(seconds: 3), () async {});
// //     final token = box.read(BoxKeys.token);
// //     log('Token: ${token ?? "No Token"}');

// //     final PermissionStatus permissionGranted = await Location().hasPermission();
// //     bool serviceEnabled = await Location().serviceEnabled();

// //     if (!serviceEnabled) {
// //       serviceEnabled = await Location().requestService();
// //       if (!serviceEnabled) {
// //         print("Location services are disabled.");
// //         closeApp();
// //         return;
// //       }
// //     }
// //     log('Permission Status: $permissionGranted');
// //     log('Service Enabled: $serviceEnabled');

// //     if (permissionGranted == PermissionStatus.denied ||
// //         permissionGranted == PermissionStatus.deniedForever ||
// //         !serviceEnabled) {
// //       log('Permission not granted or service disabled. Redirecting...');
// //       Get.offAllNamed(AppRoutes1.getgetLocationInRoute());
// //     } else {
// //       log('All permissions granted. Proceeding...');
// //       route(token);
// //     }
// //     // });
// //   }

// //   Future<void> requestLocPermission() async {
// //     if (!await Location().serviceEnabled()) {
// //       if (!await Location().requestService()) {
// //         return;
// //       }
// //     }

// //     var permissionGranted = await Location().hasPermission();
// //     if (permissionGranted == PermissionStatus.denied) {
// //       permissionGranted = await Location().requestPermission();
// //     }

// //     if (permissionGranted == PermissionStatus.granted) {
// //       final token = box.read(BoxKeys.token);
// //       route(token);
// //     }
// //   }

// //   Future<void> route(token) async {
// //     if ((token ?? "").isEmpty) {
// //       // Get.offAllNamed(AppRoutes1.driverTypeSelection);
// //       Get.offAllNamed(AppRoutes1.getDriverTypeSelectionRoute());
// //     } else {
// //       bool? isRegistered = box.read(BoxKeys.isRegistered) == "1" ? true : false;
// //       bool? isVerifed = box.read(BoxKeys.isVerified) == "1" ? true : false;
// //       String? userTypeCode = box.read(BoxKeys.userTypeCode);

// //       if (userTypeCode == UserTypeCode.fleet) {
// //         if (isRegistered ?? false) {
// //           Get.offAllNamed(AppRoutes1.getFleetHomePageInRoute());
// //         } else {
// //           // Get.offAllNamed(AppRoutes.driverTypeSelection);
// //           Get.offAllNamed(AppRoutes1.getDriverTypeSelectionRoute());
// //         }
// //       } else {
// //         if (isVerifed ?? false) {
// //           Get.offAllNamed(AppRoutes1.getHomeInRoute());
// //         } else if (isRegistered ?? false) {
// //           Get.offAllNamed(AppRoutes1.getChauffeurProofInRoute(),
// //               arguments: userTypeCode);
// //         } else {
// //           // Get.offAllNamed(AppRoutes.driverTypeSelection);
// //           Get.offAllNamed(AppRoutes1.getDriverTypeSelectionRoute());
// //         }
// //       }
// //     }
// //   }

// //   void closeApp() {
// //     if (Platform.isAndroid) {
// //       SystemNavigator.pop(); // Close app on Android
// //     } else if (Platform.isIOS) {
// //       exit(0); // Close app on iOS
// //     }
// //   }
// // }

// import 'dart:async';
// import 'dart:developer';
// import 'dart:io';

// import 'package:flutter/services.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:location/location.dart';
// import 'package:waiver_driver/helper/router/app_routes/route.dart';

// import '../../core/constants/get_storage_constants.dart';
// import '../../main.dart';

// // Binding to ensure SplashController is initialized only once
// // class SplashControllerBinding extends Bindings {
// //   @override
// //   void dependencies() {
// //     Get.put(SplashController(), permanent: true); // Ensures it's not recreated
// //   }
// // }

// class SplashController extends GetxController implements GetxService {
//   @override
//   void onInit() async {
//     super.onInit();

//     // Delayed execution for splash screen
//     await Future.delayed(const Duration(seconds: 3));
//     AppConstants.locationData = getLocationData();
//     final token = box.read(BoxKeys.token);
//     log('Token: ${token ?? "No Token"}');

//     final PermissionStatus permissionGranted = await Location().hasPermission();
//     bool serviceEnabled = await Location().serviceEnabled();

//     if (!serviceEnabled) {
//       serviceEnabled = await Location().requestService();
//       if (!serviceEnabled) {
//         log("Location services are disabled.");
//         closeApp();
//         return;
//       }

//       // Prevent multiple redirections
//       // if (Get.currentRoute != AppRoutes1.getgetLocationInRoute()) {
//       //   Get.offAllNamed(AppRoutes1.getgetLocationInRoute());
//       // }
//       route(token);
//       // return;
//     }

//     log('Permission Status: $permissionGranted');
//     log('Service Enabled: $serviceEnabled');

//     if (permissionGranted == PermissionStatus.denied ||
//         permissionGranted == PermissionStatus.deniedForever ||
//         !serviceEnabled) {
//       log('Permission not granted or service disabled. Redirecting...');

//       // Prevent unnecessary multiple calls
//       if (Get.currentRoute != AppRoutes1.getgetLocationInRoute()) {
//         Get.offAllNamed(AppRoutes1.getgetLocationInRoute());
//       }
//     } else {
//       // await AppConstants.locationData?.getLocation().then((location) {
//       //   currentPosition.value = Position(
//       //     latitude: location.latitude ?? 0.0, // Default to 0.0 if null
//       //     longitude: location.longitude ?? 0.0, // Default to 0.0 if null
//       //     timestamp: DateTime.now(), // Set current timestamp
//       //     accuracy: location.accuracy ?? 0.0,
//       //     altitude: location.altitude ?? 0.0,
//       //     heading: location.heading ?? 0.0,
//       //     speed: location.speed ?? 0.0,
//       //     speedAccuracy: location.speedAccuracy ?? 0.0,
//       //     altitudeAccuracy: 0.0,
//       //     headingAccuracy: 0.0,
//       //   );
//       // });

//       // AppConstants.currentPosition = currentPosition.value;
//       log('All permissions granted. Proceeding...');
//       route(token);
//     }
//   }

//   Rx<Position?> currentPosition = Rx<Position?>(null);
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
//       Get.offAllNamed(AppRoutes1.getDriverTypeSelectionRoute());
//     } else {
//       bool? isRegistered = box.read(BoxKeys.isRegistered) == "1";
//       bool? isVerified = box.read(BoxKeys.isVerified) == "1";
//       String? userTypeCode = box.read(BoxKeys.userTypeCode);

//       if (userTypeCode == UserTypeCode.fleet) {
//         if (isRegistered) {
//           Get.offAllNamed(AppRoutes1.getFleetHomePageInRoute());
//         } else {
//           Get.offAllNamed(AppRoutes1.getDriverTypeSelectionRoute());
//         }
//       } else {
//         if (isVerified) {
//           Get.offAllNamed(AppRoutes1.getHomeInRoute());
//         } else if (isRegistered) {
//           Get.offAllNamed(AppRoutes1.getChauffeurProofInRoute(),
//               arguments: userTypeCode);
//         } else {
//           Get.offAllNamed(AppRoutes1.getDriverTypeSelectionRoute());
//         }
//       }
//     }
//   }

//   void closeApp() {
//     if (Platform.isAndroid) {
//       SystemNavigator.pop();
//     } else if (Platform.isIOS) {
//       exit(0);
//     }
//   }

//   LocationData? getLocationData() {
//     final data = box.read(BoxKeys.lastLocation);
//     if (data != null) {
//       return LocationData.fromMap({
//         'latitude': data['latitude'],
//         'longitude': data['longitude'],
//         'accuracy': data['accuracy'],
//         'altitude': data['altitude'],
//         'speed': data['speed'],
//         'speedAccuracy': data['speedAccuracy'],
//         'heading': data['heading'],
//         'time': data['time'],
//       });
//     }
//     return null;
//   }
// }

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:app_settings/app_settings.dart'; // Add this package to pubspec.yaml
import 'package:waiver_driver/helper/router/app_routes/route.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../backend/api/api_services/api_services.dart';
import '../../core/constants/get_storage_constants.dart';
import '../../main.dart';

class SplashController extends GetxController implements GetxService {
  @override
  void onInit() async {
    super.onInit();
    _syncTokenToSharedPreferences();
    _registerVoipTokenIfAvailable();
    // Delayed execution for splash screen
    await Future.delayed(const Duration(seconds: 3));

    final token = box.read(BoxKeys.token);
    log('Token: ${token ?? "No Token"}');

    await _checkLocationPermissionAndProceed(token);
  }

  Future<void> _checkLocationPermissionAndProceed(String? token) async {
    try {
      final PermissionStatus permissionGranted = await Location().hasPermission();
      bool serviceEnabled = await Location().serviceEnabled();

      log('Permission Status: $permissionGranted');
      log('Service Enabled: $serviceEnabled');

      // First check permission status - if denied, show location screen
      if (permissionGranted == PermissionStatus.denied) {
        log('Permission denied. Redirecting to permission screen...');
        _redirectToLocationPermissionScreen();
        return;
      } else if (permissionGranted == PermissionStatus.deniedForever) {
        log('Permission denied forever. Redirecting to permission screen...');
        _redirectToLocationPermissionScreen();
        return;
      }

      // If permission is granted, then check location service
      if (permissionGranted == PermissionStatus.granted) {
        if (!serviceEnabled) {
          log('Permission granted but location service disabled. Showing system popup...');
          serviceEnabled = await Location().requestService();
          if (!serviceEnabled) {
            log("User declined to enable location services.");
            // You can choose to close app or stay on current screen
            closeApp();
            return;
          }
        }

        // Both permission and service are enabled
        log('All permissions granted and service enabled. Proceeding...');
        AppConstants.locationData = getLocationData();
        route(token);
      } else {
        log('Unexpected state. Redirecting to permission screen...');
        _redirectToLocationPermissionScreen();
      }
    } catch (e) {
      log('Error checking location permission: $e');
      _redirectToLocationPermissionScreen();
    }
  }

  void _redirectToLocationPermissionScreen() {
    if (Get.currentRoute != AppRoutes1.getgetLocationInRoute()) {
      Get.offAllNamed(AppRoutes1.getgetLocationInRoute());
    }
  }

  Rx<Position?> currentPosition = Rx<Position?>(null);

  /// Call this method when user clicks "Allow Permission" button
  Future<void> requestLocPermission() async {
    try {
      // First request permission if not granted
      var permissionGranted = await Location().hasPermission();

      if (permissionGranted == PermissionStatus.denied) {
        // Request permission
        permissionGranted = await Location().requestPermission();
      }

      if (permissionGranted == PermissionStatus.deniedForever) {
        // Permission denied forever, open app settings
        await _openAppSettings();
        return;
      }

      if (permissionGranted == PermissionStatus.granted) {
        // Permission granted! Now check location service and show popup if needed
        if (!await Location().serviceEnabled()) {
          log('Permission granted, now requesting location service...');
          final bool serviceRequested = await Location().requestService();
          if (!serviceRequested) {
            log('User declined to enable location service');
            // You can choose to close app or stay on screen
            closeApp();
            return;
          }
        }

        // Both permission and service are enabled, proceed
        log('Both permission and service enabled. Proceeding...');
        final token = box.read(BoxKeys.token);
        AppConstants.locationData = getLocationData();
        route(token);
      } else {
        // Permission still denied, open settings
        log('Permission still denied after request');
        await _openAppSettings();
      }
    } catch (e) {
      log('Error requesting location permission: $e');
      // Optionally show an error message to user
    }
  }

  /// Open device location settings
  Future<void> _openLocationSettings() async {
    try {
      // For location-specific settings, use:
      await AppSettings.openAppSettings(type: AppSettingsType.location);
    } catch (e) {
      log('Error opening location settings: $e');
      // Fallback to general app settings
      try {
        await AppSettings.openAppSettings();
      } catch (e2) {
        log('Error opening app settings: $e2');
      }
    }
  }

  /// Open app-specific settings
  Future<void> _openAppSettings() async {
    try {
      await AppSettings.openAppSettings();
    } catch (e) {
      log('Error opening app settings: $e');
    }
  }

  /// Call this method when user returns from settings
  Future<void> recheckPermissions() async {
    final token = box.read(BoxKeys.token);
    await _checkLocationPermissionAndProceed(token);
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
          Get.offAllNamed(AppRoutes1.getChauffeurProofInRoute(), arguments: userTypeCode);
        } else {
          Get.offAllNamed(AppRoutes1.getDriverTypeSelectionRoute());
        }
      }
    }
  }

  Future<void> _syncTokenToSharedPreferences() async {
    try {
      final token = box.read(BoxKeys.token);

      if (token != null && token.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        log('✅ Token synced in SplashController');
      }
    } catch (e) {
      log('❌ Error syncing token in SplashController: $e');
    }
  }

  Future<void> _registerVoipTokenIfAvailable() async {
    if (!Platform.isIOS) return;
    try {
      final token = box.read(BoxKeys.token);
      if (token == null || token.isEmpty) return;

      final voipToken = await FlutterCallkitIncoming.getDevicePushTokenVoIP();
      if (voipToken is String && voipToken.isNotEmpty) {
        // await ApiServices.registerVoipToken(token: voipToken);
      }
    } catch (e) {
      log('❌ Error registering VoIP token in SplashController: $e');
    }
  }

  void closeApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }

  LocationData? getLocationData() {
    final data = box.read(BoxKeys.lastLocation);
    if (data != null) {
      return LocationData.fromMap({
        'latitude': data['latitude'],
        'longitude': data['longitude'],
        'accuracy': data['accuracy'],
        'altitude': data['altitude'],
        'speed': data['speed'],
        'speedAccuracy': data['speedAccuracy'],
        'heading': data['heading'],
        'time': data['time'],
      });
    }
    return null;
  }
}
