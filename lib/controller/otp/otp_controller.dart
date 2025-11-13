import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:waiver_driver/backend/model/login/login_model.dart';
import 'package:waiver_driver/backend/model/otp/otp_model.dart';
import 'package:waiver_driver/backend/parser/otp/otp_parser.dart';
import 'package:waiver_driver/core/widgets/snackbar/snackbar.dart';
import 'package:waiver_driver/helper/router/app_routes/route.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../backend/LocationHandler/LocationTrackingService.dart';
import '../../backend/api/api_services/api_services.dart';
import '../../core/constants/get_storage_constants.dart';
import '../../helper/router/app_routes/app_routes.dart';
import '../../main.dart';

// class OtpControllerBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut(() => OtpController());
//   }
// }

class OtpController extends GetxController {
  final OtpParser parser;
  OtpController({required this.parser});

  @override
  Future<void> onInit() async {
    super.onInit();

    try {
      ArgumentModelForOtpPage argument = Get.arguments;
      mobileNumber = argument.mobilePhoneNumber;
      mobileCode = argument.mobileCode;
      mobileCode = argument.mobileCode;

      // OtpController.to.code.text = sms?.replaceAll(RegExp(r'[^0-9]'), '') ?? "";
    } catch (error) {
      Get.back();
    }
    await SmsAutoFill().listenForCode();
  }

  Rx<ShowTimerState> showTimer = ShowTimerState.timer.obs;

  GoogleSignInAccount? user;
  static OtpController get to => Get.find();
  String userTypeCode = box.read(BoxKeys.userTypeCode);
  String mobileNumber = "";
  String mobileCode = "";

  TextEditingController code = TextEditingController();
  RxBool showIsOtpValid = false.obs;
  RxBool isButtonLoading = false.obs;

  resendOtp() async {
    try {
      Map<String, String> body = {
        "phone": mobileNumber.trim(),
        "code": mobileCode ?? "",
        "user_type": userTypeCode,
      };
      log("otp body $body ***************");
      SendPhoneOtpResponseModel response =
          await ApiServices.sendPhoneOtp(body: body);
      OtpController.to.showTimer.value = ShowTimerState.timer;
      AppConstants.handleError(response.message ?? "");
    } catch (error, s) {
      AppConstants.handleError(error, s: s);
    }
  }

  validateOtp() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      log("mobileCode:$mobileCode");
      isButtonLoading.value = true;
      if (!showIsOtpValid.value) {
        showIsOtpValid.value = code.text.length != 6;
        Map<String, String> body = {
          "phone": mobileNumber,
          "otp": code.text,
          "code": mobileCode,
          "device_type": "android",
          "user_type": userTypeCode,
          // "fcm_token": DateTime.now().toIso8601String()
          "fcm_token": await (FirebaseMessaging.instance.getToken()) ?? ""
        };
        log("validate otp body $body ***************");
        VerifyOtpResponseModel response =
            await ApiServices.phoneAuth(body: body);

        bool? isRegistered = response.data?.isRegistered;
        bool? isVerifed = response.data?.isVerifed;
        box.write(BoxKeys.userID, response.data?.userId ?? "");
        box.write(BoxKeys.isRegistered,
            response.data?.isRegistered ?? false ? "1" : "0");
        box.write(
            BoxKeys.isVerified, response.data?.isVerifed ?? false ? "1" : "0");
        if (response.status == 200) {
          if (userTypeCode != (response.data?.userType ?? "")) {
            userTypeCode = response.data?.userType ?? "";
          }
          if (userTypeCode == UserTypeCode.fleet) {
            if (isRegistered ?? false) {
              box.write(BoxKeys.token, response.data?.accessToken);
              Get.offAllNamed(AppRoutes1.getFleetHomePageInRoute());
            } else {
              box.write(BoxKeys.token, response.data?.accessToken);
              Get.toNamed(AppRoutes.registration, arguments: user ?? "");
            }
          } else {
            box.write(BoxKeys.token, response.data?.accessToken);

            // 🔥 Safe location service initialization
            await _initializeLocationService();

            if (isVerifed ?? false) {
              Get.offAllNamed(AppRoutes1.getHomeInRoute());
            } else if (isRegistered ?? false) {
              Get.toNamed(AppRoutes1.getChauffeurProofInRoute(),
                  arguments: user ?? "");
            } else {
              Get.toNamed(AppRoutes1.registration, arguments: user ?? "");
            }
          }
        }
      }
    } catch (error, s) {
      log(error.toString(), stackTrace: s);
      AppConstants.handleError(error, s: s);
    } finally {
      isButtonLoading.value = false;
    }
  }

  Future<void> _initializeLocationService() async {
    try {
      LocationTrackingService locationService;

      // Check if service is already registered
      if (Get.isRegistered<LocationTrackingService>()) {
        locationService = Get.find<LocationTrackingService>();
        log('✅ LocationTrackingService found');
      } else {
        // Register it if not found
        locationService = Get.put(LocationTrackingService(), permanent: true);
        log('✅ LocationTrackingService registered');

        // Give it a moment to initialize
        await Future.delayed(Duration(milliseconds: 500));
      }

      // Initialize the service

      log('✅ Location service initialized successfully');
    } catch (e) {
      log('❌ Error initializing location service: $e');
      // Don't throw error - let login continue
    }
  }
}
