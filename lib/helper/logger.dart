import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class Interceptor {
  final http.Client _client = http.Client();
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: false, // Should each log print contain a timestamp
    ),
  );

  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    _logRequest('GET', url, headers, null);
    final response = await http.get(url, headers: headers);
    _logResponse(response, url);
    return response;
  }

  Future<http.Response> post(Uri url,
      {Map<String, String>? headers, Object? body}) async {
    _logRequest('POST', url, headers, body);
    final response = await _client.post(url, headers: headers, body: body);
    _logResponse(response, url);
    return response;
  }

  Future<http.Response> put(Uri url,
      {Map<String, String>? headers, Object? body}) async {
    _logRequest('PUT', url, headers, body);
    final response = await _client.put(url, headers: headers, body: body);
    _logResponse(response, url);
    return response;
  }

  Future<http.Response> delete(Uri url,
      {Map<String, String>? headers, Object? body}) async {
    _logRequest('DELETE', url, headers, body);
    final response = await _client.delete(url, headers: headers, body: body);
    _logResponse(response, url);
    return response;
  }

  void _logRequest(
      String method, Uri url, Map<String, String>? headers, Object? body) {
    _logger.i('Request: $method $url');
    if (headers != null) {
      _logger.d('Headers: $headers');
    }
    if (body != null) {
      _logger.d('Body: $body');
    }
  }

  void _logResponse(http.Response response, Uri url) {
    _logger.i(
        'Response: ${response.statusCode} ${response.reasonPhrase} url : $url');
    _logger.d('Headers: ${response.headers}');

    try {
      var jsonBody = jsonDecode(response.body);
      var prettyBody = JsonEncoder.withIndent('  ').convert(jsonBody);
      _logger.d('Body:\n$prettyBody');
    } catch (e) {
      _logger.d('Body:\n${response.body}');
    }
  }

  void close() {
    _client.close();
  }
}
