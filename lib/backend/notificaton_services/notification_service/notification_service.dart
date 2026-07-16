import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:waiver_driver/backend/model/home/home_model.dart';
import 'package:waiver_driver/controller/home/home_controller.dart';
import 'package:waiver_driver/core/colors/app_colors.dart';
import 'package:waiver_driver/core/constants/enums/enums.dart';
import 'package:waiver_driver/helper/init/init.dart';

class NotificationService {
  static Future<void> onInit() async {
    await MainBinding().dependencies();
    await AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
            channelKey: "basic_notification_channel",
            channelName: "Waiver Driver notification channel",
            channelDescription: "Notification channel for Waiver Driver man app",
            importance: NotificationImportance.Max,
            channelShowBadge: true,
            onlyAlertOnce: true,
            playSound: true,
            criticalAlerts: true,
          )
        ],
        channelGroups: [
          NotificationChannelGroup(
              channelGroupKey: ("basic_notification_channels"),
              channelGroupName: "Waiver Driver notification channel"),
        ],
        debug: true);

    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }

    await AwesomeNotifications().setListeners(
        onActionReceivedMethod: onActionReceivedMethod,
        onDismissActionReceivedMethod: onDismissActionReceivedMethod,
        onNotificationCreatedMethod: onNotificationCreatedMethod,
        onNotificationDisplayedMethod: onNotificationDisplayedMethod);

    debugPrint("AwesomeNotifications channel created");
  }

  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(ReceivedAction action) async {}

  static Future<void> onDismissActionReceivedMethod(ReceivedNotification notification) async {}

  static Future<void> onNotificationCreatedMethod(ReceivedNotification notification) async {}

  static Future<void> onNotificationDisplayedMethod(ReceivedNotification notification) async {}


  static Future<void> onMessage({required RemoteMessage notification}) async {
    debugPrint(
        "📩 RemoteMessage payload -> notification: ${notification.notification?.title} / ${notification.notification?.body} | data: ${notification.data}");
    OrderDetailsModel data = OrderDetailsModel.fromJson(notification.data);
    await showNotification(data: data);

    switch (data.rideStatus) {
      case "RED":
      case "FRED":
        HomeController.to.getAndShowOrderDetails(id: data.rideId ?? "");
        break;

      case "CAD":
      case "FCAD":
        final player = AudioPlayer();
        player.stop();
        HomeController.to.resetDistance();
        HomeController.to.isTracking = false;
        HomeController.to.rideIsActive = false;
        HomeController.to.driverState.value = DriverState.idle;
        HomeController.to.startLocationLongMarker = 0.0;
        HomeController.to.startLocationLatMarker = 0.0;
        HomeController.to.recenter();
        // Get.bottomSheet(OrderCompletedBottomSheet());
        break;

      case "PID":
        HomeController.to.isTracking = false;
        HomeController.to.rideIsActive = true;
        HomeController.to.driverState.value = DriverState.paymentInitiated;
        break;

      case "COD":
        HomeController.to.isTracking = false;
        HomeController.to.rideIsActive = true;
        await HomeController.to.getRidePayment();
        HomeController.to.driverState.value = DriverState.completed;
        HomeController.to.driverState.value = DriverState.idle;
        HomeController.to.confirmedPayment();
        break;

      default:
        HomeController.to.driverState.value = DriverState.idle;
        break;
    }
    // if (data.rideStatus == "RED" || data.rideStatus == RideStatus.favRideRequested) {
    //   HomeController.to.getAndShowOrderDetails(id: data.rideId ?? "");
    // } else if (data.rideStatus == RideStatus.cancelled || data.rideStatus == RideStatus.favRideCancelled)  {
    //   final player = AudioPlayer();
    //   player.stop();
    //   HomeController.to.resetDistance();
    //   HomeController.to.isTracking = false;
    //   HomeController.to.rideIsActive = false;
    //   HomeController.to.driverState.value = DriverState.idle;
    //   // Get.bottomSheet(OrderCompletedBottomSheet());
    // } else if (data.rideStatus == RideStatus.paymentInitiated) {
    //   HomeController.to.isTracking = false;
    //   HomeController.to.rideIsActive = true;
    //   HomeController.to.driverState.value = DriverState.paymentInitiated;
    // } else if (data.rideStatus == RideStatus.completed) {
    //   HomeController.to.isTracking = false;
    //   HomeController.to.rideIsActive = true;
    //   await HomeController.to.getRidePayment();
    //   HomeController.to.driverState.value = DriverState.completed;
    // } else {
    //   HomeController.to.driverState.value = DriverState.idle;
    // }
  }

  static Future<void> onMessageOpenedApp({required RemoteMessage notification}) async {
    // No showNotification() here: this fires when the driver taps a
    // notification that's already been displayed (by the OS or by CallKit),
    // so showing another one is redundant.
    OrderDetailsModel data = OrderDetailsModel.fromJson(notification.data);

    switch (data.rideStatus) {
      case "RED" || "FRED":
        await HomeController.to.getAndShowOrderDetails(id: data.rideId ?? "");
        break;

      case "CAD":
      case "FCAD":
        final player = AudioPlayer();
        player.stop();
        HomeController.to.resetDistance();
        HomeController.to.isTracking = false;
        HomeController.to.rideIsActive = false;
        HomeController.to.driverState.value = DriverState.idle;
        // Get.bottomSheet(OrderCompletedBottomSheet());
        break;

      case "PID":
        HomeController.to.isTracking = false;
        HomeController.to.rideIsActive = true;
        HomeController.to.driverState.value = DriverState.paymentInitiated;
        break;

      case "COD":
        HomeController.to.isTracking = false;
        HomeController.to.rideIsActive = true;
        await HomeController.to.getRidePayment();
        HomeController.to.driverState.value = DriverState.completed;
        break;

      default:
        HomeController.to.driverState.value = DriverState.idle;
        break;
    }
    // if (data.rideStatus == "RED") {
    //   HomeController.to.getAndShowOrderDetails(id: data.rideId ?? "");
    // } else if (data.rideStatus == RideStatus.cancelled) {
    //   final player = AudioPlayer();
    //   player.stop();
    //   HomeController.to.resetDistance();
    //   HomeController.to.isTracking = false;
    //   HomeController.to.rideIsActive = false;
    //   HomeController.to.driverState.value = DriverState.idle;
    //   // Get.bottomSheet(OrderCompletedBottomSheet());
    // } else if (data.rideStatus == RideStatus.paymentInitiated) {
    //   HomeController.to.isTracking = false;
    //   HomeController.to.rideIsActive = true;
    //   HomeController.to.driverState.value = DriverState.paymentInitiated;
    // } else if (data.rideStatus == RideStatus.completed) {
    //   HomeController.to.isTracking = false;
    //   HomeController.to.rideIsActive = true;
    //   await HomeController.to.getRidePayment();
    //   HomeController.to.driverState.value = DriverState.completed;
    // } else {
    //   HomeController.to.driverState.value = DriverState.idle;
    // }
  }

  static Future<void> showNotification({required OrderDetailsModel data}) async {
    AwesomeNotifications().cancelAll();
    AwesomeNotifications().createNotification(
      content: NotificationContent(
          notificationLayout: NotificationLayout.BigPicture,
          // icon: "assets/icons/app_icon.png",
          // icon: AppIcons.appIcon,
          icon: "resource://drawable/ic_stat_applogo_removebg_preview",
          id: Random().nextInt(100000000),
          backgroundColor: AppColors.white,
          channelKey: "basic_notification_channel",
          title: data.title ?? "",
          body: data.body ?? "",
          autoDismissible: true),
    );
  }
}
