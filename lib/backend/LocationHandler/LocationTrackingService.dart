// import 'dart:io';
// import 'dart:isolate';
// import 'dart:convert';
// import 'dart:async';
// import 'dart:developer';
// import 'dart:ui';
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:waiver_driver/backend/api/api_services/urls.dart';

// import '../../core/constants/get_storage_constants.dart';
// import '../../main.dart';

// class LocationTrackingService extends GetxController {
//   final isRunning = false.obs;
//   final service = FlutterBackgroundService();
//   static const String _portName = 'location_service_port';
//   ReceivePort? _receivePort;

//   @override
//   void onInit() {
//     super.onInit();
//     _setup();
//     log("LocationTrackingService#######################");
//     _initializePortListener();
//   }

//   @override
//   void onClose() {
//     _receivePort?.close();
//     super.onClose();
//   }

//   // Future<void> _setup() async {
//   //   await _requestPermissions();
//   //   // Don't save initial data here - will be done when startService is called
//   //   await _initializeService();
//   //   isRunning.value = await service.isRunning();
//   // }

//   Future<void> _setup() async {
//     // await _requestPermissions();
//     await createNotificationChannel(); // Create channel first
//     await _initializeService();
//     isRunning.value = await service.isRunning();
//   }

//   // Save necessary data for background service
//   Future<void> saveInitialData({
//     String? driverState,
//     String? passengerId,
//     bool? isOnline,
//   }) async {
//     final prefs = await SharedPreferences.getInstance();

//     // Save WebSocket configuration from your existing service
//     await prefs.setString('websocket_base_url', WebSocketUrl.base);
//     await prefs.setString(
//         'websocket_live_location_path', WebSocketUrl.liveLocation);

//     // Get token from your box
//     final token = box.read(BoxKeys.token) ?? '';
//     await prefs.setString('auth_token', token);

//     // Save current driver state and passenger info
//     await prefs.setString('driver_state', driverState ?? 'idle');
//     await prefs.setString('passenger_id', passengerId ?? 'placeholder');
//     await prefs.setBool('is_online', isOnline ?? true);

//     log('📋 Saved initial data: driverState=$driverState, passengerId=$passengerId, isOnline=$isOnline');
//   }

//   void _initializePortListener() {
//     _receivePort = ReceivePort();
//     IsolateNameServer.removePortNameMapping(_portName);
//     IsolateNameServer.registerPortWithName(_receivePort!.sendPort, _portName);

//     _receivePort!.listen((data) {
//       if (data is Map<String, dynamic>) {
//         switch (data['type']) {
//           case 'location_update':
//             log('Main isolate received location: ${data['position']}');
//             // Update UI or perform other main isolate operations
//             break;
//           case 'websocket_status':
//             log('WebSocket status: ${data['status']}');
//             break;
//           case 'location_sent':
//             log('Location sent successfully via WebSocket');
//             break;
//           case 'error':
//             log('Background service error: ${data['message']}');
//             break;
//         }
//       }
//     });
//   }

//   // Future<void> _requestPermissions() async {
//   //   LocationPermission permission = await Geolocator.checkPermission();
//   //   if (permission == LocationPermission.denied) {
//   //     permission = await Geolocator.requestPermission();
//   //   }

//   //   if (permission == LocationPermission.deniedForever) {
//   //     throw Exception('Location permissions are permanently denied');
//   //   }

//   //   if (Platform.isAndroid) {
//   //     await Permission.notification.request();
//   //   }
//   // }

//   Future<void> _requestPermissions() async {
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//     }

//     if (permission == LocationPermission.deniedForever) {
//       throw Exception('Location permissions are permanently denied');
//     }

//     if (Platform.isAndroid) {
//       // Request notification permission for Android 13+
//       await Permission.notification.request();

//       // Also request the specific permissions
//       await Permission.locationAlways.request();
//     }
//   }

//   // Future<void> _initializeService() async {
//   //   await service.configure(
//   //     androidConfiguration: AndroidConfiguration(
//   //       autoStart: false,
//   //       isForegroundMode: true,
//   //       notificationChannelId: 'bg_service_channel',
//   //       initialNotificationTitle: 'Location Tracking Active',
//   //       initialNotificationContent: 'Tracking your location in background',
//   //       foregroundServiceNotificationId: 888,
//   //       onStart: onStart,
//   //       autoStartOnBoot: false,
//   //     ),
//   //     iosConfiguration: IosConfiguration(
//   //       autoStart: false,
//   //       onForeground: onStart,
//   //       onBackground: onIosBackground,
//   //     ),
//   //   );
//   // }
//   Future<void> _initializeService() async {
//     // Create notification channel BEFORE configuring service

//     await createNotificationChannel();

