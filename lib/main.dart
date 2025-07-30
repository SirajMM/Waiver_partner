import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:waiver_driver/backend/call_funtionality.dart';
import 'package:waiver_driver/controller/home/home_controller.dart';
import 'package:waiver_driver/core/themes/app_theme.dart';
import 'package:waiver_driver/firebase_options.dart';
import 'package:waiver_driver/helper/init/init.dart';

import 'package:waiver_driver/helper/router/app_routes/route.dart';
import 'package:uuid/uuid.dart';
import 'backend/model/home/home_model.dart';
import 'backend/notificaton_services/notification_service/notification_service.dart';
import 'core/constants/enums/enums.dart';

@pragma('vm:entry-point')
ReceivePort? _receivePort;
@pragma('vm:entry-point')
void startReceivePort() {
  IsolateNameServer.removePortNameMapping('main_send_port');
  _receivePort ??= ReceivePort();
  IsolateNameServer.registerPortWithName(
      _receivePort!.sendPort, 'main_send_port');


  _startContinuousLocationSending();
  _receivePort!.listen((message) async {
    if (message is Map<String, dynamic>) {
      log('Received message: $message');

      try {
        if (message['title'] == 'accepted') {
          CallFunctionality().onCallAccepted(
            message['callId'],
            message['rideId'],
            message['rideStatus'],
            message['paymentType'],
          );
        } else if (message['title'] == 'cancelled') {
          HomeController.to.rideId = message['rideId'];
          HomeController.to.orderTimeOut;
        }
      } catch (e) {
        log('Error processing message: $e');
      }
    }
  });
}

// Start continuous location sending


void _startContinuousLocationSending() {
  // Call immediately
  _sendLocationNow();

  // Then call every 30 seconds (adjust interval as needed)
  _locationTimer = Timer.periodic(Duration(seconds: 10), (timer) {
    _sendLocationNow();
  });
}

void _sendLocationNow() {
  try {
    HomeController.to.sendLiveLocation();
    log('Live location sent at: ${DateTime.now()}');
  } catch (e) {
    log('Error calling sendLiveLocation: $e');
  }
}






Timer? _locationTimer;

void _startLocationTracking() {
  _stopLocationTracking(); // Stop any existing timer
  // Send location every 30 seconds (adjust as needed)
  _locationTimer = Timer.periodic(Duration(seconds: 10), (timer) {
    try {
      HomeController.to.sendLiveLocation();
    } catch (e) {
      log('Error sending live location: $e');
    }
  });
}

void _stopLocationTracking() {
  _locationTimer?.cancel();
  _locationTimer = null;
}

// Function to send message from background isolate to main isolate
@pragma('vm:entry-point')
void sendLocationUpdateFromBackground() {
  final SendPort? sendPort = IsolateNameServer.lookupPortByName('main_send_port');
  if (sendPort != null) {
    sendPort.send({
      'title': 'send_live_location',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  } else {
    log('SendPort not found for location update');
  }
}

// Function to start location tracking from background
@pragma('vm:entry-point')
void startLocationTrackingFromBackground() {
  final SendPort? sendPort = IsolateNameServer.lookupPortByName('main_send_port');
  if (sendPort != null) {
    sendPort.send({
      'title': 'start_location_tracking',
      'interval': 30, // seconds
    });
  }
}

// Function to stop location tracking from background
@pragma('vm:entry-point')
void stopLocationTrackingFromBackground() {
  final SendPort? sendPort = IsolateNameServer.lookupPortByName('main_send_port');
  if (sendPort != null) {
    sendPort.send({
      'title': 'stop_location_tracking',
    });
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  log("Background handler triggered!");
  log("Message data: ${message.data}");
  OrderDetailsModel data = OrderDetailsModel.fromJson(message.data);
  // await MainBinding().dependencies();
  // await NotificationService.onInit();
  if (data.rideStatus == "RED" || data.rideStatus == "FRED") {
    CallFunctionality.onInit();
    final CallFunctionality callFunctionality = CallFunctionality();
    callFunctionality.listenCallEvents();
    callFunctionality.showCallkitIncoming(const Uuid().v4(), message);
    // await player.play(AssetSource(AppAudio.notification));
  } else {
    await NotificationService.showNotification(data: data);
    switch (data.rideStatus) {
      // case "RED" || "FRED":
      //   await HomeController.to.getAndShowOrderDetails(id: data.rideId ?? "");
      //   break;

      case "CAD":
      case "FCAD":
        final player = AudioPlayer();
        player.stop();
        HomeController.to.resetDistance();
        HomeController.to.isTracking = false;
        HomeController.to.rideIsActive = false;
        HomeController.to.driverState.value = DriverState.idle;
        // Get.bottomSheet(OrderCompletedBottomSheet());
        break;

      case "PID":
        HomeController.to.isTracking = false;
        HomeController.to.rideIsActive = true;
        HomeController.to.driverState.value = DriverState.paymentInitiated;
        break;

      case "COD":
        HomeController.to.isTracking = false;
        HomeController.to.rideIsActive = true;
        await HomeController.to.getRidePayment();
        HomeController.to.driverState.value = DriverState.completed;
        break;

      default:
        HomeController.to.driverState.value = DriverState.idle;
        break;
    }
  }

  // Use a single player instance to avoid multiple instances

  // await NotificationService.showNotification(data: data);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Hive.initFlutter();

  await MainBinding().dependencies();

  await Firebase.initializeApp(
      name: 'partner', options: DefaultFirebaseOptions.currentPlatform);

  await requestPermissions();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await NotificationService.onInit();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  FirebaseMessaging.onMessage.listen(
      (message) => NotificationService.onMessage(notification: message));

  FirebaseMessaging.onMessageOpenedApp.listen((message) =>
      NotificationService.onMessageOpenedApp(notification: message));
  startReceivePort();
  // Initialize dependencies
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) {
          return GetMaterialApp(
            title: 'Waiver Driver',
            theme: AppTheme.lightTheme,
            themeMode: ThemeMode.light,
            // darkTheme: AppTheme.darkTheme,
            debugShowCheckedModeBanner: false,
            // initialRoute: AppRoutes.splash,
            // getPages: AppPages.appPages,
            initialRoute: AppRoutes1.splash,
            getPages: AppRoutes1.appPages1,
          );
        });
  }
}

Future<void> requestPermissions() async {
  // const androidConfig = flutter_background.FlutterBackgroundAndroidConfig(
  //   notificationTitle: "Waiver Partner",
  //   notificationText:
  //       "Background notification for keeping the waiver partner app running in the background",
  //   notificationImportance:
  //       flutter_background.AndroidNotificationImportance.max,
  //   notificationIcon: flutter_background.AndroidResource(
  //     name: 'launcher_icon', // Use the same name as in @mipmap/launcher_icon
  //     defType:
  //         'mipmap', // Specify 'mipmap' because the icon is in the mipmap folder
  //   ), // Default is ic_launcher from folder mipmap
  // );
  // await flutter_background.FlutterBackground.initialize(
  //     androidConfig: androidConfig);
  // Check and request notification permission first
  bool isNotificationDenied = await Permission.notification.isDenied;
  if (isNotificationDenied) {
    await Permission.notification.request();
  }
  LocationPermission locationPermission = await Geolocator.checkPermission();
  if (locationPermission == LocationPermission.denied) {
    locationPermission = await Geolocator.requestPermission();
  }
  if (locationPermission == LocationPermission.deniedForever) {
    await Geolocator.requestPermission();
  }
}

final box = GetStorage();

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
