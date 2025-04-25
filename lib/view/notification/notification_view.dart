import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:waiver_driver/backend/model/notification/notification_model.dart';
import 'package:waiver_driver/controller/notification/notification_controller.dart';
import 'package:waiver_driver/core/constants/get_storage_constants.dart';
import 'package:waiver_driver/core/themes/assets/icons.dart';
import 'package:waiver_driver/core/widgets/app_bar/app_bar.dart';
import 'package:waiver_driver/core/widgets/circle_with_gradient/circle_with_gradient.dart';
import 'package:waiver_driver/core/widgets/empty_page/empty_page.dart';
import 'package:waiver_driver/core/widgets/error_page/error_page.dart';
import 'package:waiver_driver/view/loading_animation/loading_animation.dart';


class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(title: "Notification"),
        body: GetX<NotificationController>(builder: (controller) {
          return controller.isLoading.value
              ? const LoadingBarsAnimation()
              : controller.isError.value
                  ? const ErrorPage()
                  : controller.notification.isEmpty
                      ? EmptyPage(
                          text: "No Notification found",
                        )
                      : ListView(
                          controller: controller.scrollController,
                          padding: EdgeInsets.symmetric(horizontal: 15.sp),
                          children: [
                            SizedBox(
                              height: 20.sp,
                            ),
                            Column(
                              children: NotificationController.to.notification
                                  .map((notification) =>
                                      NotificationListingItem(
                                          notification: notification))
                                  .toList(),
                            ),
                            GetX<NotificationController>(builder: (controller) {
                              return controller.isListCompeted.value
                                  ? LoadingBarsAnimation(
                                      height: 200.sp,
                                    )
                                  : const SizedBox();
                            })
                          ],
                        );
        }));
  }
}

// ignore: must_be_immutable
class NotificationListingItem extends StatelessWidget {
  NotificationModel notification;
  NotificationListingItem({super.key, required this.notification});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.sp),
      padding: EdgeInsets.all(15.sp),
      decoration: BoxDecoration(
          color: Get.theme.indicatorColor.withOpacity(.05),
          borderRadius: BorderRadius.circular(8.sp)),
      child: Row(
        children: [
          CircleWithIcon(
              height: 43.sp,
              color: Get.theme.primaryColor,
              child: Image.asset(
                notification.notificationType == NotificationType.cashBack
                    ? AppIcons.offers
                    : notification.notificationType == NotificationType.payment
                        ? AppIcons.wallet
                        : AppIcons.calender,
                color: Get.theme.indicatorColor,
                height: 25.sp,
              )),
          SizedBox(
            width: 12.sp,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.title ?? "",
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 2.sp,
              ),
              Text(
                notification.content ?? "",
                style: TextStyle(
                  fontSize: 12.sp,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