//     await service.configure(
//       androidConfiguration: AndroidConfiguration(
//         autoStart: false,
//         isForegroundMode: true,
//         notificationChannelId: 'bg_service_channel',
//         initialNotificationTitle: 'Location Tracking Active',
//         initialNotificationContent: 'Tracking your location in background',
//         foregroundServiceNotificationId: 888,
//         onStart: onStart,
//         autoStartOnBoot: false,
//       ),
//       iosConfiguration: IosConfiguration(
//         autoStart: false,
//         onForeground: onStart,
//         onBackground: onIosBackground,
//       ),
//     );

//     await AwesomeNotifications().initialize(
//         null,
//         [
//           NotificationChannel(
//             channelKey: 'basic_notification_channel',
//             channelName: 'Foreground Location Service',
//             channelDescription:
//                 'Notification for location tracking in background',
//             importance: NotificationImportance.Low,
//             defaultColor: const Color(0xFF9D50DD),
//             ledColor: Colors.white,
//             locked: true,
//             channelShowBadge: false,
//           ),
//         ],
//         debug: true);

//     if (!await AwesomeNotifications().isNotificationAllowed()) {
//       // await AwesomeNotifications().requestPermissionToSendNotifications();
//     }

//     await service.configure(
//       androidConfiguration: AndroidConfiguration(
//         onStart: onStart,
//         autoStart: true,
//         isForegroundMode: true,
//         // notificationChannelId: 'basic_notification_channel',
//         initialNotificationTitle: 'Tracking',
//         initialNotificationContent: 'Tracking your location',
//         foregroundServiceNotificationId: 888,
//       ),
//       iosConfiguration: IosConfiguration(),
//     );
//   }

//   Future<void> startService({
//     String? driverState,
//     String? passengerId,
//     bool? isOnline,
//   }) async {
//     try {
//       // Update shared preferences before starting service with current data
//       await saveInitialData(
//         driverState: driverState,
//         passengerId: passengerId,
//         isOnline: isOnline,
//       );

//       final serviceRunning = await service.isRunning();
//       if (!serviceRunning) {
//         await service.startService();
//         isRunning.value = true;
//         log('✅ Location tracking service started');
//       } else {
//         log('⚠️ Service is already running');
//         isRunning.value = true;
//       }
//     } catch (e) {
//       log('❌ Error starting service: $e');
//       isRunning.value = false;
//     }
//   }

//   Future<void> stopService() async {
//     try {
//       // Only call service methods from main isolate
//       if (await service.isRunning()) {
//         service.on('stopService').listen((event) {});
//         service.invoke("stop_service");
//         await Future.delayed(
//             Duration(milliseconds: 500)); // Give time to process
//         isRunning.value = await service.isRunning();
//       }
//       log('🛑 Location tracking service stopped');
//     } catch (e) {
//       log('❌ Error stopping service: $e');
//     }
//   }

//   // Method to update driver state from main app
//   Future<void> updateDriverState(String driverState,
//       {String? passengerId}) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('driver_state', driverState);
//     if (passengerId != null) {
//       await prefs.setString('passenger_id', passengerId);
//     }

//     // Notify background service of state change
//     service.invoke('update_state', {
//       'driver_state': driverState,
//       'passenger_id': passengerId,
//     });
//   }

//   // Method to update online status
//   Future<void> updateOnlineStatus(bool isOnline) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('is_online', isOnline);

//     service.invoke('update_online_status', {'is_online': isOnline});
//   }

//   // Method to update token (call this when token changes)
//   Future<void> updateAuthToken(String token) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('auth_token', token);

//     service.invoke('update_token', {'token': token});
//   }

//   Future<bool> getServiceStatus() async {
//     final running = await service.isRunning();
//     isRunning.value = running;
//     return running;
//   }
// }

// @pragma('vm:entry-point')
// Future<bool> onIosBackground(ServiceInstance service) async {
//   WidgetsFlutterBinding.ensureInitialized();
//   DartPluginRegistrant.ensureInitialized();
//   return true;
// }

// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//   DartPluginRegistrant.ensureInitialized();

//   // Initialize notifications
//   // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   //     FlutterLocalNotificationsPlugin();

//   // const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   //   'bg_service_channel',
//   //   'Location Tracking Service',
//   //   description: 'Used for background location tracking',
//   //   importance: Importance.low,
//   //   enableVibration: false,
//   //   playSound: false,
//   // );

//   // if (Platform.isAndroid) {
//   //   await flutterLocalNotificationsPlugin
//   //       .resolvePlatformSpecificImplementation<
//   //           AndroidFlutterLocalNotificationsPlugin>()
//   //       ?.createNotificationChannel(channel);
//   // }

//   // Set up foreground notification for Android - FIXED
//   if (Platform.isAndroid && service is AndroidServiceInstance) {
//     service.setForegroundNotificationInfo(
//       title: "Location Tracking Active",
//       content: "Initializing location services...",
//     );
//     AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id: 888,
//         channelKey: 'basic_notification_channel',
//         title: 'Tracking in Background',
//         body: 'Live location updates running...',
//         notificationLayout: NotificationLayout.Default,
//         icon: "resource://drawable/ic_stat_applogo_removebg_preview",
//         locked: true,
//         autoDismissible: false,
//         category: NotificationCategory.Service,
//       ),
//     );
//   }

