import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:waiver_driver/backend/model/home/home_model.dart';
import 'package:waiver_driver/controller/home/home_controller.dart';
import 'package:waiver_driver/core/colors/app_colors.dart';
import 'package:waiver_driver/core/constants/enums/enums.dart';
import 'package:waiver_driver/core/constants/get_storage_constants.dart';
import 'package:waiver_driver/helper/init/init.dart';

import 'package:waiver_driver/main.dart';

import '../../../core/themes/assets/icons.dart';

class NotificationService {
  NotificationService() {
    final homeController = Get.find<HomeController>();
  }
  static Future<void> onInit() async {
    // Get.find<HomeController>();
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
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
    await AwesomeNotifications().setListeners(
        onActionReceivedMethod: onActionReceivedMethod,
        onDismissActionReceivedMethod: onDismissActionReceivedMethod,
        onNotificationCreatedMethod: onNotificationCreatedMethod,
        onNotificationDisplayedMethod: onNotificationDisplayedMethod);
  }

  static Future<void> onActionReceivedMethod(ReceivedAction action) async {}

  static Future<void> onDismissActionReceivedMethod(
      ReceivedNotification notification) async {}

  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification notification) async {}

  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification notification) async {}

  static handleNotificationOnBackGround(
      {required RemoteMessage notification}) {}

  static onMessage({required RemoteMessage notification}) async {
    OrderDetailsModel data = OrderDetailsModel.fromJson(notification.data);
    await showNotification(data: data);
    HomeController.to.driverState.value = DriverState.loading;
    print("notification.data");
    print(notification.data ?? "No message");
    print(notification.notification?.body);
    print(notification.notification?.title);
    box.write(BoxKeys.paymentType, data.paymentType);
    print("***********************${data.rideStatus}");
    if (data.rideStatus == "RED") {
      HomeController.to.getAndShowOrderDetails(id: data.rideId ?? "");
    } else if (data.rideStatus == RideStatus.cancelled) {
      final player = AudioPlayer();
      player.stop();
      HomeController.to.resetDistance();
      HomeController.to.isTracking = false;
      HomeController.to.rideIsActive = false;
      HomeController.to.driverState.value = DriverState.idle;
      // Get.bottomSheet(OrderCompletedBottomSheet());
    } else if (data.rideStatus == RideStatus.paymentInitiated) {
      HomeController.to.isTracking = false;
      HomeController.to.rideIsActive = true;
      HomeController.to.driverState.value = DriverState.paymentInitiated;
    } else if (data.rideStatus == RideStatus.completed) {
      HomeController.to.isTracking = false;
      HomeController.to.rideIsActive = true;
      await HomeController.to.getRidePayment();
      HomeController.to.driverState.value = DriverState.completed;
    } else {
      HomeController.to.driverState.value = DriverState.idle;
    }
  }

  static onMessageOpenedApp({required RemoteMessage notification}) async {
    OrderDetailsModel data = OrderDetailsModel.fromJson(notification.data);
    showNotification(data: data);
    print(
        "############################notification.data#################################");
    print(notification.data);
    print(notification.notification);
    if (data.rideStatus == "RED") {
      HomeController.to.getAndShowOrderDetails(id: data.rideId ?? "");
    } else if (data.rideStatus == RideStatus.cancelled) {
      final player = AudioPlayer();
      player.stop();
      HomeController.to.resetDistance();
      HomeController.to.isTracking = false;
      HomeController.to.rideIsActive = false;
      HomeController.to.driverState.value = DriverState.idle;
      // Get.bottomSheet(OrderCompletedBottomSheet());
    } else if (data.rideStatus == RideStatus.paymentInitiated) {
      HomeController.to.isTracking = false;
      HomeController.to.rideIsActive = true;
      HomeController.to.driverState.value = DriverState.paymentInitiated;
    } else if (data.rideStatus == RideStatus.completed) {
      HomeController.to.isTracking = false;
      HomeController.to.rideIsActive = true;
      await HomeController.to.getRidePayment();
      HomeController.to.driverState.value = DriverState.completed;
    } else {
      HomeController.to.driverState.value = DriverState.idle;
    }
  }

  static Future<void> showNotification(
      {required OrderDetailsModel data}) async {
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
