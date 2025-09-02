import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:waiver_driver/backend/model/earning/earning_model.dart';
import 'package:waiver_driver/controller/earning/earning_controller.dart';
import 'package:waiver_driver/core/colors/app_colors.dart';
import 'package:waiver_driver/core/constants/get_storage_constants.dart';
import 'package:waiver_driver/core/themes/assets/icons.dart';
import 'package:waiver_driver/core/widgets/app_bar/app_bar.dart';
import 'package:waiver_driver/core/widgets/app_buttons/app_buttons.dart';
import 'package:waiver_driver/core/widgets/circle_with_gradient/circle_with_gradient.dart';
import 'package:waiver_driver/core/widgets/empty_page/empty_page.dart';
import 'package:waiver_driver/core/widgets/error_page/error_page.dart';
import 'package:waiver_driver/helper/router/app_routes/route.dart';
import 'package:waiver_driver/helper/validator/app_extensions/app_extensions.dart';
import 'package:waiver_driver/view/loading_animation/loading_animation.dart';

class EarningScreen extends StatelessWidget {
  const EarningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AppRoutes1.getEraningScreenInRoute());

    return Scaffold(
        appBar: appBar(title: "Earnings"),
        body: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              SizedBox(
                height: 25.sp,
              ),
              TabBar(
                  unselectedLabelColor: AppColors.blue,
                  indicatorSize: TabBarIndicatorSize.label,
                  dividerColor: Colors.transparent,
                  labelColor: AppColors.white,
                  labelStyle:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp),
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: AppColors.blue),
                  tabs: [
                    Tab(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border:
                                Border.all(color: AppColors.blue, width: 1.sp)),
                        child: const Text("TODAY"),
                      ),
                    ),
                    Tab(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                                color: AppColors.blue, width: 1.5.sp)),
                        child: const Text("WEEKLY"),
                      ),
                    ),
                  ]),
              SizedBox(
                height: 15.sp,
              ),
              const Expanded(
                  child: TabBarView(children: [
                TodayTab(),
                WeeklyTab(),
              ]))
            ],
          ),
        ));
  }
}

class EarningGraph extends StatelessWidget {
  const EarningGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140.sp,
      child: GetX<EarningController>(builder: (controller) {
        return controller.isGraphLoading.value
            ? LoadingBarsAnimation(
                height: 140.sp,
              )
            : controller.noDataForGraph.value
                ? EmptyPage(
                    text: "Data Earnings available",
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: controller.graphValues
                        .map((graphValue) => EarningGraphBar(
                              graphValue: graphValue,
                            ))
                        .toList(),
                  );
      }),
    );
  }
}

// ignore: must_be_immutable
class EarningGraphBar extends StatelessWidget {
  EarningsByDay? graphValue;

  EarningGraphBar({super.key, required this.graphValue});

  @override
  Widget build(BuildContext context) {
    final EarningController controller = Get.find();

    return GestureDetector(
      onTap: () {
        if (controller.selectGraphValue.value == graphValue) {
          controller.selectGraphValue.value = null;
        } else {
          controller.selectGraphValue.value = graphValue;
        }
        controller.startAnimation(amount: graphValue?.total ?? 0.0);
      },
      child: GetX<EarningController>(builder: (controller) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                  color: controller.selectGraphValue.value == graphValue
                      ? AppColors.blue
                      : AppColors.grey155,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.sp),
                    topRight: Radius.circular(8.sp),
                  )),
              height:
                  (graphValue?.total ?? 0) * (110 / controller.maxValue.value),
              width: ((Get.width - 60.sp) / 8) - 5.sp,
            ),
            SizedBox(
              height: 10.sp,
            ),
            Text(DateFormat("E").format(graphValue!.day!))
          ],
        );
      }),
    );
  }
}