//   // Get port for communication with main isolate
//   final SendPort? sendPort = IsolateNameServer.lookupPortByName(
//     LocationTrackingService._portName,
//   );

//   // Initialize background WebSocket and location tracking
//   final backgroundLocationService =
//       BackgroundLocationService(service, sendPort);
//   await backgroundLocationService.initialize();

//   // Listen for commands from main isolate
//   service.on('stop_service').listen((event) {
//     log('🛑 Received stop command');
//     backgroundLocationService.dispose();
//     service.stopSelf();
//   });

//   service.on('update_state').listen((event) {
//     if (event != null && event is Map<String, dynamic>) {
//       backgroundLocationService.updateDriverState(
//         event['driver_state'] as String,
//         passengerId: event['passenger_id'] as String?,
//       );
//     }
//   });

//   service.on('update_online_status').listen((event) {
//     if (event != null && event is Map<String, dynamic>) {
//       backgroundLocationService.updateOnlineStatus(event['is_online'] as bool);
//     }
//   });

//   service.on('update_token').listen((event) {
//     if (event != null && event is Map<String, dynamic>) {
//       backgroundLocationService.updateAuthToken(event['token'] as String);
//     }
//   });
// }

// Future<void> createNotificationChannel() async {
//   final service = FlutterBackgroundService();

//   if (Platform.isAndroid) {
//     await AwesomeNotifications().initialize(
//         null,
//         [
//           NotificationChannel(
//             channelKey: 'basic_notification_channel',
//             channelName: 'Foreground Location Service',
//             channelDescription:
//                 'Notification for location tracking in background',
//             importance: NotificationImportance.Low,
//             defaultColor: const Color(0xFF9D50DD),
//             ledColor: Colors.white,
//             locked: true,
//             channelShowBadge: false,
//           ),
//         ],
//         debug: true);

//     if (!await AwesomeNotifications().isNotificationAllowed()) {
//       // await AwesomeNotifications().requestPermissionToSendNotifications();
//     }

//     await service.configure(
//       androidConfiguration: AndroidConfiguration(
//         onStart: onStart,
//         autoStart: true,
//         isForegroundMode: true,
//         // notificationChannelId: 'basic_notification_channel',
//         initialNotificationTitle: 'Tracking',
//         initialNotificationContent: 'Tracking your location',
//         foregroundServiceNotificationId: 888,
//       ),
//       iosConfiguration: IosConfiguration(),
//     );
//   }
// }

// // Background WebSocket service that mimics your WebSocketServices
// class BackgroundWebSocketService {
//   WebSocketChannel? _channel;
//   String? _baseUrl;
//   String? _liveLocationPath;
//   String? _token;
//   bool _isConnected = false;

//   void initialize(String baseUrl, String liveLocationPath, String token) {
//     _baseUrl = baseUrl;
//     _liveLocationPath = liveLocationPath;
//     _token = token;
//     _connect();
//   }

//   void _connect() {
//     try {
//       if (_baseUrl != null && _liveLocationPath != null && _token != null) {
//         final url = Uri.parse("$_baseUrl$_liveLocationPath" + "token=$_token");
//         _channel = WebSocketChannel.connect(url);
//         _isConnected = true;
//         log('✅ Background WebSocket connected to: $url');

//         _channel!.stream.listen(
//           (data) {
//             log('📨 WebSocket received: $data');
//           },
//           onError: (error) {
//             log('❌ WebSocket error: $error');
//             _isConnected = false;
//             _reconnect();
//           },
//           onDone: () {
//             log('🔌 WebSocket connection closed');
//             _isConnected = false;
//             _reconnect();
//           },
//         );
//       }
//     } catch (e) {
//       log('❌ Failed to connect WebSocket: $e');
//       _isConnected = false;
//       _reconnect();
//     }
//   }

//   void _reconnect() {
//     Timer(const Duration(seconds: 5), () {
//       if (!_isConnected) {
//         log('🔄 Attempting WebSocket reconnection...');
//         _connect();
//       }
//     });
//   }

//   void sendLiveLocation({required Map<String, dynamic> body}) {
//     if (_isConnected && _channel != null) {
//       try {
//         log("Sending location data:");
//         log(json.encode(body));
//         _channel!.sink.add(json.encode(body));
//         log('📤 Location sent successfully via WebSocket');
//       } catch (e) {
//         log('❌ Error sending location: $e');
//       }
//     } else {
//       log('⚠️ Cannot send location: WebSocket not connected');
//     }
//   }

//   void updateToken(String newToken) {
//     _token = newToken;
//     if (_isConnected) {
//       _channel?.sink.close();
//       _isConnected = false;
//       _connect();
//     }
//   }

//   void dispose() {
//     _isConnected = false;
//     _channel?.sink.close();
//     _channel = null;
//   }
// }

