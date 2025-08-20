// import 'dart:async';
// import 'dart:developer';
// import 'dart:math' as math;
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:hive/hive.dart';
// import 'package:mobility_features/mobility_features.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:waiver_driver/backend/model/home/home_model.dart';
// import 'package:waiver_driver/backend/model/setting/setting_model.dart';
// import 'package:waiver_driver/backend/parser/Home/home_parser.dart';
// import 'package:waiver_driver/controller/driver_profile/driver_profile_controller.dart';
// import 'package:waiver_driver/core/themes/assets/audio.dart';
// import 'package:waiver_driver/core/widgets/snackbar/snackbar.dart';
// import 'package:waiver_driver/main.dart';
// import 'package:waiver_driver/view/home/home_view.dart';
// import 'package:location/location.dart' as loc;
// import '../../backend/LocationHandler/LocationTrackingService.dart';
// import '../../backend/api/api_services/api_services.dart';
// import '../../backend/api/api_services/web_socket_services.dart';
// import '../../backend/model/earning/earning_model.dart';
//
// import '../../core/colors/app_colors.dart';
// import '../../core/constants/enums/enums.dart';
// import '../../core/constants/get_storage_constants.dart';
// import '../profile/profile_controller.dart';
//
// // class HomeControllerBinding extends Bindings {
// //   @override
// //   void dependencies() {
// //     Get.lazyPut(() => HomeController());
// //   }
// // }
//
// class HomeController extends GetxController {
//   final HomeParser parser;
//   HomeController({required this.parser});
//
//   static HomeController get to => Get.find();
//
//   RxString appState = "Active".obs;
//   @override
//   void onInit() async {
//     super.onInit();
//     currentPosition.value = convertToPosition(AppConstants.locationData);
//     WidgetsBinding.instance.addObserver;
//     _initializeHive();
//     loc.Location location = loc.Location();
//     try {
//       List<Future> apis = [
//         getDriverOnlineStatus(),
//         fetchWalletBalance(),
//         latestActiveRide(),
//       ];
//       if (currentPosition.value == null) apis.add(location.getLocation());
//       isLoading.value = true;
//
//       final result = await Future.wait(apis);
//
//       if (currentPosition.value == null) {
//         currentPosition.value =
//             convertToPosition(result[3] as loc.LocationData);
//         saveLocationData(result[3] as loc.LocationData);
//       }
//       isLoading.value = false;
//       sendLiveLocation();
//       getVersionInfo();
//       ProfileController.to.getProfile();
//       isAssinged.value = await hasAssigned();
//       log("******************${isAssinged.value}@@@@@@@@@@@@@@@@@@@@@@@@@@");
//       pickUpLocation1 = TripsLocations(
//           latitude: Rx(currentPosition.value?.latitude),
//           longitude: Rx(currentPosition.value?.longitude),
//           name: "".obs);
//
//       getLocationDetails(
//           currentPosition.value!.latitude, currentPosition.value!.longitude)
//           .then(
//             (value) => pickUpLocation1?.name.value = value ?? '',
//       );
//       recenter();
//
//       isError.value = false;
//     } catch (error) {
//       isError.value = false;
//       log(error.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//
// @override
// void didChangeAppLifecycleState(AppLifecycleState state) {
//   if (state == AppLifecycleState.inactive) {
//     appState.value = "Inactive";
//     print("🟡 App Inactive - Keeping API/WebSocket Running");
//   } else if (state == AppLifecycleState.resumed) {
//     appState.value = "Active";
//     print("🟢 App Resumed - Reconnecting WebSocket/Firebase...");
//     resumeConnection();
//   } else if (state == AppLifecycleState.paused) {
//     appState.value = "Background";
//     print("🔴 App in Background - Closing WebSocket...");
//     closeConnection();
//   } else if (state == AppLifecycleState.detached) {
//     appState.value = "Terminated";
//     print(
//         "⚠️ App Terminated - Scheduling WorkManager Task...${appState.value}");

//     // changeDriverOnlineStatus();
//     //   Workmanager().registerOneOffTask(
//     //     "backgroundTask",
//     //     "executeApiCall",
//     //   );
//   }
// }