class WeeklyTab extends StatelessWidget {
  const WeeklyTab({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AppRoutes1.getEraningScreenInRoute());
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 25.sp),
      shrinkWrap: true,
      children: [
        EarningSummaryWeekly(),
        SizedBox(
          height: 15.sp,
        ),
        const BalanceAmount(),
        SizedBox(
          height: 25.sp,
        ),
        // HomeController.to.weeklyEarningList.isEmpty
        //     ? EmptyPage(
        //         text: "No Earning found",
        //       )
        //     :
        // Column(
        //         children: controller.weeklyEarningList
        //             .map((earning) => EarningListingItem(
        //                   earning: earning,
        //                 ))
        //             .toList(),
        //       ),
        GetX<EarningController>(builder: (controller) {
          return controller.isTodayEarningsIsListCompleted.value
              ? const LoadingBarsAnimation()
              : const SizedBox();
        }),
      ],
    );
  }
}

class TodayTab extends StatelessWidget {
  const TodayTab({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(EarningController(parser: Get.find()));

    return GetX<EarningController>(builder: (controller) {
      return controller.isLoading.value
          ? const LoadingBarsAnimation()
          : controller.isError.value
              ? const ErrorPage()
              : ListView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.sp, vertical: 25.sp),
                  shrinkWrap: true,
                  children: [
                    const EarningSummaryToday(),
                    SizedBox(
                      height: 15.sp,
                    ),
                    const BalanceAmountToday(),
                    SizedBox(
                      height: 25.sp,
                    ),
                    // controller.weeklyEarningList.isEmpty
                    //     ? EmptyPage(
                    //         text: "No Earning found",
                    //       )
                    //     : Column(
                    //         children: controller.todayEarningList
                    //             .map((earning) => EarningListingItem(
                    //                   earning: earning,
                    //                 ))
                    //             .toList(),
                    //       ),
                    GetX<EarningController>(builder: (controller) {
                      return controller.isTodayEarningsIsListCompleted.value
                          ? const LoadingBarsAnimation()
                          : const SizedBox();
                    }),
                  ],
                );
    });
  }
}

// ignore: must_be_immutable
class EarningListingItem extends StatelessWidget {
  EarningListItem earning;

  EarningListingItem({super.key, required this.earning});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.sp),
      margin: EdgeInsets.only(bottom: 15.sp),
      decoration: BoxDecoration(
          color: Get.theme.indicatorColor.withOpacity(.05),
          borderRadius: BorderRadius.circular(8.sp)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleWithIcon(
                height: 40.sp,
                color: AppColors.blue,
                child: Image.asset(
                  earning.earningType == EarningType.ride
                      ? AppIcons.car
                      : AppIcons.referAndEarn,
                  height: 20.sp,
                  color: AppColors.white,
                ),
              ),
              SizedBox(
                width: 10.sp,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    earning.earningType == EarningType.ride
                        ? "Trip Fare Added"
                        : "Referal Erning added",
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                  ),
                  earning.paidTime != null
                      ? Text(
                          DateFormat("EEE dd MMM yyyy 'at' hh mm a")
                              .format(earning.paidTime!),
                          style: TextStyle(
                            fontSize: 12.sp,
                          ),
                        )
                      : const SizedBox()
                ],
              ),
            ],
          ),
          Text(
            "₹ +${earning.amount ?? "0.0"}",
            style: TextStyle(color: AppColors.green40),
          )
        ],
      ),
    );
  }
}

class BalanceAmountToday extends StatelessWidget {
  const BalanceAmountToday({super.key});

