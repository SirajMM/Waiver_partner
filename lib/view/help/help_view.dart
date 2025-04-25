import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:waiver_driver/backend/model/help/help_model.dart';
import 'package:waiver_driver/controller/help/help_controller.dart';
import 'package:waiver_driver/core/colors/app_colors.dart';
import 'package:waiver_driver/core/themes/assets/icons.dart';
import 'package:waiver_driver/core/widgets/app_bar/app_bar.dart';
import 'package:waiver_driver/core/widgets/app_network_image/app_network_image.dart';
import 'package:waiver_driver/core/widgets/circle_with_gradient/circle_with_gradient.dart';
import 'package:waiver_driver/core/widgets/error_page/error_page.dart';
import 'package:waiver_driver/helper/router/app_routes/app_routes.dart';
import 'package:waiver_driver/view/loading_animation/loading_animation.dart';


class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(title: "Help"),
        body: GetX<HelpController>(builder: (controller) {
          return controller.isLoading.value
              ? const LoadingBarsAnimation()
              : controller.isError.value
                  ? const ErrorPage()
                  : ListView(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.sp, vertical: 25.sp),
                      children: controller.helpCategories
                          .map((helpCategory) =>
                              HelpListingItem(helpCategory: helpCategory))
                          .toList(),
                    );
        }));
  }
}

// ignore: must_be_immutable
class HelpListingItem extends StatelessWidget {
  HelpCategory helpCategory;

  HelpListingItem({super.key, required this.helpCategory});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.faq, arguments: helpCategory.id),
      child: Container(
        margin: EdgeInsets.only(bottom: 20.sp),
        padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 6.sp),
        decoration: BoxDecoration(
            border: Border.all(
                color: Get.theme.indicatorColor.withOpacity(.05),
                width: 1.5.sp),
            borderRadius: BorderRadius.circular(8.sp)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleWithIcon(
                    height: 43.sp,
                    color: AppColors.grey249,
                    child: AppNetworkImage(
                      imageUrl: helpCategory.icon ?? "",
                      height: 25.sp,
                      width: 25.sp,
                    )),
                SizedBox(
                  width: 12.sp,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      helpCategory.title ?? "",
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 2.sp,
                    ),
                    Text(
                      helpCategory.content ?? "",
                      style: TextStyle(
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Container(
                padding: EdgeInsets.only(right: 8.sp),
                child: SvgPicture.asset(AppIcons.arrowRight))
          ],
        ),
      ),
    );
  }
}
