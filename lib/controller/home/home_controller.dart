import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:waiver_driver/helper/logger.dart';
import 'dart:isolate';
import 'dart:math' as math;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:mobility_features/mobility_features.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waiver_driver/backend/model/home/home_model.dart';
import 'package:waiver_driver/backend/model/setting/setting_model.dart';
import 'package:waiver_driver/backend/parser/Home/home_parser.dart';
import 'package:waiver_driver/controller/driver_profile/driver_profile_controller.dart';
import 'package:waiver_driver/core/themes/assets/audio.dart';
import 'package:waiver_driver/core/widgets/app_buttons/app_buttons.dart';
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
import '../../view/home/Widget/update_widget.dart';
import '../profile/profile_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:smart_app_update_flutter/smart_app_update_flutter.dart' as sm;

class HomeController extends GetxController with WidgetsBindingObserver {
  HomeController({required this.parser});

  DashBoardItemModel acceptance = DashBoardItemModel(
      icon: Icon(Icons.check, color: AppColors.white), value: '0 %', text: 'Acceptance');

  RxInt addStopCount = 0.obs;
  RxString appState = "Active".obs;
  final RxString buildNumber = ''.obs;
  RxDouble cameraZoom = 14.0.obs;
  List<String> cancelReasons = [];
  DashBoardItemModel cancellation = DashBoardItemModel(
      icon: Icon(Icons.close, color: AppColors.white), value: '0%', text: 'Cancellation');

  String code = "";
  double currentDistance = 0;
  Rx<Position?> currentPosition = Rx<Position?>(null);
  Box? distanceBox;
  String? distanceToDropOffLocation;
  String? distanceToPickUpLocation;
  Rx<DriverState> driverState = DriverState.idle.obs;
  String? dropOffLocation;
  double? endLocationLat;
  double? endLocationLong;
  String? fare;
  String? finalDropLocation;
  GoogleMapController? googleMapController;
  RxBool isAssinged = false.obs;
  bool isBottomSheetOpen = false;
  RxBool isButtonLoading = false.obs;
  RxBool isError = false.obs;
  // StreamSubscription<MobilityContext>? mobilitySubscription;
  // MobilityContext? mobilityContext;
  RxBool isLoading = false.obs;

  RxBool isOnline = false.obs;
  RxBool isOnlineButtonLoading = false.obs;
  RxBool isRefreshingWallet = false.obs;
  bool isTracking = false;
  List<Map<String, double>> latLongList = [];
  LocationTrackingService? locationTrackingService;
  MobilityContext? mobilityContext;
  StreamSubscription<MobilityContext>? mobilitySubscription;
  GlobalKey<FormState> otpValidationFormKey = GlobalKey();
  final HomeParser parser;
  String? passengerId;
  String? passengerName;

  final RxnString _paymentTypeRx = RxnString();
  String? get paymentType => _paymentTypeRx.value;

  bool get isCashPayment => (_paymentTypeRx.value ?? box.read(BoxKeys.paymentType)) == "CSH";

  void updatePaymentType(String? type) {
    if (type == null || type.isEmpty) return;
    _paymentTypeRx.value = type;
    box.write(BoxKeys.paymentType, type);
  }

  String? pickUpLocation;
  TripsLocations? pickUpLocation1 = TripsLocations(name: "".obs, latitude: 0.0.obs, longitude: 0.0.obs);

  // Keep all your existing methods unchanged...
  final player = AudioPlayer();
  // Bumped whenever the ride this sound belongs to gets resolved
  // (accepted/timed out) before the delayed iOS playback in
  // _playIncomingRideSound fires, so that delayed call knows to skip it.
  int _rideSoundToken = 0;

  DashBoardItemModel rating =
      DashBoardItemModel(icon: Icon(Icons.star, color: AppColors.white), value: '2.5', text: 'Rating');

  RxBool recenterLoading = false.obs;
  String? rideId = "";
  bool rideIsActive = false;
  String? rideType;
  RxString selectedCancelReason = "".obs;
  RxBool showIsOtpValid = false.obs;
  double? startLocationLat;
  double? startLocationLatMarker;
  double? startLocationLong;
  double? startLocationLongMarker;
  String? tax;
  int? timeToDropOffLocation;
  String? timeToPickUpLocation;
  String? tip;
  String? total;
  double totalDistance = 0;
  String? userMobile;
  final RxString version = ''.obs;
  String? waiverCharge;
  Rx<double?> walletBalance = Rx<double?>(null);