// // Separate class to handle background operations
// class BackgroundLocationService {
//   final ServiceInstance service;
//   final SendPort? sendPort;

//   Timer? _locationTimer;
//   late BackgroundWebSocketService _webSocketService;
//   bool _isServiceRunning = true;

//   // Current state variables
//   String _driverState = 'idle';
//   String _passengerId = 'placeholder';
//   bool _isOnline = false;

//   BackgroundLocationService(this.service, this.sendPort);

//   Future<void> initialize() async {
//     _webSocketService = BackgroundWebSocketService();
//     await _loadConfiguration();
//     _startLocationTracking();
//   }

//   Future<void> _loadConfiguration() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       _driverState = prefs.getString('driver_state') ?? 'idle';
//       _passengerId = prefs.getString('passenger_id') ?? 'placeholder';
//       _isOnline = prefs.getBool('is_online') ?? false;

//       final baseUrl = prefs.getString('websocket_base_url') ?? '';
//       final liveLocationPath =
//           prefs.getString('websocket_live_location_path') ?? '';
//       final token = prefs.getString('auth_token') ?? '';

//       if (_isOnline &&
//           baseUrl.isNotEmpty &&
//           liveLocationPath.isNotEmpty &&
//           token.isNotEmpty) {
//         _webSocketService.initialize(baseUrl, liveLocationPath, token);

//         sendPort?.send({
//           'type': 'websocket_status',
//           'status': 'connected',
//         });
//       }

//       log('📋 Loaded config: driverState=$_driverState, isOnline=$_isOnline');
//     } catch (e) {
//       log('❌ Error loading configuration: $e');
//       sendPort?.send({
//         'type': 'error',
//         'message': 'Failed to load configuration: $e',
//       });
//     }
//   }

//   void _startLocationTracking() {
//     _locationTimer = Timer.periodic(const Duration(seconds: 15), (timer) async {
//       if (!_isServiceRunning) {
//         timer.cancel();
//         return;
//       }

//       try {
//         bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//         if (!serviceEnabled) {
//           log('❌ Location services are disabled');
//           return;
//         }

//         final position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high,
//           timeLimit: const Duration(seconds: 10),
//         ).timeout(
//           const Duration(seconds: 15),
//           onTimeout: () => throw TimeoutException('Location request timed out'),
//         );

//         // Send location to main isolate
//         sendPort?.send({
//           'type': 'location_update',
//           'position': {
//             'latitude': position.latitude,
//             'longitude': position.longitude,
//             'accuracy': position.accuracy,
//             'timestamp': position.timestamp?.millisecondsSinceEpoch,
//           }
//         });

//         // Send live location via WebSocket (using your original format)
//         await _sendLiveLocation(position);

//         // Update foreground notification - FIXED with proper type checking
//         _updateNotification(position);

//         log("📍 ${DateTime.now()}: ${position.latitude}, ${position.longitude}");
//       } catch (e) {
//         log("❌ Error in location tracking: $e");

//         sendPort?.send({
//           'type': 'error',
//           'message': 'Location tracking error: $e',
//         });

//         // Update notification with error - FIXED
//         _updateNotificationWithError(e.toString());
//       }
//     });
//   }

//   // Helper method to update notification with proper type checking
//   void _updateNotification(Position position) {
//     if (Platform.isAndroid && service is AndroidServiceInstance) {
//       (service as AndroidServiceInstance).setForegroundNotificationInfo(
//         title: "Location Tracking Active",
//         content: 'Live location updates running...',
//       );
//       AwesomeNotifications().createNotification(
//         content: NotificationContent(
//           id: 888,
//           channelKey: 'basic_notification_channel',
//           title: 'Tracking in Background',
//           body: 'Live location updates running...',
//           notificationLayout: NotificationLayout.Default,
//           icon: "resource://drawable/ic_stat_applogo_removebg_preview",
//           locked: true,
//           autoDismissible: false,
//           category: NotificationCategory.Service,
//         ),
//       );
//     }
//   }

//   // Helper method to update notification with error
//   void _updateNotificationWithError(String error) {
//     if (Platform.isAndroid && service is AndroidServiceInstance) {
//       (service as AndroidServiceInstance).setForegroundNotificationInfo(
//         title: "Location Tracking - Error",
//         content:
//             "Error: ${error.length > 50 ? error.substring(0, 50) + '...' : error}",
//       );
//     }
//   }

//   Future<void> _sendLiveLocation(Position position) async {
//     if (!_isOnline) {
//       log('⚠️ Cannot send location: offline');
//       return;
//     }

//     try {
//       // Using the same format as your original sendLiveLocation function
//       final locationData = {
//         "passenger_id": _driverState == 'idle' ? "save" : _passengerId,
//         "msg_type": _driverState == 'idle' ? "save" : "ride",
//         "ride_status": _driverState,
//         "current_loc_long": position.longitude,
//         "current_loc_lat": position.latitude,
//       };

