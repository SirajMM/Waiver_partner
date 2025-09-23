import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:location/location.dart' as loc;
import '../../controller/home/home_controller.dart';
import '../../core/constants/get_storage_constants.dart';
import '../../main.dart';
import '../api/api_services/urls.dart';

class LocationTrackingService extends GetxController {
  final isRunning = false.obs;
  final service = FlutterBackgroundService();
  static const String _portName = 'location_service_port';
  ReceivePort? _receivePort;

  @override
  void onInit() {
    super.onInit();
    _initializePortListener();
    log("📡 LocationTrackingService initialized");
  }

  @override
  void onClose() {
    _receivePort?.close();
    super.onClose();
  }

  void _initializePortListener() {
    _receivePort = ReceivePort();
    IsolateNameServer.removePortNameMapping(_portName);
    IsolateNameServer.registerPortWithName(_receivePort!.sendPort, _portName);

    _receivePort!.listen((data) async {
      if (data is Map<String, dynamic>) {
        switch (data['type']) {
          case 'startTracking':
            await _startBackgroundService();
            break;
          case 'stopTracking':
            await _stopBackgroundService();
            break;
          case 'updateOnlineStatus':
            bool isOnline = data['is_online'] ?? false;
            if (!isOnline) {
              await _stopBackgroundService();
            }
            break;
        }
      }
    });
  }

  Future<void> _startBackgroundService() async {
    if (await service.isRunning()) {
      log('⚠️ Service already running');
      return;
    }

    await service.startService();
    isRunning.value = true;
    log('✅ Background service started');
  }

  Future<void> _stopBackgroundService() async {
    try {
      if (await service.isRunning()) {
        service.invoke("stop_service");
      }
      isRunning.value = false;
      log('🛑 Background service stopped');
    } catch (e) {
      log('❌ Error stopping service: $e');
    }
  }

  Future<void> updateOnlineStatus(bool isOnline) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_online', isOnline);
    print("updateOnlineStatus isOnline Called ************ ");
    if (!isOnline) {
      await _stopBackgroundService();
    } else {
      await _startBackgroundService();
    }
  }

  Future<void> createNotificationChannel() async {
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

      log('✅ Notification channel created successfully');
    }
  }

  Future<void> updateDriverState(
    String driverState, {
    String? passengerId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('driver_state', driverState);
    if (passengerId != null) await prefs.setString('passenger_id', passengerId);

    service.invoke('update_state', {
      'driver_state': driverState,
      'passenger_id': passengerId,
    });
  }

  Future<void> updateAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);

    service.invoke('update_token', {'token': token});
  }

  /// iOS background handler
  @pragma('vm:entry-point')
  Future<bool> onIosBackground(ServiceInstance service) async {
    log('✅ iOS background fetch executed');
    return true; // Must return true to keep background fetch alive
  }
}

@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    print("onStert CALLED **************");
    await _createNotificationChannelInBackground();

    final prefs = await SharedPreferences.getInstance();
    final isOnline = prefs.getBool('is_online') ?? false;

    if (!isOnline) {
      log('🛑 Driver is offline, stopping service immediately');
      if (Platform.isAndroid && service is AndroidServiceInstance) {
        service.setForegroundNotificationInfo(
          title: "Waiver Driver",
          content: "Service stopping - driver offline",
        );
      }
      await Future.delayed(const Duration(milliseconds: 200));
      service.stopSelf();
      return;
    }

    if (Platform.isAndroid && service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: "Waiver Driver",
        content: "Location tracking is active",
      );
    }

    final SendPort? sendPort = IsolateNameServer.lookupPortByName(
      LocationTrackingService._portName,
    );

    final wsService = BackgroundWebSocketService();
    final locationServiceBackground = BackgroundLocationService(
      service,
      sendPort,
      wsService,
    );
    print("before locationServiceBackground.initialize() ++++++++++++++++");
    await locationServiceBackground.initialize();

    service.on('stop_service').listen((event) async {
      await locationServiceBackground.dispose();
      service.stopSelf();
    });

    service.on('update_state').listen((event) {
      if (event != null && event is Map<String, dynamic>) {
        locationServiceBackground.updateDriverState(
          event['driver_state'] as String,
          passengerId: event['passenger_id'] as String?,
        );
      }
    });

    service.on('update_token').listen((event) {
      if (event != null && event is Map<String, dynamic>) {
        wsService.updateToken(event['token'] as String);
      }
    });

    log('✅ Background service started successfully');
  } catch (e) {
    log('❌ Critical error in onStart: $e');
    service.stopSelf();
  }
}