  Timer? _positionSyncTimer;
// FIX 8: Add periodic service health check
  Timer? _serviceHealthTimer;

// FIX 1: Enhanced app lifecycle handler
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.paused:
        appState.value = "Background";
        log("App in Background - Background service will continue location tracking");
        break;
      case AppLifecycleState.resumed:
        appState.value = "Active";
        log("App Resumed - Background service is already running");
        // _checkServiceHealthOnResume();
        break;
      case AppLifecycleState.detached:
        appState.value = "Terminated";
        _handleAppTermination();
        log("App Terminated - Handling cleanup");
        break;
      case AppLifecycleState.inactive:
        // Handle inactive state gracefully
        log("App became inactive");
        break;
      case AppLifecycleState.hidden:
        // Handle hidden state
        log("App hidden");
        break;
    }
  }

// FIX 10: Enhanced dispose method
  @override
  void dispose() {
    stopServiceHealthCheck();

    // Perform cleanup without waiting (non-blocking)
    // stopLocationTracking().catchError((e) {
    //   log('Error during dispose cleanup: $e');
    // });

    super.dispose();
  }

// FIX 9: Enhanced onClose method
  @override
  void onClose() {
    stopServiceHealthCheck();
    WidgetsBinding.instance.removeObserver(this);

    // Perform cleanup without waiting (non-blocking)
    // stopLocationTracking().catchError((e) {
    //   log('Error during onClose cleanup: $e');
    // });

    super.onClose();
  }

  @override
  void onReady() {
    super.onReady();
    UpdateChecker.checkForUpdate();
    // checkForUpdate();
  }

  @override
  void onInit() async {
    super.onInit();
    _syncTokenToSharedPreferences();
    _checkAndStopServiceIfOffline();
    currentPosition.value = convertToPosition(AppConstants.locationData);
    WidgetsBinding.instance.addObserver(this);
    _initializeHive();
    // _loadIsOnlineStatus();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   debugDumpSemanticsTree(DebugSemanticsDumpOrder.inverseHitTest);
    // });

    loc.Location location = loc.Location();
    try {
      List<Future> apis = [
        getDriverOnlineStatus(), // index 0
        fetchWalletBalance(), // index 1
        latestActiveRide(), // index 2
      ];

      int? locationIndex;
      if (currentPosition.value == null) {
        apis.add(location.getLocation());
        locationIndex = apis.length - 1; // This will be index 3
      }

      isLoading.value = true;
      final result = await Future.wait(apis);

// Only process location if it was actually fetched
      if (currentPosition.value == null && locationIndex != null) {
        currentPosition.value = convertToPosition(result[locationIndex] as loc.LocationData);
        saveLocationData(result[locationIndex] as loc.LocationData);
      }
      isLoading.value = false;
      // checkForUpdate();

      // Initialize location tracking service only when needed
      await _initializeLocationTrackingIfNeeded();

      // Continue with regular location stream (for UI updates)
      // sendLiveLocation();
      _startServiceHealthCheck();

      getVersionInfo();
      ProfileController.to.getProfile();
      isAssinged.value = await hasAssigned();
      recenter();
      pickUpLocation1 = TripsLocations(
          latitude: Rx(currentPosition.value?.latitude),
          longitude: Rx(currentPosition.value?.longitude),
          name: Rx<String>(''));

      getLocationDetails(currentPosition.value!.latitude, currentPosition.value!.longitude).then(
        (value) => pickUpLocation1?.name.value = value ?? '',
      );

      // _positionSyncTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      //   _loadCurrentPositionFromStorage();
      //   log("⏳ Synced currentPosition: ${currentPosition.value}");
      // });
      recenter();

      isError.value = false;
    } catch (error) {
      isError.value = false;
      log(error.toString());
    } finally {
      isLoading.value = false;
    }
  }

  static HomeController get to => Get.find();

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
    }, onError: (error) {
      log('❌ Error in sendLiveLocation position stream: $error');
    });
  }

  // void _loadIsOnlineStatus() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   isOnline.value = prefs.getBool('isOnline') ?? false;
  // }

  void _startServiceHealthCheck() {
    // Stop any existing timer first
    _serviceHealthTimer?.cancel();

    // Run every 1 minute (tweak as needed)
    _serviceHealthTimer = Timer.periodic(const Duration(minutes: 1), (_) async {
      try {
        log("🩺 Running service health check...");

        final response = await ApiServices.getOnlineStatus();
        final serverOnline = response.data?.isOnline ?? false;
        final localOnline = box.read(BoxKeys.isOnline) ?? false;

        // If server shows offline but app says online → resync
        if (localOnline && !serverOnline) {
          log("⚠️ Server shows offline but app says online → re-syncing online status...");
          await ApiServices.changeOnlineStatus(body: {"is_online": 1});
        }

        // If app shows offline but server says online → fix local cache
        if (!localOnline && serverOnline) {
          log("⚠️ App offline but server online → syncing local storage...");
          box.write(BoxKeys.isOnline, true);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('is_online', true);
          isOnline.value = true;
        }
      } catch (e, s) {
        AppConstants.handleError(e, s: s);
        log("❌ Error in service health check: $e");
      }
    });

    log("✅ Service health check started");
  }

