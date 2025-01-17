import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:waiver_driver/backend/model/login/login_model.dart';
import 'package:waiver_driver/controller/login/login_controller.dart';
import 'package:waiver_driver/core/colors/app_colors.dart';
import 'package:waiver_driver/core/themes/assets/icons.dart';
import 'package:waiver_driver/core/widgets/app_bar/app_bar.dart';
import 'package:waiver_driver/core/widgets/app_buttons/app_buttons.dart';
import 'package:waiver_driver/helper/validator/validators/validators.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: ''),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 15.sp),
        children: [
          SizedBox(
            height: 25.sp,
          ),
          Text(
            "Enter your phone number",
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
            "This number will be used to contact you and communicate all ride related details",
            style: TextStyle(
              fontSize: 16.sp,
              height: 1,
              fontWeight: FontWeight.w200,
            ),
          ),
          SizedBox(
            height: 25.sp,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 3.sp),
            decoration: BoxDecoration(
              color: Get.theme.primaryColor.withOpacity(.5),
              borderRadius: BorderRadius.circular(8.sp),
              border: Border.all(color: AppColors.grey155),
            ),
            child: Form(
              key: LoginController.to.formKeyForLoginPage,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CountrySelection(),
                  Container(
                    height: 1,
                    color: AppColors.grey155,
                  ),
                  const MobileNumberTextField(),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 60.sp,
          ),
          GetX<LoginController>(builder: (controller) {
            return BlueButton(
              text: "Next",
              isLoading: controller.isButtonLoading.value,
              onTap: () => controller.sendPhoneOtp(),
            );
          })
        ],
      ),
    );
  }
}

class MobileNumberTextField extends StatelessWidget {
  const MobileNumberTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: LoginController.to.controllerPhoneNumber,
      validator: (value) =>
          Validators.isMobile(value: value?.replaceAll(" ", "")),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      keyboardType: TextInputType.phone,
      smartDashesType: SmartDashesType.enabled,
      maxLines: 1,
      maxLength: 10,
      decoration: InputDecoration(
        isDense: false,
        hintText: "Phone Number",
        hintStyle: TextStyle(color: AppColors.grey93, fontSize: 14.sp),
        counterText: "",
        contentPadding:
            EdgeInsets.symmetric(horizontal: 15.sp, vertical: 13.sp),
        filled: true,
        fillColor: Get.theme.primaryColor,
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.sp),
            borderSide: BorderSide(color: AppColors.white)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.sp),
            borderSide: BorderSide(color: AppColors.white)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.sp),
            borderSide: BorderSide(color: AppColors.white)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.sp),
            borderSide: BorderSide(color: AppColors.white)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.sp),
            borderSide: BorderSide(color: AppColors.white)),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.sp),
            borderSide: BorderSide(color: AppColors.white)),
      ),
    );
  }
}

class CountrySelection extends StatelessWidget {
  const CountrySelection({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField<CountryModel>(
          validator: (value) =>
              Validators.isEmpty(value: value?.mobileCode ?? ""),
          value: LoginController.to.selectedCountry,
          icon: SvgPicture.asset(AppIcons.downArrow),
          items: LoginController.to.countryList
              .map((country) => DropdownMenuItem(
                    value: country,
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(right: 5.sp),
                          child: Image.asset(
                            country.image,
                            width: 30.sp,
                          ),
                        ),
                        Text(
                          "${country.name} (${country.mobileCode})",
                          style: TextStyle(
                              color: Get.theme.indicatorColor.withOpacity(.8)),
                        ),
                      ],
                    ),
                  ))
              .toList(),
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 15.sp, vertical: 13.sp),
            filled: true,
            fillColor: Get.theme.primaryColor,
            isDense: false,
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.sp),
                borderSide: BorderSide(color: AppColors.white)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.sp),
                borderSide: BorderSide(color: AppColors.white)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.sp),
                borderSide: BorderSide(color: AppColors.white)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.sp),
                borderSide: BorderSide(color: AppColors.white)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.sp),
                borderSide: BorderSide(color: AppColors.white)),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.sp),
                borderSide: BorderSide(color: AppColors.white)),
          ),
          onChanged: (country) {
            LoginController.to.selectedCountry = country;
          }),
    );
  }
}
