import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';

import 'package:waiver_driver/backend/model/login/login_model.dart';
import 'package:waiver_driver/backend/parser/Login/login_parser.dart';
import 'package:waiver_driver/core/themes/assets/images.dart';
import 'package:waiver_driver/core/widgets/snackbar/snackbar.dart';
import 'package:waiver_driver/helper/router/app_routes/route.dart';
import 'package:waiver_driver/main.dart';

import '../../backend/api/api_services/api_services.dart';
import '../../core/constants/get_storage_constants.dart';
import '../../helper/router/app_routes/app_routes.dart';

// class LoginControllerBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut(() => LoginController());
//   }
// }

class LoginController extends GetxController {
  static LoginController get to => Get.find();
  final LoginParser parser;
  LoginController({required this.parser});

  @override
  void onInit() {
    selectedCountry = countryList[0];
    super.onInit();
  }

  RxBool isButtonLoading = false.obs;

  TextEditingController controllerPhoneNumber = TextEditingController();
  GlobalKey<FormState> formKeyForLoginPage = GlobalKey();

  CountryModel? selectedCountry;
  List<CountryModel> countryList = <CountryModel>[
    CountryModel(image: AppImages.indiaFlag, name: "India", mobileCode: '+91')
  ];
  Rx<SendPhoneOtpResponseModel> errorResponse =
      Rx<SendPhoneOtpResponseModel>(SendPhoneOtpResponseModel());
  sendPhoneOtp() async {
    if (formKeyForLoginPage.currentState?.validate() ?? false) {
      try {
        isButtonLoading.value = true;
        Map<String, String> body = {
          "phone": controllerPhoneNumber.text.trim(),
          "code": selectedCountry?.mobileCode ?? "",
          "hash_key": await SmsAutoFill().getAppSignature,
          "user_type": box.read(BoxKeys.userTypeCode),
        };

        SendPhoneOtpResponseModel response =
            await ApiServices.sendPhoneOtp(body: body);

        errorResponse.value = response;

        // Handle specific error message for phone already exists
        String displayMessage = response.message ?? "";
        if (response.status == 400 &&
            response.error?.nonFieldErrors != null &&
            response.error!.nonFieldErrors!.isNotEmpty) {
          displayMessage = response.error!.nonFieldErrors![0];

          Get.showSnackbar(
            GetSnackBar(
              duration: Duration(seconds: 5),
              backgroundColor: Colors.transparent,
              padding: EdgeInsets.zero,
              messageText: AppSnackBar(
                  text: displayMessage ?? "OOPS Something went Wrong"),
            ),
          );
        }

        if (response.status == 200) {
          Get.toNamed(
            AppRoutes1.getOtpInRoute(),
            arguments: ArgumentModelForOtpPage(
              mobileCode: selectedCountry?.mobileCode ?? "",
              mobilePhoneNumber: controllerPhoneNumber.text.trim(),
              user: Get.arguments,
            ),
          );
        }
        Get.showSnackbar(
          GetSnackBar(
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            messageText: AppSnackBar(text: response.message ?? ""),
          ),
        );
      } catch (error) {
        if (kDebugMode) {
          print(error);
        }
        Get.showSnackbar(
          GetSnackBar(
            duration: Duration(seconds: 5),
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            messageText: AppSnackBar(
                text: error.toString() ?? "OOPS Something went Wrong"),
          ),
        );
      } finally {
        isButtonLoading.value = false;
      }
    }
  }
}
