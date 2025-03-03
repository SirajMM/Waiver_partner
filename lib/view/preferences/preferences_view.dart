import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:waiver_driver/controller/preferences/preferences_controller.dart';
import 'package:waiver_driver/core/widgets/app_bar/app_bar.dart';
import 'package:waiver_driver/core/widgets/error_page/error_page.dart';
import 'package:waiver_driver/view/loading_animation/loading_animation.dart';

import '../../core/colors/app_colors.dart';

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(title: "Preferences"),
        body: GetX<PreferencesController>(builder: (controller) {
          return controller.isLoading.value
              ? const LoadingBarsAnimation()
              : controller.isError.value
                  ? const ErrorPage()
                  : ListView(
                      padding: EdgeInsets.symmetric(horizontal: 15.sp),
                      children: [
                        SizedBox(height: 25.sp),
                        Text(
                          "Email",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 14.sp),
                        PreferenceListingItem(
                          text: "Allow email for promotion & offers",
                          value: PreferencesController
                              .to.allowEmailForPromotionAndOffers,
                          onTap: () => PreferencesController.to
                              .changeAllowEmailForPromotionAndOffers(),
                        ),
                        SizedBox(height: 14.sp),
                        PreferenceListingItem(
                          text: "Allow email for invoice",
                          value: PreferencesController.to.allowEmailForInvoice,
                          onTap: () => PreferencesController.to
                              .changeAllowEmailForInvoice(),
                        ),
                        SizedBox(height: 25.sp),
                        Text(
                          "SMS & Whatsapp",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 14.sp),
                        PreferenceListingItem(
                          text: "Allow SMS for invoice",
                          value: PreferencesController.to.allowSMSForInvoice,
                          onTap: () => PreferencesController.to
                              .changeAllowSMSForInvoice(),
                        ),
                        SizedBox(height: 14.sp),
                        PreferenceListingItem(
                          text: "Allow SMS for promotion & offers",
                          value: PreferencesController
                              .to.allowSMSForPromotionAndOffers,
                          onTap: () => PreferencesController.to
                              .changeAllowSMSForPromotionAndOffers(),
                        ),
                        SizedBox(height: 14.sp),
                        PreferenceListingItem(
                          text: "Allow update to be sent on Whatsapp",
                          value: PreferencesController
                              .to.allowUpdateToBeSentOnWhatsapp,
                          onTap: () => PreferencesController.to
                              .changeAllowUpdateToBeSentOnWhatsapp(),
                        ),
                        SizedBox(height: 25.sp),
                        Text(
                          "Push Notification",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 14.sp),
                        PreferenceListingItem(
                          text: "Allow push notification",
                          value: PreferencesController.to.allowPushNotification,
                          onTap: () => PreferencesController.to
                              .changeAllowPushNotification(),
                        ),
                        SizedBox(height: 25.sp),
                        Text(
                          " Picture in Picture (PIP)",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 14.sp),
                        PreferenceListingItem(
                          text: "Picture in Picture (PIP)",
                          value: PreferencesController
                              .to.allowPictureInPictureAccess,
                          onTap: () => PreferencesController.to
                              .changeAllowPictureInPictureAccess(),
                        ),
                        SizedBox(height: 30.sp),
                      ],
                    );
        }));
  }
}

class PreferenceListingItem extends StatelessWidget {
  String text;
  RxBool value;
  void Function() onTap;
  PreferenceListingItem({
    super.key,
    required this.text,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 6.sp),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.sp),
          border: Border.all(color: AppColors.grey155, width: 1.5.sp)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          GetX<PreferencesController>(
            builder: (controller) {
              return Checkbox(
                  value: value.value, onChanged: (value) => onTap());
            },
          )
        ],
      ),
    );
  }
}
