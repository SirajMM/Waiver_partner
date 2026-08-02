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

import 'backend/LocationHandler/LocationTrackingService.dart';
import 'backend/facebook_sdk_service/facebook_sdk_services.dart';
import 'backend/model/home/home_model.dart';
import 'backend/notificaton_services/notification_service/notification_service.dart';
import 'core/constants/enums/enums.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

final box = GetStorage();
Timer? _locationTimer;
ReceivePort? _receivePort;

/// Completes when the post-first-frame initialization (remote config,
/// permission requests, services) has finished, so the splash flow can wait
/// for permissions to settle before deciding where to route.
final Completer<void> _startupInitCompleter = Completer<void>();
Future<void> get startupInitDone => _startupInitCompleter.future;

/// ------------------- ReceivePort -------------------
@pragma('vm:entry-point')
void startReceivePort() {
  IsolateNameServer.removePortNameMapping('main_send_port');

  _receivePort ??= ReceivePort();
  IsolateNameServer.registerPortWithName(_receivePort!.sendPort, 'main_send_port');

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
  _locationTimer = Timer.periodic(Duration(seconds: interval), (_) => _sendLocationNow());
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
  sendPort?.send({'title': 'send_live_location', 'timestamp': DateTime.now().millisecondsSinceEpoch});
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

  final data = OrderDetailsModel.fromJson(message.data);

  if (data.rideStatus == "RED" || data.rideStatus == "FRED") {
    CallFunctionality.onInit();
    CallFunctionality().listenCallEvents();
    CallFunctionality().showCallkitIncoming(const Uuid().v4(), message);
  } else {
    // No local notification here: when the app is backgrounded, iOS/Android
    // already auto-display the FCM payload's own `notification` block as a
    // system banner. Building another one via awesome_notifications produced
    // a duplicate banner. `NotificationService.showNotification` is still
    // used in the foreground path (`onMessage`), where nothing is
    // auto-displayed and the app must build the banner itself.
    if (Get.isRegistered<HomeController>()) {
      HomeController.to.updatePaymentType(data.paymentType);
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  await Hive.initFlutter();

  await Firebase.initializeApp(name: 'partner', options: DefaultFirebaseOptions.currentPlatform);

  await MainBinding().dependencies();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  startReceivePort();

  HttpOverrides.global = MyHttpOverrides();

  runApp(const MyApp());

  WidgetsBinding.instance.addPostFrameCallback((_) {
    _initializeDeferredServices();
  });
}

/// Runs after the first frame: the splash screen is already visible, so
/// permission dialogs appear over it and a slow/failed network fetch can no
/// longer block or kill startup.
Future<void> _initializeDeferredServices() async {
  try {
    await _fetchRemoteConfig();

    await _requestNotificationPermissions();

    await _createNotificationChannels();

    await _configureBackgroundService();

    await requestPermissions();

    try {
      await NotificationService.onInit();
    } catch (e) {
      log('❌ Error initializing NotificationService: $e');
    }

    FirebaseMessaging.onMessage.listen((msg) => NotificationService.onMessage(notification: msg));
    FirebaseMessaging.onMessageOpenedApp
        .listen((msg) => NotificationService.onMessageOpenedApp(notification: msg));

    try {
      await CallFunctionality.onInit();
      CallFunctionality().listenCallEvents();
    } catch (e) {
      log('❌ Error initializing call functionality: $e');
    }

    try {
      await FacebookAnalyticsService.initialize();
      await FacebookAnalyticsService.logAppLaunch();
    } catch (e) {
      log('❌ Error initializing Facebook analytics: $e');
    }
  } finally {
    if (!_startupInitCompleter.isCompleted) {
      _startupInitCompleter.complete();
    }
  }
}

Future<void> _fetchRemoteConfig() async {
  try {
    final remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      minimumFetchInterval: Duration.zero,
      fetchTimeout: Duration(seconds: 10),
    ));

    await remoteConfig.fetchAndActivate();
    log('✅ Remote config fetched and activated');
  } catch (e) {
    log('❌ Error fetching remote config: $e');
  }
}

/// ------------------- Request Notification Permissions -------------------
Future<void> _requestNotificationPermissions() async {
  try {
    if (Platform.isAndroid) {
      // Exactly one plugin may request POST_NOTIFICATIONS: firing both
      // awesome_notifications and permission_handler trips Android's
      // "Can request only one set of permissions at a time" limit and the
      // dropped request comes back denied before the user can answer.
      final status = await Permission.notification.request();
      log('Notification permission status: $status');

      // Request ignore battery optimization
      if (await Permission.ignoreBatteryOptimizations.isDenied) {
        await Permission.ignoreBatteryOptimizations.request();
      }
    }

    if (Platform.isIOS) {
      bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
      if (!isAllowed) {
        await AwesomeNotifications().requestPermissionToSendNotifications();
      }

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

/// ------------------- Notification Channels -------------------
Future<void> _createNotificationChannels() async {
  try {
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
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      log('✅ Flutter Local notification channel created');
    }
  } catch (e) {
    log('❌ Error creating notification channels: $e');
  }
}

/// ------------------- App Widget -------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, __) => GetMaterialApp(
        title: 'Waiver Partner',
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.system,
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

    if (Platform.isIOS && locationPermission == LocationPermission.whileInUse) {
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
    return super.createHttpClient(context)..badCertificateCallback = (cert, host, port) => true;
  }
}
