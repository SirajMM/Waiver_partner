import 'dart:developer';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/get_storage_constants.dart';

class UpdateChecker {
  static Future<void> checkForUpdate() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetchAndActivate();
    int remoteVersion = remoteConfig.getInt('force_update_config');
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int currentBuild = int.parse(packageInfo.buildNumber);

    bool buildOutdated = currentBuild < remoteVersion;

    if (buildOutdated) {
      _showForceUpdateDialog();
    }
  }

  static void _showForceUpdateDialog() {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => true, // prevent back button
        child: Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.system_update, size: 60),
                const SizedBox(height: 15),
                const Text(
                  "Update Required",
                  style: TextStyle(
                    // color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "A new version of the app is available.\nPlease update to get latest features.Ignore this message if you have already updated.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () => _openStore(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.getColor(),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    "Update Now",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void _openStore() {
    const packageName = "com.waiver.driver";

    launchUrl(
      Uri.parse("https://play.google.com/store/apps/details?id=$packageName"),
      mode: LaunchMode.externalApplication,
    );
  }
}
