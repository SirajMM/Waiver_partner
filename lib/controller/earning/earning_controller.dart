import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:waiver_driver/backend/model/earning/earning_model.dart';
import 'package:waiver_driver/backend/parser/Earning/earningscreen_parser.dart';
import 'package:waiver_driver/core/themes/assets/icons.dart';
import 'package:waiver_driver/helper/validator/app_extensions/app_extensions.dart';

import '../../backend/api/api_services/api_services.dart';
import '../../core/colors/app_colors.dart';
import '../../core/widgets/circle_with_gradient/circle_with_gradient.dart';
import '../../helper/router/app_routes/route.dart';

// class EarningControllerBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.put(EarningController());
//   }
// }

class EarningController extends GetxController
    with GetSingleTickerProviderStateMixin {
  EarningscreenParser parser;
  EarningController({required this.parser});

  static EarningController get to => Get.find();

  @override
  void onInit() async {
    super.onInit();
    Get.put(AppRoutes1.getEraningScreenInRoute());

    try {
      isLoading.value = true;

      curve = CurvedAnimation(parent: controller, curve: Curves.easeOut);
      animation = Tween(begin: 0.0, end: 0.0).animate(curve);
      await Future.wait([
        getEarningStatusWeekly(),
        getEarnings(),
        getEarningsWeekly(),
        getEarningStatusToday()
      ]);
      isError.value = false;
    } catch (error) {
      log(error.toString());
      isError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  startAnimation({required double amount}) {
    controller.reset();
    controller.forward();
    animation =
        Tween(begin: weeklyEarning.value ?? 0.0, end: amount).animate(curve);
  }

  late AnimationController controller = AnimationController(
      duration: const Duration(milliseconds: 250), vsync: this);
  late Animation<double> animation;
  late Animation<double> curve;

  RxBool isTodayEarningsIsListCompleted = false.obs;
  RxBool isWeeklyEarningsIsListCompleted = false.obs;
  Future<void> getEarnings() async {
    var response = await ApiServices.getEarnings(queryParameter: {
      "start_date": DateTime.now().changeDateFormat(),
      "end_date": DateTime.now().changeDateFormat(),
    });
    todayEarningList.addAll(response.data?.results ?? []);
    // isTodayEarningsIsListCompleted.value = response.data?.next ?? false;
    isTodayEarningsIsListCompleted.value = false;
  }

  Future<void> getEarningsWeekly() async {
    var response = await ApiServices.getEarnings(queryParameter: {
      "start_date": weeklyDateEnd.value
          .subtract(const Duration(days: 7))
          .changeDateFormat(),
      "end_date": weeklyDateEnd.value.changeDateFormat()
    });

    weeklyEarningList.addAll(response.data?.results ?? []);
    // isWeeklyEarningsIsListCompleted.value = response.data?.next ?? false;
    isWeeklyEarningsIsListCompleted.value = false;
  }

  RxBool isLoading = false.obs;
  RxBool isError = false.obs;

  Future<void> getEarningStatusWeekly() async {
    GetEarningStatusResponseModel response =
        await ApiServices.getEarningStatus(queryParameter: {
      "start_date": weeklyDateEnd.value
          .subtract(const Duration(days: 7))
          .changeDateFormat(),
      "end_date": weeklyDateEnd.value.changeDateFormat()
    });
    startAnimation(amount: response.data?.earnings?.total ?? 0);
    weeklyEarning.value = (response.data?.earnings?.total ?? 0);

    graphValues.value = response.data?.earnings?.earningsByDay ?? [];
    noDataForGraph.value = (graphValues.isEmpty);
    if (graphValues.length >= 2) {
      maxValue.value = graphValues
              .reduce((a, b) => (a?.total ?? 0) > (b?.total ?? 0) ? a : b)
              ?.total ??
          1;
    }
    weeklyTrips.value.value = (response.data?.rides?.totalRides ?? 0);
    weeklyDistance.value.value = (response.data?.rides?.totalDistance ?? 0);
    weeklyOnlineHours.value.value = (response.data?.rides?.totalDuration ?? 0);
    weeklyTripFare = response.data?.earnings?.rideFare ?? 0;
    weeklyWaiverCharge = response.data?.earnings?.waiverCharge ?? 0;
    weeklyTax = response.data?.earnings?.tax ?? 0;
    weeklyIncentives = response.data?.earnings?.incentives ?? 0;
    weeklyReferEarnings = response.data?.earnings?.referrals ?? 0;
    weeklyPayment.value = response.data?.earnings?.total ?? 0;
    print(weeklyTripFare);
  }

  RxBool noDataForGraph = false.obs;
  getPreviousWeekData() async {
    try {
      isGraphLoading.value = true;
      weeklyDateEnd.value = EarningController.to.weeklyDateEnd.value
          .subtract(const Duration(days: 7));
      selectGraphValue.value = null;
      await getEarningStatusWeekly();
    } finally {
      isGraphLoading.value = false;
    }
  }

  getNextWeekData() async {
    try {
      isGraphLoading.value = true;
      weeklyDateEnd.value =
          EarningController.to.weeklyDateEnd.value.add(const Duration(days: 7));
      selectGraphValue.value = null;
      await getEarningStatusWeekly();
    } finally {
      isGraphLoading.value = false;
    }
  }

  RxBool isGraphLoading = false.obs;

  Future<void> getEarningStatusToday() async {
    var response = await ApiServices.getEarningStatus(queryParameter: {
      "start_date": DateTime.now().changeDateFormat(),
      "end_date": DateTime.now().changeDateFormat(),
    });
    todayEarning = response.data?.earnings?.total ?? 0;
    todayTrips.value.value = (response.data?.rides?.totalRides ?? 0);
    todayDistance.value.value = (response.data?.rides?.totalDistance ?? 0);
    todayOnlineHours.value.value = (response.data?.rides?.totalDuration ?? 0);
    todayTripFare = response.data?.earnings?.rideFare ?? 0;
    todayWaiverCharge = response.data?.earnings?.waiverCharge ?? 0;
    todayTax = response.data?.earnings?.tax ?? 0;
    todayIncentives = response.data?.earnings?.incentives ?? 0;
    todayReferEarnings = response.data?.earnings?.referrals ?? 0;
    todayPayment = response.data?.earnings?.total ?? 0;
    todayBalanceAmount = response.data?.earnings?.total ?? 0;
  }

  String tt = "";
  Rx<DateTime> weeklyDateEnd = DateTime.now().obs;
  double? todayEarning;
  Rx<double?> weeklyEarning = Rx<double?>(null);
  double? todayTripFare;
  double? weeklyTripFare;
  double? todayWaiverCharge;
  double? weeklyWaiverCharge;
  double? todayTax;
  double? weeklyTax;
  double? todayIncentives;
  double? weeklyIncentives;
  double? weeklyReferEarnings;
  double? todayReferEarnings;
  Rx<double?> weeklyPayment = Rx<double?>(null);
  double? todayPayment;
  double? weeklyBalanceAmount;
  double? todayBalanceAmount;
  RxList<EarningListItem> todayEarningList = <EarningListItem>[].obs;
  RxList<EarningListItem> weeklyEarningList = <EarningListItem>[].obs;
  RxList<EarningsByDay?> graphValues = <EarningsByDay?>[].obs;
  RxDouble maxValue = 1.0.obs;

  Rx<EarningsByDay?> selectGraphValue = Rx<EarningsByDay?>(null);

  DateTime payOutDate = DateTime.now();

  EarningItemModel weeklyTrips = EarningItemModel(
      icon: CircleWithIcon(
        height: 40.sp,
        color: AppColors.blue,
        child: Image.asset(
          AppIcons.car,
          height: 20.sp,
          color: AppColors.white,
        ),
      ),
      value: 55.0.obs,
      text: 'Trips');
  EarningItemModel weeklyOnlineHours = EarningItemModel(
    icon: CircleWithIcon(
      height: 40.sp,
      color: AppColors.blue,
      child: Image.asset(
        AppIcons.clock,
        height: 20.sp,
        color: AppColors.white,
      ),
    ),
    value: 8.40.obs,
    text: 'Online Hours',
  );
  EarningItemModel weeklyDistance = EarningItemModel(
      icon: CircleWithIcon(
        height: 40.sp,
        color: AppColors.blue,
        child: Image.asset(
          AppIcons.location,
          height: 20.sp,
          color: AppColors.white,
        ),
      ),
      value: 24.5.obs,
      text: 'Distance');

  EarningItemModel todayTrips = EarningItemModel(
      icon: CircleWithIcon(
        height: 40.sp,
        color: AppColors.blue,
        child: Image.asset(
          AppIcons.car,
          height: 20.sp,
          color: AppColors.white,
        ),
      ),
      value: 55.0.obs,
      text: 'Trips');
  EarningItemModel todayOnlineHours = EarningItemModel(
      icon: CircleWithIcon(
        height: 40.sp,
        color: AppColors.blue,
        child: Image.asset(
          AppIcons.clock,
          height: 20.sp,
          color: AppColors.white,
        ),
      ),
      value: 8.40.obs,
      text: 'Online Hours');
  EarningItemModel todayDistance = EarningItemModel(
      icon: CircleWithIcon(
        height: 40.sp,
        color: AppColors.blue,
        child: Image.asset(
          AppIcons.location,
          height: 20.sp,
          color: AppColors.white,
        ),
      ),
      value: 24.5.obs,
      text: 'Distance');
}
