import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:waiver_driver/controller/otp/otp_controller.dart';
import 'package:waiver_driver/core/colors/app_colors.dart';
import 'package:waiver_driver/core/constants/get_storage_constants.dart';
import 'package:waiver_driver/core/widgets/app_bar/app_bar.dart';
import 'package:waiver_driver/core/widgets/app_buttons/app_buttons.dart';
import 'package:waiver_driver/core/widgets/count_down/count_down_view.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: ""),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 15.sp),
        shrinkWrap: true,
        children: [
          SizedBox(
            height: 25.sp,
          ),
          Text(
            "Verify it’s you",
            style: TextStyle(
              height: 1,
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 14.sp,
          ),
          Text(
            "We send a OTP to ( ${OtpController.to.mobileCode} ${OtpController.to.mobileNumber} ).Enter it here to verify your identity",
            style: TextStyle(
              fontSize: 15.sp,
              height: 1,
              fontWeight: FontWeight.w200,
            ),
          ),
          SizedBox(
            height: 38.sp,
          ),
          TextFieldPinAutoFill(
              inputFormatters: [
               FilteringTextInputFormatter.digitsOnly
              ],
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.sp),
                  borderSide: BorderSide(color: AppColors.grey155)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.sp),
                  borderSide: BorderSide(color: AppColors.grey155)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.sp),
                  borderSide: BorderSide(color: AppColors.grey155)),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.sp),
                  borderSide: BorderSide(color: AppColors.grey155)),
            ),
            currentCode: "",
            onCodeSubmitted: (code) {
              if (code?.length == 6) {
                OtpController.to.code.text = code!;
                OtpController.to.validateOtp();
              }
            },
            onCodeChanged: (code) {
              if (code?.length == 6) {
                OtpController.to.code.text = code!;
                OtpController.to.validateOtp();
              }
            },
            codeLength: 6,
          ),
          GetX<OtpController>(
            builder: (controller) {
              return controller.showIsOtpValid.value
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10.sp,
                        ),
                        Text(
                          "Please enter full Otp",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.red,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox();
            },
          ),
          SizedBox(
            height: 20.sp,
          ),
          GetX<OtpController>(builder: (controller) {
            return ResendOtp(
              timerState: controller.showTimer.value,
              onTap: () {
                OtpController.to.resendOtp();
              },
              onEnd: () =>
                  OtpController.to.showTimer.value = ShowTimerState.text,
            );
          }),
          SizedBox(
            height: 30.sp,
          ),
          GetX<OtpController>(
            builder: (controller) {
              return BlueButton(
                text: "Confirm",
                isLoading: controller.isButtonLoading.value,
                onTap: () => OtpController.to.validateOtp(),
              );
            },
          )
        ],
      ),
    );
  }
}

class ResendOtp extends StatelessWidget {
  final ShowTimerState timerState;
  final void Function()? onTap;
  final void Function()? onEnd;
  const ResendOtp({
    super.key,
    required this.timerState,
    this.onTap,
    this.onEnd,
  });

  @override
  Widget build(BuildContext context) {
    switch (timerState) {
      case ShowTimerState.timer:
        return AppCountDown(
          text: "Resend OTP in ",
          endDate: DateTime.now().add(
            const Duration(minutes: 1),
          ),
          onEnd: onEnd,
        );

      case ShowTimerState.text:
        return GestureDetector(
          onTap: onTap,
          child: Text(
            "Resend OTP",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 15.sp,
            ),
          ),
        );

      case ShowTimerState.loading:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 25.sp,
              width: 25.sp,
              child: CircularProgressIndicator(color: AppColors.black),
            ),
          ],
        );
    }
  }
}