//       // Use the background WebSocket service (mimics your WebSocketServices.sendLiveLocation)
//       _webSocketService.sendLiveLocation(body: locationData);

//       sendPort?.send({
//         'type': 'location_sent',
//         'data': locationData,
//       });
//     } catch (e) {
//       log('❌ Error sending location via WebSocket: $e');
//       sendPort?.send({
//         'type': 'error',
//         'message': 'Failed to send location: $e',
//       });
//     }
//   }

//   void updateDriverState(String driverState, {String? passengerId}) {
//     _driverState = driverState;
//     if (passengerId != null) {
//       _passengerId = passengerId;
//     }
//     log('🔄 Updated driver state: $_driverState, passenger: $_passengerId');
//   }

//   void updateOnlineStatus(bool isOnline) {
//     final wasOnline = _isOnline;
//     _isOnline = isOnline;
//     log('🔄 Updated online status: $_isOnline');

//     if (_isOnline && !wasOnline) {
//       // Going online - initialize WebSocket
//       _loadConfiguration();
//     } else if (!_isOnline && wasOnline) {
//       // Going offline - dispose WebSocket
//       _webSocketService.dispose();
//     }
//   }

//   void updateAuthToken(String token) {
//     _webSocketService.updateToken(token);
//     log('🔄 Updated auth token');
//   }

//   void dispose() {
//     _isServiceRunning = false;
//     _locationTimer?.cancel();
//     _webSocketService.dispose();
//     log('🗑️ Background location service disposed');
//   }
// }

// String _formatDateTime(DateTime dateTime) {
//   return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}";
// }

import 'dart:io';
import 'dart:isolate';
import 'dart:convert';
import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:waiver_driver/backend/api/api_services/urls.dart';

import '../../core/constants/get_storage_constants.dart';
import '../../main.dart';

class LocationTrackingService extends GetxController {
  final isRunning = false.obs;
  final service = FlutterBackgroundService();
  static const String _portName = 'location_service_port';
  ReceivePort? _receivePort;

  @override
  void onInit() {
    super.onInit();
    _setup();
    log("LocationTrackingService initialized");
    _initializePortListener();
  }

  @override
  void onClose() {
    _receivePort?.close();
    super.onClose();
  }

  Future<void> _setup() async {
    // Only initialize service configuration, don't start it automatically
    await _initializeService();
    isRunning.value = await service.isRunning();
  }

  // Save necessary data for background service
  Future<void> saveInitialData({
    String? driverState,
    String? passengerId,
    bool? isOnline,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Save WebSocket configuration from your existing service
    await prefs.setString('websocket_base_url', WebSocketUrl.base);
    await prefs.setString(
        'websocket_live_location_path', WebSocketUrl.liveLocation);

    // Get token from your box
    final token = box.read(BoxKeys.token) ?? '';
    await prefs.setString('auth_token', token);

    // Save current driver state and passenger info
    await prefs.setString('driver_state', driverState ?? 'idle');
    await prefs.setString('passenger_id', passengerId ?? 'placeholder');
    await prefs.setBool(
        'is_online', isOnline ?? false); // Changed default to false

    log('📋 Saved initial data: driverState=$driverState, passengerId=$passengerId, isOnline=$isOnline');
  }

  void _initializePortListener() {
    _receivePort = ReceivePort();
    IsolateNameServer.removePortNameMapping(_portName);
    IsolateNameServer.registerPortWithName(_receivePort!.sendPort, _portName);

    _receivePort!.listen((data) {
      if (data is Map<String, dynamic>) {
        switch (data['type']) {
          case 'location_update':
            log('Main isolate received location: ${data['position']}');
            break;
          case 'websocket_status':
            log('WebSocket status: ${data['status']}');
            break;
          case 'location_sent':
            log('Location sent successfully via WebSocket');
            break;
          case 'error':
            log('Background service error: ${data['message']}');
            break;
        }
      }
    });
  }

  Future<void> _requestPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    if (Platform.isAndroid) {
      await Permission.notification.request();
      await Permission.locationAlways.request();
    }
  }

// Fix 2: Update the _initializeService method with better configuration
  Future<void> _initializeService() async {
    try {
      // Ensure notification channel is created first
      await createNotificationChannel();

      await service.configure(
        androidConfiguration: AndroidConfiguration(
          autoStart: false,
          isForegroundMode: true,
          notificationChannelId:
              'bg_service_channel', // Must match channel created above
          initialNotificationTitle: 'Waiver Driver',
          initialNotificationContent: 'Location tracking is active',
          foregroundServiceNotificationId: 888,
          onStart: onStart,
          autoStartOnBoot: false,
        ),
        iosConfiguration: IosConfiguration(
          autoStart: false,
          onForeground: onStart,
          onBackground: onIosBackground,
        ),
      );

      log('✅ Background service configured successfully');
    } catch (e) {
      log('❌ Error configuring background service: $e');
      rethrow;
    }
  }

// Fix 3: Update the startService method with better error handling
  Future<void> startService({
    String? driverState,
    String? passengerId,
    bool? isOnline,
  }) async {
    try {
      // Only start if driver is actually online
      if (isOnline != true) {
        log('⚠️ Not starting service - driver is offline');
        return;
      }

      // Ensure permissions are granted
      // await _requestPermissions();

      // Update shared preferences before starting service
      await saveInitialData(
        driverState: driverState,
        passengerId: passengerId,
        isOnline: isOnline,
      );

      final serviceRunning = await service.isRunning();
      if (!serviceRunning) {
        // Ensure notification channel exists before starting
        await createNotificationChannel();

        // Add a small delay to ensure channel is ready
        await Future.delayed(const Duration(milliseconds: 500));

        await service.startService();

        // Verify service started
        await Future.delayed(const Duration(milliseconds: 1000));
        final started = await service.isRunning();

        if (started) {
          isRunning.value = true;
          log('✅ Location tracking service started successfully');
        } else {
          throw Exception('Service failed to start');
        }
      } else {
        log('⚠️ Service is already running');
        isRunning.value = true;
      }
    } catch (e) {
      log('❌ Error starting service: $e');
      isRunning.value = false;
      rethrow; // Re-throw to handle in calling code
    }
  }