  @override
  Widget build(BuildContext context) {
    final EarningController controller = Get.find();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 20.sp),
      decoration: BoxDecoration(
          color: Get.theme.indicatorColor.withOpacity(.05),
          borderRadius: BorderRadius.circular(8.sp)),
      child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Balance Amount",
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  Text(
                    "₹ ${controller.todayBalanceAmount.value ?? "0"}",
                    style:
                        TextStyle(fontSize: 23.sp, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Payout scheduled: ${DateFormat("dd MMMM").format(controller.payOutDate.value)}",
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Obx(() {
                bool shouldDisable = controller.todayBalanceAmount.value == 0 ||
                    controller.isPaymentSuccessful.value ||
                    controller.isPaymentProcessing.value;

                return Opacity(
                  opacity: shouldDisable ? 0.5 : 1.0,
                  child: BlueButton(
                    width: 110.w,
                    height: 40.h,
                    fontSize: 12,
                    text: controller.isPaymentProcessing.value
                        ? 'Processing...'
                        : controller.isPaymentSuccessful.value
                            ? 'Payment Completed'
                            : controller.todayBalanceAmount.value == 0
                                ? 'No Amount Due'
                                : 'Pay Now',
                    onTap: shouldDisable
                        ? () {} // Empty function to prevent action
                        : () => controller.createOrder(
                            controller.todayBalanceAmount.value.toString()),
                  ),
                );
              })
            ],
          )),
    );
  }
}

class BalanceAmount extends StatelessWidget {
  const BalanceAmount({super.key});

  @override
  Widget build(BuildContext context) {
    final EarningController controller = Get.find();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 20.sp),
      decoration: BoxDecoration(
          color: Get.theme.indicatorColor.withOpacity(.05),
          borderRadius: BorderRadius.circular(8.sp)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Balance Amount",
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
              Text(
                "₹ ${controller.weeklyBalanceAmount.value ?? "0"}",
                style: TextStyle(fontSize: 23.sp, fontWeight: FontWeight.w600),
              ),
              Text(
                "Payout scheduled: ${DateFormat("dd MMMM").format(controller.payOutDate.value)}",
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Obx(() {
            bool shouldDisable = controller.weeklyBalanceAmount.value == 0 ||
                controller.isPaymentSuccessful.value ||
                controller.isPaymentProcessing.value;

            return Opacity(
              opacity: shouldDisable ? 0.5 : 1.0,
              child: BlueButton(
                width: 110.w,
                height: 40.h,
                fontSize: 12,
                text: controller.isPaymentProcessing.value
                    ? 'Processing...'
                    : controller.isPaymentSuccessful.value
                        ? 'Payment Completed'
                        : controller.weeklyBalanceAmount.value == 0
                            ? 'No Amount Due'
                            : 'Pay Now',
                onTap: shouldDisable
                    ? () {} // Empty function to prevent action
                    : () => controller.createOrder(
                        controller.weeklyBalanceAmount.value.toString()),
              ),
            );
          })
        ],
      ),
    );
  }
}

class PreviousWeek extends StatelessWidget {
  const PreviousWeek({super.key});

  @override
  Widget build(BuildContext context) {
    final EarningController controller = Get.find();

    return GestureDetector(
        onTap: () => controller.getPreviousWeekData(),
        child: const Icon(Icons.arrow_back_ios));
  }
}

class NextWeek extends StatelessWidget {
  const NextWeek({super.key});

  @override
  Widget build(BuildContext context) {
    final EarningController controller = Get.find();

    return GestureDetector(
        onTap: () => controller.getNextWeekData(),
        child: const Icon(Icons.arrow_forward_ios_rounded));
  }
}

class DateForGraphWeekly extends StatelessWidget {
  const DateForGraphWeekly({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GetX<EarningController>(builder: (controller) {
          return controller.weeklyDateEnd.value.changeDateFormat() ==
                  DateTime.now()
                      .subtract(const Duration(days: 7 * 10))
                      .changeDateFormat()
              ? const SizedBox()
              : const PreviousWeek();
        }),
        GetX<EarningController>(builder: (controller) {
          return controller.selectGraphValue.value?.day == null
              ? Text(
                  "${controller.weeklyDateEnd.value.subtract(const Duration(days: 7)).changeDateFormat(format: "EEE dd MMM yyyy")} to ${controller.weeklyDateEnd.value.changeDateFormat(format: "EEE dd MMM yyyy")}",
                  style: TextStyle(
                      color: Get.theme.indicatorColor.withOpacity(0.5),
                      fontSize: 14.sp))
              : Text(
                  DateFormat("EEE dd MMM yyyy").format(
                      controller.selectGraphValue.value?.day ?? DateTime.now()),
                  style: TextStyle(
                      color: Get.theme.indicatorColor.withOpacity(.05),
                      fontSize: 14.sp));
        }),
        GetX<EarningController>(builder: (controller) {
          return controller.weeklyDateEnd.value.changeDateFormat() ==
                  DateTime.now().changeDateFormat()
              ? const SizedBox()
              : const NextWeek();
        }),
      ],
    );
  }
}

