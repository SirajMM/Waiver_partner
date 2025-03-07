import 'dart:io';

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

import 'package:flutter_background/flutter_background.dart'
    as flutter_background;
import 'package:geolocator_android/geolocator_android.dart'
    as geolocator_android;

import 'package:upgrader/upgrader.dart';
import 'package:waiver_driver/backend/call_funtionality.dart';
import 'package:waiver_driver/core/themes/app_theme.dart';
import 'package:waiver_driver/core/themes/assets/audio.dart';
import 'package:waiver_driver/firebase_options.dart';
import 'package:waiver_driver/helper/init/init.dart';
import 'package:waiver_driver/helper/router/app_pages/app_pages.dart';
import 'package:waiver_driver/helper/router/app_routes/app_routes.dart';
import 'package:waiver_driver/helper/router/app_routes/route.dart';
import 'package:uuid/uuid.dart';
import 'backend/model/home/home_model.dart';
import 'backend/notificaton_services/notification_service/notification_service.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await MainBinding().dependencies();
    NotificationService.onInit();
  OrderDetailsModel data = OrderDetailsModel.fromJson(message.data);
  final player = AudioPlayer();
  if (data.rideStatus == "RED") {
    player.play(AssetSource(AppAudio.notification));
  }
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  NotificationService.showNotification(notification: message);
  // CallFunctionality().listenCallEvents();
  // CallFunctionality().showCallkitIncoming(const Uuid().v4(), message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestPermissions();
  await GetStorage.init();
  await Hive.initFlutter();

  NotificationService.onInit();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await Firebase.initializeApp();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  FirebaseMessaging.onMessage.listen(
      (message) => NotificationService.onMessage(notification: message));

  FirebaseMessaging.onMessageOpenedApp.listen((message) =>
      NotificationService.onMessageOpenedApp(notification: message));

  await MainBinding().dependencies();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
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

requestPermissions() async {
  const androidConfig = flutter_background.FlutterBackgroundAndroidConfig(
    notificationTitle: "Waiver Partner",
    notificationText:
        "Background notification for keeping the waiver partner app running in the background",
    notificationImportance:
        flutter_background.AndroidNotificationImportance.max,
    notificationIcon: flutter_background.AndroidResource(
      name: 'launcher_icon', // Use the same name as in @mipmap/launcher_icon
      defType:
          'mipmap', // Specify 'mipmap' because the icon is in the mipmap folder
    ), // Default is ic_launcher from folder mipmap
  );
  await flutter_background.FlutterBackground.initialize(
      androidConfig: androidConfig);
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
