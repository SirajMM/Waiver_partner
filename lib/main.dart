import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:workmanager/workmanager.dart';
import '../../backend/api/api_services/api_services.dart';
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
import 'package:waiver_driver/controller/home/home_controller.dart';
import 'package:waiver_driver/core/themes/app_theme.dart';
import 'package:waiver_driver/core/themes/assets/audio.dart';
import 'package:waiver_driver/firebase_options.dart';
import 'package:waiver_driver/helper/init/init.dart';

import 'package:waiver_driver/helper/router/app_routes/route.dart';
import 'package:uuid/uuid.dart';
import 'backend/model/home/home_model.dart';
import 'backend/model/setting/setting_model.dart';
import 'backend/notificaton_services/notification_service/notification_service.dart';
import 'core/callbackdispatcher/callback.dart';

@pragma('vm:entry-point')
ReceivePort? _receivePort;
@pragma('vm:entry-point')
void startReceivePort() {
  IsolateNameServer.removePortNameMapping('main_send_port');
  _receivePort ??= ReceivePort();
  IsolateNameServer.registerPortWithName(
      _receivePort!.sendPort, 'main_send_port');

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

  print("Background handler triggered!");
  print("Message data: ${message.data}");

  // await MainBinding().dependencies();
  // await NotificationService.onInit();
  CallFunctionality.onInit();

  OrderDetailsModel data = OrderDetailsModel.fromJson(message.data);

  // Use a single player instance to avoid multiple instances
  final AudioPlayer player = AudioPlayer();

  if (data.rideStatus == "RED") {
    await player.play(AssetSource(AppAudio.notification));
  }

  // await NotificationService.showNotification(data: data);

  final CallFunctionality callFunctionality = CallFunctionality();
  callFunctionality.listenCallEvents();
  callFunctionality.showCallkitIncoming(const Uuid().v4(), message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestPermissions();
  await GetStorage.init();
  await Hive.initFlutter();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  await MainBinding().dependencies();
  // final appLifecycleObserver = AppLifecycleObserver();
  // WidgetsBinding.instance.addObserver(appLifecycleObserver);

  // // Check for previous unexpected termination
  // final prefs = GetStorage();
  // final appClosed = prefs.read<bool>('app_properly_closed') ?? true;
  // if (!appClosed) {
  //   // App was terminated unexpectedly
  //   appLifecycleObserver.changeDriverOnlineStatus();
  // }
  // await prefs.write('app_properly_closed', false);
  // Initialize Firebase before setting up message handlers
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Register background handler before other Firebase setup
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize notification service
  await NotificationService.onInit();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Set up foreground message handlers
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

// class AppLifecycleObserver extends WidgetsBindingObserver {
//   bool isOnline = false;
//   DateTime _lastActiveTime = DateTime.now();

//   AppLifecycleObserver() {
//     // Check if the app was terminated unexpectedly in the previous session
//     _checkLastSession();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       // App is in the foreground
//       _lastActiveTime = DateTime.now();
//       _updateLastActiveTime();
//     } else if (state == AppLifecycleState.paused) {
//       // App is in the background but might resume
//       _updateLastActiveTime();
//       // changeDriverOnlineStatus();
//     } else if (state == AppLifecycleState.detached) {
//       // App is being detached or becoming inactive - try to mark status as offline
//       _updateLastActiveTime();
//       changeDriverOnlineStatus();
//       _markProperlyClosedIfPossible();
//     }
//   }

//   Future<void> _updateLastActiveTime() async {
//     try {
//       final prefs = GetStorage();
//       await prefs.write('last_active_time', _lastActiveTime.toIso8601String());
//     } catch (e) {
//       print('Failed to update last active time: $e');
//     }
//   }

//   Future<void> _markProperlyClosedIfPossible() async {
//     try {
//       final prefs = GetStorage();
//       await prefs.write('app_properly_closed', true);
//     } catch (e) {
//       print('Failed to mark app as properly closed: $e');
//     }
//   }

//   Future<void> _checkLastSession() async {
//     await MainBinding().dependencies();
//     final prefs = GetStorage();
//     final lastActiveTime = prefs.read<String>('last_active_time');
//     final appClosed = prefs.read<bool>('app_properly_closed') ?? true;

//     if (lastActiveTime != null && !appClosed) {
//       await MainBinding().dependencies();
//       // App was terminated unexpectedly in the last session
//       // Call the API to ensure driver is marked offline

//       // await changeDriverOnlineStatus();
//     }

//     // Reset for this session
//     await prefs.write('app_properly_closed', false);
//   }

//   changeDriverOnlineStatus() async {
//     await MainBinding().dependencies();
//     // log(HomeController.to.isOnline.value.toString());
//     HomeController.to.changeDriverOnlineStatus();

//     log("####################################changeDriverOnlineStatus called#################################");
//     // try {
//     //   // Call the API to change the online status
//     //   LogoutResponseModel response = await ApiServices.changeOnlineStatus(
//     //     body: {
//     //       "is_online": 1,
//     //     },
//     //   );

//     //   // If the API call is successful
//     //   if (response.status == 200) {
//     //     isOnline = !isOnline;

//     //     // Additional: Also save the status locally
//     //     final prefs = GetStorage();
//     //     await prefs.write('driver_online_status', false);

//     //     // Disable background execution if it's enabled
//     //     if (FlutterBackground.isBackgroundExecutionEnabled) {
//     //       await FlutterBackground.disableBackgroundExecution();
//     //     }
//     //   } else {
//     //     print("Failed to update online status: ${response.message}");
//     //   }
//     // } catch (e) {
//     //   print("Error in changeDriverOnlineStatus: $e");
//     // }
//   }
// }