class EarningSummaryWeekly extends StatelessWidget {
  final bool? isWeekly;

  const EarningSummaryWeekly({super.key, this.isWeekly});

  @override
  Widget build(BuildContext context) {
    final EarningController controller = Get.find();
    return Container(
      padding: EdgeInsets.all(15.sp),
      decoration: BoxDecoration(
          color: Get.theme.indicatorColor.withOpacity(.05),
          borderRadius: BorderRadius.circular(8.sp)),
      child: Column(
        children: [
          const DateForGraphWeekly(),
          AnimatedBuilder(
              animation: controller.controller,
              builder: (BuildContext context, Widget? child) {
                return Text(
                    (controller.animation.value.roundToDouble()).toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 22.sp));
              }),
          SizedBox(
            height: 25.sp,
          ),
          // const EarningGraph(),
          SizedBox(
            height: 15.sp,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              EarningItem(item: controller.weeklyTrips),
              EarningItemHours(item: controller.weeklyOnlineHours),
              EarningItemDistance(item: controller.weeklyDistance),
            ],
          ),
          GetX<EarningController>(builder: (controller) {
            return controller.isGraphLoading.value
                ? LoadingAnimationDots()
                : ExpansionTile(
                    shape: const Border(),
                    tilePadding: EdgeInsets.zero,
                    childrenPadding: EdgeInsets.zero,
                    title: const Text(
                      "Details",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    children: [
                      Obx(() {
                        return DetailsItemView(
                          text: "Your earnings",
                          value: "₹ ${controller.weeklyTripFare.value}",
                        );
                      }),
                      // DetailsItemView(
                      //   text: "Waiver Charge",
                      //   value: "- ₹ ${controller.weeklyWaiverCharge}",
                      // ),
                      // DetailsItemView(
                      //   text: "Tax",
                      //   value: "- ₹ ${controller.weeklyTax}",
                      // ),
                      DetailsItemView(
                        text: "Incentives",
                        value: "- ₹ ${controller.weeklyIncentives}",
                      ),
                      DetailsItemView(
                        text: "Refer Earnings",
                        value: "₹ ${controller.weeklyReferEarnings}",
                      ),
                      SizedBox(
                        height: 10.sp,
                      ),
                    ],
                  );
          }),
          Divider(
            height: 1.5.sp,
          ),
          SizedBox(
            height: 10.sp,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Payment",
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              ),
              GetX<EarningController>(builder: (controller) {
                return Text(
                  "₹ ${controller.weeklyTripFare ?? 0.0}",
                  style:
                      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                );
              }),
            ],
          )
        ],
      ),
    );
  }
}

// class EarningItem extends StatelessWidget {
//   EarningItemModel item;
//   EarningItem({
//     super.key,
//     required this.item,
//   });
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: Get.width * .25,
//       padding: EdgeInsets.symmetric(vertical: 16.sp),
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10.sp),
//           border: Border.all(width: 1.5.sp, color: AppColors.grey155)),
//       child: Column(
//         children: [
//           CircleWithIcon(
//               height: 30.sp, color: AppColors.blue, child: item.icon),
//           SizedBox(
//             height: 10.sp,
//           ),
//           GetX<EarningController>(builder: (controller) {
//             return Text(
//               item.value.toString() ?? "0",
//               style: TextStyle(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w500,
//                   color: AppColors.black),
//             );
//           }),
//           Text(
//             item.text,
//             style: TextStyle(
//               fontSize: 12.sp,
//               fontWeight: FontWeight.w500,
//               color: Get.theme.indicatorColor.withOpacity(.5),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

