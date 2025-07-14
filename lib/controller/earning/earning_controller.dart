import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'package:waiver_driver/backend/model/earning/earning_model.dart';
import 'package:waiver_driver/backend/parser/Earning/earningscreen_parser.dart';
import 'package:waiver_driver/core/themes/assets/icons.dart';
import 'package:waiver_driver/helper/validator/app_extensions/app_extensions.dart';

import '../../backend/api/api_services/api_services.dart';
import '../../core/colors/app_colors.dart';
import '../../core/constants/get_storage_constants.dart';
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

  // static EarningController get to => Get.find();
  late Razorpay razorpay;
  @override
  void onInit() async {
    super.onInit();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlePaymentExternalWallet);
    Get.put(AppRoutes1.getEraningScreenInRoute());

    try {
      isLoading.value = true;

      curve = CurvedAnimation(parent: controller, curve: Curves.easeOut);
      animation = Tween(begin: 0.0, end: 0.0).animate(curve);
      // await Future.wait([
      getEarningStatusWeekly();
      getEarnings();
      getEarningsWeekly();
      getEarningStatusToday();
      // ]);
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
    try {
      var response = await ApiServices.getEarnings(queryParameter: {
        "start_date": DateTime.now().changeDateFormat(),
        "end_date": DateTime.now().changeDateFormat(),
      });

      todayEarningList.addAll(response.data?.results ?? []);
      // isTodayEarningsIsListCompleted.value = response.data?.next ?? false;
      // isTodayEarningsIsListCompleted.value = false;
    } catch (error, s) {
      AppConstants.handleError(error, s: s);
      print('Error fetching earnings: $error');
    } finally {
      print('API call completed');
    }
  }

  Future<void> getEarningsWeekly() async {
    try {
      var response = await ApiServices.getEarnings(queryParameter: {
        "start_date": weeklyDateEnd.value
            .subtract(const Duration(days: 7))
            .changeDateFormat(),
        "end_date": weeklyDateEnd.value.changeDateFormat()
      });

      weeklyEarningList.addAll(response.data?.results ?? []);
      // isWeeklyEarningsIsListCompleted.value = response.data?.next ?? false;
      // isWeeklyEarningsIsListCompleted.value = false;
    } catch (error, s) {
      print('Error fetching weekly earnings: $error');
      AppConstants.handleError(error, s: s);
    } finally {
      // Code that always executes (cleanup, loading states, etc.)
      // isWeeklyLoading.value = false;
      print('Weekly earnings API call completed');
    }
  }

  RxBool isLoading = false.obs;
  RxBool isError = false.obs;

  // Future<void> getEarningStatusWeekly() async {
  //   GetEarningStatusResponseModel response =
  //       await ApiServices.getEarningStatus(queryParameter: {
  //     "start_date": weeklyDateEnd.value
  //         .subtract(const Duration(days: 7))
  //         .changeDateFormat(),
  //     "end_date": weeklyDateEnd.value.changeDateFormat()
  //   });
  //   startAnimation(amount: response.data?.earnings?.total ?? 0);
  //   weeklyEarning.value = (response.data?.earnings?.total ?? 0);

  //   graphValues.value = response.data?.earnings?.earningsByDay ?? [];
  //   noDataForGraph.value = (graphValues.isEmpty);
  //   if (graphValues.length >= 2) {
  //     maxValue.value = graphValues
  //             .reduce((a, b) => (a?.total ?? 0) > (b?.total ?? 0) ? a : b)
  //             ?.total ??
  //         1;
  //   }
  //   weeklyTrips.value.value = (response.data?.rides?.totalRides ?? 0);
  //   weeklyDistance.value.value = (response.data?.rides?.totalDistance ?? 0);
  //   weeklyOnlineHours.value.value = (response.data?.rides?.totalDuration ?? 0);
  //   weeklyTripFare = response.data?.earnings?.rideFare ?? 0;
  //   weeklyWaiverCharge = response.data?.earnings?.waiverCharge ?? 0;
  //   weeklyTax = response.data?.earnings?.tax ?? 0;
  //   weeklyIncentives = response.data?.earnings?.incentives ?? 0;
  //   weeklyReferEarnings = response.data?.earnings?.referrals ?? 0;
  //   weeklyPayment.value = response.data?.earnings?.total ?? 0;
  //   print(weeklyTripFare);
  // }

  Future<void> getEarningStatusWeekly() async {
    try {
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
      weeklyOnlineHours.value.value =
          (response.data?.rides?.totalDuration ?? 0);
      weeklyTripFare = response.data?.earnings?.rideFare ?? 0;
      weeklyWaiverCharge = response.data?.earnings?.waiverCharge ?? 0;
      weeklyTax = response.data?.earnings?.tax ?? 0;
      weeklyIncentives = response.data?.earnings?.incentives ?? 0;
      weeklyReferEarnings = response.data?.earnings?.referrals ?? 0;
      weeklyPayment.value = response.data?.earnings?.total ?? 0;
      print(weeklyTripFare);
    } catch (error, s) {
      AppConstants.handleError(error, s: s);
      print('Error fetching weekly earning status: $error');

      // Set default values on error to prevent UI issues
      weeklyEarning.value = 0;
      graphValues.value = [];
      noDataForGraph.value = true;
      maxValue.value = 1;
      weeklyTrips.value.value = 0;
      weeklyDistance.value.value = 0;
      weeklyOnlineHours.value.value = 0;
      weeklyTripFare = 0;
      weeklyWaiverCharge = 0;
      weeklyTax = 0;
      weeklyIncentives = 0;
      weeklyReferEarnings = 0;
      weeklyPayment.value = 0;

      // Optional: Set error state or show error message
      // errorMessage.value = 'Failed to load weekly earning status';
    } finally {
      // Code that always executes (cleanup, loading states, etc.)
      // isWeeklyStatusLoading.value = false;
      print('Weekly earning status API call completed');
    }
  }

  RxBool noDataForGraph = false.obs;
  getPreviousWeekData() async {
    try {
      isGraphLoading.value = true;
      weeklyDateEnd.value =
          weeklyDateEnd.value.subtract(const Duration(days: 7));
      selectGraphValue.value = null;
      await getEarningStatusWeekly();
    } finally {
      isGraphLoading.value = false;
    }
  }

  getNextWeekData() async {
    try {
      isGraphLoading.value = true;
      weeklyDateEnd.value = weeklyDateEnd.value.add(const Duration(days: 7));
      selectGraphValue.value = null;
      await getEarningStatusWeekly();
    } finally {
      isGraphLoading.value = false;
    }
  }

  RxBool isGraphLoading = false.obs;

  // Future<void> getEarningStatusToday() async {
  //   var response = await ApiServices.getEarningStatus(queryParameter: {
  //     "start_date": DateTime.now().changeDateFormat(),
  //     "end_date": DateTime.now().changeDateFormat(),
  //   });
  //   todayEarning.value = response.data?.earnings?.total ?? 0;
  //   todayTrips.value.value = (response.data?.rides?.totalRides ?? 0);
  //   todayDistance.value.value = (response.data?.rides?.totalDistance ?? 0);
  //   todayOnlineHours.value.value = (response.data?.rides?.totalDuration ?? 0);
  //   todayTripFare.value = response.data?.earnings?.rideFare ?? 0;
  //   todayWaiverCharge.value = response.data?.earnings?.waiverCharge ?? 0;
  //   todayTax.value = response.data?.earnings?.tax ?? 0;
  //   todayIncentives.value = response.data?.earnings?.incentives ?? 0;
  //   todayReferEarnings.value = response.data?.earnings?.referrals ?? 0;
  //   todayPayment.value = response.data?.earnings?.total ?? 0;
  //   todayBalanceAmount.value = response.data?.earnings?.total ?? 0;
  // }

  Future<void> getEarningStatusToday() async {
    try {
      var response = await ApiServices.getEarningStatus(queryParameter: {
        "start_date": DateTime.now().changeDateFormat(),
        "end_date": DateTime.now().changeDateFormat(),
      });

      todayEarning.value = response.data?.earnings?.total ?? 0;
      todayTrips.value.value = (response.data?.rides?.totalRides ?? 0);
      todayDistance.value.value = (response.data?.rides?.totalDistance ?? 0);
      todayOnlineHours.value.value = (response.data?.rides?.totalDuration ?? 0);
      todayTripFare.value = response.data?.earnings?.rideFare ?? 0;
      todayWaiverCharge.value = response.data?.earnings?.waiverCharge ?? 0;
      todayTax.value = response.data?.earnings?.tax ?? 0;
      todayIncentives.value = response.data?.earnings?.incentives ?? 0;
      todayReferEarnings.value = response.data?.earnings?.referrals ?? 0;
      todayPayment.value = response.data?.earnings?.total ?? 0;
      todayBalanceAmount.value = response.data?.earnings?.total ?? 0;
    } catch (error, s) {
      print('Error fetching today\'s earning status: $error');

      AppConstants.handleError(error, s: s);
      // Set default values on error to prevent UI issues
      todayEarning.value = 0;
      todayTrips.value.value = 0;
      todayDistance.value.value = 0;
      todayOnlineHours.value.value = 0;
      todayTripFare.value = 0;
      todayWaiverCharge.value = 0;
      todayTax.value = 0;
      todayIncentives.value = 0;
      todayReferEarnings.value = 0;
      todayPayment.value = 0;
      todayBalanceAmount.value = 0;

      // Optional: Set error state or show error message
      // errorMessage.value = 'Failed to load today\'s earning status';
    } finally {
      // Code that always executes (cleanup, loading states, etc.)
      // isTodayStatusLoading.value = false;
      print('Today\'s earning status API call completed');
    }
  }

  String tt = "";
  Rx<DateTime> weeklyDateEnd = DateTime.now().obs;
  Rx<double?> todayEarning = Rx<double?>(null);
  Rx<double?> weeklyEarning = Rx<double?>(null);
  Rx<double?> todayTripFare = Rx<double?>(null);
  double? weeklyTripFare;
  Rx<double?> todayWaiverCharge = Rx<double?>(null);
  double? weeklyWaiverCharge;
  Rx<double?> todayTax = Rx<double?>(null);
  double? weeklyTax;
  Rx<double?> todayIncentives = Rx<double?>(null);
  double? weeklyIncentives;
  double? weeklyReferEarnings;
  Rx<double?> todayReferEarnings = Rx<double?>(null);
  Rx<double?> weeklyPayment = Rx<double?>(null);
  Rx<double?> todayPayment = Rx<double?>(null);
  double? weeklyBalanceAmount;
  Rx<double?> todayBalanceAmount = Rx<double?>(null);
  RxList<EarningListItem> todayEarningList = <EarningListItem>[].obs;
  RxList<EarningListItem> weeklyEarningList = <EarningListItem>[].obs;
  RxList<EarningsByDay?> graphValues = <EarningsByDay?>[].obs;
  RxDouble maxValue = 1.0.obs;

  Rx<EarningsByDay?> selectGraphValue = Rx<EarningsByDay?>(null);

  Rx<DateTime> payOutDate = Rx<DateTime>(DateTime.now());

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
      value: 0.0.obs,
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
    value: 0.0.obs,
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
      value: 0.0.obs,
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
      value: 0.0.obs,
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
      value: 0.0.obs,
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
      value: 0.0.obs,
      text: 'Distance');

  Future<void> handlePaymentSuccess(PaymentSuccessResponse response) async {
    // print(response.data);
    // razorpayPaymentId = response.paymentId ?? "";
    // razorpaySignature = response.signature ?? "";
    // Get.dialog(PaymentDialog(
    //   isSuccess: true,
    //   message: response.paymentId ?? '',
    // ));
    //
    // await paymentSuccessful();
  }

  void handlePaymentError(PaymentFailureResponse response) {
    // getRidePayment(rideID.value);
    // print(response.message);
    // Get.dialog(PaymentDialog(
    //   isSuccess: false,
    //   message: response.message ?? '',
    // ));
  }

  void handlePaymentExternalWallet(ExternalWalletResponse response) {
    // print(response);
    // Get.dialog(PaymentDialog(
    //   isSuccess: true,
    //   message: response.walletName ?? '',
    // ));
  }
  void checkOut(String amount) {
    Map<String, dynamic> options = {
      'key': 'rzp_live_AGIJ73c4q0mVTI',
      'order_id': '',
      'amount': amount,
      'name': 'waiver',
      'prefill': {'contact': '123245', 'email': 'jho@gmail.com'},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      razorpay.open(options);
    } catch (e, stackTrace) {
      debugPrint('Error: $e');
      debugPrint('Stack Trace: $stackTrace');
      print(options);
    }
  }
}
