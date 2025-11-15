import 'dart:developer';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waiver_driver/core/widgets/app_buttons/app_buttons.dart';

import '../../../core/constants/get_storage_constants.dart';

class UpdateChecker {
  static Future<void> checkForUpdate() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.fetchAndActivate();

    // Firebase values
    bool forceUpdate = remoteConfig.getBool('force_update');
    String remoteVersion = remoteConfig.getString('latest_version'); // "3.1.2"
    int remoteBuild = remoteConfig.getInt('min_build_number'); // 52 or higher

    // App version
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version; // "3.1.2"
    int currentBuild = int.parse(packageInfo.buildNumber); // 52

    // Check version difference
    bool versionOutdated =
        _isNewVersionAvailable(currentVersion, remoteVersion);
    bool buildOutdated = currentBuild < remoteBuild;

    // Force update logic
    if (versionOutdated || buildOutdated) {
      log("${forceUpdate} ${remoteVersion} ${remoteBuild} check Update###################### ");
      _showForceUpdateDialog();
    }
  }

  // Version compare function ("3.1.2" < "3.2.0")
  static bool _isNewVersionAvailable(String current, String latest) {
    List<int> currentParts =
        current.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    List<int> latestParts =
        latest.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    for (int i = 0; i < latestParts.length; i++) {
      if (i >= currentParts.length) return true;
      if (latestParts[i] > currentParts[i]) return true;
      if (latestParts[i] < currentParts[i]) return false;
    }
    return false;
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
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