class EarningItem extends StatelessWidget {
  final EarningItemModel item;

  const EarningItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * .25,
      padding: EdgeInsets.symmetric(vertical: 16.sp),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.sp),
          border: Border.all(width: 1.5.sp, color: AppColors.grey155)),
      child: Column(
        children: [
          CircleWithIcon(
              height: 30.sp, color: AppColors.blue, child: item.icon),
          SizedBox(
            height: 10.sp,
          ),
          // This is the main issue - using Obx and accessing value.value correctly
          Obx(() => Text(
                "${item.value.value}",
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black),
              )),
          Text(
            item.text,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: Get.theme.indicatorColor.withOpacity(.5),
            ),
          )
        ],
      ),
    );
  }
}

class EarningItemDistance extends StatelessWidget {
  final EarningItemModel item;

  const EarningItemDistance({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * .25,
      padding: EdgeInsets.symmetric(vertical: 16.sp),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.sp),
          border: Border.all(width: 1.5.sp, color: AppColors.grey155)),
      child: Column(
        children: [
          CircleWithIcon(
              height: 30.sp, color: AppColors.blue, child: item.icon),
          SizedBox(
            height: 10.sp,
          ),
          // This is the main issue - using Obx and accessing value.value correctly
          Obx(() => Container(
                child: Text(
                  "${(item.value.value)}Km",
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black),
                ),
              )),
          Text(
            item.text,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: Get.theme.indicatorColor.withOpacity(.5),
            ),
          )
        ],
      ),
    );
  }
}

class EarningItemHours extends StatelessWidget {
  final EarningItemModel item;

  const EarningItemHours({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * .25,
      padding: EdgeInsets.symmetric(vertical: 16.sp),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.sp),
          border: Border.all(width: 1.5.sp, color: AppColors.grey155)),
      child: Column(
        children: [
          CircleWithIcon(
              height: 30.sp, color: AppColors.blue, child: item.icon),
          SizedBox(
            height: 10.sp,
          ),
          // This is the main issue - using Obx and accessing value.value correctly
          Obx(() => Text(
                "${AppConstants.formatSecondsToHrAndMinForDouble(item.value.value)}",
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black),
              )),
          Text(
            item.text,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: Get.theme.indicatorColor.withOpacity(.5),
            ),
          )
        ],
      ),
    );
  }
}

// class EarningSummaryToday extends StatelessWidget {
//   const EarningSummaryToday({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final EarningController controller = Get.find();

//     return Container(
//       padding: EdgeInsets.all(15.sp),
//       decoration: BoxDecoration(
//           color: Get.theme.indicatorColor.withOpacity(.05),
//           borderRadius: BorderRadius.circular(8.sp)),
//       child: Column(
//         children: [
//           Text(DateFormat("EEE dd MMM yyyy").format(DateTime.now()),
//               style: TextStyle(fontSize: 14.sp)),
//           Text(
//             "₹ ${controller.todayEarning.value ?? 0}",
//             style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22.sp),
//           ),
//           SizedBox(
//             height: 25.sp,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               EarningItem(item: controller.todayTrips),
//               EarningItem(item: controller.todayOnlineHours),
//               EarningItem(item: controller.todayDistance),
//             ],
//           ),
//           ExpansionTile(
//             shape: const Border(),
//             tilePadding: EdgeInsets.zero,
//             childrenPadding: EdgeInsets.zero,
//             title: const Text(
//               "Details",
//               style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//             ),
//             children: [
//               DetailsItemView(
//                 text: "Trip Fare",
//                 value: "₹ ${controller.todayTripFare ?? 0.0}",
//               ),
//               DetailsItemView(
//                 text: "Waiver Charge",
//                 value: "- ₹ ${controller.todayWaiverCharge ?? 0.0}",
//               ),
//               DetailsItemView(
//                 text: "Tax",
//                 value: "- ₹ ${controller.todayTax ?? 0.0}",
//               ),
//               DetailsItemView(
//                 text: "Incentives",
//                 value: "- ₹ ${controller.todayIncentives ?? 0.0}",
//               ),
//               DetailsItemView(
//                 text: "Refer Earnings",
//                 value: "₹ ${controller.todayReferEarnings ?? 0.0}",
//               ),
//               SizedBox(
//                 height: 10.sp,
//               ),
//             ],
//           ),
//           Divider(
//             height: 1.5.sp,
//           ),
//           SizedBox(
//             height: 10.sp,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Payment",
//                 style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
//               ),
//               Text(
//                 "₹ ${controller.todayPayment ?? 0.0}",
//                 style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }

