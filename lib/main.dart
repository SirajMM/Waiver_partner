import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:waiver_driver/backend/call_funtionality.dart';
import 'package:waiver_driver/controller/home/home_controller.dart';
import 'package:waiver_driver/core/themes/app_theme.dart';
import 'package:waiver_driver/firebase_options.dart';
import 'package:waiver_driver/helper/init/init.dart';
import 'package:waiver_driver/helper/router/app_routes/route.dart';
import 'package:uuid/uuid.dart';

import 'backend/LocationHandler/LocationTrackingService.dart'
    show LocationTrackingService, onStart, onIosBackground;
import 'backend/facebook_sdk_service/facebook_sdk_services.dart';
import 'backend/model/home/home_model.dart';
import 'backend/notificaton_services/notification_service/notification_service.dart';
import 'core/constants/enums/enums.dart';
import 'core/constants/get_storage_constants.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:smart_app_update_flutter/smart_app_update_flutter.dart' as sm;

final box = GetStorage();
Timer? _locationTimer;
ReceivePort? _receivePort;

/// ------------------- ReceivePort -------------------
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
        switch (message['title']) {
          case 'accepted':
            CallFunctionality().onCallAccepted(
              message['callId'],
              message['rideId'],
              message['rideStatus'],
              message['paymentType'],
            );
            break;
          case 'cancelled':
            if (Get.isRegistered<HomeController>()) {
              HomeController.to.rideId = message['rideId'];
              HomeController.to.orderTimeOut();
            }
            break;
          case 'send_live_location':
            _sendLocationNow();
            break;
          case 'start_location_tracking':
            _startLocationUpdates(interval: message['interval'] ?? 10);
            break;
          case 'stop_location_tracking':
            _stopLocationUpdates();
            break;
        }
      } catch (e) {
        log('Error processing message: $e');
      }
    }
  });
}

void _startLocationUpdates({int interval = 10}) {
  _locationTimer?.cancel();
  _locationTimer =
      Timer.periodic(Duration(seconds: interval), (_) => _sendLocationNow());
}

void _stopLocationUpdates() {
  _locationTimer?.cancel();
  _locationTimer = null;
}

void _sendLocationNow() {
  try {
    if (Get.isRegistered<HomeController>()) {
      // HomeController.to.sendLiveLocation(); // Uncomment if needed
    }
    log('Live location sent at: ${DateTime.now()}');
  } catch (e) {
    log('Error sending location: $e');
  }
}

/// ------------------- Background Location Functions -------------------
@pragma('vm:entry-point')
void sendLocationUpdateFromBackground() {
  final sendPort = IsolateNameServer.lookupPortByName('main_send_port');
  sendPort?.send({
    'title': 'send_live_location',
    'timestamp': DateTime.now().millisecondsSinceEpoch
  });
}

@pragma('vm:entry-point')
void startLocationTrackingFromBackground() {
  final sendPort = IsolateNameServer.lookupPortByName('main_send_port');
  sendPort?.send({'title': 'start_location_tracking', 'interval': 30});
}

@pragma('vm:entry-point')
void stopLocationTrackingFromBackground() {
  final sendPort = IsolateNameServer.lookupPortByName('main_send_port');
  sendPort?.send({'title': 'stop_location_tracking'});
}

/// ------------------- Firebase Background Handler -------------------
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize Awesome Notifications in background handler
  // ✅ Use consistent channel name
  // await AwesomeNotifications().initialize(
  //   'resource://drawable/ic_stat_applogo_removebg_preview',
  //   [
  //     NotificationChannel(
  //       channelGroupKey: 'basic_notification_channels',
  //       channelKey:
  //           'basic_notification_channel', // ← Use your preferred channel
  //       channelName: 'Waiver Driver notification channel',
  //       channelDescription: 'Notification channel for Waiver Driver man app',
  //       importance: NotificationImportance.Max,
  //       channelShowBadge: true,
  //       onlyAlertOnce: true,
  //       playSound: true,
  //       criticalAlerts: true,
  //     ),
  //   ],
  //   channelGroups: [
  //     NotificationChannelGroup(
  //       channelGroupKey: 'basic_notification_channels',
  //       channelGroupName: 'Waiver Driver notification channel',
  //     ),
  //   ],
  // );

  log("Background handler triggered!");
  log("Message data: ${message.data}");

  final data = OrderDetailsModel.fromJson(message.data);

  if (data.rideStatus == "RED" || data.rideStatus == "FRED") {
    CallFunctionality.onInit();
    CallFunctionality().listenCallEvents();
    CallFunctionality().showCallkitIncoming(const Uuid().v4(), message);
  } else {
    await NotificationService.showNotification(data: data);

    if (Get.isRegistered<HomeController>()) {
      switch (data.rideStatus) {
        case "CAD":
        case "FCAD":
          AudioPlayer().stop();
          HomeController.to
            ..resetDistance()
            ..isTracking = false
            ..rideIsActive = false
            ..driverState.value = DriverState.idle;
          break;
        case "PID":
          HomeController.to
            ..isTracking = false
            ..rideIsActive = true
            ..driverState.value = DriverState.paymentInitiated;
          break;
        case "COD":
          HomeController.to
            ..isTracking = false
            ..rideIsActive = true;
          await HomeController.to.getRidePayment();
          HomeController.to.driverState.value = DriverState.completed;
          break;
        default:
          HomeController.to.driverState.value = DriverState.idle;
      }
    }
  }
}