// FIX 5: Enhanced changeDriverOnlineStatus method

// Update your changeDriverOnlineStatus method:

  // Entry point for the GO / Stop button.
  // Keeps the loading spinner up for the WHOLE flow (profile fetch +
  // assignment check + toggle) and blocks duplicate taps while running.
  Future<void> onGoButtonTapped() async {
    if (isOnlineButtonLoading.value) return;
    isOnlineButtonLoading.value = true;
    try {
      await ProfileController.to.getProfile();
      isAssinged.value = await hasAssigned();

      final useTypeCode = box.read(BoxKeys.userTypeCode) ?? "";
      if (isAssinged.value == false && useTypeCode == UserTypeCode.driver) {
        Get.showSnackbar(
          const GetSnackBar(
            duration: Duration(seconds: 3),
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            messageText: AppSnackBar(
              text: "You have no assinged vehicles",
            ),
          ),
        );
        return;
      }
      await _toggleOnlineStatus();
    } catch (error, s) {
      debugPrint("Error in onGoButtonTapped: $error");
      AppConstants.handleError("error", s: s);
    } finally {
      isOnlineButtonLoading.value = false;
    }
  }

  // Public entry used by the side menu / settings. Manages the loading
  // flag itself so those callers also block duplicate taps.
  Future<void> changeDriverOnlineStatus() async {
    if (isOnlineButtonLoading.value) return;
    isOnlineButtonLoading.value = true;
    try {
      await _toggleOnlineStatus();
    } finally {
      isOnlineButtonLoading.value = false;
    }
  }

  // Core toggle logic. Callers are responsible for managing
  // [isOnlineButtonLoading] around this method.
  Future<void> _toggleOnlineStatus() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      // 🔹 Call API to toggle online/offline
      LogoutResponseModel response = await ApiServices.changeOnlineStatus(
        body: {
          "is_online": isOnline.value ? 0 : 1,
        },
      );
      final token = box.read(BoxKeys.token);
      await prefs.setString('auth_token', token);
      if (response.status == 200) {
        final wasOnline = isOnline.value;
        isOnline.value = !isOnline.value;

        // 🔹 Persist status
        box.write(BoxKeys.isOnline, isOnline.value);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isOnline', isOnline.value);

        if (isOnline.value && !wasOnline) {
          // ---------------- DRIVER GOING ONLINE ----------------
          await requestBatteryOptimizationExemption();

          // Ensure service exists
          locationTrackingService ??= Get.put(LocationTrackingService());

          // Tell service to start
          log("locationTrackingService!.updateOnlineStatus(true)CALLED isOnline*************");
          await locationTrackingService!.updateOnlineStatus(true);
          sendLiveLocation();
          // sendLiveLocation();

          final service = FlutterBackgroundService();
          final isRunning = await service.isRunning();

          if (!isRunning) {
            await service.startService();
            log('📡 Background service started');
          } else {
            log('⚡ Service already running');
          }

          log('✅ Driver went online');
        } else if (!isOnline.value && wasOnline) {
          // ---------------- DRIVER GOING OFFLINE ----------------
          if (locationTrackingService != null) {
            await locationTrackingService!.updateOnlineStatus(false);

            final service = FlutterBackgroundService();
            final isRunning = await service.isRunning();

            if (isRunning) {
              service.invoke("stopService");
              log('📴 Background service stopped');
            }
          }

          log('✅ Driver went offline');
        }
      }
    } catch (error, s) {
      debugPrint("Error in _toggleOnlineStatus: $error");
      AppConstants.handleError("error", s: s);
    }
  }

  // Add this method to your HomeController
  Future<void> requestBatteryOptimizationExemption() async {
    try {
      if (Platform.isAndroid) {
        final status = await Permission.ignoreBatteryOptimizations.status;

        if (status.isDenied) {
          final result = await Permission.ignoreBatteryOptimizations.request();

          if (result.isGranted) {
            log('Battery optimization exemption granted');
          } else {
            log('Battery optimization exemption denied');
            // Show user a dialog explaining why this is important
            _showBatteryOptimizationDialog();
          }
        }
      }
    } catch (e) {
      log('Error requesting battery optimization exemption: $e');
    }
  }

  // ... rest of your existing methods remain the same ...

  Future<void> acceptOrder() async {
    try {
      isButtonLoading.value = true;
      driverState.value = DriverState.loading;
      _rideSoundToken++;
      player.stop();
      ChangeRideStatusModel response = await ApiServices.changeRideStatus(
          body: {"ride_id": rideId, "ride_status": RideStatus.accepted});
      if (response.status == 200) {
        rideIsActive = true;
        Get.back();
        driverState.value = DriverState.goingToPickUp;

        // Update background service with new driver state and passenger
        if (locationTrackingService != null) {
          await locationTrackingService!.updateDriverState(
            driverState.value.toString(),
            passengerId: passengerId,
          );
        }
      }
    } catch (error) {
      _handleRideError();
    } finally {
      isButtonLoading.value = false;
      recenter();
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

        // Update background service
        if (locationTrackingService != null) {
          await locationTrackingService!.updateDriverState(
            driverState.value.toString(),
            passengerId: passengerId,
          );
        }
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
        if (locationTrackingService != null) {
          await locationTrackingService!.updateDriverState(
            driverState.value.toString(),
            passengerId: passengerId,
          );
        }

        await MobilityFeatures()
            .startListening(Geolocator.getPositionStream().handleError((error, stack) {
          log('❌ Error in mobility features position stream: $error');
        }).map((location) {
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

  Future<void> confirmedPayment() async {
    final previousState = driverState.value;
    driverState.value = DriverState.loading;
    try {
      ChangeRideStatusModel response = await ApiServices.changeRideStatus(
          body: {"ride_id": rideId, "ride_status": RideStatus.completed});
      if (response.status == 200) {
        Get.back();
        await _onPaymentConfirmed();
      } else {
        driverState.value = previousState;
      }
    } on HttpException catch (e) {
      // The backend refusing COD -> COD means the ride is already completed
      // server-side (online-payment push, or a double tap on Confirm) — for
      // the driver that is the same outcome as success.
      if (e.message.contains('Invalid status transition from COD to COD')) {
        if (Get.isDialogOpen ?? false) Get.back();
        await _onPaymentConfirmed();
      } else {
        ApiLog.error('confirmedPayment failed', e);
        driverState.value = previousState;
      }
    } catch (e, s) {
      ApiLog.error('confirmedPayment failed', e, s);
      driverState.value = previousState;
    }
  }

  Future<void> _onPaymentConfirmed() async {
    driverState.value = DriverState.completed;
    driverState.value = DriverState.idle;

    // Update background service back to idle state
    if (locationTrackingService != null) {
      await locationTrackingService!.updateDriverState(
        driverState.value.toString(),
        passengerId: passengerId,
      );
    }

    fetchWalletBalance();
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
        if (locationTrackingService != null) {
          await locationTrackingService!.updateDriverState(
            driverState.value.toString(),
            passengerId: passengerId,
          );
        }

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
      _rideSoundToken++;
      player.stop();
      rideIsActive = false;
      box.remove(BoxKeys.rideId);
      if (Get.isBottomSheetOpen ?? false) {
        Get.back();
      }
      ChangeRideStatusModel response = await ApiServices.changeRideStatus(body: {
        "ride_id": rideId,
        "ride_status": RideStatus.cancelled,
      });

      if (response.status == 200) {
        driverState.value = DriverState.idle;

        // Update background service back to idle
        if (locationTrackingService != null) {
          await locationTrackingService!.updateDriverState(
            driverState.value.toString(),
            passengerId: passengerId,
          );
        }

        if (driverState.value == DriverState.idle) {
          startLocationLongMarker = 0.0;
          startLocationLatMarker = 0.0;
          recenter();
        }

        Get.defaultDialog(middleText: "This order has expired or transferred to another driver");
      }
    } finally {
      driverState.value = DriverState.idle;
      if (Get.isBottomSheetOpen ?? false) {
        Get.back();
      }
    }
  }

  Future<void> updateAuthToken(String newToken) async {
    try {
      if (locationTrackingService != null) {
        await locationTrackingService!.updateAuthToken(newToken);
        log('✅ Auth token updated in background service');
      }
    } catch (e) {
      log('❌ Failed to update auth token: $e');
    }
  }

  // Method to check if location service is running
  // Example for isLocationServiceRunning:
  Future<bool> isLocationServiceRunning() async {
    if (locationTrackingService != null) {
      // return await locationTrackingService!.getServiceStatus();
    }
    return false;
  }

// FIX 6: Enhanced setDriverOfflineOnTermination
  Future<void> setDriverOfflineOnTermination() async {
    try {
      // Only set offline if currently online
      if (isOnline.value) {
        // Create a completer for the API call
        final apiCompleter = Completer<void>();

        ApiServices.changeOnlineStatus(
          body: {"is_online": 0},
        ).then((response) {
          // Update local state
          isOnline.value = false;
          box.write(BoxKeys.isOnline, false);
          log('Driver set to offline due to app termination');

          if (!apiCompleter.isCompleted) {
            apiCompleter.complete();
          }
        }).catchError((e) {
          log('Error setting driver offline on termination: $e');
          // Still update local state even if API fails
          isOnline.value = false;
          box.write(BoxKeys.isOnline, false);

          if (!apiCompleter.isCompleted) {
            apiCompleter.complete();
          }
        });

        // Wait for API call with timeout
        await apiCompleter.future.timeout(
          const Duration(seconds: 2),
          onTimeout: () {
            log('Offline API call timed out');
            // Update local state anyway
            isOnline.value = false;
            box.write(BoxKeys.isOnline, false);
          },
        );
      }
    } catch (e) {
      log('Error setting driver offline on termination: $e');
      // Ensure local state is updated
      isOnline.value = false;
      box.write(BoxKeys.isOnline, false);
    }
  }

  // FIX 7: Add a method to gracefully handle service restart
  Future<void> restartLocationService() async {
    try {
      log('Restarting location service...');

      // Stop current service
      // await stopLocationTracking();

      // Wait a moment
      await Future.delayed(const Duration(milliseconds: 500));

      // Start fresh
      if (isOnline.value) {
        // await startLocationTracking();
        log('Location service restarted successfully');
      }
    } catch (e) {
      log('Error restarting location service: $e');
    }
  }

  void stopServiceHealthCheck() {
    _serviceHealthTimer?.cancel();
    _serviceHealthTimer = null;
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = math.cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * math.asin(math.sqrt(a));
  }

  // Future<void> getDriverOnlineStatus() async {
  //   try {
  //     GetOnlineStatusResponseModel response =
  //         await ApiServices.getOnlineStatus();
  //     if (response.status == 200) {
  //       isOnline.value = response.data?.isOnline ?? false;
  //     }
  //   } catch (error, s) {
  //     AppConstants.handleError(error, s: s);
  //     print('Error fetching driver online status: $error');
  //     isOnline.value = false;
  //   }
  // }

  Future<void> getDriverOnlineStatus() async {
    try {
      GetOnlineStatusResponseModel response = await ApiServices.getOnlineStatus();
      if (response.status == 200) {
        final serverIsOnline = response.data?.isOnline ?? false;
        isOnline.value = serverIsOnline;

        // Sync to both storage systems
        box.write(BoxKeys.isOnline, serverIsOnline);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_online', serverIsOnline);

        log('✅ Online status synced from server: $serverIsOnline');

        // If server says offline, stop the service
        if (!serverIsOnline) {
          final service = FlutterBackgroundService();
          final isRunning = await service.isRunning();

          if (isRunning) {
            log('🛑 Server says offline - stopping background service');
            service.invoke("stop_service");
          }
        }
      }
    } catch (error, s) {
      AppConstants.handleError(error, s: s);
      print('Error fetching driver online status: $error');
      isOnline.value = false;
    }
  }

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
      AppConstants.handleError(error, s: s);
    }
  }

  // Keep all your existing methods like getAndShowOrderDetails, getOrderDetails, etc.
  // ... (rest of your existing methods remain unchanged)

  Future<void> getAndShowOrderDetails({required String id, bool? fromBackGroundCall}) async {
    _playIncomingRideSound();
    GetRideDetailsResponseModel response =
        await ApiServices.rideOrderDetails(queryParameters: {"ride_id": id});
    getOrderDetails(response: response);
    showMyBottomSheet(IncomingOrderBottomSheet(data: response.data));
  }

  Future<void> _playIncomingRideSound() async {
    final token = ++_rideSoundToken;
    if (Platform.isIOS) {
      // CallFunctionality.listenCallEvents() ends the CallKit call ~1s after
      // accept, and iOS itself tears down the CallKit audio session around
      // that same moment. Starting playback any earlier means this sound
      // gets cut off mid-way (or never audibly starts) as CallKit's session
      // teardown steps on the shared AVAudioSession. Wait for that to settle
      // before grabbing the session for ourselves.
      await Future.delayed(const Duration(milliseconds: 1300));
      // The ride was accepted/timed out while we were waiting - don't play
      // a stale ring for a dialog that's no longer on screen.
      if (token != _rideSoundToken) return;
      // Force the `playback` category so this is audible even if the phone's
      // ring/silent switch is on.
      await player.setAudioContext(AudioContext(
        iOS: AudioContextIOS(
          category: AVAudioSessionCategory.playback,
          options: {
            AVAudioSessionOptions.mixWithOthers,
            AVAudioSessionOptions.duckOthers,
          },
        ),
      ));
    }
    player.play(AssetSource(AppAudio.notification));
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
    rideType = response.data?.rideType;
    updatePaymentType(response.data?.paymentType);

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
    if (locationTrackingService != null) {
      locationTrackingService!.updateDriverState(
        driverState.value.toString(),
        passengerId: passengerId,
      );
    }
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
    } catch (error, s) {
      isRefreshingWallet.value = false;
      Get.showSnackbar(GetSnackBar(
          duration: Duration(seconds: 2),
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.zero,
          messageText: AppSnackBar(text: error.toString())));
    }
  }

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
      ChangeRideStatusModel response = await ApiServices.changeRideStatus(body: {
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
        if (locationTrackingService != null) {
          await locationTrackingService!.updateDriverState(
            driverState.value.toString(),
            passengerId: passengerId,
          );
        }
      }
    } finally {
      driverState.value = DriverState.reachedDestination;
    }
  }

  Future<String?> getLocationDetails(double latitude, double longitude) async {
    try {
      GoogleLocationResponse response = await ApiServices.getCurrentLocation(latitude, longitude);

      for (var result in response.results ?? []) {
        for (var addressComponent in result.addressComponents ?? []) {
          if ((addressComponent.types?.contains("sublocality") ?? false) ||
              (addressComponent.types?.contains("subpremise") ?? false)) {
            return addressComponent.shortName;
          }
        }
      }
    } catch (e) {
      // Reverse geocoding is only used for the pickup-location label; on a
      // network failure keep the previous label rather than crash.
      ApiLog.error('getLocationDetails failed', e);
    }

    return null;
  }

  Future<void> recenter() async {
    log("recenter() called ......");
    if (recenterLoading.value) return;
    recenterLoading.value = true;
    cameraZoom.value = 15.0;
    try {
      // On iOS, location.getLocation() can hang indefinitely while waiting
      // for a GPS fix (or throw if permission/services aren't ready). Guard
      // it with a timeout so the "Fetching current location" spinner always
      // stops.
      final newLoc = await loc.Location().getLocation().timeout(const Duration(seconds: 15));

      saveLocationData(newLoc);
      currentPosition.value = convertToPosition(newLoc);
      getLocationDetails(currentPosition.value?.latitude ?? 0.0, currentPosition.value?.longitude ?? 0.0)
          .then(
        (value) => pickUpLocation1?.name.value = value ?? '',
      );
      log("${pickUpLocation1?.name} && ${newLoc.latitude}, ${newLoc.longitude}");
      googleMapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          zoom: cameraZoom.value,
          target: LatLng(newLoc.latitude ?? 0.0, newLoc.longitude ?? 0.0),
        ),
      ));
    } catch (e) {
      // Timeout or platform error while fetching location. Swallow it so the
      // spinner is cleared by finally; the map just stays where it is.
      log("recenter() failed to fetch location: $e");
    } finally {
      recenterLoading.value = false;
    }
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
    recenter();
    getFinalDropLocation();
    log("mobilityContext?.stops");
    log("${mobilityContext?.stops}");
    if (currentPosition.value == null) {
      _loadCurrentPositionFromStorage();
    }
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
        log("paymentInitiatedpaymentInitiated$finalDropLocation,${currentPosition.value?.latitude}${currentPosition.value?.longitude}paymentInitiatedpaymentInitiated");
        await getRidePayment();
        resetDistance();

        // Update background service
        if (locationTrackingService != null) {
          await locationTrackingService!.updateDriverState(
            driverState.value.toString(),
            passengerId: passengerId,
          );
        }
        recenter();
      }
    } catch (error, s) {
      AppConstants.handleError(error, s: s);
    } finally {
      driverState.value = DriverState.paymentInitiated;
    }
  }

  Future<void> getRidePayment() async {
    RidePaymentResponseModel response =
        await ApiServices.getRidePayment(queryParameter: {"ride_id": rideId});
    if (response.status == 200) {
      fare = response.data?.fare;
      tax = response.data?.tax;
      total = response.data?.total;
      updatePaymentType(response.data?.paymentType);
      waiverCharge = response.data?.waiverCharge;
      driverState.value = DriverState.completed;
      if (locationTrackingService != null) {
        await locationTrackingService!.updateDriverState(
          driverState.value.toString(),
          passengerId: null,
        );
      }
      Get.back();
    }
  }

  Future<void> completeRide() async {
    ChangeRideStatusModel response = await ApiServices.changeRideStatus(
        body: {"ride_id": rideId, "ride_status": RideStatus.completed});
    if (response.status == 200) {
      driverState.value = DriverState.idle;

      // Update background service back to idle
      if (locationTrackingService != null) {
        await locationTrackingService!.updateDriverState(
          driverState.value.toString(),
          passengerId: null,
        );
      }
    }
  }

  Future<void> getFinalDropLocation() async {
    finalDropLocation = (await getLocationDetails(
            currentPosition.value?.latitude ?? 0.0, currentPosition.value?.longitude ?? 0.0)) ??
        "";
  }

  Future<void> openMap({required double? latitude, required double? longitude}) async {
    if (Platform.isIOS) {
      var googleMapsUri =
          Uri.parse("comgooglemaps://?daddr=$latitude,$longitude&directionsmode=driving");
      if (await canLaunch(googleMapsUri.toString())) {
        await launch(googleMapsUri.toString());
        return;
      }
      var appleMapsUri = Uri.parse("https://maps.apple.com/?daddr=$latitude,$longitude&dirflg=d");
      if (await canLaunch(appleMapsUri.toString())) {
        await launch(appleMapsUri.toString());
        return;
      }
      throw 'Could not launch maps';
    }

    var uri = Uri.parse("google.navigation:q=$latitude,$longitude&mode=d");
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not launch ${uri.toString()}';
    }
  }

  Future<void> openRoundTripMap({
    required double? startLatitude,
    required double? startLongitude,
    required double? destinationLatitude,
    required double? destinationLongitude,
  }) async {
    log("round trip@@@@@@@@@@@@$rideType");

    if (Platform.isIOS) {
      var googleMapsUri = Uri.parse("comgooglemaps://?daddr=$destinationLatitude,$destinationLongitude"
          "&waypoints=$startLatitude,$startLongitude"
          "&directionsmode=driving");
      if (await canLaunch(googleMapsUri.toString())) {
        await launch(googleMapsUri.toString());
        return;
      }
      var appleMapsUri =
          Uri.parse("https://maps.apple.com/?daddr=$destinationLatitude,$destinationLongitude"
              "&saddr=$startLatitude,$startLongitude&dirflg=d");
      if (await canLaunch(appleMapsUri.toString())) {
        await launch(appleMapsUri.toString());
        return;
      }
      throw 'Could not launch maps';
    }

    // Create a round trip by adding the starting point as the final waypoint
    var uri = Uri.parse("google.navigation:q=$destinationLatitude,$destinationLongitude"
        "&waypoints=$startLatitude,$startLongitude"
        "&mode=d");

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

  // Initialize location tracking service only when needed
  Future<void> _initializeLocationTrackingIfNeeded() async {
    try {
      // Only initialize if user is online or has been online before
      final prefs = await SharedPreferences.getInstance();
      final savedOnlineStatus = box.read(BoxKeys.isOnline) ?? false;
      final token = box.read(BoxKeys.token);
      await prefs.setString('auth_token', token);

      if (savedOnlineStatus || isOnline.value) {
        locationTrackingService = Get.put(LocationTrackingService());
        log('LocationTrackingService initialized');
        // ---------------- DRIVER GOING ONLINE ----------------
        await requestBatteryOptimizationExemption();

        // Ensure service exists
        locationTrackingService ??= Get.put(LocationTrackingService());

        // Tell service to start
        log("locationTrackingService!.updateOnlineStatus(true)CALLED isOnline*************");
        await locationTrackingService!.updateOnlineStatus(true);

        final service = FlutterBackgroundService();
        final isRunning = await service.isRunning();

        if (!isRunning) {
          await service.startService();
          log('📡 Background service started from _initializeLocationTrackingIfNeeded');
        } else {
          log('⚡ Service already running');
        }

        log('✅ Driver went online');
        // }
      }
    } catch (e) {
      log('Error initializing location tracking service: $e');
    }
  }

  void _showBatteryOptimizationDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Battery Optimization'),
        content: Text(
            'For reliable location tracking, please disable battery optimization for this app in your device settings.'),
        actions: [
          BlueButton(
            onTap: () => Get.back(),
            text: "OK",
          ),
        ],
      ),
    );
  }

  void _handleRideError() {
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
  }

  Future<void> _handleAppTermination() async {
    try {
      log("🧹 Handling app termination cleanup...");

      // 1️⃣ Mark driver offline via API
      await ApiServices.changeOnlineStatus(body: {"is_online": 0});
      log("📴 Driver marked offline due to app termination");

      // 2️⃣ Stop background service and WebSocket
      final service = FlutterBackgroundService();
      final isRunning = await service.isRunning();
      if (isRunning) {
        service.invoke("stop_service"); // triggers disposal in background
        log("🛑 Background service stopped on termination");
      }

      // 3️⃣ Update local state
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_online', false);
      box.write(BoxKeys.isOnline, false);
      isOnline.value = false;
    } catch (e) {
      log("❌ Error during termination cleanup: $e");
    }
  }

