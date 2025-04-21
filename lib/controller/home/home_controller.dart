import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:mobility_features/mobility_features.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waiver_driver/backend/model/home/home_model.dart';
import 'package:waiver_driver/backend/model/setting/setting_model.dart';
import 'package:waiver_driver/backend/parser/Home/home_parser.dart';
import 'package:waiver_driver/core/themes/assets/audio.dart';
import 'package:waiver_driver/core/widgets/snackbar/snackbar.dart';
import 'package:waiver_driver/main.dart';
import 'package:waiver_driver/view/home/home_view.dart';
import 'package:location/location.dart' as loc;
import '../../backend/api/api_services/api_services.dart';
import '../../backend/api/api_services/web_socket_services.dart';
import '../../backend/model/earning/earning_model.dart';

import '../../core/colors/app_colors.dart';
import '../../core/constants/enums/enums.dart';
import '../../core/constants/get_storage_constants.dart';

// class HomeControllerBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut(() => HomeController());
//   }
// }

class HomeController extends GetxController {
  final HomeParser parser;
  HomeController({required this.parser});

  static HomeController get to => Get.find();
  RxString appState = "Active".obs;
  @override
  void onInit() async {
    super.onInit();
    currentPosition.value = convertToPosition(AppConstants.locationData);
    // WidgetsBinding.instance.addObserver(this);
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
        currentPosition.value = convertToPosition(result[3] as loc.LocationData);
        saveLocationData(result[3] as loc.LocationData);
      }
      isLoading.value = false;
      sendLiveLocation();

      pickUpLocation1 = TripsLocations(
          latitude: Rx(currentPosition.value?.latitude),
          longitude: Rx(currentPosition.value?.longitude),
          name: "".obs);

      getLocationDetails(currentPosition.value!.latitude, currentPosition.value!.longitude).then(
        (value) => pickUpLocation1?.name.value = value ?? '',
      );

