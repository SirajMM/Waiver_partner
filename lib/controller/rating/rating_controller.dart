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
      if (isListCompeted.value.isNotEmpty &&
          scrollController.position.maxScrollExtent ==
              scrollController.position.pixels) {
        getReviews();
      }
    });
  }

  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  RxString isListCompeted = "".obs;
  ScrollController scrollController = ScrollController();
  int currentOffset = 0;
  int limit = 10;
  bool hasMoreData = true;

  RxBool isPaginationLoading = false.obs;
  RxList<ReviewModel> ratingsList = <ReviewModel>[].obs;

  // Future<void> getReviews() async {
  //   try {
  //     var response = await ApiServices.getReviews();
  //     ratingsList.addAll(response.data?.results ?? []);
  //     isListCompeted.value = response.data?.next ?? "";
  //   } catch (error, s) {
  //     AppConstants.handleError(error, s: s);
  //     print('Error fetching reviews: $error');
  //   } finally {}
  // }
  void setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        // Load more when user is near the bottom
        loadMoreReviews();
      }
    });
  }

  Future<void> loadMoreReviews() async {
    if (hasMoreData && !isPaginationLoading.value && !isLoading.value) {
      await getReviews(isInitial: false);
    }
  }

  Future<void> refreshReviews() async {
    await getReviews(isInitial: true);
  }
  Future<void> getReviews({bool isInitial = true}) async {
    try {
      if (isInitial) {
        isLoading.value = true;
        ratingsList.clear();
      }

      var response = await ApiServices.getReviews();

      if (response.data?.results != null) {
        ratingsList.addAll(response.data!.results!);
        // Check if there's more data to load
        isListCompeted.value = response.data?.next ?? "";
      }

      isError.value = false;
    } catch (error, s) {
      isError.value = true;
      AppConstants.handleError(error, s: s);
      print('Error fetching reviews: $error');
    } finally {
      isLoading.value = false;
    }
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
      icon: Icon(Icons.check, color: AppColors.white),
      value: '85.5',  // Will show as "85.5%"
      text: 'Acceptance');

  DashBoardItemModel rating = DashBoardItemModel(
      icon: Icon(Icons.star, color: AppColors.white),
      value: '4.2',   // Will show as "4.2"
      text: 'Rating');

  DashBoardItemModel cancellation = DashBoardItemModel(
      icon: Icon(Icons.close, color: AppColors.white),
      value: '12.8',  // Will show as "12.8%"
      text: 'Cancellation');
// RxList<ReviewModel> ratingsList = <ReviewModel>[].obs;
}
