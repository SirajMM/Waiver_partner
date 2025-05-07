import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';



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

@pragma('vm:entry-point')
ReceivePort? _receivePort;
@pragma('vm:entry-point')
void startReceivePort() {
  IsolateNameServer.removePortNameMapping('main_send_port');
  _receivePort ??= ReceivePort();
  IsolateNameServer.registerPortWithName(_receivePort!.sendPort, 'main_send_port');

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
          HomeController.to.orderTimeOut();
        }
      } catch (e) {
        log('Error processing message: $e');
      }
    }
  });
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
  if (data.rideStatus == "RED"|| data.rideStatus == "FRED") {
    CallFunctionality.onInit();
    // await player.play(AssetSource(AppAudio.notification));
  }




  // Use a single player instance to avoid multiple instances



  // await NotificationService.showNotification(data: data);

  final CallFunctionality callFunctionality = CallFunctionality();
  callFunctionality.listenCallEvents();
  callFunctionality.showCallkitIncoming(const Uuid().v4(), message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Hive.initFlutter();

  await MainBinding().dependencies();

  await Firebase.initializeApp(name: 'partner', options: DefaultFirebaseOptions.currentPlatform);

  await requestPermissions();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await NotificationService.onInit();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  FirebaseMessaging.onMessage.listen((message) => NotificationService.onMessage(notification: message));

  FirebaseMessaging.onMessageOpenedApp
      .listen((message) => NotificationService.onMessageOpenedApp(notification: message));
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
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
