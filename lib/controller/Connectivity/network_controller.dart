import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

import '../../core/constants/get_storage_constants.dart';

class NetworkController extends GetxService {
  final Connectivity _connectivity = Connectivity();
  @override
  void onInit() async {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    Geolocator.getServiceStatusStream().listen(_requestPermission);
    checkForInReview();
    try {
      final perMissionStatus = await Location().hasPermission();
      if (perMissionStatus == PermissionStatus.granted) {
        Location().getLocation().then((value) => AppConstants.locationData = value);
      }
    } catch (e) {
      log('Error getting location: $e');
    }
  }

  RxBool inReview = false.obs;

  Future<void> _updateConnectionStatus(List<ConnectivityResult> connectivityResult) async {
    if (connectivityResult.contains(ConnectivityResult.none)) {
      Get.closeAllSnackbars();
      _showSnackbar(
        message: 'PLEASE CONNECT TO THE INTERNET',
        backgroundColor: Colors.red[400]!,
        icon: Icons.wifi_off,
      );
    } else {
      Get.closeCurrentSnackbar();
      _showSnackbar(
        message: 'CONNECTED',
        backgroundColor: Colors.green[400]!,
        icon: Icons.wifi,
        duration: const Duration(seconds: 1),
      );
    }
    Get.closeCurrentSnackbar();
    final isPoorConnection = await _isPoorConnection();

    if (isPoorConnection) {
      _showSnackbar(
        message: 'POOR CONNECTION',
        backgroundColor: Colors.orange[400]!,
        icon: Icons.signal_cellular_connected_no_internet_4_bar,
      );
    }
  }

  void _showSnackbar({
    required String message,
    required Color backgroundColor,
    required IconData icon,
    Duration duration = const Duration(days: 1),
  }) {
    Get.rawSnackbar(
      messageText: Text(
        message,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
      isDismissible: false,
      duration: duration,
      backgroundColor: backgroundColor,
      icon: Icon(
        icon,
        color: Colors.white,
        size: 35,
      ),
      margin: EdgeInsets.zero,
      snackStyle: SnackStyle.GROUNDED,
    );
  }

  Future<bool> _isPoorConnection() async {
    try {
      List<InternetAddress> result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return false;
      }
    } catch (e) {
      return true;
    }

    return true;
  }

  Future<void> _requestPermission(ServiceStatus status) async {
    final perMissionStatus = await Location().hasPermission();
    if (status == ServiceStatus.disabled && perMissionStatus == PermissionStatus.granted) {
      bool isEnabled = await Location().requestService();
      if (!isEnabled) _requestPermission(status);
    }
  }

  void checkForInReview() {
    FirebaseDatabase.instance.ref().child("inReview").onValue.listen((DatabaseEvent event) {
      final snapshot = event.snapshot;

      final data = snapshot.value;
      if (data is bool) {
        inReview.value = data;
      } else {
        log('Unexpected type: ${data.runtimeType}');
      }
    }, onError: (error) {
      log('Error receiving inReview update', error: error);
    });
  }
}