      isError.value = false;
    } catch (error) {
      isError.value = false;
    } finally {
      isLoading.value = false;
    }
  }

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
  //
  //     // changeDriverOnlineStatus();
  //     //   Workmanager().registerOneOffTask(
  //     //     "backgroundTask",
  //     //     "executeApiCall",
  //     //   );
  //   }
  // }

  // void closeConnection() {
  //   print("🔴 Closing WebSocket/Firebase connection...");
  // }
  //
  // void resumeConnection() {
  //   print("🟢 Reconnecting WebSocket/Firebase...");
  // }

  // @override
  // void onClose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   super.onClose();
  // }

  @override
  void dispose() {
    changeDriverOnlineStatus();
    super.dispose();
  }

  final player = AudioPlayer();

  Rx<Position?> currentPosition = Rx<Position?>(null);
  GoogleMapController? googleMapController;
  Rx<double?> walletBalance = Rx<double?>(null);
  bool rideIsActive = false;
  String? finalDropLocation;
  bool isTracking = false;
  double currentDistance = 0; // Current distance in meters before it exceeds 100m
  double totalDistance = 0; // Total distance saved in Hive (in meters)
  List<Map<String, double>> latLongList = [];
  Box? distanceBox;

  Future<void> _initializeHive() async {
    distanceBox = await Hive.openBox('distanceBox');
    totalDistance = distanceBox?.get('totalDistance', defaultValue: 0.0) ?? 0.0;
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295; // Pi/180
    var c = math.cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * math.asin(math.sqrt(a)); // Distance in kilometers
  }

  Future<void> changeDriverOnlineStatus() async {
    try {
      LogoutResponseModel response = await ApiServices.changeOnlineStatus(
        body: {
          "is_online": isOnline.value ? 0 : 1,
        },
      );
      log("#####################${isOnline.value}#####################");

      if (response.status == 200) {
        isOnline.value = !isOnline.value;
        log("#####################${isOnline.value}#####################");

        if (isOnline.value) {
          // Initialize FlutterBackground if needed
          // var androidConfig = const FlutterBackgroundAndroidConfig(
          //   notificationTitle: "Driver Active",
          //   notificationText: "You are currently available for rides.",
          //   notificationImportance: AndroidNotificationImportance.max,
          //   enableWifiLock: true,
          // );
          //
          // final initialized =
          //     await FlutterBackground.initialize(androidConfig: androidConfig);
          // if (initialized) {
          //   await FlutterBackground.enableBackgroundExecution();
        } else {
          log("Failed to initialize background execution");
        }
      } else {
        // Disable background execution if it’s enabled
        // if (FlutterBackground.isBackgroundExecutionEnabled) {
        //   await FlutterBackground.disableBackgroundExecution();
        // }
      }
    } catch (e) {
      debugPrint("Error in changeDriverOnlineStatus: $e");
    }
  }

  Future<void> getDriverOnlineStatus() async {
    GetOnlineStatusResponseModel response = await ApiServices.getOnlineStatus();
    if (response.status == 200) {
      isOnline.value = response.data?.isOnline ?? false;
    }
  }

  String? passengerId;

  StreamSubscription<MobilityContext>? mobilitySubscription;
  MobilityContext? mobilityContext;
  void sendLiveLocation() {
    Geolocator.getPositionStream().listen((position) {
      currentPosition.value = position;
      saveLocationData(convertPositionToLocationData(position));
      if (isOnline.value) {
        WebSocketServices.sendLiveLocation(body: {
          "passenger_id":
              driverState.value == DriverState.idle ? RiderStatus.save : passengerId ?? "placeholder",
          "msg_type": driverState.value == DriverState.idle ? RiderStatus.save : RiderStatus.ride,
          "ride_status": driverState.value.toString(),
          "current_loc_long": position.longitude,
          "current_loc_lat": position.latitude,
        });
      }
    });
  }

  RxBool isLoading = false.obs;
  RxBool isError = false.obs;

  Future<void> latestActiveRide() async {
    try {
      GetRideDetailsResponseModel response = await ApiServices.latestActiveRide();
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
      icon: Icon(
        Icons.check,
        color: AppColors.white,
      ),
      value: '0 %',
      text: 'Acceptance');
  DashBoardItemModel rating =
      DashBoardItemModel(icon: Icon(Icons.star, color: AppColors.white), value: '2.5', text: 'Rating');
  DashBoardItemModel cancellation = DashBoardItemModel(
      icon: Icon(Icons.close, color: AppColors.white), value: '0%', text: 'Cancellation');

  double? startLocationLat;
  double? startLocationLong;
  double? startLocationLatMarker;
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
  TripsLocations? pickUpLocation1 = TripsLocations(name: "".obs, latitude: 0.0.obs, longitude: 0.0.obs);

  Future<void> getAndShowOrderDetails({required String id, bool? fromBackGroundCall}) async {
    player.play(AssetSource(AppAudio.notification));
    GetRideDetailsResponseModel response =
        await ApiServices.rideOrderDetails(queryParameters: {"ride_id": id});
    getOrderDetails(response: response);
    Get.bottomSheet(IncomingOrderBottomSheet(data: response.data));
  }

  void getOrderDetails({required GetRideDetailsResponseModel response}) {
    startLocationLat = double.parse(response.data?.startLocationLat ?? "0.0");
    startLocationLong = double.parse(response.data?.startLocationLong ?? "0.0");
    startLocationLatMarker = double.parse(response.data?.startLocationLat ?? "0.0");
    startLocationLongMarker = double.parse(response.data?.startLocationLong ?? "0.0");
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
      // trackDistance();
      // goingToDropOffLocation();
      driverState.value = DriverState.goingToDestination;
    } else if (response.data?.rideStatus == RideStatus.reachedDropOff) {
      driverState.value = DriverState.reachedDestination;
    } else if (response.data?.rideStatus == RideStatus.paymentInitiated) {
      driverState.value = DriverState.paymentInitiated;
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
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
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
        walletBalance.value = double.tryParse(response.data.amount ?? '') ?? 0.0;
        isRefreshingWallet.value = false;
      } else {
        isRefreshingWallet.value = false;
      }
    } catch (e) {
      isRefreshingWallet.value = false;
    }
  }

  RxBool isRefreshingWallet = false.obs;

  Future<void> refreshWalletBalance() async {
    try {
      // Call your wallet API
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
      // Handle error
      Get.showSnackbar(
        const GetSnackBar(
          duration: Duration(seconds: 3),
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.zero,
          messageText: AppSnackBar(
            text: "Something wnet wrong",
          ),
        ),
      );
    } finally {}
  }

  Future<void> addStop(context) async {
    try {
      driverState.value = DriverState.loading;
      AddStopResponseModel response = await ApiServices.addStop(body: {
        "ride_id": rideId,
        "location_lat": currentPosition.value?.latitude.toString(),
        "end_loc_long": currentPosition.value?.longitude.toString()
      });
      if (response.status == 200) {
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
        await Future.delayed(Duration(milliseconds: 300)); // Ensure Snackbar is shown
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

  // Future<void> trackDistance() async {
  //   while (isTracking) {
  //     Position position = await getCurrentPosition();
  //     double currentLat = position.latitude;
  //     double currentLng = position.longitude;
  //     print("location updating---------------");
  //     print(currentLng);
  //     print(currentLat);
  //
  //     // Calculate distance if a previous location exists
  //     if (latLongList.isNotEmpty) {
  //       double lastLat = latLongList.last['lat']!;
  //       double lastLng = latLongList.last['lng']!;
  //       double distanceInKilometers = calculateDistance(lastLat, lastLng, currentLat, currentLng);
  //       currentDistance += distanceInKilometers;
  //
  //       // Save total distance if current distance exceeds 0.1 km (100 meters)
  //       if (currentDistance >= 0.1) {
  //         totalDistance += currentDistance;
  //         saveDistance(totalDistance); // Save to Hive
  //         currentDistance = 0;
  //         latLongList.clear();
  //         print(totalDistance);
  //       }
  //       print("totalDistance-------------------------");
  //       print(totalDistance);
  //     }
  //
  //     // Update location list
  //     latLongList.add({'lat': currentLat, 'lng': currentLng});
  //
  //   }
  //
  //   print("location not updating---------------");
  // }

  // Save the total distance in Hive
  void saveDistance(double distance) {
    distanceBox?.put('totalDistance', distance);
  }

  // Reset total distance if needed
  void resetDistance() {
    totalDistance = 0;
    distanceBox?.put('totalDistance', 0.0);
  }

  Future<void> acceptOrder() async {
    try {
      driverState.value = DriverState.loading;
      player.stop();
      ChangeRideStatusModel response = await ApiServices.changeRideStatus(
          body: {"ride_id": rideId, "ride_status": RideStatus.accepted});
      if (response.status == 200) {
        if (driverState.value == DriverState.idle) {
          startLocationLongMarker = 0.0;
          startLocationLatMarker = 0.0;
        }
        rideIsActive = true;
        Get.back();
        driverState.value = DriverState.goingToPickUp;
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

  Future<void> reachedPickUpLocation() async {
    try {
      driverState.value = DriverState.loading;
      ChangeRideStatusModel response = await ApiServices.changeRideStatus(
          body: {"ride_id": rideId, "ride_status": RideStatus.reachedPickUp});
      if (response.status == 200) {
        Get.back();
        driverState.value = DriverState.arrivedAtPickUp;
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
        await MobilityFeatures().startListening(Geolocator.getPositionStream().map((location) {
          log("mobility features");
          log("${mobilityContext?.distanceTraveled}");
          log(location.toString());
          log(location.longitude.toString());
          return LocationSample(GeoLocation(location.latitude, location.longitude), DateTime.now());
        }));
      }
    } finally {
      // driverState.value = DriverState.readyToGoToDestination;
    }
  }

  Future<void> reachedDropOffLocation() async {
    try {
      driverState.value = DriverState.loading;
      ChangeRideStatusModel response = await ApiServices.changeRideStatus(
          body: {"ride_id": rideId, "ride_status": RideStatus.reachedDropOff});
      if (response.status == 200) {
        driverState.value = DriverState.reachedDestination;
        isTracking = false;
      }
    } finally {
      driverState.value = DriverState.reachedDestination;
    }
  }

  Future<String?> getLocationDetails(double latitude, double longitude) async {
    GoogleLocationResponse response = await ApiServices.getCurrentLocation(latitude, longitude);

    for (var result in response.results ?? []) {
      for (var addressComponent in result.addressComponents ?? []) {
        if ((addressComponent.types?.contains("sublocality") ?? false) ||
            (addressComponent.types?.contains("subpremise") ?? false)) {
          return addressComponent.shortName;
        }
      }
    }

    return null; // Return null if no sublocality or subpremise is found
  }

  Future<String?> getLocationDetails1() async {
    if (driverState.value == DriverState.idle) {
      GoogleLocationResponse response = await ApiServices.getCurrentLocation(
          pickUpLocation1?.latitude.value ?? 0.0, pickUpLocation1?.longitude.value ?? 0.0);

      String? neighborhood = response.results?.firstOrNull?.addressComponents
          ?.firstWhereOrNull((address) => ((address.types ?? []).contains("neighborhood")))
          ?.longName;

      String? political = response.results?.firstOrNull?.addressComponents
          ?.firstWhereOrNull((address) => ((address.types ?? []).contains("political")))
          ?.longName;
      String? sublocality = response.results?.firstOrNull?.addressComponents
          ?.firstWhereOrNull((address) => ((address.types ?? []).contains("sublocality")))
          ?.longName;
      String? locality = response.results?.firstOrNull?.addressComponents
          ?.firstWhereOrNull((address) => ((address.types ?? []).contains("locality")))
          ?.longName;
      String? postalCode = response.results?.firstOrNull?.addressComponents
          ?.firstWhereOrNull((address) => ((address.types ?? []).contains("postal_code")))
          ?.longName;
      String? premise = response.results?.firstOrNull?.addressComponents
          ?.firstWhereOrNull((address) => ((address.types ?? []).contains("premise")))
          ?.longName;
      return ({premise, neighborhood, political, sublocality, locality, postalCode}
          .toList()
          .where((name) => name != null)
          .join(","));
    } else {
      return "";
    }
  }

  Future<void> paymentInitiated() async {
    driverState.value = DriverState.loading;
    log("mobilityContext?.stops");
    log("${mobilityContext?.stops}");
    try {
      ChangeRideStatusModel response = await ApiServices.changeRideStatus(body: {
        "ride_id": rideId,
        "ride_status": RideStatus.paymentInitiated,
        "stops": mobilityContext?.stops,
        "location": finalDropLocation,
        "location_lat": currentPosition.value?.latitude.toString(),
        "location_long": currentPosition.value?.longitude.toString()
      });
      if (response.status == 200) {
        resetDistance();
        // getRidePayment();
      }
    } finally {
      driverState.value = DriverState.paymentInitiated;
    }
  }

  // MobilityContext? _mobilityContext;

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
    }
  }

  Future<void> completeRide() async {
    ChangeRideStatusModel response = await ApiServices.changeRideStatus(
        body: {"ride_id": rideId, "ride_status": RideStatus.completed});
    if (response.status == 200) {
      driverState.value = DriverState.idle;
    }
  }

  Future<void> confirmedPayment() async {
    driverState.value = DriverState.loading;
    ChangeRideStatusModel response = await ApiServices.changeRideStatus(
        body: {"ride_id": rideId, "ride_status": RideStatus.completed});
    if (response.status == 200) {
      Get.back();
      await getRidePayment();
      driverState.value = DriverState.completed;
    }
  }

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
        if (response.status == 200) {
          startLocationLatMarker = 0.0;
          startLocationLatMarker = 0.0;
          if (type == RideStatus.reachedPickUp) {
            await ApiServices.changeRideStatus(
                body: {"ride_id": rideId, "ride_status": RideStatus.reachedPickUp});
            log("tracking -----------");
            log(isTracking.toString());
            isTracking = true;
            // trackDistance();
            goingToDropOffLocation();
          } else {
            MobilityFeatures().stopListening();
            // ChangeRideStatusModel response = await ApiServices.changeRideStatus(
            //     body: {
            //       "ride_id": rideId,
            //       "ride_status": RideStatus.paymentInitiated
            //     });

            getFinalDropLocation();
          }
          code = " ";
        } else {
          Get.showSnackbar(const GetSnackBar(
              duration: Duration(seconds: 5),
              backgroundColor: Colors.transparent,
              padding: EdgeInsets.zero,
              messageText: AppSnackBar(text: "Wrong otp")));
        }
      } else {
        Get.showSnackbar(const GetSnackBar(
            duration: Duration(seconds: 5),
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            messageText: AppSnackBar(text: "Wrong otp")));
      }
    } catch (error) {
      Get.showSnackbar(const GetSnackBar(
          duration: Duration(seconds: 5),
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.zero,
          messageText: AppSnackBar(text: "OOPS Something went wrong")));
    } finally {
      if (type == RideStatus.reachedPickUp) {
        driverState.value = DriverState.arrivedAtPickUp;
      } else {
        driverState.value = DriverState.reachedDestination;
      }
    }
  }

  Future<void> getFinalDropLocation() async {
    finalDropLocation = (await getLocationDetails(
            currentPosition.value?.latitude ?? 0.0, currentPosition.value?.longitude ?? 0.0)) ??
        "";
    paymentInitiated();
  }

  Future<void> orderTimeOut() async {
    player.stop();
    ChangeRideStatusModel response = await ApiServices.changeRideStatus(body: {
      "ride_id": rideId,
      "ride_status": RideStatus.cancelled,
    });
    if (response.status == 200) {
      rideIsActive = false;
      box.remove(BoxKeys.rideId);
      driverState.value = DriverState.idle;
      if (Get.isBottomSheetOpen ?? false) {
        Get.back();
      }
      Get.defaultDialog(middleText: "This order has expired and has been transferred to another driver");
    }
  }

  Future<void> openMap({required double? latitude, required double? longitude}) async {
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

  // void recenter() {
  //   if (!recenterLoading.value) {
  //     recenterLoading.value = true;
  //     loc.Location().getLocation().then(
  //           (newLoc) {
  //         recenterLoading.value = false;
  //         saveLocationData(newLoc);
  //         googleMapController?.animateCamera(CameraUpdate.newCameraPosition(
  //           CameraPosition(
  //             zoom: cameraZoom.value,
  //             target: LatLng(newLoc.latitude ?? 0.0, newLoc.longitude ?? 0.0),
  //           ),
  //         ));
  //       },
  //     );
  //     cameraZoom.value = 14.0;
  //   }
  // }
}
