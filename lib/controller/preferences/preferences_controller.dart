import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waiver_driver/backend/model/preferences/preferences_model.dart';
import 'package:waiver_driver/backend/parser/Preference/preference_parser.dart';
import 'package:waiver_driver/core/widgets/snackbar/snackbar.dart';
import 'package:waiver_driver/view/preferences/preferences_view.dart';

import '../../backend/api/api_services/api_services.dart';

// class PreferencesControllerBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut(() => PreferencesController());
//   }
// }

class PreferencesController extends GetxController {
  PreferencesParser parser;

  PreferencesController({required this.parser});

  static PreferencesController get to => Get.find();
  @override
  void onInit() async {
    super.onInit();
    try {
      isLoading.value = true;
      await getPreference();
      isError.value = false;
    } catch (error) {
      isError.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  RxBool isLoading = false.obs;
  RxBool isError = false.obs;

  getPreference() async {
    UpdatePreferenceResponseModel response = await ApiServices.getPreference();
    allowEmailForPromotionAndOffers.value =
        response.data?.emailPromotion ?? false;
    allowEmailForInvoice.value = response.data?.emailInvoice ?? false;
    allowSMSForInvoice.value = response.data?.smsInvoice ?? false;
    allowSMSForPromotionAndOffers.value = response.data?.smsPromotion ?? false;
    allowUpdateToBeSentOnWhatsapp.value = response.data?.wtspUpdates ?? false;
    allowPushNotification.value = response.data?.pushNotification ?? false;
    allowPictureInPictureAccess.value = response.data?.picInPicAccess ?? false;
  }

  savePreference() async {
    try {
      UpdatePreferenceResponseModel response =
          await ApiServices.savePreference(body: {
        "email_promotion": allowEmailForPromotionAndOffers.value.toString(),
        "email_invoice": allowEmailForInvoice.value.toString(),
        "sms_invoice": allowSMSForInvoice.value.toString(),
        "sms_promotion": allowSMSForPromotionAndOffers.value.toString(),
        "wtsp_updates": allowUpdateToBeSentOnWhatsapp.value.toString(),
        "push_notification": allowPushNotification.value.toString(),
        "pic_in_pic_access": allowPictureInPictureAccess.value.toString(),
      });
      if (response.status != 200) {
        allowEmailForPromotionAndOffers.value =
            response.data?.emailPromotion ?? false;
        allowEmailForInvoice.value = response.data?.emailInvoice ?? false;
        allowSMSForInvoice.value = response.data?.smsInvoice ?? false;
        allowSMSForPromotionAndOffers.value =
            response.data?.smsPromotion ?? false;
        allowUpdateToBeSentOnWhatsapp.value =
            response.data?.wtspUpdates ?? false;
        allowPushNotification.value = response.data?.pushNotification ?? false;
        allowPictureInPictureAccess.value =
            response.data?.picInPicAccess ?? false;
        Get.showSnackbar(GetSnackBar(
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            messageText: AppSnackBar(text: response.message ?? "")));
      }
    } catch (error) {
      Get.showSnackbar(const GetSnackBar(
          duration: Duration(seconds: 5),
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.zero,
          messageText: AppSnackBar(text: "OOPS Something went wrong")));
    }
  }

  RxBool allowEmailForPromotionAndOffers = false.obs;
  changeAllowEmailForPromotionAndOffers() {
    allowEmailForPromotionAndOffers.value =
        !allowEmailForPromotionAndOffers.value;
    savePreference();
  }

  RxBool allowEmailForInvoice = false.obs;
  changeAllowEmailForInvoice() {
    allowEmailForInvoice.value = !allowEmailForInvoice.value;
    savePreference();
  }

  RxBool allowSMSForPromotionAndOffers = false.obs;
  changeAllowSMSForPromotionAndOffers() {
    allowSMSForPromotionAndOffers.value = !allowSMSForPromotionAndOffers.value;
    savePreference();
  }

  RxBool allowSMSForInvoice = false.obs;
  changeAllowSMSForInvoice() {
    allowSMSForInvoice.value = !allowSMSForInvoice.value;
    savePreference();
  }

  RxBool allowUpdateToBeSentOnWhatsapp = false.obs;
  changeAllowUpdateToBeSentOnWhatsapp() {
    allowUpdateToBeSentOnWhatsapp.value = !allowUpdateToBeSentOnWhatsapp.value;
    savePreference();
  }

  RxBool allowPushNotification = false.obs;
  changeAllowPushNotification() {
    allowPushNotification.value = !allowPushNotification.value;
    savePreference();
  }

  RxBool allowPictureInPictureAccess = false.obs;
  changeAllowPictureInPictureAccess() {
    allowPictureInPictureAccess.value = !allowPictureInPictureAccess.value;
    savePreference();
  }
}
