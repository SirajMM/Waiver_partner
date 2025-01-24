import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:mobility_features/mobility_features.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waiver_driver/backend/model/home/home_model.dart';
import 'package:waiver_driver/backend/model/setting/setting_model.dart';
import 'package:waiver_driver/backend/parser/FleetHomePage/fleet_home_page_parser.dart';
import 'package:waiver_driver/backend/parser/Home/home_parser.dart';
import 'package:waiver_driver/core/themes/assets/audio.dart';
import 'package:waiver_driver/core/widgets/snackbar/snackbar.dart';

import 'package:waiver_driver/main.dart';
import 'package:waiver_driver/view/home/home_view.dart';
import 'package:location/location.dart' as loc;

import '../../backend/api/api_services/api_services.dart';
import '../../backend/api/api_services/web_socket_services.dart';
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
  void onInit() async {
    super.onInit();

    _initializeHive();
    try {
      isLoading.value = true;
      await getDriverOnlineStatus();
      sendLiveLocation();
      loc.Location location = loc.Location();

      await location.getLocation().then((location) {
        currentPosition.value = Position(
          latitude: location.latitude ?? 0.0, // Default to 0.0 if null
          longitude: location.longitude ?? 0.0, // Default to 0.0 if null
          timestamp: DateTime.now(), // Set current timestamp
          accuracy: location.accuracy ?? 0.0,
          altitude: location.altitude ?? 0.0,
          heading: location.heading ?? 0.0,
          speed: location.speed ?? 0.0,
          speedAccuracy: location.speedAccuracy ?? 0.0,
          altitudeAccuracy: 0.0,
          headingAccuracy: 0.0,
        );
      });
      pickUpLocation1 = TripsLocations(
          latitude: Rx(currentPosition.value?.latitude),
          longitude: Rx(currentPosition.value?.longitude),
          name: "".obs);

      pickUpLocation1?.name.value = await getLocationDetails(
          currentPosition.value!.latitude, currentPosition.value!.longitude);
      latestActiveRide();
      // WakelockPlus.enable();

      isError.value = false;
    } catch (error) {
      isError.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  final player = AudioPlayer();

  Rx<Position?> currentPosition = Rx<Position?>(null);
  GoogleMapController? googleMapController;
  RxInt walletBalance = 0.obs;
  bool rideIsActive = false;
  String? finalDropLocation;
  bool isTracking = false;
  double currentDistance =
      0; // Current distance in meters before it exceeds 100m
  double totalDistance = 0; // Total distance saved in Hive (in meters)
  List<Map<String, double>> latLongList = [];
  Box? distanceBox;

  Future<void> _initializeHive() async {
    distanceBox = await Hive.openBox('distanceBox');
    totalDistance = distanceBox?.get('totalDistance', defaultValue: 0.0) ?? 0.0;
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295; // Pi/180
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // Distance in kilometers
  }

  changeDriverOnlineStatus() async {
    try {
      // Call the API to change the online status
      LogoutResponseModel response = await ApiServices.changeOnlineStatus(
        body: {
          "is_online": isOnline.value ? 0 : 1,
        },
      );

      // If the API call is successful
      if (response.status == 200) {
        isOnline.value = !isOnline.value;

        // Handle background execution
        if (isOnline.value) {
          // Initialize FlutterBackground if needed
          var androidConfig = const FlutterBackgroundAndroidConfig(
            notificationTitle: "Driver Active",
            notificationText: "You are currently available for rides.",
            notificationImportance: AndroidNotificationImportance.max,
            enableWifiLock: true,
          );

          final initialized =
              await FlutterBackground.initialize(androidConfig: androidConfig);
          if (initialized) {
            await FlutterBackground.enableBackgroundExecution();
          } else {
            print("Failed to initialize background execution");
          }
        } else {
          // Disable background execution if it’s enabled
          if (FlutterBackground.isBackgroundExecutionEnabled) {
            await FlutterBackground.disableBackgroundExecution();
          }
        }
      } else {
        print("Failed to update online status: ${response.message}");
      }
    } catch (e) {
      print("Error in changeDriverOnlineStatus: $e");
    }
  }

  getDriverOnlineStatus() async {
    GetOnlineStatusResponseModel response = await ApiServices.getOnlineStatus();
    if (response.status == 200) {
      isOnline.value = response.data?.isOnline ?? false;
    }
  }

  String? passengerId;

  StreamSubscription<MobilityContext>? mobilitySubscription;
  MobilityContext? mobilityContext;
  sendLiveLocation() {
    Geolocator.getPositionStream().listen((position) {
      currentPosition.value = position;
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

  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  @override
  latestActiveRide() async {
    try {
      GetRideDetailsResponseModel response =
          await ApiServices.latestActiveRide();
      if ((response.data?.id ?? "").isNotEmpty) {
        rideIsActive = true;
        await getOrderDetails(response: response);
      } else {
        rideIsActive = false;
      }
    } catch (error) {}
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

  getAndShowOrderDetails({required String id, bool? fromBackGroundCall}) async {
    player.play(AssetSource(AppAudio.notification));
    GetRideDetailsResponseModel response =
        await ApiServices.rideOrderDetails(queryParameters: {"ride_id": id});
    getOrderDetails(response: response);
    Get.bottomSheet(IncomingOrderBottomSheet(data: response.data));
  }

  getOrderDetails({required GetRideDetailsResponseModel response}) {
    startLocationLat = double.parse(response.data?.startLocationLat ?? "0.0");
    startLocationLong = double.parse(response.data?.startLocationLong ?? "0.0");
    endLocationLat = double.parse(response.data?.endLocationLat ?? "0.0");
    endLocationLong = double.parse(response.data?.endLocationLong ?? "0.0");
    rideId = response.data?.id;
    userMobile = response.data?.passengerPhone;
    passengerId = response.data?.passenger ?? "";
    print(passengerId);
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

  onMapCreate() async {
    Position position = await Geolocator.getCurrentPosition();
    // LocationAccuracyStatus position1 = await Geolocator.getLocationAccuracy();

    currentPosition.value = position;

    googleMapController!.animateCamera(
      CameraUpdate.newLatLng(LatLng(
        position.latitude,
        position.longitude,
      )),
    );
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

  addStop(context) async {
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
        await Future.delayed(
            Duration(milliseconds: 300)); // Ensure Snackbar is shown
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

  acceptOrder() async {
    try {
      driverState.value = DriverState.loading;
      player.stop();
      ChangeRideStatusModel response = await ApiServices.changeRideStatus(
          body: {"ride_id": rideId, "ride_status": RideStatus.accepted});
      if (response.status == 200) {
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

  reachedPickUpLocation() async {
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

  goingToDropOffLocation() async {
    try {
      driverState.value = DriverState.loading;
      ChangeRideStatusModel response = await ApiServices.changeRideStatus(
          body: {"ride_id": rideId, "ride_status": RideStatus.onGoing});
      if (response.status == 200) {
        driverState.value = DriverState.readyToGoToDestination;
        await MobilityFeatures()
            .startListening(Geolocator.getPositionStream().map((location) {
          print("mobility features");
          print(mobilityContext?.distanceTraveled ?? "null");
          print(location);
          print(location.longitude);
          return LocationSample(
              GeoLocation(location.latitude, location.longitude),
              DateTime.now());
        }));
      }
    } finally {
      // driverState.value = DriverState.readyToGoToDestination;
    }
  }

  reachedDropOffLocation() async {
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

    return null; // Return null if no sublocality or subpremise is found
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

  paymentInitiated() async {
    driverState.value = DriverState.loading;
    print("mobilityContext?.stops");
    print(mobilityContext?.stops);
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
        resetDistance();
        // getRidePayment();
      }
    } finally {
      driverState.value = DriverState.paymentInitiated;
    }
  }

  MobilityContext? _mobilityContext;

  String? fare;
  String? tip;
  String? tax;
  String? waiverCharge;
  String? paymentType;
  String? total;
  getRidePayment() async {
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

  completeRide() async {
    ChangeRideStatusModel response = await ApiServices.changeRideStatus(
        body: {"ride_id": rideId, "ride_status": RideStatus.completed});
    if (response.status == 200) {
      driverState.value = DriverState.idle;
    }
  }

  confirmedPayment() async {
    driverState.value = DriverState.loading;
    ChangeRideStatusModel response = await ApiServices.changeRideStatus(
        body: {"ride_id": rideId, "ride_status": RideStatus.completed});
    if (response.status == 200) {
      Get.back();
      await getRidePayment();
      driverState.value = DriverState.completed;
    }
  }

  verifyRideOtp({required String type}) async {
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
          if (type == RideStatus.reachedPickUp) {
            ChangeRideStatusModel response = await ApiServices.changeRideStatus(
                body: {
                  "ride_id": rideId,
                  "ride_status": RideStatus.reachedPickUp
                });
            print("tracking -----------");
            print(isTracking);
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

  getFinalDropLocation() async {
    finalDropLocation = (await getLocationDetails(
            currentPosition.value?.latitude ?? 0.0,
            currentPosition.value?.longitude ?? 0.0)) ??
        "";
    paymentInitiated();
  }

  orderTimeOut() async {
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
      Get.defaultDialog(
          middleText:
              "This order has expired and has been transferred to another driver");
    }
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
}
