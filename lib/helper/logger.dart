import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

/// Structured logger for the API layer.
///
/// Silent in release builds: request/response payloads carry auth tokens and
/// personal data, so they must never reach production logcat/console.
class ApiLog {
  ApiLog._();

  static final Logger _logger = Logger(
    level: kReleaseMode ? Level.off : Level.debug,
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: false,
      dateTimeFormat: DateTimeFormat.onlyTime,
    ),
  );

  static void request(String method, Uri url,
      {Map<String, String>? headers, Object? body}) {
    final buffer = StringBuffer('--> $method $url');
    if (headers != null && headers.isNotEmpty) {
      buffer.write('\nheaders: ${redactHeaders(headers)}');
    }
    if (body != null) {
      buffer.write('\nbody: ${_pretty(body.toString())}');
    }
    _logger.i(buffer.toString());
  }

  static void response(Uri url, int statusCode, String body) {
    final message = '<-- $statusCode $url\n${_pretty(body)}';
    if (statusCode >= 400) {
      _logger.w(message);
    } else {
      _logger.i(message);
    }
  }

  static void error(String context, Object error, [StackTrace? stackTrace]) {
    _logger.e(context, error: error, stackTrace: stackTrace);
  }

  /// Tokens must never appear in logs, even in debug.
  static Map<String, String> redactHeaders(Map<String, String> headers) => {
        for (final entry in headers.entries)
          entry.key: entry.key.toLowerCase() == 'authorization'
              ? '<redacted>'
              : entry.value,
      };

  static const int _maxBodyLength = 2000;

  static String _pretty(String body) {
    String text;
    try {
      text = const JsonEncoder.withIndent('  ').convert(jsonDecode(body));
    } catch (_) {
      text = body;
    }
    if (text.length > _maxBodyLength) {
      text = '${text.substring(0, _maxBodyLength)}\n… (${text.length} chars)';
    }
    return text;
  }
}

/// HTTP client for all API calls: logs every request and response through
/// [ApiLog] (Authorization header redacted) in one place instead of ad-hoc
/// log lines at each call site.
class ApiClient {
  ApiClient._();

  static final ApiClient instance = ApiClient._();

  final http.Client _client = http.Client();

  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    ApiLog.request('GET', url, headers: headers);
    final response = await _client.get(url, headers: headers);
    ApiLog.response(url, response.statusCode, response.body);
    return response;
  }

  Future<http.Response> post(Uri url,
      {Map<String, String>? headers, Object? body}) async {
    ApiLog.request('POST', url, headers: headers, body: body);
    final response = await _client.post(url, headers: headers, body: body);
    ApiLog.response(url, response.statusCode, response.body);
    return response;
  }

  Future<http.Response> put(Uri url,
      {Map<String, String>? headers, Object? body}) async {
    ApiLog.request('PUT', url, headers: headers, body: body);
    final response = await _client.put(url, headers: headers, body: body);
    ApiLog.response(url, response.statusCode, response.body);
    return response;
  }

  Future<http.Response> delete(Uri url,
      {Map<String, String>? headers, Object? body}) async {
    ApiLog.request('DELETE', url, headers: headers, body: body);
    final response = await _client.delete(url, headers: headers, body: body);
    ApiLog.response(url, response.statusCode, response.body);
    return response;
  }

  /// For [http.MultipartRequest] and other streamed requests. The response
  /// stream is buffered so it can be logged and still consumed by the caller.
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    ApiLog.request(
      request.method,
      request.url,
      headers: request.headers,
      body: request is http.MultipartRequest
          ? 'multipart fields: ${request.fields}, '
              'files: ${request.files.map((f) => f.filename).toList()}'
          : null,
    );
    final streamed = await request.send();
    final bytes = await streamed.stream.toBytes();
    ApiLog.response(
      request.url,
      streamed.statusCode,
      utf8.decode(bytes, allowMalformed: true),
    );
    return http.StreamedResponse(
      Stream.value(bytes),
      streamed.statusCode,
      contentLength: bytes.length,
      request: streamed.request,
      headers: streamed.headers,
      isRedirect: streamed.isRedirect,
      persistentConnection: streamed.persistentConnection,
      reasonPhrase: streamed.reasonPhrase,
    );
  }
}