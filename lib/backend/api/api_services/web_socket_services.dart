import 'dart:convert';
import 'dart:developer';

import 'package:waiver_driver/backend/api/api_services/urls.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../core/constants/get_storage_constants.dart';
import '../../../main.dart';

class WebSocketServices {
  static Uri url =
      Uri.parse("${WebSocketUrl.base}${WebSocketUrl.liveLocation}token=${box.read(BoxKeys.token)}");
  static final channel = WebSocketChannel.connect(url);

  static void sendLiveLocation({required Map<String, dynamic> body}) {
    log("$url");
    log("json.encode(body)");
    log(json.encode(body));
    channel.sink.add(json.encode(body));
  }
}
