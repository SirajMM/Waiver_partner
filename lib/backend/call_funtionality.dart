import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/entities/notification_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:uuid/uuid.dart';
import 'package:waiver_driver/backend/model/home/home_model.dart';
import 'package:waiver_driver/controller/home/home_controller.dart';
import 'package:waiver_driver/core/constants/enums/enums.dart';
import 'package:waiver_driver/core/constants/get_storage_constants.dart';
import 'package:waiver_driver/core/themes/assets/icons.dart';
import 'package:waiver_driver/helper/init/init.dart';
import 'package:waiver_driver/main.dart';

class CallFunctionality {
  OrderDetailsModel? data;



  Future<void> showCallkitIncoming(
      String uuid, RemoteMessage notification) async {
    data = OrderDetailsModel.fromJson(notification.data);
    final params = CallKitParams(
      id: uuid,
      nameCaller: notification.notification?.title,
      appName: 'Callkit',
      avatar: AppIcons.appLogo,
      handle: notification.notification?.body,
      type: 0,
      duration: 10000,
      textAccept: 'Accept',
      textDecline: 'Decline',
      missedCallNotification: const NotificationParams(
        showNotification: true,
        isShowCallback: true,
        subtitle: 'Missed call',
        callbackText: 'Call back',
      ),
      extra: <String, dynamic>{'userId': '1a2b3c4d'},
      headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
      android: const AndroidParams(
        isCustomNotification: true,
        isShowLogo: false,
        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#0955fa',
        backgroundUrl: 'assets/test.png',
        actionColor: '#4CAF50',
        textColor: '#ffffff',
      ),
      ios: const IOSParams(
        iconName: 'CallKitLogo',
        handleType: '',
        supportsVideo: true,
        maximumCallGroups: 2,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'system_ringtone_default',
      ),
    );
    await FlutterCallkitIncoming.showCallkitIncoming(params);
  }

  void listenCallEvents() async {

    FlutterCallkitIncoming.onEvent.listen((event) {
      if (event?.event == Event.actionCallAccept) {
        _onCallAccepted(event?.body['id']);
      }
    });
  }

  Future<void> _onCallAccepted(String? callId) async {
    // Call your method here
    print("Call accepted: $callId");
    // OrderDetailsModel data = OrderDetailsModel.fromJson(notification.data);
    HomeController.to.driverState.value = DriverState.loading;
    print("notification.data");
    print(data ?? "No message");
    box.write(BoxKeys.paymentType, data?.paymentType);
    print("***********************${data?.rideStatus}");
    if (data?.rideStatus == "RED") {
      HomeController.to.getAndShowOrderDetails(id: data?.rideId ?? "");
    } else if (data?.rideStatus == RideStatus.cancelled) {
      final player = AudioPlayer();
      player.stop();
      HomeController.to.resetDistance();
      HomeController.to.isTracking = false;
      HomeController.to.rideIsActive = false;
      HomeController.to.driverState.value = DriverState.idle;
      // Get.bottomSheet(OrderCompletedBottomSheet());
    } else if (data?.rideStatus == RideStatus.paymentInitiated) {
      HomeController.to.isTracking = false;
      HomeController.to.rideIsActive = true;
      HomeController.to.driverState.value = DriverState.paymentInitiated;
    } else if (data?.rideStatus == RideStatus.completed) {
      HomeController.to.isTracking = false;
      HomeController.to.rideIsActive = true;
      await HomeController.to.getRidePayment();
      HomeController.to.driverState.value = DriverState.completed;
    } else {
      HomeController.to.driverState.value = DriverState.idle;
    }
  }
}
