import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';


import 'package:waiver_driver/main.dart';

import '../../colors/app_colors.dart';
import '../../constants/get_storage_constants.dart';
import '../../themes/assets/icons.dart';



class BlueButton extends StatelessWidget {
  final String text;
  final double? height;
  final double? width;
  final double? fontSize;
  final double? radius;
  final void Function()? onTap;
  final bool? isLoading;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  const BlueButton({
    super.key,
    required this.text,
    this.height,
    this.fontSize,
    this.onTap,
    this.width,
    this.radius,
    this.isLoading,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: GestureDetector(
        onTap: (isLoading ?? false) ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: (isLoading ?? false) ? height ?? 60.sp : height ?? 52.sp,
          width: (isLoading ?? false) ? height ?? 60.sp : width ?? 370.sp,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              (isLoading ?? false) ? 55.sp : radius ?? 8.sp,
            ),
            color: box.read(BoxKeys.userTypeCode) == UserTypeCode.driver
                ? AppColors.orange
                : AppColors.blue,
          ),
          child: Center(
            child: isLoading ?? false
                ? CircularProgressIndicator(
                    color: AppColors.white,
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      prefixIcon ??
                          SizedBox(
                            width: 0.sp,
                          ),
                      Text(
                        text,
                        style: TextStyle(
                          fontSize: fontSize ?? 16.sp,
                          color: AppColors.white,
                        ),
                      ),
                      suffixIcon ??
                          SizedBox(
                            width: 0.sp,
                          ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
class BlueOnlyButton extends StatelessWidget {
  final String text;
  final double? height;
  final double? width;
  final double? fontSize;
  final double? radius;
  final void Function()? onTap;
  final bool? isLoading;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  const BlueOnlyButton({
    super.key,
    required this.text,
    this.height,
    this.fontSize,
    this.onTap,
    this.width,
    this.radius,
    this.isLoading,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: GestureDetector(
        onTap: (isLoading ?? false) ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: (isLoading ?? false) ? height ?? 60.sp : height ?? 52.sp,
          width: (isLoading ?? false) ? height ?? 60.sp : width ?? 370.sp,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              (isLoading ?? false) ? 55.sp : radius ?? 8.sp,
            ),
            color: AppColors.blue,
          ),
          child: Center(
            child: isLoading ?? false
                ? CircularProgressIndicator(
              color: AppColors.white,
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                prefixIcon ??
                    SizedBox(
                      width: 0.sp,
                    ),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: fontSize ?? 16.sp,
                    color: AppColors.white,
                  ),
                ),
                suffixIcon ??
                    SizedBox(
                      width: 0.sp,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RedButton extends StatelessWidget {
  final String text;
  final double? height;
  final double? width;
  final double? fontSize;
  final double? radius;
  final void Function()? onTap;
  final bool? isLoading;
  final Widget? icon;
  const RedButton({
    super.key,
    required this.text,
    this.height,
    this.fontSize,
    this.onTap,
    this.width,
    this.radius,
    this.isLoading,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: GestureDetector(
        onTap: (isLoading ?? false) ? null : onTap,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: (isLoading ?? false) ? height ?? 60.sp : height ?? 52.sp,
            width: (isLoading ?? false) ? height ?? 60.sp : width ?? 370.sp,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                  (isLoading ?? false) ? 55.sp : radius ?? 8.sp),
              color: AppColors.red,
            ),
            child: Center(
              child: isLoading ?? false
                  ? CircularProgressIndicator(
                      color: AppColors.white,
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        icon != null
                            ? Container(
                                padding: EdgeInsets.only(right: 10.sp),
                                child: icon,
                              )
                            : const SizedBox(),
                        Text(
                          text,
                          style: TextStyle(
                              fontSize: fontSize ?? 16.sp,
                              color: AppColors.white),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class RedBorderedButton extends StatelessWidget {
  final String text;
  final double? height;
  final double? width;
  final double? fontSize;
  final double? radius;
  final void Function()? onTap;
  final bool? isLoading;
  final Widget? icon;
  const RedBorderedButton({
    super.key,
    required this.text,
    this.height,
    this.fontSize,
    this.onTap,
    this.width,
    this.radius,
    this.isLoading,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: GestureDetector(
        onTap: (isLoading ?? false) ? null : onTap,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: (isLoading ?? false) ? height ?? 60.sp : height ?? 52.sp,
            width: (isLoading ?? false) ? height ?? 60.sp : width ?? 370.sp,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.red),
              borderRadius: BorderRadius.circular(
                  (isLoading ?? false) ? 55.sp : radius ?? 8.sp),
              color: AppColors.red.withOpacity(0),
            ),
            child: Center(
              child: isLoading ?? false
                  ? CircularProgressIndicator(
                      color: AppColors.white,
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        icon != null
                            ? Container(
                                padding: EdgeInsets.only(right: 10.sp),
                                child: icon,
                              )
                            : const SizedBox(),
                        Text(
                          text,
                          style: TextStyle(
                              fontSize: fontSize ?? 16.sp,
                              color: AppColors.black),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class WhiteButton extends StatelessWidget {
  final String text;
  final double? height;
  final double? width;
  final double? fontSize;
  final double? radius;
  final void Function()? onTap;
  final bool? isLoading;
  final Widget? icon;

  const WhiteButton({
    super.key,
    required this.text,
    this.height,
    this.icon,
    this.fontSize,
    this.onTap,
    this.width,
    this.radius,
    this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: GestureDetector(
        onTap: (isLoading ?? false) ? null : onTap,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: EdgeInsets.all(5.sp),
            height: (isLoading ?? false) ? height ?? 60.sp : height ?? 52.sp,
            width: (isLoading ?? false) ? height ?? 60.sp : width ?? 370.sp,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey155, width: 1.5.sp),
              borderRadius: BorderRadius.circular(
                  (isLoading ?? false) ? 55.sp : radius ?? 8.sp),
              color: AppColors.white,
            ),
            child: Center(
              child: isLoading ?? false
                  ? CircularProgressIndicator(
                      color: AppColors.black,
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        icon != null
                            ? Container(
                                padding: EdgeInsets.only(right: 10.sp),
                                child: icon,
                              )
                            : const SizedBox(),
                        Text(
                          text,
                          style: TextStyle(
                              fontSize: fontSize ?? 16.sp,
                              color: AppColors.black),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class BackArrow extends StatelessWidget {
  final void Function()? onTap;
  const BackArrow({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            decoration: BoxDecoration(
                border:
                    Border.all(color: Get.theme.indicatorColor, width: 1.5.sp),
                shape: BoxShape.circle),
            padding: EdgeInsets.all(5.sp),
            child: SvgPicture.asset(
              AppIcons.arrowLeft,
              color: Get.theme.indicatorColor,
            )));
  }
}

class MenuButton extends StatelessWidget {
  final void Function()? onTap;
  const MenuButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            decoration: BoxDecoration(
                border:
                    Border.all(color: Get.theme.indicatorColor, width: 1.5.sp),
                shape: BoxShape.circle),
            padding: EdgeInsets.all(5.sp),
            child: SvgPicture.asset(
              AppIcons.menu,
              color: Get.theme.indicatorColor,
            )));
  }
}
