// main.dart

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

import 'backend/api/api_services/web_socket_services.dart';
import 'backend/model/home/home_model.dart';
import 'backend/notificaton_services/notification_service/notification_service.dart';
import 'backend/shared_pref.dart';
import 'core/constants/enums/enums.dart';

final box = GetStorage();
ReceivePort? _receivePort;
const String liveLocationTask = "sendLiveLocation";

@pragma('vm:entry-point')
void startReceivePort() {
  IsolateNameServer.removePortNameMapping('main_send_port');

  _receivePort ??= ReceivePort();
  IsolateNameServer.registerPortWithName(_receivePort!.sendPort, 'main_send_port');

  // _startLocationUpdates(); // Unified method

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
            HomeController.to.rideId = message['rideId'];
            HomeController.to.orderTimeOut;
            break;
        }
      } catch (e, s) {
        log('Error processing message: $e', stackTrace: s);
      }
    }
  });
}

@pragma('vm:entry-point')
void stopLocationTrackingFromBackground() {
  final sendPort = IsolateNameServer.lookupPortByName('main_send_port');
  sendPort?.send({'title': 'stop_location_tracking'});
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  log("Background handler triggered!");
  log("Message data: ${message.data}");

  final data = OrderDetailsModel.fromJson(message.data);

  if (data.rideStatus == "RED" || data.rideStatus == "FRED") {
    CallFunctionality.onInit();
    CallFunctionality().listenCallEvents();
    CallFunctionality().showCallkitIncoming(const Uuid().v4(), message);
  } else {
    await NotificationService.showNotification(data: data);

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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Hive.initFlutter();
  await Firebase.initializeApp(name: 'partner', options: DefaultFirebaseOptions.currentPlatform);
  MainBinding mainBinding = MainBinding();
  mainBinding.dependencies();

  await _requestPermissions();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((msg) => NotificationService.onMessage(notification: msg));
  FirebaseMessaging.onMessageOpenedApp.listen(
    (msg) => NotificationService.onMessageOpenedApp(notification: msg),
  );

  await NotificationService.onInit();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  startReceivePort();
  await SharedPrefsService.init();

  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

Future<void> _requestPermissions() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  var locationPermission = await Geolocator.checkPermission();
  if (locationPermission == LocationPermission.denied ||
      locationPermission == LocationPermission.deniedForever) {
    await Geolocator.requestPermission();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => GetMaterialApp(
        title: 'Waiver Driver',
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes1.splash,
        getPages: AppRoutes1.appPages1,
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (cert, host, port) => true;
  }
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'basic_notification_channel',
          channelName: 'Foreground Location Service',
          channelDescription: 'Notification for location tracking in background',
          importance: NotificationImportance.Low,
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          locked: true,
          channelShowBadge: false,
        ),
      ],
      debug: true);

  if (!await AwesomeNotifications().isNotificationAllowed()) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      // notificationChannelId: 'basic_notification_channel',
      initialNotificationTitle: 'Tracking',
      initialNotificationContent: 'Tracking your location',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(),
  );
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) {
  DartPluginRegistrant.ensureInitialized();

  String? passengerId;
  String? driverState;
  String? messageType;

  bool isOnline = false;
  service.on('stopService').listen((event) {
    service.stopSelf();
  });
  service.on("setData").listen((event) {
    passengerId = event?['passengerId'];
    driverState = event?['driverState'];
    messageType = event?['messageType'];
    isOnline = event?['isOnline'];
    final token = event?["token"];

    if (token != null && isOnline) {
      WebSocketServices.connect(token);
    } else {
      WebSocketServices.disconnect();
    }
  });
  // service.on("connectSocket").listen((event) async {
  //   await WebSocketServices.connect();
  // });
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 888,
      channelKey: 'basic_notification_channel',
      title: 'Tracking in Background',
      body: 'Live location updates running...',
      notificationLayout: NotificationLayout.Default,
      icon: "resource://drawable/ic_stat_applogo_removebg_preview",
      locked: true,
      autoDismissible: false,
      category: NotificationCategory.Service,
    ),
  );
  Timer.periodic(Duration(seconds: 5), (timer) async {
    if (isOnline) {
      Position position = await Geolocator.getCurrentPosition(
          locationSettings: LocationSettings(accuracy: LocationAccuracy.high));

      WebSocketServices.sendLiveLocation(body: {
        "passenger_id": passengerId,
        "msg_type": messageType,
        "ride_status": driverState,
        "current_loc_long": position.longitude,
        "current_loc_lat": position.latitude,
      });
      print('🎈Sending periodic location update... $position');
    } else {
      await AwesomeNotifications().cancel(888);
    }
  });
}