//   // void closeConnection() {
//   //   log("🔴 Closing WebSocket/Firebase connection........................");
//   //   sendLiveLocation();
//   // }
//   //
//   // void resumeConnection() {
//   //   print("🟢 Reconnecting WebSocket/Firebase...");
//   // }
//
//   @override
//   void onClose() {
//      WidgetsBinding.instance.removeObserver;
//     super.onClose();
//   }
//
//   @override
//   void dispose() {
//     // changeDriverOnlineStatus();
//     super.dispose();
//   }
//
//   final player = AudioPlayer();
//
//   Rx<Position?> currentPosition = Rx<Position?>(null);
//   GoogleMapController? googleMapController;
//   Rx<double?> walletBalance = Rx<double?>(null);
//   bool rideIsActive = false;
//   String? finalDropLocation;
//   bool isTracking = false;
//   double currentDistance =
//   0; // Current distance in meters before it exceeds 100m
//   double totalDistance = 0; // Total distance saved in Hive (in meters)x
//   List<Map<String, double>> latLongList = [];
//   Box? distanceBox;
//   final RxString version = ''.obs;
//   final RxString buildNumber = ''.obs;
//   RxBool recenterLoading = false.obs;
//   RxBool isAssinged = false.obs;
//   RxDouble cameraZoom = 14.0.obs;
//
//   Future<void> _initializeHive() async {
//     distanceBox = await Hive.openBox('distanceBox');
//     totalDistance = distanceBox?.get('totalDistance', defaultValue: 0.0) ?? 0.0;
//   }
//
//   double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
//     var p = 0.017453292519943295; // Pi/180
//     var c = math.cos;
//     var a = 0.5 -
//         c((lat2 - lat1) * p) / 2 +
//         c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
//     return 12742 * math.asin(math.sqrt(a)); // Distance in kilometers
//   }
//
//   Future<void> changeDriverOnlineStatus() async {
//     try {
//       if (isOnlineButtonLoading.value) return;
//       isOnlineButtonLoading.value = true;
//
//       LogoutResponseModel response = await ApiServices.changeOnlineStatus(
//         body: {
//           "is_online": isOnline.value ? 0 : 1,
//         },
//       );
//       log("#####################${isOnline.value}#####################");
//
//       if (response.status == 200) {
//         isOnline.value = !isOnline.value;
//         log("#####################${isOnline.value}#####################");
//
//         if (isOnline.value) {
//           // Initialize FlutterBackground if needed
//           // var androidConfig = const FlutterBackgroundAndroidConfig(
//           //   notificationTitle: "Driver Active",
//           //   notificationText: "You are currently available for rides.",
//           //   notificationImportance: AndroidNotificationImportance.max,
//           //   enableWifiLock: true,
//           // );
//           //
//           // final initialized =
//           //     await FlutterBackground.initialize(androidConfig: androidConfig);
//           // if (initialized) {
//           //   await FlutterBackground.enableBackgroundExecution();
//         } else {
//           log("Failed to initialize background execution");
//         }
//       } else {
//         // Disable background execution if it’s enabled
//         // if (FlutterBackground.isBackgroundExecutionEnabled) {
//         //   await FlutterBackground.disableBackgroundExecution();
//         // }
//       }
//     } catch (error,s) {
//       debugPrint("Error in changeDriverOnlineStatus: $error");
//       AppConstants.handleError(error, s: s);
//     } finally {
//       isOnlineButtonLoading.value = false;
//     }
//   }
//
//   // Future<void> getDriverOnlineStatus() async {
//   //   GetOnlineStatusResponseModel response = await ApiServices.getOnlineStatus();
//   //   if (response.status == 200) {
//   //     isOnline.value = response.data?.isOnline ?? false;
//   //   }
//   // }
//
//   Future<void> getDriverOnlineStatus() async {
//     try {
//       GetOnlineStatusResponseModel response = await ApiServices.getOnlineStatus();
//       if (response.status == 200) {
//         isOnline.value = response.data?.isOnline ?? false;
//       }
//     } catch (error,s) {
//       AppConstants.handleError(error,s: s);
//       print('Error fetching driver online status: $error');
//       // You might want to set a default value or show an error message
//       isOnline.value = false;
//     }
//   }
//
//   String? passengerId;
//
//   StreamSubscription<MobilityContext>? mobilitySubscription;
//   MobilityContext? mobilityContext;
//
//   void sendLiveLocation() {
//     Geolocator.getPositionStream().listen((position) {
//       currentPosition.value = position;
//       saveLocationData(convertPositionToLocationData(position));
//       if (isOnline.value) {
//         WebSocketServices.sendLiveLocation(body: {
//           "passenger_id": driverState.value == DriverState.idle
//               ? RiderStatus.save
//               : passengerId ?? "placeholder",
//           "msg_type": driverState.value == DriverState.idle
//               ? RiderStatus.save
//               : RiderStatus.ride,
//           "ride_status": driverState.value.toString(),
//           "current_loc_long": position.longitude,
//           "current_loc_lat": position.latitude,
//         });
//       }
//     });
//   }
// // Replace your existing sendLiveLocation() function with this:
// //   void sendLiveLocation() {
// //
// //       startLocationTracking();
// //
// //   }
// //
// // // Add this new method to start the location tracking service
// //   Future<void> startLocationTracking() async {
// //     try {
// //       await LocationTrackingService.startLocationTracking(
// //         // driverId: driverId, // Make sure you have this variable
// //         passengerId: passengerId,
// //         driverState: driverState.value.toString(),
// //         onPositionUpdate: (Position position) {
// //           // This replaces: currentPosition.value = position;
// //           currentPosition.value = position;
// //         },
// //         onSaveLocation: (Map<String, dynamic> locationData) {
// //           // Convert the map to loc.LocationData and use your existing save method
// //           final locData = loc.LocationData.fromMap(locationData);
// //           saveLocationData(locData); // Uses your existing method
// //         },
// //         onWebSocketSend: (Map<String, dynamic> payload) {
// //           // This replaces your WebSocket logic with isOnline check
// //           if (isOnline.value) {
// //             WebSocketServices.sendLiveLocation(body: payload);
// //           }
// //         },
// //       );
// //
// //       print('Location tracking started successfully');
// //     } catch (e) {
// //       print('Failed to start location tracking: $e');
// //     }
// //   }
// //
// // // Add method to stop location tracking
// //   void stopLocationTracking() {
// //     LocationTrackingService.stopLocationTracking();
// //   }
// //
// // // Update driver state when needed
// //   void updateDriverState({
// //     String? newPassengerId,
// //     required DriverState newDriverState,
// //   }) {
// //     // Update local state
// //     passengerId = newPassengerId;
// //     driverState.value = newDriverState;
// //
// //     // Update in the isolate
// //     LocationTrackingService.updateDriverState(
// //       passengerId: newPassengerId,
// //       driverState: newDriverState.toString(),
// //     );
// //   }
//
//
// // Your existing saveLocationData method can stay the same, but now it receives a Map
// //   void saveLocationData(Map<String, dynamic> locationData) {
// //     // You can convert the map to your existing format if needed:
// //     // final convertedData = convertMapToLocationData(locationData);
// //     // Or use the map directly since it contains all the same data
// //
// //     // Your existing save logic here
// //     print('Location saved: ${locationData['latitude']}, ${locationData['longitude']}');
// //   }
//
// // Helper method to convert map to your existing format (if needed)
//   Map<String, dynamic> convertMapToLocationData(Map<String, dynamic> locationData) {
//     // This converts the locationData map to whatever format your existing
//     // convertPositionToLocationData method was returning
//     return locationData; // They should already be in the same format
//   }
//
//   RxBool isLoading = false.obs;
//   RxBool isButtonLoading = false.obs;
//   RxBool isError = false.obs;
//
//   Future<void> latestActiveRide() async {
//     try {
//       GetRideDetailsResponseModel response =
//       await ApiServices.latestActiveRide();
//       if ((response.data?.id ?? "").isNotEmpty) {
//         rideIsActive = true;
//         getOrderDetails(response: response);
//       } else {
//         rideIsActive = false;
//       }
//     } catch (error, s) {
//       // AppConstants.handleError(error,s: s);
//       log('last active ride $error', error: error, stackTrace: s);
//     }
//   }
//
//   Rx<DriverState> driverState = DriverState.idle.obs;
//
//   String code = "";
//   RxBool showIsOtpValid = false.obs;
//   GlobalKey<FormState> otpValidationFormKey = GlobalKey();
//   RxString selectedCancelReason = "".obs;
//   List<String> cancelReasons = [];
//
//   RxBool isOnline = false.obs;
//   RxBool isOnlineButtonLoading = false.obs;
//   DashBoardItemModel acceptance = DashBoardItemModel(
//       icon: Icon(
//         Icons.check,
//         color: AppColors.white,
//       ),
//       value: '0 %',
//       text: 'Acceptance');
//   DashBoardItemModel rating = DashBoardItemModel(
//       icon: Icon(Icons.star, color: AppColors.white),
//       value: '2.5',
//       text: 'Rating');
//   DashBoardItemModel cancellation = DashBoardItemModel(
//       icon: Icon(Icons.close, color: AppColors.white),
//       value: '0%',
//       text: 'Cancellation');
//
//   double? startLocationLat;
//   double? startLocationLong;
//   double? startLocationLatMarker;
//   bool isBottomSheetOpen = false;
//   double? startLocationLongMarker;
//   double? endLocationLat;
//   double? endLocationLong;
//   String? rideId = "";
//   String? userMobile;
//   int? timeToDropOffLocation;
//   String? distanceToDropOffLocation;
//   String? distanceToPickUpLocation;
//   String? timeToPickUpLocation;
//   String? pickUpLocation;
//   String? dropOffLocation;
//   String? passengerName;
//   TripsLocations? pickUpLocation1 =
//   TripsLocations(name: "".obs, latitude: 0.0.obs, longitude: 0.0.obs);
//
//   Future<void> getAndShowOrderDetails(
//       {required String id, bool? fromBackGroundCall}) async {
//     player.play(AssetSource(AppAudio.notification));
//     GetRideDetailsResponseModel response =
//     await ApiServices.rideOrderDetails(queryParameters: {"ride_id": id});
//     getOrderDetails(response: response);
//     // Get.bottomSheet(IncomingOrderBottomSheet(data: response.data),
//     //     enableDrag: false, isDismissible: false
//     // );
//     showMyBottomSheet(IncomingOrderBottomSheet(data: response.data));
//   }
//
//   void showMyBottomSheet(Widget bottom) {
//     if (isBottomSheetOpen) return; // Prevent opening if already open
//
//     isBottomSheetOpen = true;
//
//     Get.bottomSheet(
//       enableDrag: false, isDismissible: false,
//       // Your bottom sheet content
//       bottom,
//     ).then((_) {
//       // Reset flag when bottom sheet is closed
//       isBottomSheetOpen = false;
//     });
//   }
//
//   void getOrderDetails({required GetRideDetailsResponseModel response}) {
//     startLocationLat = double.parse(response.data?.startLocationLat ?? "0.0");
//     startLocationLong = double.parse(response.data?.startLocationLong ?? "0.0");
//     startLocationLatMarker =
//         double.parse(response.data?.startLocationLat ?? "0.0");
//     startLocationLongMarker =
//         double.parse(response.data?.startLocationLong ?? "0.0");
//     log("################### passenger latitude ##########################");
//     log("################### Isonline ##########################");
//     log(isOnline.value.toString());
//     log(startLocationLat.toString());
//     log(startLocationLong.toString());
//     endLocationLat = double.parse(response.data?.endLocationLat ?? "0.0");
//     endLocationLong = double.parse(response.data?.endLocationLong ?? "0.0");
//     rideId = response.data?.id;
//     userMobile = response.data?.passengerPhone;
//     passengerId = response.data?.passenger ?? "";
//     log(passengerId.toString());
//     timeToDropOffLocation = response.data?.duration;
//     distanceToDropOffLocation = response.data?.distance;
//     passengerName = response.data?.passengerName;
//     pickUpLocation = response.data?.startLocation;
//     dropOffLocation = response.data?.endLocation;
//     if (response.data?.rideStatus == RideStatus.accepted) {
//       driverState.value = DriverState.goingToPickUp;
//     } else if (response.data?.rideStatus == RideStatus.reachedPickUp) {
//       driverState.value = DriverState.arrivedAtPickUp;
//     } else if (response.data?.rideStatus == RideStatus.onGoing) {
//       isTracking = true;
//       // trackDistance();
//       // goingToDropOffLocation();
//       driverState.value = DriverState.goingToDestination;
//     } else if (response.data?.rideStatus == RideStatus.reachedDropOff) {
//       driverState.value = DriverState.reachedDestination;
//     } else if (response.data?.rideStatus == RideStatus.paymentInitiated) {
//       driverState.value = DriverState.paymentInitiated;
//     }
//   }
//
//   Future<bool> hasAssigned() async {
//     String userTypeCode = await box.read(BoxKeys.userTypeCode);
//     bool? istrue = box.read(BoxKeys.isTaken);
//     if (userTypeCode == "DVR" && istrue == true) {
//       return true;
//     } else {
//       return false;
//     }
//   }
//
//   Future<void> onMapCreate() async {
//     try {
//       currentPosition.refresh();
//       await googleMapController!.animateCamera(
//         CameraUpdate.newLatLng(LatLng(
//           currentPosition.value?.latitude ?? 0.0,
//           currentPosition.value?.longitude ?? 0.0,
//         )),
//       );
//     } catch (e, s) {
//       log(e.toString(), error: e, stackTrace: s);
//       isError.value = true;
//     }
//   }
//
//   Future<void> getVersionInfo() async {
//     final PackageInfo info = await PackageInfo.fromPlatform();
//
//     version.value = info.version;
//     buildNumber.value = info.buildNumber;
//     box.write(BoxKeys.version, version.value);
//     box.write(BoxKeys.buildNumber, buildNumber.value);
//   }
//
//   Future<Position> getCurrentPosition() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) throw Exception('Location services are disabled');
//
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         throw Exception('Location permissions are denied');
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       throw Exception('Location permissions are permanently denied');
//     }
//     return await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.best);
//   }
//
//   Future<void> makePhoneCall() async {
//     final Uri uri = Uri.parse('tel:$userMobile');
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri);
//     } else {
//       throw 'Could not launch $userMobile';
//     }
//   }
//
//   Future<void> fetchWalletBalance() async {
//     isRefreshingWallet.value = true;
//     try {
//       WalletResponse response = await ApiServices.getPartnerWallet();
//
//       if (response.status == 200) {
//         walletBalance.value =
//             double.tryParse(response.data.amount ?? '') ?? 0.0;
//         isRefreshingWallet.value = false;
//       } else {
//         isRefreshingWallet.value = false;
//       }
//     } catch (error,s) {
//       isRefreshingWallet.value = false;
//       Get.showSnackbar(GetSnackBar(
//           duration: Duration(seconds: 2),
//           backgroundColor: Colors.transparent,
//           padding: EdgeInsets.zero,
//           messageText: AppSnackBar(text: error.toString())));
//     }
//   }
//
//   RxBool isRefreshingWallet = false.obs;
//
//   Future<void> refreshWalletBalance() async {
//     try {
//       // Call your wallet API
//       await fetchWalletBalance();
//       Get.showSnackbar(
//         const GetSnackBar(
//           duration: Duration(seconds: 2),
//           backgroundColor: Colors.transparent,
//           padding: EdgeInsets.zero,
//           messageText: AppSnackBar(
//             text: "Updated wallet balance",
//           ),
//         ),
//       );
//     } catch (e) {
//       // Handle error
//       Get.showSnackbar(
//         const GetSnackBar(
//           duration: Duration(seconds: 3),
//           backgroundColor: Colors.transparent,
//           padding: EdgeInsets.zero,
//           messageText: AppSnackBar(
//             text: "Something went wrong",
//           ),
//         ),
//       );
//     } finally {}
//   }
//
//   Future<void> addStop(context) async {
//     try {
//       driverState.value = DriverState.loading;
//       AddStopResponseModel response = await ApiServices.addStop(body: {
//         "ride_id": rideId,
//         "location_lat": currentPosition.value?.latitude.toString(),
//         "end_loc_long": currentPosition.value?.longitude.toString()
//       });
//       if (response.status == 200) {
//         Get.showSnackbar(
//           const GetSnackBar(
//             duration: Duration(seconds: 5),
//             backgroundColor: Colors.transparent,
//             padding: EdgeInsets.zero,
//             messageText: AppSnackBar(
//               text: "Stop Added",
//             ),
//           ),
//         );
//         await Future.delayed(
//             Duration(milliseconds: 300)); // Ensure Snackbar is shown
//         Navigator.pop(context);
//       } else {
//         Get.showSnackbar(
//           const GetSnackBar(
//             duration: Duration(seconds: 5),
//             backgroundColor: Colors.transparent,
//             padding: EdgeInsets.zero,
//             messageText: AppSnackBar(
//               text: "OOPS Some thing went wrong",
//             ),
//           ),
//         );
//       }
//     } catch (error) {
//       Get.showSnackbar(
//         const GetSnackBar(
//           duration: Duration(seconds: 5),
//           backgroundColor: Colors.transparent,
//           padding: EdgeInsets.zero,
//           messageText: AppSnackBar(
//             text: "OOPS Some thing went wrong",
//           ),
//         ),
//       );
//     } finally {
//       driverState.value = DriverState.goingToDestination;
//     }
//   }
//
//   // Future<void> trackDistance() async {
//   //   while (isTracking) {
//   //     Position position = await getCurrentPosition();
//   //     double currentLat = position.latitude;
//   //     double currentLng = position.longitude;
//   //     print("location updating---------------");
//   //     print(currentLng);
//   //     print(currentLat);
//   //
//   //     // Calculate distance if a previous location exists
//   //     if (latLongList.isNotEmpty) {
//   //       double lastLat = latLongList.last['lat']!;
//   //       double lastLng = latLongList.last['lng']!;
//   //       double distanceInKilometers = calculateDistance(lastLat, lastLng, currentLat, currentLng);
//   //       currentDistance += distanceInKilometers;
//   //
//   //       // Save total distance if current distance exceeds 0.1 km (100 meters)
//   //       if (currentDistance >= 0.1) {
//   //         totalDistance += currentDistance;
//   //         saveDistance(totalDistance); // Save to Hive
//   //         currentDistance = 0;
//   //         latLongList.clear();
//   //         print(totalDistance);
//   //       }
//   //       print("totalDistance-------------------------");
//   //       print(totalDistance);
//   //     }
//   //
//   //     // Update location list
//   //     latLongList.add({'lat': currentLat, 'lng': currentLng});
//   //
//   //   }
//   //
//   //   print("location not updating---------------");
//   // }
//
//   // Save the total distance in Hive
//   void saveDistance(double distance) {
//     distanceBox?.put('totalDistance', distance);
//   }
//
//   // Reset total distance if needed
//   void resetDistance() {
//     totalDistance = 0;
//     distanceBox?.put('totalDistance', 0.0);
//   }
//
//   Future<void> acceptOrder() async {
//     try {
//       isButtonLoading.value = true;
//       driverState.value = DriverState.loading;
//       player.stop();
//       ChangeRideStatusModel response = await ApiServices.changeRideStatus(
//           body: {"ride_id": rideId, "ride_status": RideStatus.accepted});
//       if (response.status == 200) {
//         log(isButtonLoading.toString());
//         // if (driverState.value == DriverState.idle) {
//         //   startLocationLongMarker = 0.0;
//         //   startLocationLatMarker = 0.0;
//         // }
//         rideIsActive = true;
//         Get.back();
//         driverState.value = DriverState.goingToPickUp;
//       }
//     } catch (error) {
//       Get.back();
//       Get.showSnackbar(
//         const GetSnackBar(
//           duration: Duration(seconds: 5),
//           backgroundColor: Colors.transparent,
//           padding: EdgeInsets.zero,
//           messageText: AppSnackBar(
//             text: "OOPS Something went wrong",
//           ),
//         ),
//       );
//       startLocationLongMarker = 0.0;
//       startLocationLatMarker = 0.0;
//       recenter();
//     } finally {
//       isButtonLoading.value = false;
//       recenter();
//     }
//   }
//
//   Future<void> reachedPickUpLocation() async {
//     try {
//       driverState.value = DriverState.loading;
//       ChangeRideStatusModel response = await ApiServices.changeRideStatus(
//           body: {"ride_id": rideId, "ride_status": RideStatus.reachedPickUp});
//       if (response.status == 200) {
//         Get.back();
//         driverState.value = DriverState.arrivedAtPickUp;
//       }
//     } catch (error) {
//       Get.back();
//       Get.showSnackbar(
//         const GetSnackBar(
//           duration: Duration(seconds: 5),
//           backgroundColor: Colors.transparent,
//           padding: EdgeInsets.zero,
//           messageText: AppSnackBar(
//             text: "OOPS Something went wrong",
//           ),
//         ),
//       );
//     }
//   }
//
//   Future<void> goingToDropOffLocation() async {
//     try {
//       driverState.value = DriverState.loading;
//       ChangeRideStatusModel response = await ApiServices.changeRideStatus(
//           body: {"ride_id": rideId, "ride_status": RideStatus.onGoing});
//       if (response.status == 200) {
//         driverState.value = DriverState.readyToGoToDestination;
//         await MobilityFeatures()
//             .startListening(Geolocator.getPositionStream().map((location) {
//           log("mobility features");
//           log("${mobilityContext?.distanceTraveled}");
//           log(location.toString());
//           log(location.longitude.toString());
//           return LocationSample(
//               GeoLocation(location.latitude, location.longitude),
//               DateTime.now());
//         }));
//       }
//     } finally {
//       // driverState.value = DriverState.readyToGoToDestination;
//     }
//   }
//
//   Future<void> reachedDropOffLocation() async {
//     try {
//       driverState.value = DriverState.loading;
//       await getFinalDropLocation();
//       ChangeRideStatusModel response =
//       await ApiServices.changeRideStatus(body: {
//         "ride_id": rideId,
//         "ride_status": RideStatus.reachedDropOff,
//         "location": finalDropLocation,
//         "location_lat": currentPosition.value?.latitude.toString(),
//         "location_long": currentPosition.value?.longitude.toString(),
//       });
//       if (response.status == 200) {
//         driverState.value = DriverState.reachedDestination;
//         isTracking = false;
//       }
//     } finally {
//       driverState.value = DriverState.reachedDestination;
//     }
//   }
//
//   Future<String?> getLocationDetails(double latitude, double longitude) async {
//     GoogleLocationResponse response =
//     await ApiServices.getCurrentLocation(latitude, longitude);
//
//     for (var result in response.results ?? []) {
//       for (var addressComponent in result.addressComponents ?? []) {
//         if ((addressComponent.types?.contains("sublocality") ?? false) ||
//             (addressComponent.types?.contains("subpremise") ?? false)) {
//           return addressComponent.shortName;
//         }
//       }
//     }
//
//     return null; // Return null if no sublocality or subpremise is found
//   }
//
//   void recenter() {
//     if (!recenterLoading.value) {
//       recenterLoading.value = true;
//       loc.Location().getLocation().then(
//             (newLoc) {
//           recenterLoading.value = false;
//           saveLocationData(newLoc);
//           googleMapController?.animateCamera(CameraUpdate.newCameraPosition(
//             CameraPosition(
//               zoom: cameraZoom.value,
//               target: LatLng(newLoc.latitude ?? 0.0, newLoc.longitude ?? 0.0),
//             ),
//           ));
//         },
//       );
//       cameraZoom.value = 15.0;
//     }
//   }
//
//   Future<String?> getLocationDetails1() async {
//     if (driverState.value == DriverState.idle) {
//       GoogleLocationResponse response = await ApiServices.getCurrentLocation(
//           pickUpLocation1?.latitude.value ?? 0.0,
//           pickUpLocation1?.longitude.value ?? 0.0);
//
//       String? neighborhood = response.results?.firstOrNull?.addressComponents
//           ?.firstWhereOrNull(
//               (address) => ((address.types ?? []).contains("neighborhood")))
//           ?.longName;
//
//       String? political = response.results?.firstOrNull?.addressComponents
//           ?.firstWhereOrNull(
//               (address) => ((address.types ?? []).contains("political")))
//           ?.longName;
//       String? sublocality = response.results?.firstOrNull?.addressComponents
//           ?.firstWhereOrNull(
//               (address) => ((address.types ?? []).contains("sublocality")))
//           ?.longName;
//       String? locality = response.results?.firstOrNull?.addressComponents
//           ?.firstWhereOrNull(
//               (address) => ((address.types ?? []).contains("locality")))
//           ?.longName;
//       String? postalCode = response.results?.firstOrNull?.addressComponents
//           ?.firstWhereOrNull(
//               (address) => ((address.types ?? []).contains("postal_code")))
//           ?.longName;
//       String? premise = response.results?.firstOrNull?.addressComponents
//           ?.firstWhereOrNull(
//               (address) => ((address.types ?? []).contains("premise")))
//           ?.longName;
//       return ({
//         premise,
//         neighborhood,
//         political,
//         sublocality,
//         locality,
//         postalCode
//       }.toList().where((name) => name != null).join(","));
//     } else {
//       return "";
//     }
//   }
//
//   Future<void> paymentInitiated() async {
//     driverState.value = DriverState.loading;
//     log("mobilityContext?.stops");
//     log("${mobilityContext?.stops}");
//     try {
//       ChangeRideStatusModel response =
//       await ApiServices.changeRideStatus(body: {
//         "ride_id": rideId,
//         "ride_status": RideStatus.paymentInitiated,
//         "stops": mobilityContext?.stops,
//         "location": finalDropLocation,
//         "location_lat": currentPosition.value?.latitude.toString(),
//         "location_long": currentPosition.value?.longitude.toString()
//       });
//       if (response.status == 200) {
//         await getRidePayment();
//         resetDistance();
//         // getRidePayment();
//       }
//     }catch(error,s){
//       AppConstants.handleError(error, s: s);
//     }
//     finally {
//       driverState.value = DriverState.paymentInitiated;
//     }
//   }
//
//   // MobilityContext? _mobilityContext;
//
//   String? fare;
//   String? tip;
//   String? tax;
//   String? waiverCharge;
//   String? paymentType;
//   String? total;
//   Future<void> getRidePayment() async {
//     RidePaymentResponseModel response =
//     await ApiServices.getRidePayment(queryParameter: {"ride_id": rideId});
//     if (response.status == 200) {
//       fare = response.data?.fare;
//       tax = response.data?.tax;
//       total = response.data?.total;
//       paymentType = response.data?.paymentType;
//       waiverCharge = response.data?.waiverCharge;
//       driverState.value = DriverState.completed;
//       Get.back();
//     }
//   }
//
//   Future<void> completeRide() async {
//     ChangeRideStatusModel response = await ApiServices.changeRideStatus(
//         body: {"ride_id": rideId, "ride_status": RideStatus.completed});
//     if (response.status == 200) {
//       driverState.value = DriverState.idle;
//     }
//   }
//
//   Future<void> confirmedPayment() async {
//     driverState.value = DriverState.loading;
//     ChangeRideStatusModel response = await ApiServices.changeRideStatus(
//         body: {"ride_id": rideId, "ride_status": RideStatus.completed});
//     if (response.status == 200) {
//       Get.back();
//       // await getRidePayment();
//       driverState.value = DriverState.completed;
//       driverState.value = DriverState.idle;
//       fetchWalletBalance();
//     }
//   }
//
//   // Future<void> verifyRideOtp({required String type}) async {
//   //   try {
//   //     driverState.value = DriverState.loading;
//   //     var response = await ApiServices.verifyRideOtp(body: {
//   //       "ride_id": rideId,
//   //       "otp": code,
//   //       "type": type == RideStatus.reachedPickUp ? "APO" : "ADO"
//   //     });
//   //     Get.back();
//   //     if (response.status == 200) {
//   //       if (response.status == 200) {
//   //         startLocationLatMarker = 0.0;
//   //         startLocationLongMarker = 0.0;
//   //         recenter();
//   //         if (type == RideStatus.reachedPickUp) {
//   //           // await ApiServices.changeRideStatus(body: {
//   //           //   "ride_id": rideId,
//   //           //   "ride_status": RideStatus.reachedPickUp
//   //           // });
//   //           goingToDropOffLocation();
//   //
//   //           log("tracking -----------");
//   //           log(isTracking.toString());
//   //           isTracking = true;
//   //           // trackDistance();
//   //           // goingToDropOffLocation();
//   //         } else {
//   //           MobilityFeatures().stopListening();
//   //           // ChangeRideStatusModel response = await ApiServices.changeRideStatus(
//   //           //     body: {
//   //           //       "ride_id": rideId,
//   //           //       "ride_status": RideStatus.paymentInitiated
//   //           //     });
//   //           // confirmedPayment();
//   //           // getFinalDropLocation();
//   //           await paymentInitiated();
//   //         }
//   //         code = " ";
//   //       } else {
//   //         Get.showSnackbar(const GetSnackBar(
//   //             duration: Duration(seconds: 5),
//   //             backgroundColor: Colors.transparent,
//   //             padding: EdgeInsets.zero,
//   //             messageText: AppSnackBar(text: "Wrong otp")));
//   //       }
//   //     } else {
//   //       Get.showSnackbar(const GetSnackBar(
//   //           duration: Duration(seconds: 5),
//   //           backgroundColor: Colors.transparent,
//   //           padding: EdgeInsets.zero,
//   //           messageText: AppSnackBar(text: "Wrong otp")));
//   //     }
//   //   } catch (error) {
//   //     Get.showSnackbar(const GetSnackBar(
//   //         duration: Duration(seconds: 5),
//   //         backgroundColor: Colors.transparent,
//   //         padding: EdgeInsets.zero,
//   //         messageText: AppSnackBar(text: "OOPS Something went wrong")));
//   //   } finally {
//   //     if (type == RideStatus.reachedPickUp) {
//   //       driverState.value = DriverState.arrivedAtPickUp;
//   //     } else {
//   //       driverState.value = DriverState.paymentInitiated;
//   //     }
//   //   }
//   // }
//   Future<void> verifyRideOtp({required String type}) async {
//     try {
//       driverState.value = DriverState.loading;
//       var response = await ApiServices.verifyRideOtp(body: {
//         "ride_id": rideId,
//         "otp": code,
//         "type": type == RideStatus.reachedPickUp ? "APO" : "ADO"
//       });
//
//       Get.back();
//
//       if (response.status == 200) {
//         // Reset marker positions
//         startLocationLatMarker = 0.0;
//         startLocationLongMarker = 0.0;
//         recenter();
//
//         if (type == RideStatus.reachedPickUp) {
//           goingToDropOffLocation();
//           log("tracking -----------");
//           log(isTracking.toString());
//           isTracking = true;
//           driverState.value = DriverState.arrivedAtPickUp;
//         } else {
//           MobilityFeatures().stopListening();
//           await paymentInitiated();
//           driverState.value = DriverState.paymentInitiated;
//         }
//         code = " ";
//       } else {
//         // Handle API error response
//         _showErrorSnackbar("Wrong otp");
//         // Reset to previous state on error
//         driverState.value = type == RideStatus.reachedPickUp
//             ? DriverState.arrivedAtPickUp
//             : DriverState.reachedDestination;
//       }
//     } catch (error) {
//       log("Error in verifyRideOtp: $error");
//       _showErrorSnackbar("OOPS Something went wrong");
//       // Reset to previous state on exception
//       driverState.value = type == RideStatus.reachedPickUp
//           ? DriverState.arrivedAtPickUp
//           : DriverState.reachedDestination;
//     }
//   }
//
//   void _showErrorSnackbar(String message) {
//     Get.showSnackbar(GetSnackBar(
//       duration: const Duration(seconds: 5),
//       backgroundColor: Colors.transparent,
//       padding: EdgeInsets.zero,
//       messageText: AppSnackBar(text: message),
//     ));
//   }
//   Future<void> getFinalDropLocation() async {
//     finalDropLocation = (await getLocationDetails(
//         currentPosition.value?.latitude ?? 0.0,
//         currentPosition.value?.longitude ?? 0.0)) ??
//         "";
//     // paymentInitiated();
//   }
//
//   Future<void> orderTimeOut() async {
//     try {
//       player.stop();
//       rideIsActive = false;
//       box.remove(BoxKeys.rideId);
//       if (Get.isBottomSheetOpen ?? false) {
//         Get.back();
//       }
//       ChangeRideStatusModel response =
//       await ApiServices.changeRideStatus(body: {
//         "ride_id": rideId,
//         "ride_status": RideStatus.cancelled,
//       });
//
//       if (response.status == 200) {
//         driverState.value = DriverState.idle;
//         if (driverState.value == DriverState.idle) {
//           startLocationLongMarker = 0.0;
//           startLocationLatMarker = 0.0;
//           recenter();
//         }
//
//         Get.defaultDialog(
//             middleText:
//             "This order has expired or transferred to another driver");
//       }
//     } finally {
//       driverState.value = DriverState.idle;
//       if (Get.isBottomSheetOpen ?? false) {
//         Get.back();
//       }
//     }
//   }
//
//   Future<void> openMap(
//       {required double? latitude, required double? longitude}) async {
//     var uri = Uri.parse("google.navigation:q=$latitude,$longitude&mode=d");
//     if (await canLaunch(uri.toString())) {
//       await launch(uri.toString());
//     } else {
//       throw 'Could not launch ${uri.toString()}';
//     }
//   }
//
//   Position convertToPosition(loc.LocationData? location) {
//     return Position(
//       latitude: location?.latitude ?? 0.0,
//       longitude: location?.longitude ?? 0.0,
//       timestamp: DateTime.now(),
//       accuracy: location?.accuracy ?? 0.0,
//       altitude: location?.altitude ?? 0.0,
//       heading: location?.heading ?? 0.0,
//       speed: location?.speed ?? 0.0,
//       speedAccuracy: location?.speedAccuracy ?? 0.0,
//       altitudeAccuracy: 0.0,
//       headingAccuracy: 0.0,
//     );
//   }
//
//   void saveLocationData(loc.LocationData locationData) {
//     box.write(BoxKeys.lastLocation, {
//       'latitude': locationData.latitude,
//       'longitude': locationData.longitude,
//       'accuracy': locationData.accuracy,
//       'altitude': locationData.altitude,
//       'speed': locationData.speed,
//       'speedAccuracy': locationData.speedAccuracy,
//       'heading': locationData.heading,
//       'time': locationData.time,
//     });
//   }
//
//   loc.LocationData convertPositionToLocationData(Position position) {
//     return loc.LocationData.fromMap({
//       "latitude": position.latitude,
//       "longitude": position.longitude,
//       "accuracy": position.accuracy,
//       "altitude": position.altitude,
//       "speed": position.speed,
//       "speed_accuracy": position.speedAccuracy,
//       "heading": position.heading,
//     });
//   }
//
// // void recenter() {
// //   if (!recenterLoading.value) {
// //     recenterLoading.value = true;
// //     loc.Location().getLocation().then(
// //           (newLoc) {
// //         recenterLoading.value = false;
// //         saveLocationData(newLoc);
// //         googleMapController?.animateCamera(CameraUpdate.newCameraPosition(
// //           CameraPosition(
// //             zoom: cameraZoom.value,
// //             target: LatLng(newLoc.latitude ?? 0.0, newLoc.longitude ?? 0.0),
// //           ),
// //         ));
// //       },
// //     );
// //     cameraZoom.value = 14.0;
// //   }
// // }
//
//
//
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.paused) {
//       appState.value = "Background";
//       sendLiveLocation();
//       print("App in Background - Scheduling background task or keeping location stream alive.");
//       // Keep location service alive or schedule WorkManager task here
//     } else if (state == AppLifecycleState.resumed) {
//       appState.value = "Active";
//       print(" App Resumed - Reconnecting services...");
//       sendLiveLocation(); // Resume location sending
//     }
//   }
//
// }

import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:mobility_features/mobility_features.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waiver_driver/backend/model/home/home_model.dart';
import 'package:waiver_driver/backend/model/setting/setting_model.dart';
import 'package:waiver_driver/backend/parser/Home/home_parser.dart';
import 'package:waiver_driver/controller/driver_profile/driver_profile_controller.dart';
import 'package:waiver_driver/core/themes/assets/audio.dart';
import 'package:waiver_driver/core/widgets/snackbar/snackbar.dart';
import 'package:waiver_driver/main.dart';
import 'package:waiver_driver/view/home/home_view.dart';
import 'package:location/location.dart' as loc;
import '../../backend/LocationHandler/LocationTrackingService.dart';
import '../../backend/api/api_services/api_services.dart';
import '../../backend/api/api_services/web_socket_services.dart';
import '../../backend/model/earning/earning_model.dart';

import '../../core/colors/app_colors.dart';
import '../../core/constants/enums/enums.dart';
import '../../core/constants/get_storage_constants.dart';
import '../profile/profile_controller.dart';

class HomeController extends GetxController with WidgetsBindingObserver {
  final HomeParser parser;
  HomeController({required this.parser});

  static HomeController get to => Get.find();

  // Add LocationTrackingService instance
  late LocationTrackingService locationTrackingService;

  RxString appState = "Active".obs;

  @override
  void onInit() async {
    super.onInit();

    // Initialize location tracking service
    locationTrackingService = Get.put(LocationTrackingService());

    currentPosition.value = convertToPosition(AppConstants.locationData);
    WidgetsBinding.instance.addObserver(this);
    _initializeHive();

    loc.Location location = loc.Location();
    try {
      List<Future> apis = [
        getDriverOnlineStatus(),
        fetchWalletBalance(),
        latestActiveRide(),
      ];
      if (currentPosition.value == null) apis.add(location.getLocation());
      isLoading.value = true;

      final result = await Future.wait(apis);

      if (currentPosition.value == null) {
        currentPosition.value =
            convertToPosition(result[3] as loc.LocationData);
        saveLocationData(result[3] as loc.LocationData);
      }
      isLoading.value = false;
      checkForUpdate();
      // Start location tracking instead of old sendLiveLocation
      sendLiveLocation();
      await startLocationTracking();

      getVersionInfo();
      ProfileController.to.getProfile();
      isAssinged.value = await hasAssigned();
      log("******************${isAssinged.value}@@@@@@@@@@@@@@@@@@@@@@@@@@");
      pickUpLocation1 = TripsLocations(
          latitude: Rx(currentPosition.value?.latitude),
          longitude: Rx(currentPosition.value?.longitude),
          name: "".obs);

      getLocationDetails(
              currentPosition.value!.latitude, currentPosition.value!.longitude)
          .then(
        (value) => pickUpLocation1?.name.value = value ?? '',
      );
      recenter();

      isError.value = false;
    } catch (error) {
      isError.value = false;
      log(error.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    // Stop location tracking when controller is disposed
    stopLocationTracking();
    super.onClose();
  }

  @override
  void dispose() {
    // Stop location tracking on dispose
    stopLocationTracking();
    super.dispose();
  }

  StreamSubscription<MobilityContext>? mobilitySubscription;
  MobilityContext? mobilityContext;

  void sendLiveLocation() {
    Geolocator.getPositionStream().listen((position) {
      currentPosition.value = position;
      saveLocationData(convertPositionToLocationData(position));
      if (isOnline.value) {
        WebSocketServices.sendLiveLocation(body: {
          "passenger_id": driverState.value == DriverState.idle
              ? RiderStatus.save
              : passengerId ?? "placeholder",
          "msg_type": driverState.value == DriverState.idle
              ? RiderStatus.save
              : RiderStatus.ride,
          "ride_status": driverState.value.toString(),
          "current_loc_long": position.longitude,
          "current_loc_lat": position.latitude,
        });
      }
    });
  }

  // Replace the old sendLiveLocation() method with this:
  Future<void> startLocationTracking() async {
    try {
      // Save initial data for background service
      await locationTrackingService.saveInitialData(
        driverState: driverState.value.toString(),
        passengerId: passengerId,
        isOnline: isOnline.value,
      );

      // Start the background location service
      await locationTrackingService.startService(
        driverState: driverState.value.toString(),
        passengerId: passengerId,
        isOnline: isOnline.value,
      );

      log('✅ Location tracking started successfully');
    } catch (e) {
      log('❌ Failed to start location tracking: $e');
    }
  }

  // Method to stop location tracking
  Future<void> stopLocationTracking() async {
    try {
      await locationTrackingService.stopService();
      log('🛑 Location tracking stopped');
    } catch (e) {
      log('❌ Error stopping location tracking: $e');
    }
  }

  // Update the changeDriverOnlineStatus method
  Future<void> changeDriverOnlineStatus() async {
    try {
      if (isOnlineButtonLoading.value) return;
      isOnlineButtonLoading.value = true;

      LogoutResponseModel response = await ApiServices.changeOnlineStatus(
        body: {
          "is_online": isOnline.value ? 0 : 1,
        },
      );
      log("#####################${isOnline.value}#####################");

      if (response.status == 200) {
        isOnline.value = !isOnline.value;
        log("#####################${isOnline.value}#####################");

        // Update the background service with new online status
        await locationTrackingService.updateOnlineStatus(isOnline.value);

        if (isOnline.value) {
          // Start location tracking when going online
          await startLocationTracking();
        } else {
          // Stop location tracking when going offline
          await stopLocationTracking();
        }
      }
    } catch (error, s) {
      debugPrint("Error in changeDriverOnlineStatus: $error");
      AppConstants.handleError(error, s: s);
    } finally {
      isOnlineButtonLoading.value = false;
    }
  }

  // Update acceptOrder method to notify background service
  Future<void> acceptOrder() async {
    try {
      isButtonLoading.value = true;
      driverState.value = DriverState.loading;
      player.stop();
      ChangeRideStatusModel response = await ApiServices.changeRideStatus(
          body: {"ride_id": rideId, "ride_status": RideStatus.accepted});
      if (response.status == 200) {
        log(isButtonLoading.toString());
        rideIsActive = true;
        Get.back();
        driverState.value = DriverState.goingToPickUp;

        // Update background service with new driver state and passenger
        await locationTrackingService.updateDriverState(
          driverState.value.toString(),
          passengerId: passengerId,
        );
      }
    } catch (error) {
      Get.back();
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
      startLocationLongMarker = 0.0;
      startLocationLatMarker = 0.0;
      recenter();
    } finally {
      isButtonLoading.value = false;
      recenter();
    }
  }

  // Update other ride status change methods
  Future<void> reachedPickUpLocation() async {
    try {
      driverState.value = DriverState.loading;
      ChangeRideStatusModel response = await ApiServices.changeRideStatus(
          body: {"ride_id": rideId, "ride_status": RideStatus.reachedPickUp});
      if (response.status == 200) {
        Get.back();
        driverState.value = DriverState.arrivedAtPickUp;

        // Update background service
        await locationTrackingService.updateDriverState(
          driverState.value.toString(),
          passengerId: passengerId,
        );
      }
    } catch (error) {
      Get.back();
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

  Future<void> goingToDropOffLocation() async {
    try {
      driverState.value = DriverState.loading;
      ChangeRideStatusModel response = await ApiServices.changeRideStatus(
          body: {"ride_id": rideId, "ride_status": RideStatus.onGoing});
      if (response.status == 200) {
        driverState.value = DriverState.readyToGoToDestination;

        // Update background service
        await locationTrackingService.updateDriverState(
          driverState.value.toString(),
          passengerId: passengerId,
        );

        await MobilityFeatures()
            .startListening(Geolocator.getPositionStream().map((location) {
          log("mobility features");
          log("${mobilityContext?.distanceTraveled}");
          log(location.toString());
          log(location.longitude.toString());
          return LocationSample(
              GeoLocation(location.latitude, location.longitude),
              DateTime.now());
        }));
      }
    } finally {
      // driverState.value = DriverState.readyToGoToDestination;
    }
  }

  Future<void> confirmedPayment() async {
    driverState.value = DriverState.loading;
    ChangeRideStatusModel response = await ApiServices.changeRideStatus(
        body: {"ride_id": rideId, "ride_status": RideStatus.completed});
    if (response.status == 200) {
      Get.back();
      driverState.value = DriverState.completed;
      driverState.value = DriverState.idle;

      // Update background service back to idle state
      await locationTrackingService.updateDriverState(
        driverState.value.toString(),
        passengerId: null, // Clear passenger when ride is completed
      );

      fetchWalletBalance();
    }
  }

  // Update verifyRideOtp method
  Future<void> verifyRideOtp({required String type}) async {
    try {
      driverState.value = DriverState.loading;
      var response = await ApiServices.verifyRideOtp(body: {
        "ride_id": rideId,
        "otp": code,
        "type": type == RideStatus.reachedPickUp ? "APO" : "ADO"
      });

      Get.back();

      if (response.status == 200) {
        startLocationLatMarker = 0.0;
        startLocationLongMarker = 0.0;
        recenter();

        if (type == RideStatus.reachedPickUp) {
          goingToDropOffLocation();
          log("tracking -----------");
          log(isTracking.toString());
          isTracking = true;
          driverState.value = DriverState.arrivedAtPickUp;
        } else {
          MobilityFeatures().stopListening();
          addStopCount.value = 0;
          log("addStopCount after otp*************$addStopCount");
          await paymentInitiated();
          driverState.value = DriverState.paymentInitiated;
        }

        // Update background service with new state
        await locationTrackingService.updateDriverState(
          driverState.value.toString(),
          passengerId: passengerId,
        );

        code = " ";
      } else {
        _showErrorSnackbar("Wrong otp");
        driverState.value = type == RideStatus.reachedPickUp
            ? DriverState.arrivedAtPickUp
            : DriverState.reachedDestination;
      }
    } catch (error) {
      log("Error in verifyRideOtp: $error");
      _showErrorSnackbar("OOPS Something went wrong");
      driverState.value = type == RideStatus.reachedPickUp
          ? DriverState.arrivedAtPickUp
          : DriverState.reachedDestination;
    }
  }

  // Update orderTimeOut method
  Future<void> orderTimeOut() async {
    try {
      player.stop();
      rideIsActive = false;
      box.remove(BoxKeys.rideId);
      if (Get.isBottomSheetOpen ?? false) {
        Get.back();
      }
      ChangeRideStatusModel response =
          await ApiServices.changeRideStatus(body: {
        "ride_id": rideId,
        "ride_status": RideStatus.cancelled,
      });

      if (response.status == 200) {
        driverState.value = DriverState.idle;

        // Update background service back to idle
        await locationTrackingService.updateDriverState(
          driverState.value.toString(),
          passengerId: null,
        );

        if (driverState.value == DriverState.idle) {
          startLocationLongMarker = 0.0;
          startLocationLatMarker = 0.0;
          recenter();
        }

        Get.defaultDialog(
            middleText:
                "This order has expired or transferred to another driver");
      }
    } finally {
      driverState.value = DriverState.idle;
      if (Get.isBottomSheetOpen ?? false) {
        Get.back();
      }
    }
  }

  // Update app lifecycle state handler
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      appState.value = "Background";
      log("🔴 App in Background - Background service will continue location tracking");
      // Background service automatically continues tracking
    } else if (state == AppLifecycleState.resumed) {
      appState.value = "Active";
      log("🟢 App Resumed - Background service is already running");
      // Background service was already running, nothing needed
    } else if (state == AppLifecycleState.detached) {
      appState.value = "Terminated";
      stopLocationTrackingFromBackground();
      stopLocationTracking();
      setDriverOfflineOnTermination();
      log("⚠️ App Terminated - Background service will continue");
      // Background service continues even when app is terminated
    }
  }

  // Method to update auth token (call when token refreshes)
  Future<void> updateAuthToken(String newToken) async {
    try {
      await locationTrackingService.updateAuthToken(newToken);
      log('✅ Auth token updated in background service');
    } catch (e) {
      log('❌ Failed to update auth token: $e');
    }
  }

  // Method to check if location service is running
  Future<bool> isLocationServiceRunning() async {
    return await locationTrackingService.getServiceStatus();
  }

  Future<void> setDriverOfflineOnTermination() async {
    try {
      // Call your API to set driver offline
      await ApiServices.changeOnlineStatus(
        body: {"is_online": 0},
      );

      // Update local state
      isOnline.value = false;

      log('✅ Driver set to offline due to app termination');
    } catch (e) {
      log('❌ Error setting driver offline on termination: $e');
    }
  }

  // Keep all your existing methods unchanged...
  final player = AudioPlayer();
  Rx<Position?> currentPosition = Rx<Position?>(null);
  GoogleMapController? googleMapController;
  Rx<double?> walletBalance = Rx<double?>(null);
  bool rideIsActive = false;
  String? finalDropLocation;
  bool isTracking = false;
  double currentDistance = 0;
  double totalDistance = 0;
  List<Map<String, double>> latLongList = [];
  Box? distanceBox;
  final RxString version = ''.obs;
  final RxString buildNumber = ''.obs;
  RxBool recenterLoading = false.obs;
  RxBool isAssinged = false.obs;
  RxDouble cameraZoom = 14.0.obs;

  Future<void> _initializeHive() async {
    distanceBox = await Hive.openBox('distanceBox');
    totalDistance = distanceBox?.get('totalDistance', defaultValue: 0.0) ?? 0.0;
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = math.cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * math.asin(math.sqrt(a));
  }

  Future<void> getDriverOnlineStatus() async {
    try {
      GetOnlineStatusResponseModel response =
          await ApiServices.getOnlineStatus();
      if (response.status == 200) {
        isOnline.value = response.data?.isOnline ?? false;
      }
    } catch (error, s) {
      AppConstants.handleError(error, s: s);
      print('Error fetching driver online status: $error');
      isOnline.value = false;
    }
  }

  String? passengerId;
  // StreamSubscription<MobilityContext>? mobilitySubscription;
  // MobilityContext? mobilityContext;
  RxBool isLoading = false.obs;
  RxBool isButtonLoading = false.obs;
  RxBool isError = false.obs;

  Future<void> latestActiveRide() async {
    try {
      GetRideDetailsResponseModel response =
          await ApiServices.latestActiveRide();
      if ((response.data?.id ?? "").isNotEmpty) {
        rideIsActive = true;
        getOrderDetails(response: response);
      } else {
        rideIsActive = false;
      }
    } catch (error, s) {
      log('last active ride $error', error: error, stackTrace: s);
    }
  }

  Rx<DriverState> driverState = DriverState.idle.obs;
  String code = "";
  RxBool showIsOtpValid = false.obs;
  GlobalKey<FormState> otpValidationFormKey = GlobalKey();
  RxString selectedCancelReason = "".obs;
  List<String> cancelReasons = [];
  RxBool isOnline = false.obs;
  RxBool isOnlineButtonLoading = false.obs;

  DashBoardItemModel acceptance = DashBoardItemModel(
      icon: Icon(Icons.check, color: AppColors.white),
      value: '0 %',
      text: 'Acceptance');
  DashBoardItemModel rating = DashBoardItemModel(
      icon: Icon(Icons.star, color: AppColors.white),
      value: '2.5',
      text: 'Rating');
  DashBoardItemModel cancellation = DashBoardItemModel(
      icon: Icon(Icons.close, color: AppColors.white),
      value: '0%',
      text: 'Cancellation');

  double? startLocationLat;
  double? startLocationLong;
  double? startLocationLatMarker;
  bool isBottomSheetOpen = false;
  double? startLocationLongMarker;
  double? endLocationLat;
  double? endLocationLong;
  String? rideId = "";
  String? userMobile;
  int? timeToDropOffLocation;
  String? distanceToDropOffLocation;
  String? distanceToPickUpLocation;
  String? timeToPickUpLocation;
  String? pickUpLocation;
  String? dropOffLocation;
  String? passengerName;
  TripsLocations? pickUpLocation1 =
      TripsLocations(name: "".obs, latitude: 0.0.obs, longitude: 0.0.obs);

  // Keep all your existing methods like getAndShowOrderDetails, getOrderDetails, etc.
  // ... (rest of your existing methods remain unchanged)

  Future<void> getAndShowOrderDetails(
      {required String id, bool? fromBackGroundCall}) async {
    player.play(AssetSource(AppAudio.notification));
    GetRideDetailsResponseModel response =
        await ApiServices.rideOrderDetails(queryParameters: {"ride_id": id});
    getOrderDetails(response: response);
    showMyBottomSheet(IncomingOrderBottomSheet(data: response.data));
  }

  void showMyBottomSheet(Widget bottom) {
    if (isBottomSheetOpen) return;
    isBottomSheetOpen = true;
    Get.bottomSheet(
      enableDrag: false,
      isDismissible: false,
      bottom,
    ).then((_) {
      isBottomSheetOpen = false;
    });
  }

  void getOrderDetails({required GetRideDetailsResponseModel response}) {
    startLocationLat = double.parse(response.data?.startLocationLat ?? "0.0");
    startLocationLong = double.parse(response.data?.startLocationLong ?? "0.0");
    startLocationLatMarker =
        double.parse(response.data?.startLocationLat ?? "0.0");
    startLocationLongMarker =
        double.parse(response.data?.startLocationLong ?? "0.0");
    log("################### passenger latitude ##########################");
    log("################### Isonline ##########################");
    log(isOnline.value.toString());
    log(startLocationLat.toString());
    log(startLocationLong.toString());
    endLocationLat = double.parse(response.data?.endLocationLat ?? "0.0");
    endLocationLong = double.parse(response.data?.endLocationLong ?? "0.0");
    rideId = response.data?.id;
    userMobile = response.data?.passengerPhone;
    passengerId = response.data?.passenger ?? "";
    log(passengerId.toString());
    timeToDropOffLocation = response.data?.duration;
    distanceToDropOffLocation = response.data?.distance;
    passengerName = response.data?.passengerName;
    pickUpLocation = response.data?.startLocation;
    dropOffLocation = response.data?.endLocation;

    if (response.data?.rideStatus == RideStatus.accepted) {
      driverState.value = DriverState.goingToPickUp;
    } else if (response.data?.rideStatus == RideStatus.reachedPickUp) {
      driverState.value = DriverState.arrivedAtPickUp;
    } else if (response.data?.rideStatus == RideStatus.onGoing) {
      isTracking = true;
      driverState.value = DriverState.goingToDestination;
    } else if (response.data?.rideStatus == RideStatus.reachedDropOff) {
      driverState.value = DriverState.reachedDestination;
    } else if (response.data?.rideStatus == RideStatus.paymentInitiated) {
      driverState.value = DriverState.paymentInitiated;
    }

    // Update background service with new passenger and state
    locationTrackingService.updateDriverState(
      driverState.value.toString(),
      passengerId: passengerId,
    );
  }

  // ... Keep all your other existing methods unchanged ...

  Future<bool> hasAssigned() async {
    String userTypeCode = await box.read(BoxKeys.userTypeCode);
    bool? istrue = box.read(BoxKeys.isTaken);
    if (userTypeCode == "DVR" && istrue == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> onMapCreate() async {
    try {
      currentPosition.refresh();
      await googleMapController!.animateCamera(
        CameraUpdate.newLatLng(LatLng(
          currentPosition.value?.latitude ?? 0.0,
          currentPosition.value?.longitude ?? 0.0,
        )),
      );
    } catch (e, s) {
      log(e.toString(), error: e, stackTrace: s);
      isError.value = true;
    }
  }

  Future<void> getVersionInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    version.value = info.version;
    buildNumber.value = info.buildNumber;
    box.write(BoxKeys.version, version.value);
    box.write(BoxKeys.buildNumber, buildNumber.value);
  }

  Future<Position> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception('Location services are disabled');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  Future<void> makePhoneCall() async {
    final Uri uri = Uri.parse('tel:$userMobile');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $userMobile';
    }
  }

  Future<void> fetchWalletBalance() async {
    isRefreshingWallet.value = true;
    try {
      WalletResponse response = await ApiServices.getPartnerWallet();

      if (response.status == 200) {
        walletBalance.value =
            double.tryParse(response.data.amount ?? '') ?? 0.0;
        isRefreshingWallet.value = false;
      } else {
        isRefreshingWallet.value = false;
      }
    } catch (error, s) {
      isRefreshingWallet.value = false;
      Get.showSnackbar(GetSnackBar(
          duration: Duration(seconds: 2),
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.zero,
          messageText: AppSnackBar(text: error.toString())));
    }
  }

  RxBool isRefreshingWallet = false.obs;

  Future<void> refreshWalletBalance() async {
    try {
      await fetchWalletBalance();
      Get.showSnackbar(
        const GetSnackBar(
          duration: Duration(seconds: 2),
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.zero,
          messageText: AppSnackBar(
            text: "Updated wallet balance",
          ),
        ),
      );
    } catch (e) {
      Get.showSnackbar(
        const GetSnackBar(
          duration: Duration(seconds: 3),
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.zero,
          messageText: AppSnackBar(
            text: "Something went wrong",
          ),
        ),
      );
    } finally {}
  }

  RxInt addStopCount = 0.obs;
  Future<void> addStop(context) async {
    try {
      if (addStopCount.value > 4) {
        Get.showSnackbar(
          const GetSnackBar(
            duration: Duration(seconds: 5),
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            messageText: AppSnackBar(
              text: "Only 4 Stops can be added",
            ),
          ),
        );
        // Get.back();
        return;
      }
      driverState.value = DriverState.loading;
      AddStopResponseModel response = await ApiServices.addStop(body: {
        "ride_id": rideId,
        "location_lat": currentPosition.value?.latitude.toString(),
        "end_loc_long": currentPosition.value?.longitude.toString()
      });
      if (response.status == 200) {
        addStopCount++;
        log("addStopCount************$addStopCount");
        Get.showSnackbar(
          const GetSnackBar(
            duration: Duration(seconds: 5),
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            messageText: AppSnackBar(
              text: "Stop Added",
            ),
          ),
        );
        await Future.delayed(Duration(milliseconds: 300));
        Navigator.pop(context);
      } else {
        Get.showSnackbar(
          const GetSnackBar(
            duration: Duration(seconds: 5),
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            messageText: AppSnackBar(
              text: "OOPS Some thing went wrong",
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
            text: "OOPS Some thing went wrong",
          ),
        ),
      );
    } finally {
      driverState.value = DriverState.goingToDestination;
    }
  }

  void saveDistance(double distance) {
    distanceBox?.put('totalDistance', distance);
  }

  void resetDistance() {
    totalDistance = 0;
    distanceBox?.put('totalDistance', 0.0);
  }

  Future<void> reachedDropOffLocation() async {
    try {
      driverState.value = DriverState.loading;
      await getFinalDropLocation();
      ChangeRideStatusModel response =
          await ApiServices.changeRideStatus(body: {
        "ride_id": rideId,
        "ride_status": RideStatus.reachedDropOff,
        "location": finalDropLocation,
        "location_lat": currentPosition.value?.latitude.toString(),
        "location_long": currentPosition.value?.longitude.toString(),
      });
      if (response.status == 200) {
        driverState.value = DriverState.reachedDestination;
        isTracking = false;

        // Update background service
        await locationTrackingService.updateDriverState(
          driverState.value.toString(),
          passengerId: passengerId,
        );
      }
    } finally {
      driverState.value = DriverState.reachedDestination;
    }
  }

  Future<String?> getLocationDetails(double latitude, double longitude) async {
    GoogleLocationResponse response =
        await ApiServices.getCurrentLocation(latitude, longitude);

    for (var result in response.results ?? []) {
      for (var addressComponent in result.addressComponents ?? []) {
        if ((addressComponent.types?.contains("sublocality") ?? false) ||
            (addressComponent.types?.contains("subpremise") ?? false)) {
          return addressComponent.shortName;
        }
      }
    }

    return null;
  }

  void recenter() {
    if (!recenterLoading.value) {
      recenterLoading.value = true;
      loc.Location().getLocation().then(
        (newLoc) {
          recenterLoading.value = false;
          saveLocationData(newLoc);
          googleMapController?.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: cameraZoom.value,
              target: LatLng(newLoc.latitude ?? 0.0, newLoc.longitude ?? 0.0),
            ),
          ));
        },
      );
      cameraZoom.value = 15.0;
    }
  }

  Future<String?> getLocationDetails1() async {
    if (driverState.value == DriverState.idle) {
      GoogleLocationResponse response = await ApiServices.getCurrentLocation(
          pickUpLocation1?.latitude.value ?? 0.0,
          pickUpLocation1?.longitude.value ?? 0.0);

      String? neighborhood = response.results?.firstOrNull?.addressComponents
          ?.firstWhereOrNull(
              (address) => ((address.types ?? []).contains("neighborhood")))
          ?.longName;

      String? political = response.results?.firstOrNull?.addressComponents
          ?.firstWhereOrNull(
              (address) => ((address.types ?? []).contains("political")))
          ?.longName;
      String? sublocality = response.results?.firstOrNull?.addressComponents
          ?.firstWhereOrNull(
              (address) => ((address.types ?? []).contains("sublocality")))
          ?.longName;
      String? locality = response.results?.firstOrNull?.addressComponents
          ?.firstWhereOrNull(
              (address) => ((address.types ?? []).contains("locality")))
          ?.longName;
      String? postalCode = response.results?.firstOrNull?.addressComponents
          ?.firstWhereOrNull(
              (address) => ((address.types ?? []).contains("postal_code")))
          ?.longName;
      String? premise = response.results?.firstOrNull?.addressComponents
          ?.firstWhereOrNull(
              (address) => ((address.types ?? []).contains("premise")))
          ?.longName;
      return ({
        premise,
        neighborhood,
        political,
        sublocality,
        locality,
        postalCode
      }.toList().where((name) => name != null).join(","));
    } else {
      return "";
    }
  }

  Future<void> paymentInitiated() async {
    driverState.value = DriverState.loading;
    log("mobilityContext?.stops");
    log("${mobilityContext?.stops}");
    try {
      ChangeRideStatusModel response =
          await ApiServices.changeRideStatus(body: {
        "ride_id": rideId,
        "ride_status": RideStatus.paymentInitiated,
        "stops": mobilityContext?.stops,
        "location": finalDropLocation,
        "location_lat": currentPosition.value?.latitude.toString(),
        "location_long": currentPosition.value?.longitude.toString()
      });
      if (response.status == 200) {
        log("paymentInitiatedpaymentInitiated$finalDropLocation,${currentPosition.value?.latitude}${currentPosition.value?.longitude}paymentInitiatedpaymentInitiated");
        await getRidePayment();
        resetDistance();

        // Update background service
        await locationTrackingService.updateDriverState(
          driverState.value.toString(),
          passengerId: passengerId,
        );
      }
    } catch (error, s) {
      AppConstants.handleError(error, s: s);
    } finally {
      driverState.value = DriverState.paymentInitiated;
    }
  }

  String? fare;
  String? tip;
  String? tax;
  String? waiverCharge;
  String? paymentType;
  String? total;

  Future<void> getRidePayment() async {
    RidePaymentResponseModel response =
        await ApiServices.getRidePayment(queryParameter: {"ride_id": rideId});
    if (response.status == 200) {
      fare = response.data?.fare;
      tax = response.data?.tax;
      total = response.data?.total;
      paymentType = response.data?.paymentType;
      waiverCharge = response.data?.waiverCharge;
      driverState.value = DriverState.completed;
      await locationTrackingService.updateDriverState(
        driverState.value.toString(),
        passengerId: null,
      );
      Get.back();
    }
  }

  Future<void> completeRide() async {
    ChangeRideStatusModel response = await ApiServices.changeRideStatus(
        body: {"ride_id": rideId, "ride_status": RideStatus.completed});
    if (response.status == 200) {
      driverState.value = DriverState.idle;

      // Update background service back to idle
      await locationTrackingService.updateDriverState(
        driverState.value.toString(),
        passengerId: null,
      );
    }
  }

  void _showErrorSnackbar(String message) {
    Get.showSnackbar(GetSnackBar(
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.transparent,
      padding: EdgeInsets.zero,
      messageText: AppSnackBar(text: message),
    ));
  }

  Future<void> getFinalDropLocation() async {
    finalDropLocation = (await getLocationDetails(
            currentPosition.value?.latitude ?? 0.0,
            currentPosition.value?.longitude ?? 0.0)) ??
        "";
  }

  Future<void> openMap(
      {required double? latitude, required double? longitude}) async {
    var uri = Uri.parse("google.navigation:q=$latitude,$longitude&mode=d");
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not launch ${uri.toString()}';
    }
  }

  Position convertToPosition(loc.LocationData? location) {
    return Position(
      latitude: location?.latitude ?? 0.0,
      longitude: location?.longitude ?? 0.0,
      timestamp: DateTime.now(),
      accuracy: location?.accuracy ?? 0.0,
      altitude: location?.altitude ?? 0.0,
      heading: location?.heading ?? 0.0,
      speed: location?.speed ?? 0.0,
      speedAccuracy: location?.speedAccuracy ?? 0.0,
      altitudeAccuracy: 0.0,
      headingAccuracy: 0.0,
    );
  }

  void saveLocationData(loc.LocationData locationData) {
    box.write(BoxKeys.lastLocation, {
      'latitude': locationData.latitude,
      'longitude': locationData.longitude,
      'accuracy': locationData.accuracy,
      'altitude': locationData.altitude,
      'speed': locationData.speed,
      'speedAccuracy': locationData.speedAccuracy,
      'heading': locationData.heading,
      'time': locationData.time,
    });
  }

  loc.LocationData convertPositionToLocationData(Position position) {
    return loc.LocationData.fromMap({
      "latitude": position.latitude,
      "longitude": position.longitude,
      "accuracy": position.accuracy,
      "altitude": position.altitude,
      "speed": position.speed,
      "speed_accuracy": position.speedAccuracy,
      "heading": position.heading,
    });
  }

  Future<void> checkForUpdate() async {
    print('checking for Update');
    await InAppUpdate.checkForUpdate().then((info) async {
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        print('update available');
        await InAppUpdate.startFlexibleUpdate();
        InAppUpdate.completeFlexibleUpdate().then((_) {}).catchError((e) {
          print(e.toString());
        });
      }
    }).catchError((e, s) {
      log(e.toString(), error: e, stackTrace: s);
    });
  }
}
