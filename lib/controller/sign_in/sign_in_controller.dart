import 'package:flutter/material.dart';
import 'package:flutter_custom_utils/flutter_custom_utils.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:waiver_driver/backend/api/api_services/urls.dart';
import 'package:waiver_driver/backend/parser/Signin/signin_parser.dart';
import 'package:waiver_driver/core/widgets/snackbar/snackbar.dart';

import '../../backend/api/api_services/api_services.dart';
import '../../helper/router/app_routes/app_routes.dart';

// class SignInControllerBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.put(SignInController());
//   }
// }

class SignInController extends GetxController {
  final SignInParser parser;
  SignInController({required this.parser});
  @override
  void onInit() {
    Get.put(ApiServices(appBaseUrl: AppUrls.base));
    userType = Get.arguments;
    cLog("login userType : $userType");
    super.onInit();
  }

  RxBool isGoogleLoginLoading = false.obs;

  // loginWithGoogle() async {
  //   try {
  //     isGoogleLoginLoading.value = true;
  //     GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //     if (googleUser != null) {
  //       Get.toNamed(AppRoutes.login, arguments: googleUser);
  //     } else {
  //       Get.showSnackbar(
  //         const GetSnackBar(
  //           duration: Duration(seconds: 5),
  //           backgroundColor: Colors.transparent,
  //           padding: EdgeInsets.zero,
  //           messageText: AppSnackBar(
  //             text: "OOPS there was some issue with google login"
  //                 " please try again or select Continue With Phone Number ",
  //           ),
  //         ),
  //       );
  //     }
  //   } catch (error) {
  //     {
  //       print(error);
  //       Get.showSnackbar(
  //         const GetSnackBar(
  //           duration: Duration(seconds: 5),
  //           backgroundColor: Colors.transparent,
  //           padding: EdgeInsets.zero,
  //           messageText: AppSnackBar(
  //             text: "OOPS Some thing went wrong",
  //           ),
  //         ),
  //       );
  //     }
  //   } finally {
  //     isGoogleLoginLoading.value = false;
  //   }
  // }

  static SignInController get to => Get.find();
  String userType = "";
}
