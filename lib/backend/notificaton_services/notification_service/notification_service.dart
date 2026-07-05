import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:waiver_driver/backend/model/home/home_model.dart';
import 'package:waiver_driver/controller/home/home_controller.dart';
import 'package:waiver_driver/core/colors/app_colors.dart';
import 'package:waiver_driver/core/constants/enums/enums.dart';
import 'package:waiver_driver/core/constants/get_storage_constants.dart';
import 'package:waiver_driver/helper/init/init.dart';

import 'package:waiver_driver/main.dart';

class NotificationService {
  /// Fixed id for the iOS ride "call" notification so it can be cancelled
  /// once the driver taps Accept/Reject.
  static const int rideCallNotificationId = 1122;

  /// Action button keys for the iOS ride "call" notification.
  static const String acceptRideActionKey = "ACCEPT_RIDE";
  static const String rejectRideActionKey = "REJECT_RIDE";

  static Future<void> onInit() async {
    await MainBinding().dependencies();
    await AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
            channelKey: "basic_notification_channel",
            channelName: "Waiver Driver notification channel",
            channelDescription:
                "Notification channel for Waiver Driver man app",
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
    if (isAllowed) {
      // <-- FIXED: Only request if NOT allowed
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }

    await AwesomeNotifications().setListeners(
        onActionReceivedMethod: onActionReceivedMethod,
        onDismissActionReceivedMethod: onDismissActionReceivedMethod,
        onNotificationCreatedMethod: onNotificationCreatedMethod,
        onNotificationDisplayedMethod: onNotificationDisplayedMethod);

    debugPrint("AwesomeNotifications channel created");
  }

  /// Handles taps on the iOS ride "call" notification (Accept / Reject).
  ///
  /// This mirrors the Android CallKit flow in [CallFunctionality]: instead of
  /// touching [HomeController] directly (which may not be registered in the
  /// notification-action isolate), it forwards the decision to the main isolate
  /// through the existing `main_send_port`. `startReceivePort` in main.dart then
  /// runs the exact same downstream logic used by the Android accept/decline
  /// events (`onCallAccepted` / `orderTimeOut`).
  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(ReceivedAction action) async {
    // Only react to our ride-call action buttons.
    if (action.buttonKeyPressed != acceptRideActionKey &&
        action.buttonKeyPressed != rejectRideActionKey) {
      return;
    }

    final Map<String, String?> payload = action.payload ?? {};
    final String? rideId = payload["rideId"];
    final String? rideStatus = payload["rideStatus"];
    final String? paymentType = payload["paymentType"];

    final SendPort? sendPort =
        IsolateNameServer.lookupPortByName('main_send_port');

    if (action.buttonKeyPressed == acceptRideActionKey) {
      sendPort?.send({
        'title': 'accepted',
        'callId': '',
        'rideStatus': rideStatus,
        'rideId': rideId,
        'paymentType': paymentType,
      });
    } else {
      sendPort?.send({
        'title': 'cancelled',
        'rideId': rideId,
      });
    }

    await AwesomeNotifications().cancel(rideCallNotificationId);
  }

  static Future<void> onDismissActionReceivedMethod(
      ReceivedNotification notification) async {}

  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification notification) async {}

  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification notification) async {}

  static handleNotificationOnBackGround(
      {required RemoteMessage notification}) {}

  static Future<void> onMessage({required RemoteMessage notification}) async {
    OrderDetailsModel data = OrderDetailsModel.fromJson(notification.data);
    await showNotification(data: data);
    print(notification.notification);
    HomeController.to.driverState.value = DriverState.loading;
    print("notification.data");
    print(notification.data ?? "No message");
    print(notification.notification?.body);
    print(notification.notification?.title);
    box.write(BoxKeys.paymentType, data.paymentType);
    print("***********************${data.rideStatus}");

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

  static Future<void> onMessageOpenedApp(
      {required RemoteMessage notification}) async {
    OrderDetailsModel data = OrderDetailsModel.fromJson(notification.data);
    showNotification(data: data);
    print(
        "############################notification.data#################################");
    print(notification.data);
    print(notification.notification);

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

  /// iOS replacement for the Android CallKit incoming-call screen.
  ///
  /// Shows a high-priority notification with Accept / Reject action buttons for
  /// a new ride request (rideStatus RED/FRED). Because iOS CallKit requires
  /// VoIP/PushKit (not used in this app), this is the closest experience that
  /// works from a normal FCM push while the app is in the foreground or
  /// background (not force-terminated).
  static Future<void> showRideCallNotification(
      {required OrderDetailsModel data}) async {
    await AwesomeNotifications().cancelAll();
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: rideCallNotificationId,
        channelKey: "basic_notification_channel",
        icon: "resource://drawable/ic_stat_applogo_removebg_preview",
        backgroundColor: AppColors.white,
        title: data.title ?? "New Ride Request",
        body: data.body ?? "Tap Accept to view the ride details",
        category: NotificationCategory.Call,
        wakeUpScreen: true,
        fullScreenIntent: true,
        autoDismissible: false,
        payload: {
          "rideId": data.rideId ?? "",
          "rideStatus": data.rideStatus ?? "",
          "paymentType": data.paymentType ?? "",
        },
      ),
      actionButtons: [
        NotificationActionButton(
          key: acceptRideActionKey,
          label: "Accept",
          actionType: ActionType.Default,
          color: AppColors.green40,
        ),
        NotificationActionButton(
          key: rejectRideActionKey,
          label: "Reject",
          actionType: ActionType.SilentAction,
          isDangerousOption: true,
        ),
      ],
    );
  }

  static Future<void> showNotification(
      {required OrderDetailsModel data}) async {
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