// FIX 3: Enhanced app termination handler
  // Future<void> _handleAppTermination() async {
  //   try {
  //     // Use a completer with timeout to prevent hanging
  //     final completer = Completer<void>();

  //     // Start cleanup
  //     _performCleanup().then((_) {
  //       if (!completer.isCompleted) {
  //         completer.complete();
  //       }
  //     }).catchError((e) {
  //       log('Error during cleanup: $e');
  //       if (!completer.isCompleted) {
  //         completer.complete(); // Complete even on error
  //       }
  //     });

  //     // Wait for cleanup with timeout
  //     await completer.future.timeout(
  //       const Duration(seconds: 3),
  //       onTimeout: () {
  //         log('Cleanup timed out - app will terminate anyway');
  //       },
  //     );

  //     log('App termination cleanup completed');
  //   } catch (e) {
  //     log('Error during app termination cleanup: $e');
  //   }
  // }

  Future<void> _performCleanup() async {
    // Stop location tracking with timeout
    if (locationTrackingService != null) {
      // await stopLocationTracking().timeout(
      //   const Duration(seconds: 2),
      //   onTimeout: () => log('Location tracking stop timed out'),
      // );
    }

    // Set driver offline if needed
    if (isOnline.value) {
      await setDriverOfflineOnTermination().timeout(
        const Duration(seconds: 2),
        onTimeout: () => log('Setting offline timed out'),
      );
    }
  }

  Future<void> _initializeHive() async {
    distanceBox = await Hive.openBox('distanceBox');
    totalDistance = distanceBox?.get('totalDistance', defaultValue: 0.0) ?? 0.0;
  }

