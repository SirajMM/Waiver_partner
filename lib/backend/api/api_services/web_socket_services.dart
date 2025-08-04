import 'dart:convert';
import 'dart:developer';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketServices {
  static WebSocketChannel? _channel;

  static Future<void> connect(String token) async {
    if (token.isEmpty) {
      print("❌ Token is null or empty. Cannot connect to WebSocket.");
      return;
    }

    final url = Uri.parse("wss://api.waiverapp.in/ws/live-location/?token=$token");
    log("‼️ Connecting to WebSocket: $url");
    try {
      _channel = WebSocketChannel.connect(url);

      _channel?.stream.listen(
        (data) => print("📩 Received: $data"),
        onDone: () {
          print("✅ WebSocket closed.");
          // HomeController.to.isOnline.value = false;
        },
        onError: (error) => print("❌ WebSocket error: $error"),
      );

      print("✅ WebSocket connected.");
    } catch (e) {
      print("❌ Failed to connect WebSocket: $e");
    }
  }

  static void sendLiveLocation({required Map<String, dynamic> body}) {
    if (_channel == null) {
      print("❌ WebSocket not connected. Cannot send data.");
      return;
    }

    final jsonData = json.encode(body);
    print("📤 Sending live location: $jsonData");
    _channel?.sink.add(jsonData);
  }

  static void setData({
    required String passengerId,
    required String driverState,
    required bool isOnline,
    required String messageType,
    required String token,
  }) async {
    bool isRunning = await FlutterBackgroundService().isRunning();
    if (isRunning) {
      FlutterBackgroundService().invoke("setData", {
        "passengerId": passengerId,
        "driverState": driverState,
        "isOnline": isOnline,
        "messageType": messageType,
        "token": token,
      });
    }
  }

  static void disconnect() async {
    _channel?.sink.close();
    _channel = null;
    FlutterBackgroundService().invoke("stopService");
    await AwesomeNotifications().cancel(888);
  }
}