Future<void> _createNotificationChannelInBackground() async {
  if (Platform.isAndroid) {
    final FlutterLocalNotificationsPlugin plugin =
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

    await plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
}

class BackgroundLocationService {
  final ServiceInstance service;
  final SendPort? sendPort;
  final BackgroundWebSocketService _webSocketService;

  Timer? _locationTimer;
  Position? _lastPosition;
  DateTime _lastSentTime = DateTime.now();

  String _driverState = "idle";
  String _passengerId = "save";
  bool _isOnline = false;

  BackgroundLocationService(
    this.service,
    this.sendPort,
    this._webSocketService,
  );

  Future<void> initialize() async {
    await _loadConfig();
    if (_isOnline) {
      _startLocationTracking();
    }
  }

  Future<void> _loadConfig() async {
    debugPrint(" Called _loadConfig ********************** ");
    print(" Called _loadConfig ********************** ");
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getString('websocket_base_url') == null) {
      prefs.setString('websocket_base_url', WebSocketUrl.base);
    }
    if (prefs.getString('websocket_live_location_path') == null) {
      prefs.setString(
        'websocket_live_location_path',
        WebSocketUrl.liveLocation,
      );
    }
    final tempToken = await prefs.getString('auth_token');
    print("token $tempToken +++++++++++++++++++++++++++++");
    if (prefs.getString('auth_token') == null) {
      final token = box.read(BoxKeys.token) ?? '';
      await prefs.setString('auth_token', token);
    }

    _driverState = prefs.getString('driver_state') ?? "idle";
    _passengerId = prefs.getString('passenger_id') ?? "save";
    _isOnline = prefs.getBool('is_online') ?? false;

    final baseUrl = prefs.getString('websocket_base_url')!;
    final path = prefs.getString('websocket_live_location_path')!;
    final token = prefs.getString('auth_token')!;
    debugPrint(" $baseUrl + $path + $token");
    print(" $baseUrl + $path + $token  +++++++++++++++++++++++++++++");
    if (_isOnline &&
        baseUrl.isNotEmpty &&
        path.isNotEmpty &&
        token.isNotEmpty) {
      _webSocketService.initialize(baseUrl, path, token);
    }
  }

  StreamSubscription<Position>? positionSubscription;

  void _startLocationTracking() {
    LocationAccuracy accuracy = _getAccuracyForState(_driverState);
    Duration interval = _getIntervalForState(_driverState);

    debugPrint("Calling _startLocationTracking function with stream");
    log("interval and driverState : $interval , $_driverState #################");

    // Cancel any previous subscription before starting a new one
    positionSubscription?.cancel();

    final locationSettings = LocationSettings(
      accuracy: accuracy,
      distanceFilter:
          0, // set >0 if you only want updates after moving certain meters
      timeLimit: null,
      // optional: on Android you can also set `intervalDuration`
      // intervalDuration: interval,
    );

    positionSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((position) {
      try {
        final shouldSend = _shouldSendUpdate(position);

        debugPrint(
            '$shouldSend _startLocationTracking _shouldSendUpdate **************');
        log('$shouldSend _startLocationTracking _shouldSendUpdate **************');
        saveLocationData(convertPositionToLocationData(position));
        _saveLocationToMemory(position);
        // if (shouldSend) {
        debugPrint("Calling _sendLiveLocation function");
        log("Calling _sendLiveLocation function");
        _sendLiveLocation(position);
        _lastPosition = position;
        _lastSentTime = DateTime.now();
        // }
      } catch (e) {
        log('❌ Error in location stream: $e');
      }
    });
  }

  void _saveLocationToMemory(Position position) async {
  // final box = GetStorage(); // or SharedPreferences
  await box.write("last_latBG", position.latitude);
  await box.write("last_lngGB", position.longitude);
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

  bool _shouldSendUpdate(Position position) {
    if (_lastPosition == null) return true;

    final distance = Geolocator.distanceBetween(
      _lastPosition!.latitude,
      _lastPosition!.longitude,
      position.latitude,
      position.longitude,
    );

    final speedKmh = (position.speed) * 3.6;
    final timeSinceLast = DateTime.now().difference(_lastSentTime);

    return distance > 5 ||
        speedKmh > 10 ||
        timeSinceLast > const Duration(minutes: 1);
  }

  void _sendLiveLocation(Position position) {
    final locationData = {
      "passenger_id": _driverState == 'idle' ? "save" : _passengerId,
      "msg_type": _driverState == 'idle' ? "save" : "ride",
      "ride_status": _driverState,
      "current_loc_long": position.longitude,
      "current_loc_lat": position.latitude,
    };
    debugPrint(
      "_sendLiveLocation first $locationData ************************",
    );
    print("_sendLiveLocation first $locationData ************************");
    log("_sendLiveLocation first $locationData ************************");
    _webSocketService.sendLiveLocation(body: locationData);
  }

  Duration _getIntervalForState(String state) {
    switch (state) {
      case "idle":
        return const Duration(seconds: 5);
      case "waiting":
        return const Duration(seconds: 10);
      case "active":
        return const Duration(seconds: 2);
      default:
        return const Duration(seconds: 2);
    }
  }

  LocationAccuracy _getAccuracyForState(String state) {
    switch (state) {
      case "idle":
        return LocationAccuracy.medium;
      case "waiting":
        return LocationAccuracy.best;
      case "active":
        return LocationAccuracy.high;
      default:
        return LocationAccuracy.high;
    }
  }

  void updateDriverState(String driverState, {String? passengerId}) {
    _driverState = driverState;
    if (passengerId != null) _passengerId = passengerId;
    _locationTimer?.cancel();
    _startLocationTracking(); // restart with new interval/accuracy
  }

  Future<void> dispose() async {
    _locationTimer?.cancel();
    positionSubscription?.cancel();
    positionSubscription = null;
    await _webSocketService.dispose();
  }
}

class BackgroundWebSocketService {
  WebSocketChannel? _channel;
  String? _baseUrl;
  String? _path;
  String? _token;
  bool _connected = false;

  void initialize(String baseUrl, String path, String token) {
    _baseUrl = baseUrl;
    _path = path;
    _token = token;
    print("Inside initialize++++++++++++");
    _connect();
  }

  void _connect() {
    if (_baseUrl == null || _path == null || _token == null) return;

    final url = Uri.parse("$_baseUrl$_path" + "token=$_token");

    log("Web socket url : $url");
    _channel = WebSocketChannel.connect(url);
    _connected = true;

    _channel!.stream.listen(
      (data) {
        log('📨 WebSocket received: $data');
        print('📨 WebSocket received: $data');
      },
      onError: (e) {
        log('❌ WebSocket error: $e');
        print('❌ WebSocket error: $e');
        _connected = false;
        _reconnect();
      },
      onDone: () {
        log('🔌 WebSocket closed');
        _connected = false;
        _reconnect();
      },
    );
  }

  void _reconnect() {
    Timer(const Duration(seconds: 5), () {
      if (!_connected) _connect();
    });
  }

  void sendLiveLocation({required Map<String, dynamic> body}) {
    if (_connected && _channel != null) {
      _channel!.sink.add(json.encode(body));
      log('📤 Location sent via WebSocket inside  ${json.encode(body)} &&&&&&&&&&&&&&&');
    }
  }

  void updateToken(String newToken) {
    _token = newToken;
    _channel?.sink.close();
    _connected = false;
    _connect();
  }

  Future<void> dispose() async {
    _connected = false;
    await _channel?.sink.close().catchError((_) {});
    _channel = null;
  }
}