// NEW METHOD: Check and stop service if offline
  Future<void> _checkAndStopServiceIfOffline() async {
    try {
      final savedOnlineStatus = box.read(BoxKeys.isOnline) ?? false;
      final prefs = await SharedPreferences.getInstance();
      final prefsOnlineStatus = prefs.getBool('is_online') ?? false;

      log('📊 Checking online status on app restart:');
      log('GetStorage isOnline: $savedOnlineStatus');
      log('SharedPreferences isOnline: $prefsOnlineStatus');

      // If driver is offline in either storage, stop the service
      if (!savedOnlineStatus || !prefsOnlineStatus) {
        final service = FlutterBackgroundService();
        final isRunning = await service.isRunning();

        if (isRunning) {
          log('🛑 Driver is offline but service is running - stopping service');
          service.invoke("stop_service");
          await Future.delayed(const Duration(milliseconds: 500));

          // Ensure both storage systems are synced to offline
          await prefs.setBool('is_online', false);
          box.write(BoxKeys.isOnline, false);
          isOnline.value = false;

          log('✅ Background service stopped due to offline status');
        } else {
          log('✅ Service is not running and driver is offline - all good');
        }
      } else {
        log('✅ Driver is online - service will be initialized if needed');
      }
    } catch (e) {
      log('❌ Error checking and stopping service: $e');
    }
  }

  Future<void> _syncTokenToSharedPreferences() async {
    try {
      final token = box.read(BoxKeys.token);

      if (token == null || token.isEmpty) {
        log('⚠️ No token found in GetStorage - user might be logged out');
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final existingToken = prefs.getString('auth_token');

      // Always sync the token from GetStorage to SharedPreferences
      if (existingToken != token) {
        await prefs.setString('auth_token', token);
        log('✅ Token synced from GetStorage to SharedPreferences');
      } else {
        log('✅ Token already synced in both storage systems');
      }

      // Also sync other important data
      final isOnline = box.read(BoxKeys.isOnline) ?? false;
      await prefs.setBool('is_online', isOnline);

      log('📦 GetStorage token: $token');
      log('💾 SharedPreferences token: ${prefs.getString("auth_token")}');
    } catch (e) {
      log('❌ Error syncing token: $e');
    }
  }

  Future<void> checkForUpdate() async {
    log("Check upatte####################");
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      minimumFetchInterval: Duration.zero,
      fetchTimeout: Duration(seconds: 10),
    ));
    await remoteConfig.fetchAndActivate();
    bool isForceUpdate = false;
    isForceUpdate = FirebaseRemoteConfig.instance.getBool("force_update");
    log("Check update $isForceUpdate####################");
    await sm.AppUpdateManager.checkAndPrompt(
      forceUpdate: isForceUpdate,
      repeat_totalminutes: isForceUpdate ? 0 : 60,
    );
  }

  void _loadCurrentPositionFromStorage() {
    // final box = GetStorage();
    final lat = box.read("last_latBG");
    final lng = box.read("last_lngGB");

    if (lat != null && lng != null) {
      currentPosition.value = Position(
        latitude: lat,
        longitude: lng,
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        altitudeAccuracy: 0.0,
        headingAccuracy: 0.0,
      );
      log("✅ currentPosition updated from storage: $currentPosition");
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
}
