import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:waiver_driver/controller/sign_in/sign_in_controller.dart';
import 'package:waiver_driver/core/themes/assets/images.dart';
import 'package:waiver_driver/core/widgets/app_buttons/app_buttons.dart';
import 'package:waiver_driver/helper/router/app_routes/app_routes.dart';
import 'package:waiver_driver/helper/router/app_routes/route.dart';


class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: WelcomeContainer(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              AppImages.loginBackground,
            ),
            fit: BoxFit.fill,
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }
}

class WelcomeContainer extends StatelessWidget {
  const WelcomeContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        color: Get.theme.primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.sp),
          topRight: Radius.circular(15.sp),
        ),
      ),
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 24.sp, vertical: 20.sp),
        children: [
          Text(
            "Great!",
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
            "Excited to onboard you as a Waiver Partner! Let's get started!",
            style: TextStyle(
              fontSize: 16.sp,
              height: 1,
              fontWeight: FontWeight.w200,
            ),
          ),
          SizedBox(
            height: 25.sp,
          ),
          Hero(
            tag: SignInController.to.userType,
            child: Material(
              child: BlueButton(
                text: "Continue with Phone Number",
                // onTap: () => Get.toNamed(AppRoutes.login),
                onTap: () => Get.toNamed(AppRoutes1.getLoginRoute() ),
              ),
            ),
          ),
          SizedBox(
            height: 16.sp,
          ),
          // GetX<SignInController>(builder: (controller) {
          //   return WhiteButton(
          //     icon: SvgPicture.asset(AppIcons.google),
          //     text: "Continue with Google",
          //     isLoading: controller.isGoogleLoginLoading.value,
          //     onTap: () => controller.loginWithGoogle(),
          //   );
          // }),
        ],
      ),
    );
  }
}
