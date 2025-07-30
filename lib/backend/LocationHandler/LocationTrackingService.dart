// lib/services/location_tracking_service.dart

import 'dart:isolate';
import 'dart:convert';
import 'dart:async';
import 'dart:developer';
import 'package:geolocator/geolocator.dart';

class LocationTrackingService {
  static Isolate? _locationIsolate;
  static SendPort? _locationSendPort;
  static bool _isTracking = false;
  static ReceivePort? _locationReceivePort;

  // Start location tracking in a separate isolate
  static Future<void> startLocationTracking({
    // required String driverId,
    String? passengerId,
    required String driverState,
    Function(Position)? onPositionUpdate,
    Function(Map<String, dynamic>)? onSaveLocation,
    Function(Map<String, dynamic>)? onWebSocketSend,
  }) async {
    if (_isTracking) {
      log('Location tracking already running');
      return;
    }

    // Check permissions first
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions permanently denied');
    }

    try {
      // Create receive port for communication with location isolate
      _locationReceivePort = ReceivePort();

      // Listen for messages from location isolate
      _locationReceivePort!.listen((data) {
        if (data is Map<String, dynamic>) {
          switch (data['type']) {
            case 'ready':
              log('Location isolate ready');
              break;
            case 'position_update':
              final positionData = data['position'];
              final position = Position(
                latitude: positionData['latitude'],
                longitude: positionData['longitude'],
                timestamp: positionData['timestamp'] != null
                    ? DateTime.fromMillisecondsSinceEpoch(positionData['timestamp'])
                    : DateTime.now(),
                accuracy: positionData['accuracy'],
                altitude: positionData['altitude'],
                altitudeAccuracy: positionData['altitudeAccuracy'] ?? 0.0,
                heading: positionData['heading'],
                headingAccuracy: positionData['headingAccuracy'] ?? 0.0,
                speed: positionData['speed'],
                speedAccuracy: positionData['speedAccuracy'],
              );
              onPositionUpdate?.call(position);
              break;
            case 'save_location':
              onSaveLocation?.call(data['locationData']);
              break;
            case 'send_websocket':
            // Use your existing WebSocket service
              onWebSocketSend?.call(data['payload']);
              break;
            case 'location_sent':
              log('Location data sent: ${data['lat']}, ${data['lng']}');
              break;
            case 'location_error':
              log('Location error: ${data['error']}');
              break;
            case 'send_port':
              _locationSendPort = data['sendPort'];
              log('Location isolate send port received');
              break;
          }
        }
      });

      // Spawn the location tracking isolate
      _locationIsolate = await Isolate.spawn(
        _locationTrackingIsolateEntry,
        {
          'receivePort': _locationReceivePort!.sendPort,
          'config': {
            // 'driverId': driverId,
            'passengerId': passengerId,
            'driverState': driverState,
          }
        },
      );

      _isTracking = true;
      log('Location tracking isolate started');
    } catch (e) {
      log('Failed to start location tracking isolate: $e');
      _locationReceivePort?.close();
      throw e;
    }
  }

  // Update configuration
  static void updateDriverState({
    String? passengerId,
    required String driverState,
  }) {
    if (_locationSendPort != null && _isTracking) {
      _locationSendPort!.send({
        'action': 'update_config',
        'config': {
          'passengerId': passengerId,
          'driverState': driverState,
        },
      });
      log('Driver state updated in location isolate');
    }
  }

  // Stop location tracking
  static void stopLocationTracking() {
    if (_locationSendPort != null) {
      _locationSendPort!.send({'action': 'stop'});
    }

    _locationIsolate?.kill(priority: Isolate.immediate);
    _locationReceivePort?.close();

    _locationIsolate = null;
    _locationSendPort = null;
    _locationReceivePort = null;
    _isTracking = false;

    log('Location tracking stopped');
  }

  static bool get isTracking => _isTracking;
}

// Location tracking isolate entry point
@pragma('vm:entry-point')
void _locationTrackingIsolateEntry(Map<String, dynamic> params) async {
  final SendPort mainSendPort = params['receivePort'];
  final Map<String, dynamic> config = params['config'];

  // Create receive port for this isolate
  final ReceivePort isolateReceivePort = ReceivePort();

  // Send the send port back to main isolate
  mainSendPort.send({
    'type': 'send_port',
    'sendPort': isolateReceivePort.sendPort,
  });

  // Location tracking state
  StreamSubscription<Position>? locationSubscription;
  Map<String, dynamic> currentConfig = Map.from(config);

  // Send location data via WebSocket
  void sendLocationData(Position position) {
    // Always update current position and save location data
    mainSendPort.send({
      'type': 'position_update',
      'position': {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'timestamp': position.timestamp?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch,
        'accuracy': position.accuracy,
        'altitude': position.altitude,
        'altitudeAccuracy': position.altitudeAccuracy,
        'heading': position.heading,
        'headingAccuracy': position.headingAccuracy,
        'speed': position.speed,
        'speedAccuracy': position.speedAccuracy,
      }
    });

    // Save location data locally - send data that matches your convertPositionToLocationData format
    mainSendPort.send({
      'type': 'save_location',
      'locationData': {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'accuracy': position.accuracy,
        'altitude': position.altitude,
        'speed': position.speed,
        'speed_accuracy': position.speedAccuracy, // Note: using speed_accuracy to match your fromMap
        'heading': position.heading,
      }
    });

    // Always send to WebSocket - let your WebSocketServices handle online/offline logic
    final locationPayload = {
      "passenger_id": currentConfig['driverState'] == 'idle'
          ? currentConfig['driverId']
          : currentConfig['passengerId'] ?? "placeholder",
      "msg_type": currentConfig['driverState'] == 'idle' ? "save" : "ride",
      "ride_status": currentConfig['driverState'],
      "current_loc_long": position.longitude,
      "current_loc_lat": position.latitude,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
    };

    // Send location data to main isolate to use existing WebSocket
    mainSendPort.send({
      'type': 'send_websocket',
      'payload': locationPayload,
    });

    mainSendPort.send({
      'type': 'location_sent',
      'lat': position.latitude,
      'lng': position.longitude,
    });
  }

  // Start location stream
  void startLocationStream() {
    locationSubscription?.cancel();

    locationSubscription = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
        timeLimit: Duration(seconds: 30),
      ),
    ).listen(
          (Position position) {
        sendLocationData(position);
      },
      onError: (error) {
        mainSendPort.send({
          'type': 'location_error',
          'error': error.toString(),
        });
      },
    );
  }

  // Listen for commands from main isolate
  isolateReceivePort.listen((data) {
    if (data is Map<String, dynamic>) {
      switch (data['action']) {
        case 'update_config':
        // Update only the provided config values
          data['config'].forEach((key, value) {
            currentConfig[key] = value;
          });
          break;
        case 'stop':
          locationSubscription?.cancel();
          isolateReceivePort.close();
          break;
      }
    }
  });

  // Initialize everything
  startLocationStream();

  // Send ready signal
  mainSendPort.send({'type': 'ready'});
}