  Future<void> stopService() async {
    try {
      if (await service.isRunning()) {
        // Set offline state before stopping
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_online', false);

        service.on('stopService').listen((event) {});
        service.invoke("stop_service");
        await Future.delayed(Duration(milliseconds: 500));

        // Force stop if still running
        bool stillRunning = await service.isRunning();
        if (stillRunning) {
          // Additional cleanup
          await service.configure(
            androidConfiguration: AndroidConfiguration(
              autoStart: false,
              isForegroundMode: false,
              onStart: onStart,
            ),
            iosConfiguration: IosConfiguration(
              autoStart: false,
              onForeground: onStart,
              onBackground: onIosBackground,
            ),
          );
        }

        isRunning.value = await service.isRunning();
      }
      log('🛑 Location tracking service stopped');
    } catch (e) {
      log('❌ Error stopping service: $e');
    }
  }

  // Method to update driver state from main app
  Future<void> updateDriverState(String driverState,
      {String? passengerId}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('driver_state', driverState);
    if (passengerId != null) {
      await prefs.setString('passenger_id', passengerId);
    }

    // Notify background service of state change
    service.invoke('update_state', {
      'driver_state': driverState,
      'passenger_id': passengerId,
    });
  }

  // Method to update online status
  Future<void> updateOnlineStatus(bool isOnline) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_online', isOnline);

    if (!isOnline) {
      // Stop service when going offline
      await stopService();
    } else {
      // Start service when going online
      String driverState = prefs.getString('driver_state') ?? 'idle';
      String? passengerId = prefs.getString('passenger_id');

      await startService(
        driverState: driverState,
        passengerId: passengerId,
        isOnline: true,
      );
    }

    service.invoke('update_online_status', {'is_online': isOnline});
  }

  // Method to update token (call this when token changes)
  Future<void> updateAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);

    service.invoke('update_token', {'token': token});
  }

  Future<bool> getServiceStatus() async {
    final running = await service.isRunning();
    isRunning.value = running;
    return running;
  }
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

// Fix 4: Update the onStart function with better notification handling
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  try {
    DartPluginRegistrant.ensureInitialized();

    // Check if driver is actually online before starting
    final prefs = await SharedPreferences.getInstance();
    final isOnline = prefs.getBool('is_online') ?? false;

    if (!isOnline) {
      log('🛑 Driver is offline, stopping service immediately');
      service.stopSelf();
      return;
    }

    // Create notification only when service actually starts
    if (Platform.isAndroid && service is AndroidServiceInstance) {
      try {
        service.setForegroundNotificationInfo(
          title: "Waiver Driver",
          content: "Location tracking is active",
        );
        log('✅ Foreground notification set successfully');
      } catch (e) {
        log('❌ Error setting foreground notification: $e');
        // Don't stop service, but log the error
      }
    }

    // Get port for communication with main isolate
    final SendPort? sendPort = IsolateNameServer.lookupPortByName(
      LocationTrackingService._portName,
    );

    // Initialize background WebSocket and location tracking
    final backgroundLocationService =
        BackgroundLocationService(service, sendPort);
    await backgroundLocationService.initialize();

    // Listen for commands from main isolate
    service.on('stop_service').listen((event) {
      log('🛑 Received stop command');
      backgroundLocationService.dispose();
      service.stopSelf();
    });

    service.on('update_state').listen((event) {
      if (event != null && event is Map<String, dynamic>) {
        backgroundLocationService.updateDriverState(
          event['driver_state'] as String,
          passengerId: event['passenger_id'] as String?,
        );
      }
    });

    service.on('update_online_status').listen((event) {
      if (event != null && event is Map<String, dynamic>) {
        final isOnline = event['is_online'] as bool;
        if (!isOnline) {
          backgroundLocationService.dispose();
          service.stopSelf();
        } else {
          backgroundLocationService.updateOnlineStatus(isOnline);
        }
      }
    });

    service.on('update_token').listen((event) {
      if (event != null && event is Map<String, dynamic>) {
        backgroundLocationService.updateAuthToken(event['token'] as String);
      }
    });

    log('✅ Background service started successfully');
  } catch (e) {
    log('❌ Error in onStart: $e');
    service.stopSelf();
  }
}

