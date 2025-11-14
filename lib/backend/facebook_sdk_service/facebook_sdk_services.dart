import 'dart:developer';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:facebook_app_events/facebook_app_events.dart';

class FacebookAnalyticsService {
  static final FacebookAppEvents facebookAppEvents = FacebookAppEvents();

  static Future<void> initialize() async {
    if (Platform.isIOS) {
      final status = await AppTrackingTransparency.trackingAuthorizationStatus;
      if (status == TrackingStatus.notDetermined) {
        await AppTrackingTransparency.requestTrackingAuthorization();
      }
      await AppTrackingTransparency.getAdvertisingIdentifier();
    }
  }

  static Future<void> logAppLaunch() async {
    await facebookAppEvents.logEvent(name: 'app_launch');
    log('Logged app launch event');
  }

  static Future<void> logCustomEvent(String eventName, {Map<String, dynamic>? parameters}) async {
    await facebookAppEvents.logEvent(
      name: eventName,
      parameters: parameters,
    );
    log('Logged custom event: $eventName');
  }

  static Future<void> logPurchase({
    required double amount,
    required String currency,
    Map<String, dynamic>? parameters,
  }) async {
    await facebookAppEvents.logPurchase(
      amount: amount,
      currency: currency,
      parameters: parameters,
    );
    log('Logged purchase event: $amount $currency');
  }

  static Future<void> setUserData({
    String? email,
    String? phone,
    String? userId,
  }) async {
    await facebookAppEvents.setUserData(
      email: email ?? '',
      phone: phone ?? '',
    );
    log('Set user data for Facebook');
  }
}
