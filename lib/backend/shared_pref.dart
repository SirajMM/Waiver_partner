// lib/services/shared_prefs_service.dart

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static final SharedPrefsService _instance = SharedPrefsService._internal();
  static SharedPreferences? _prefs;

  SharedPrefsService._internal();

  factory SharedPrefsService() => _instance;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setToken(String? token) async {
    await _prefs?.setString('token', token ?? '');
  }

  String? getToken() {
    return _prefs?.getString('token');
  }

  Future<void> clear() async {
    await _prefs?.clear();
  }
}