class EarningSummaryToday extends StatelessWidget {
  const EarningSummaryToday({super.key});

  @override
  Widget build(BuildContext context) {
    final EarningController controller = Get.find();

    return Container(
      padding: EdgeInsets.all(15.sp),
      decoration: BoxDecoration(
          color: Get.theme.indicatorColor.withOpacity(.05),
          borderRadius: BorderRadius.circular(8.sp)),
      child: Column(
        children: [
          Text(DateFormat("EEE dd MMM yyyy").format(DateTime.now()),
              style: TextStyle(fontSize: 14.sp)),

          // Wrap only the specific widget that needs to be updated
          Obx(() => Text(
                "₹ ${controller.todayEarning.value ?? 0}",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22.sp),
              )),

          SizedBox(
            height: 25.sp,
          ),

          // Each row item should have its own Obx in the EarningItem widget
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              EarningItem(item: controller.todayTrips),
              EarningItemHours(item: controller.todayOnlineHours),
              EarningItemDistance(item: controller.todayDistance),
            ],
          ),

          ExpansionTile(
            shape: const Border(),
            tilePadding: EdgeInsets.zero,
            childrenPadding: EdgeInsets.zero,
            title: const Text(
              "Details",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            children: [
              // Each detail item should have its own Obx
              Obx(() => DetailsItemView(
                    text: "Your earnings",
                    value: "₹ ${controller.todayTripFare.value ?? 0.0}",
                  )),
              // Obx(() => DetailsItemView(
              //       text: "Waiver Charge",
              //       value: "- ₹ ${controller.todayWaiverCharge.value ?? 0.0}",
              //     )),
              // Obx(() => DetailsItemView(
              //       text: "Tax",
              //       value: "- ₹ ${controller.todayTax.value ?? 0.0}",
              //     )),
              Obx(() => DetailsItemView(
                    text: "Incentives",
                    value: "- ₹ ${controller.todayIncentives.value ?? 0.0}",
                  )),
              Obx(() => DetailsItemView(
                    text: "Refer Earnings",
                    value: "₹ ${controller.todayReferEarnings.value ?? 0.0}",
                  )),
              SizedBox(
                height: 10.sp,
              ),
            ],
          ),

          Divider(
            height: 1.5.sp,
          ),

          SizedBox(
            height: 10.sp,
          ),

          // Wrap this specific row for the payment information
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Payment",
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "₹ ${controller.todayTripFare.value ?? 0.0}",
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}

class DetailsItemView extends StatelessWidget {
  final String text;
  final String value;

  const DetailsItemView({super.key, required this.text, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class TodayOrWeekSelection extends StatelessWidget {
  const TodayOrWeekSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TodayOrWeekSelectionItem(
          header: "Today",
        ),
        TodayOrWeekSelectionItem(
          header: "Weekly",
        ),
      ],
    );
  }
}

class TodayOrWeekSelectionItem extends StatelessWidget {
  final String header;

  const TodayOrWeekSelectionItem({super.key, required this.header});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.blue),
      child: Text(
        header,
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp),
      ),
    );
  }
}
