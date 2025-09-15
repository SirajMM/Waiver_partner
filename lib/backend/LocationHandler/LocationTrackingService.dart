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

import '../../core/constants/get_storage_constants.dart';
import '../../main.dart';
import '../api/api_services/urls.dart';

class LocationTrackingService extends GetxController {
  final isRunning = false.obs;
  final service = FlutterBackgroundService();
  static const String _portName = 'location_service_port';
  ReceivePort? _receivePort;

  StreamSubscription<Position>? _positionStream;

  @override
  void onInit() {
    super.onInit();
    _initializePortListener();
    log("LocationTrackingService initialized");
  }

  @override
  void onClose() {
    _receivePort?.close();
    _positionStream?.cancel();
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
      _positionStream?.cancel();
      _positionStream = null;

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

    if (!isOnline) {
      await _stopBackgroundService();
    } else {
      await _startBackgroundService();
    }
  }

  // Add this method to your LocationTrackingService class
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

  Future<void> updateDriverState(String driverState,
      {String? passengerId}) async {
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
}

@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    // Create notification channel FIRST - this is critical
    await _createNotificationChannelInBackground();

    // Check if driver should be online
    final prefs = await SharedPreferences.getInstance();
    final isOnline = prefs.getBool('is_online') ?? false;

    if (!isOnline) {
      log('🛑 Driver is offline, stopping service immediately');
      // Set a brief notification before stopping
      if (Platform.isAndroid && service is AndroidServiceInstance) {
        try {
          service.setForegroundNotificationInfo(
            title: "Waiver Driver",
            content: "Service stopping - driver offline",
          );
        } catch (e) {
          log('❌ Error setting stop notification: $e');
        }
      }
      log("🚀 Background service onStart called");
      // Small delay to allow notification to show
      await Future.delayed(const Duration(milliseconds: 200));
      service.stopSelf();
      return;
    }

    // Set foreground notification AFTER channel creation
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

    // Get communication port
    final SendPort? sendPort = IsolateNameServer.lookupPortByName(
      LocationTrackingService._portName,
    );

    // Initialize background services
    final wsService = BackgroundWebSocketService();
    final locationServiceBackground =
        BackgroundLocationService(service, sendPort, wsService);
    final locationService = LocationTrackingService();

    // Initialize location service
    await locationServiceBackground.initialize();

    // Set up service event listeners
    service.on('stop_service').listen((event) async {
      log('🛑 Received stop command - cleaning up');

      try {
        // Update notification to show stopping
        if (Platform.isAndroid && service is AndroidServiceInstance) {
          service.setForegroundNotificationInfo(
            title: "Waiver Driver",
            content: "Stopping location tracking...",
          );
        }

        // Dispose services with timeout
        await locationServiceBackground.dispose().timeout(
              const Duration(seconds: 2),
              onTimeout: () => log('⚠️ Service dispose timed out'),
            );

        // Small delay for cleanup
        await Future.delayed(const Duration(milliseconds: 200));

        log('✅ Service cleanup completed, stopping');
        service.stopSelf();
      } catch (e) {
        log('❌ Error during service cleanup: $e');
        service.stopSelf();
      }
    });

    service.on('update_state').listen((event) {
      if (event != null && event is Map<String, dynamic>) {
        locationService.updateDriverState(
          event['driver_state'] as String,
          passengerId: event['passenger_id'] as String?,
        );
      }
    });

    service.on('update_token').listen((event) {
      if (event != null && event is Map<String, dynamic>) {
        locationService.updateAuthToken(event['token'] as String);
      }
    });

    service.on('update_online_status').listen((event) async {
      if (event != null && event is Map<String, dynamic>) {
        final isOnlineUpdate = event['is_online'] as bool;
        if (!isOnlineUpdate) {
          log('🛑 Going offline - disposing service');
          try {
            await locationServiceBackground.dispose().timeout(
                  const Duration(seconds: 2),
                  onTimeout: () => log('⚠️ Dispose timeout on offline'),
                );
            await Future.delayed(const Duration(milliseconds: 200));
            service.stopSelf();
          } catch (e) {
            log('❌ Error going offline: $e');
            service.stopSelf();
          }
        } else {
          locationService.updateOnlineStatus(isOnlineUpdate);
        }
      }
    });

    log('✅ Background service started successfully');
  } catch (e) {
    log('❌ Critical error in onStart: $e');

    // Attempt to set error notification
    try {
      if (Platform.isAndroid && service is AndroidServiceInstance) {
        service.setForegroundNotificationInfo(
          title: "Waiver Driver",
          content: "Service error - stopping",
        );
      }
      await Future.delayed(const Duration(milliseconds: 200));
    } catch (notificationError) {
      log('❌ Error setting error notification: $notificationError');
    }

    // Stop service on any critical error
    service.stopSelf();
  }
}

// Helper function to create notification channel in background isolate
Future<void> _createNotificationChannelInBackground() async {
  if (Platform.isAndroid) {
    try {
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

      log('✅ Background notification channel created');
    } catch (e) {
      log('❌ Error creating notification channel in background: $e');
    }
  }
}

// ----------------- iOS Background -----------------
@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  // Required for iOS background execution
  await onStart(service);
  return true;
}

