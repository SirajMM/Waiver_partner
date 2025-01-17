import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:waiver_driver/backend/model/faq_topics/faq_topic_model.dart';
import 'package:waiver_driver/controller/faq_topics/faq_topic_controller.dart';
import 'package:waiver_driver/core/colors/app_colors.dart';
import 'package:waiver_driver/core/themes/assets/icons.dart';
import 'package:waiver_driver/core/widgets/app_bar/app_bar.dart';
import 'package:waiver_driver/core/widgets/empty_page/empty_page.dart';
import 'package:waiver_driver/core/widgets/error_page/error_page.dart';
import 'package:waiver_driver/helper/router/app_routes/app_routes.dart';
import 'package:waiver_driver/view/loading_animation/loading_animation.dart';


class FaqTopicsScreen extends StatelessWidget {
  const FaqTopicsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(title: "FAQs"),
        body: GetX<FaqController>(builder: (controller) {
          return controller.isLoading.value
              ? const LoadingBarsAnimation()
              : controller.isError.value
                  ? const ErrorPage()
                  : controller.faqTopics.isEmpty
                      ? EmptyPage(
                          text: "No Faq found for this session",
                        )
                      : ListView(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.sp,
                            vertical: 25.sp,
                          ),
                          children: FaqController.to.faqTopics
                              .map((topic) => FaqTopicListingItem(faq: topic))
                              .toList());
        }));
  }
}

class FaqTopicListingItem extends StatelessWidget {
  FaqModel faq;
  FaqTopicListingItem({super.key, required this.faq});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.faqListing, arguments: faq.faqs),
      child: Container(
        padding: EdgeInsets.all(14.sp),
        margin: EdgeInsets.only(bottom: 15.sp),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey155, width: 1.5.sp),
          borderRadius: BorderRadius.circular(8.sp),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              faq.title ?? "",
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
            ),
            SvgPicture.asset(AppIcons.arrowRight)
          ],
        ),
      ),
    );
  }
}