// Fix 1: Update the createNotificationChannel function
// Fix: Force using your custom icon in the notification channel
Future<void> createNotificationChannel() async {
  if (Platform.isAndroid) {
    // Create the notification channel using FlutterLocalNotifications
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'bg_service_channel', // Must match the channelId in service configuration
      'Location Tracking Service',
      description: 'Background location tracking for rides',
      importance: Importance.low, // Low = non-intrusive
      enableVibration: false,
      playSound: false,
      showBadge: false,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Also initialize AwesomeNotifications with the correct icon
    try {
      await AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
            channelKey: 'bg_service_channel',
            channelName: 'Location Tracking Service',
            channelDescription: 'Background location tracking for rides',
            importance: NotificationImportance.Low,
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white,
            locked: true,
            channelShowBadge: false,
            enableVibration: false,
            playSound: false,
            criticalAlerts: false,

            // 👇 this forces your custom app logo icon
            icon: "resource://drawable/ic_stat_applogo_removebg_preview",
          ),
        ],
        debug: false,
      );
    } catch (e) {
      log('AwesomeNotifications initialization failed: $e');
    }

    log('✅ Notification channel created successfully with custom icon');
  }
}

// Background WebSocket service that mimics your WebSocketServices
class BackgroundWebSocketService {
  WebSocketChannel? _channel;
  String? _baseUrl;
  String? _liveLocationPath;
  String? _token;
  bool _isConnected = false;

  void initialize(String baseUrl, String liveLocationPath, String token) {
    _baseUrl = baseUrl;
    _liveLocationPath = liveLocationPath;
    _token = token;
    _connect();
  }

  void _connect() {
    try {
      if (_baseUrl != null && _liveLocationPath != null && _token != null) {
        final url = Uri.parse("$_baseUrl$_liveLocationPath" + "token=$_token");
        _channel = WebSocketChannel.connect(url);
        _isConnected = true;
        log('✅ Background WebSocket connected to: $url');

        _channel!.stream.listen(
          (data) {
            log('📨 WebSocket received: $data');
          },
          onError: (error) {
            log('❌ WebSocket error: $error');
            _isConnected = false;
            _reconnect();
          },
          onDone: () {
            log('🔌 WebSocket connection closed');
            _isConnected = false;
            _reconnect();
          },
        );
      }
    } catch (e) {
      log('❌ Failed to connect WebSocket: $e');
      _isConnected = false;
      _reconnect();
    }
  }

  void _reconnect() {
    Timer(const Duration(seconds: 5), () {
      if (!_isConnected) {
        log('🔄 Attempting WebSocket reconnection...');
        _connect();
      }
    });
  }

  void sendLiveLocation({required Map<String, dynamic> body}) {
    if (_isConnected && _channel != null) {
      try {
        log("Sending location data:");
        log(json.encode(body));
        _channel!.sink.add(json.encode(body));
        log('📤 Location sent successfully via WebSocket');
      } catch (e) {
        log('❌ Error sending location: $e');
      }
    } else {
      log('⚠️ Cannot send location: WebSocket not connected');
    }
  }

  void updateToken(String newToken) {
    _token = newToken;
    if (_isConnected) {
      _channel?.sink.close();
      _isConnected = false;
      _connect();
    }
  }

  void dispose() {
    _isConnected = false;
    _channel?.sink.close();
    _channel = null;
  }
}

// Separate class to handle background operations
class BackgroundLocationService {
  final ServiceInstance service;
  final SendPort? sendPort;

  Timer? _locationTimer;
  late BackgroundWebSocketService _webSocketService;
  bool _isServiceRunning = true;

  // Current state variables
  String _driverState = 'idle';
  String _passengerId = 'placeholder';
  bool _isOnline = false;

  BackgroundLocationService(this.service, this.sendPort);

  Future<void> initialize() async {
    _webSocketService = BackgroundWebSocketService();
    await _loadConfiguration();

    // Only start location tracking if driver is online
    if (_isOnline) {
      _startLocationTracking();
    } else {
      log('⚠️ Driver is offline, not starting location tracking');
      service.stopSelf();
    }
  }

  Future<void> _loadConfiguration() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _driverState = prefs.getString('driver_state') ?? 'idle';
      _passengerId = prefs.getString('passenger_id') ?? 'placeholder';
      _isOnline = prefs.getBool('is_online') ?? false;

