import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waiver_driver/backend/model/home/home_model.dart';
import 'package:waiver_driver/backend/model/rating/rating_model.dart';
import 'package:waiver_driver/backend/parser/Rating/ratingscreen_parser.dart';

import '../../backend/api/api_services/api_services.dart';
import '../../core/colors/app_colors.dart';
import '../../core/constants/get_storage_constants.dart';

// class RatingControllerBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut(() => RatingController());
//   }
// }

class RatingController extends GetxController {
  RatingscreenParser parser;
  RatingController({required this.parser});

  @override
  void onInit() async {
    super.onInit();

    try {
      isLoading.value = true;
      await Future.wait([getReviews(), getReviewsStatus()]);
      isError.value = false;
    } catch (error, s) {
      log(error.toString(), error: error, stackTrace: s);
      isError.value = true;
    } finally {
      isLoading.value = false;
    }

    scrollController.addListener(() {
      if (isListCompeted.value &&
          scrollController.position.maxScrollExtent ==
              scrollController.position.pixels) {
        getReviews();
      }
    });
  }

  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  RxBool isListCompeted = false.obs;
  ScrollController scrollController = ScrollController();
  Future<void> getReviews() async {
    try {
      var response = await ApiServices.getReviews();
      ratingsList.addAll(response.data?.results ?? []);
      isListCompeted.value = response.data?.next ?? false;
    } catch (error, s) {
      AppConstants.handleError(error, s: s);
      print('Error fetching reviews: $error');
    } finally {}
  }

  Future<void> getReviewsStatus() async {
    try {
      GetReviewStatusResponseModel response =
          await ApiServices.getReviewsStatus();
      acceptance.value = "${response.data?.acceptance ?? 0.0} %";
      rating.value = "${response.data?.rating ?? 0.0} ";
      cancellation.value = "${response.data?.cancellation ?? 0.0} %";
    } catch (error, s) {
      // Handle error appropriately
      print('Error fetching review status: $error');
      // Set default values or error state
      acceptance.value = "0.0 %";
      rating.value = "0.0 ";
      cancellation.value = "0.0 %";
      // errorMessage.value = 'Failed to load review status';
      AppConstants.handleError(error, s: s);
    } finally {}
  }

  static RatingController get to => Get.find();
  DashBoardItemModel acceptance = DashBoardItemModel(
      icon: Icon(
        Icons.check,
        color: AppColors.white,
      ),
      value: '11',
      text: 'Acceptance');
  DashBoardItemModel rating = DashBoardItemModel(
      icon: Icon(Icons.star, color: AppColors.white),
      value: '11',
      text: 'Rating');
  DashBoardItemModel cancellation = DashBoardItemModel(
      icon: Icon(Icons.close, color: AppColors.white),
      value: '11',
      text: 'Cancellation');

  RxList<ReviewModel> ratingsList = <ReviewModel>[].obs;
}