class BackgroundLocationService {
  final ServiceInstance service;
  final SendPort? sendPort;
  final BackgroundWebSocketService _webSocketService;

  Timer? _locationTimer;
  bool _isRunning = true;

  String _driverState = 'idle';
  String _passengerId = 'placeholder';
  bool _isOnline = false;

  BackgroundLocationService(
      this.service, this.sendPort, this._webSocketService);

  Future<void> initialize() async {
    await _loadConfig();
    if (_isOnline) {
      _startLocationTracking();
    } else {
      _stopServiceSafely();
    }

    service.on('stop_service').listen((_) async {
      await dispose();
      service.stopSelf();
    });

    service.on('update_state').listen((event) {
      if (event != null && event is Map<String, dynamic>) {
        _driverState = event['driver_state'] ?? _driverState;
        _passengerId = event['passenger_id'] ?? _passengerId;
      }
    });

    service.on('update_token').listen((event) {
      if (event != null && event is Map<String, dynamic>) {
        _webSocketService.updateToken(event['token'] ?? '');
      }
    });
  }

  Future<void> _loadConfig() async {
    final prefs = await SharedPreferences.getInstance();

    // Restore SharedPreferences defaults if not already set
    if (prefs.getString('websocket_base_url') == null) {
      prefs.setString('websocket_base_url', WebSocketUrl.base);
    }
    if (prefs.getString('websocket_live_location_path') == null) {
      prefs.setString(
          'websocket_live_location_path', WebSocketUrl.liveLocation);
    }
    if (prefs.getString('auth_token') == null) {
      final token = box.read(BoxKeys.token) ?? '';
      await prefs.setString('auth_token', token);
    }

    _driverState = prefs.getString('driver_state') ?? 'idle';
    _passengerId = prefs.getString('passenger_id') ?? 'placeholder';
    _isOnline = prefs.getBool('is_online') ?? false;

    final baseUrl = prefs.getString('websocket_base_url')!;
    final path = prefs.getString('websocket_live_location_path')!;
    final token = prefs.getString('auth_token')!;

    if (_isOnline &&
        baseUrl.isNotEmpty &&
        path.isNotEmpty &&
        token.isNotEmpty) {
      _webSocketService.initialize(baseUrl, path, token);
      sendPort?.send({'type': 'websocket_status', 'status': 'connected'});
    }

    log('📋 Loaded config: driverState=$_driverState, isOnline=$_isOnline');
  }

  void _startLocationTracking() {
    _locationTimer = Timer.periodic(const Duration(seconds: 15), (timer) async {
      if (!_isRunning || !_isOnline) {
        timer.cancel();
        _stopServiceSafely();
        return;
      }

      try {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 10),
        );
        log("📍 Got new position: $position");
        sendPort?.send({
          'type': 'location_update',
          'position': {
            'latitude': position.latitude,
            'longitude': position.longitude,
            'accuracy': position.accuracy,
            'timestamp': position.timestamp?.millisecondsSinceEpoch,
          }
        });

        _sendLiveLocation(position);

        if (Platform.isAndroid && service is AndroidServiceInstance) {
          (service as AndroidServiceInstance).setForegroundNotificationInfo(
            title: "Waiver Driver - Active",
            content: "Tracking location for rides...",
          );
        }
      } catch (e) {
        log('❌ Error in location tracking: $e');
      }
    });
  }

  Future<void> _sendLiveLocation(Position position) async {
    final locationData = {
      "passenger_id": _driverState == 'idle' ? "save" : _passengerId,
      "msg_type": _driverState == 'idle' ? "save" : "ride",
      "ride_status": _driverState,
      "current_loc_long": position.longitude,
      "current_loc_lat": position.latitude,
    };
    log("*************_sendLiveLocation: $locationData");
    _webSocketService.sendLiveLocation(body: locationData);
    sendPort?.send({'type': 'location_sent', 'data': locationData});
  }

  void _stopServiceSafely() {
    _isRunning = false;
    _locationTimer?.cancel();
    _webSocketService.dispose().catchError((e) {
      log('❌ WebSocket dispose error: $e');
    });
  }

  Future<void> dispose() async {
    _stopServiceSafely();
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
    _connect();
  }

  void _connect() {
    if (_baseUrl == null || _path == null || _token == null) return;

    final url = Uri.parse("$_baseUrl$_path" + "token=$_token");
    _channel = WebSocketChannel.connect(url);
    _connected = true;

    _channel!.stream.listen(
      (data) => log('📨 WebSocket received: $data'),
      onError: (e) {
        log('❌ WebSocket error: $e');
        _connected = false;
        _reconnect();
      },
      onDone: () {
        log('🔌 WebSocket closed');
        _connected = false;
        _reconnect();
      },
    );

    log('✅ WebSocket connected to $url');
  }

  void _reconnect() {
    Timer(const Duration(seconds: 5), () {
      if (!_connected) _connect();
    });
  }

  void sendLiveLocation({required Map<String, dynamic> body}) {
    if (_connected && _channel != null) {
      log("*************_sendLiveLocation:${_baseUrl}${_path} ${body}");
      log('📤 Location sent via WebSocket');
      print("*************_sendLiveLocation:$_baseUrl$_path $body");
      print('📤 Location sent via WebSocket');
      _channel!.sink.add(json.encode(body));
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