      final baseUrl = prefs.getString('websocket_base_url') ?? '';
      final liveLocationPath =
          prefs.getString('websocket_live_location_path') ?? '';
      final token = prefs.getString('auth_token') ?? '';

      if (_isOnline &&
          baseUrl.isNotEmpty &&
          liveLocationPath.isNotEmpty &&
          token.isNotEmpty) {
        _webSocketService.initialize(baseUrl, liveLocationPath, token);

        sendPort?.send({
          'type': 'websocket_status',
          'status': 'connected',
        });
      }

      log('📋 Loaded config: driverState=$_driverState, isOnline=$_isOnline');
    } catch (e) {
      log('❌ Error loading configuration: $e');
      sendPort?.send({
        'type': 'error',
        'message': 'Failed to load configuration: $e',
      });
    }
  }

  void _startLocationTracking() {
    _locationTimer = Timer.periodic(const Duration(seconds: 15), (timer) async {
      if (!_isServiceRunning || !_isOnline) {
        timer.cancel();
        return;
      }

      try {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          log('❌ Location services are disabled');
          return;
        }

        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 10),
        ).timeout(
          const Duration(seconds: 15),
          onTimeout: () => throw TimeoutException('Location request timed out'),
        );

        // Send location to main isolate
        sendPort?.send({
          'type': 'location_update',
          'position': {
            'latitude': position.latitude,
            'longitude': position.longitude,
            'accuracy': position.accuracy,
            'timestamp': position.timestamp?.millisecondsSinceEpoch,
          }
        });

        // Send live location via WebSocket (using your original format)
        await _sendLiveLocation(position);

        // Update foreground notification
        _updateNotification(position);

        log("📍 ${DateTime.now()}: ${position.latitude}, ${position.longitude}");
      } catch (e) {
        log("❌ Error in location tracking: $e");

        sendPort?.send({
          'type': 'error',
          'message': 'Location tracking error: $e',
        });

        _updateNotificationWithError(e.toString());
      }
    });
  }

// Fix 5: Add better error handling in _updateNotification methods
  void _updateNotification(Position position) {
    try {
      if (Platform.isAndroid && service is AndroidServiceInstance) {
        (service as AndroidServiceInstance).setForegroundNotificationInfo(
          title: "Waiver Driver - Active",
          content: 'Tracking location for rides...',
        );
      }
    } catch (e) {
      log('❌ Error updating notification: $e');
    }
  }

  void _updateNotificationWithError(String error) {
    try {
      if (Platform.isAndroid && service is AndroidServiceInstance) {
        (service as AndroidServiceInstance).setForegroundNotificationInfo(
          title: "Waiver Driver - Error",
          content:
              "Error: ${error.length > 30 ? error.substring(0, 30) + '...' : error}",
        );
      }
    } catch (e) {
      log('❌ Error updating error notification: $e');
    }
  }

  Future<void> _sendLiveLocation(Position position) async {
    if (!_isOnline) {
      log('⚠️ Cannot send location: offline');
      return;
    }

    try {
      // Using the same format as your original sendLiveLocation function
      final locationData = {
        "passenger_id": _driverState == 'idle' ? "save" : _passengerId,
        "msg_type": _driverState == 'idle' ? "save" : "ride",
        "ride_status": _driverState,
        "current_loc_long": position.longitude,
        "current_loc_lat": position.latitude,
      };

      // Use the background WebSocket service (mimics your WebSocketServices.sendLiveLocation)
      _webSocketService.sendLiveLocation(body: locationData);

      sendPort?.send({
        'type': 'location_sent',
        'data': locationData,
      });
    } catch (e) {
      log('❌ Error sending location via WebSocket: $e');
      sendPort?.send({
        'type': 'error',
        'message': 'Failed to send location: $e',
      });
    }
  }

  void updateDriverState(String driverState, {String? passengerId}) {
    _driverState = driverState;
    if (passengerId != null) {
      _passengerId = passengerId;
    }
    log('🔄 Updated driver state: $_driverState, passenger: $_passengerId');
  }

  void updateOnlineStatus(bool isOnline) {
    final wasOnline = _isOnline;
    _isOnline = isOnline;
    log('🔄 Updated online status: $_isOnline');

    if (_isOnline && !wasOnline) {
      // Going online - initialize WebSocket and start tracking
      _loadConfiguration();
      _startLocationTracking();
    } else if (!_isOnline && wasOnline) {
      // Going offline - dispose WebSocket and stop tracking
      _webSocketService.dispose();
      _locationTimer?.cancel();
      service.stopSelf(); // Stop the service when going offline
    }
  }

  void updateAuthToken(String token) {
    _webSocketService.updateToken(token);
    log('🔄 Updated auth token');
  }

  void dispose() {
    _isServiceRunning = false;
    _locationTimer?.cancel();
    _webSocketService.dispose();
    log('🗑️ Background location service disposed');
  }
}

String _formatDateTime(DateTime dateTime) {
  return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}";
}