/// ------------------- Initialize Awesome Notifications -------------------
Future<void> _initializeAwesomeNotifications() async {
  // ✅ REMOVED: Initialization now handled in NotificationService.onInit()
  // This prevents duplicate channel creation
  log('✅ Awesome Notifications will be initialized by NotificationService');
}

/// ------------------- Main -------------------
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage first
  await GetStorage.init();
  await Hive.initFlutter();

  // Initialize Firebase
  await Firebase.initializeApp(
      name: 'partner', options: DefaultFirebaseOptions.currentPlatform);

  final remoteConfig = FirebaseRemoteConfig.instance;

  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    minimumFetchInterval: Duration.zero,
    fetchTimeout: Duration(seconds: 10),
  ));

  await remoteConfig.fetchAndActivate();
  // Initialize Awesome Notifications BEFORE any other services
  // ✅ REMOVED: Now handled by NotificationService.onInit() to avoid conflicts

  // Request notification permissions early
  await _requestNotificationPermissions();

  // Create notification channel for background service
  await _createNotificationChannels();

  // Configure Background Service
  await _configureBackgroundService();

  // Initialize Dependencies
  await MainBinding().dependencies();

  // Request other permissions
  await requestPermissions();

  // Notification Service
  await NotificationService.onInit();

  // Firebase Messaging Listeners
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage
      .listen((msg) => NotificationService.onMessage(notification: msg));
  FirebaseMessaging.onMessageOpenedApp.listen(
      (msg) => NotificationService.onMessageOpenedApp(notification: msg));

  // Orientation
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Start Receive Port
  startReceivePort();
  await FacebookAnalyticsService.initialize();
  await FacebookAnalyticsService.logAppLaunch();
  // HTTP Overrides
  HttpOverrides.global = MyHttpOverrides();

  // Initialize LocationTrackingService
  // await _initializeLocationServiceIfNeeded();

  // Run App
  runApp(const MyApp());
}

/// ------------------- Request Notification Permissions -------------------
Future<void> _requestNotificationPermissions() async {
  try {
    // Request permission for Awesome Notifications
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }

    // For Android 13+ (API level 33+), request POST_NOTIFICATIONS permission
    if (Platform.isAndroid) {
      final status = await Permission.notification.request();
      log('Notification permission status: $status');

      // Request ignore battery optimization
      if (await Permission.ignoreBatteryOptimizations.isDenied) {
        await Permission.ignoreBatteryOptimizations.request();
      }
    }

    // For iOS, request Firebase messaging permissions
    if (Platform.isIOS) {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
    }

    log('✅ Notification permissions requested');
  } catch (e) {
    log('❌ Error requesting notification permissions: $e');
  }
}

/// ------------------- Background Service Configuration -------------------
Future<void> _configureBackgroundService() async {
  try {
    log('Configuring background service...');
    await FlutterBackgroundService().configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: false,
        isForegroundMode: true,
        notificationChannelId: 'bg_service_channel',
        initialNotificationTitle: 'Waiver Driver',
        initialNotificationContent: 'Initializing location service...',
        foregroundServiceNotificationId: 888,
        autoStartOnBoot: false,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: onStart,
        // onBackground: onIosBackground,
      ),
    );
    log('✅ Background service configured successfully');
  } catch (e) {
    log('❌ Error configuring background service: $e');
  }
}

/// ------------------- Initialize Location Service -------------------
Future<void> _initializeLocationServiceIfNeeded() async {
  try {
    final wasOnline = box.read(BoxKeys.isOnline) ?? false;
    final hasToken = box.read(BoxKeys.token) != null;

    if (wasOnline && hasToken) {
      Get.put(LocationTrackingService());
      await FlutterBackgroundService().startService();
      log('✅ LocationTrackingService initialized & background service started');
    } else {
      log('Skipping LocationTrackingService initialization for new/offline user');
    }
  } catch (e) {
    log('❌ Error checking user status: $e');
  }
}

/// ------------------- Notification Channels -------------------
Future<void> _createNotificationChannels() async {
  if (Platform.isAndroid) {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'bg_service_channel',
      'Location Tracking Service',
      description: 'Background location tracking for rides',
      importance: Importance.low,
      enableVibration: false,
      playSound: false,
      showBadge: false,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    log('✅ Flutter Local notification channel created');
  }
}

/// ------------------- App Widget -------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => GetMaterialApp(
        title: 'Waiver Partner',
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes1.splash,
        getPages: AppRoutes1.appPages1,
      ),
    );
  }
}

/// ------------------- Permissions -------------------
Future<void> requestPermissions() async {
  try {
    var locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
    }

    // Request exact alarm permission for Android 12+
    if (Platform.isAndroid) {
      await Permission.scheduleExactAlarm.request();
    }

    log('✅ Location permissions processed');
  } catch (e) {
    log("❌ Error requesting permissions: $e");
  }
}

/// ------------------- HTTP Overrides -------------------
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}
