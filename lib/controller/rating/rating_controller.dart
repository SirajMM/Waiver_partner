import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waiver_driver/backend/model/home/home_model.dart';
import 'package:waiver_driver/backend/model/rating/rating_model.dart';
import 'package:waiver_driver/backend/parser/Rating/ratingscreen_parser.dart';
import 'package:waiver_driver/backend/api/api_services/api_services.dart';
import 'package:waiver_driver/core/colors/app_colors.dart';
import 'package:waiver_driver/core/constants/get_storage_constants.dart';

class RatingController extends GetxController {
  RatingscreenParser parser;
  RatingController({required this.parser});

  // Reactive variables
  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  RxBool isPaginationLoading = false.obs;
  RxList<ReviewModel> ratingsList = <ReviewModel>[].obs;
  RxString ratingCount = "".obs;

  // Pagination variables
  ScrollController scrollController = ScrollController();
  int currentOffset = 0;
  int limit = 10;
  bool hasMoreData = true;

  // Dashboard items (moved outside onInit)
  static RatingController get to => Get.find();

  Rx<DashBoardItemModel> acceptance = DashBoardItemModel(
          icon: Icon(Icons.check, color: AppColors.white),
          value: '0.0',
          text: 'Acceptance')
      .obs;

  Rx<DashBoardItemModel> rating = DashBoardItemModel(
          icon: Icon(Icons.star, color: AppColors.white),
          value: '0.0',
          text: 'Rating')
      .obs;

  Rx<DashBoardItemModel> cancellation = DashBoardItemModel(
          icon: Icon(Icons.close, color: AppColors.white),
          value: '0.0',
          text: 'Cancellation')
      .obs;

  @override
  void onInit() async {
    super.onInit();
    setupScrollListener();
    await _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      isLoading.value = true;
      await Future.wait([getReviews(isInitial: true), getReviewsStatus()]);
      isError.value = false;
    } catch (error, s) {
      log(error.toString(), error: error, stackTrace: s);
      isError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  void setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        loadMoreReviews();
      }
    });
  }

  Future<void> getReviews({bool isInitial = false}) async {
    try {
      if (isInitial) {
        isLoading.value = true;
        ratingsList.clear();
        currentOffset = 0;
        hasMoreData = true;
      } else {
        if (!hasMoreData || isPaginationLoading.value) {
          return;
        }
        isPaginationLoading.value = true;
      }

      GetReviewResponseModel response =
          await ApiServices.getReviewsWithPagination(
        offset: currentOffset,
        limit: limit,
      );

      if (response.data?.results != null) {
        ratingsList.addAll(response.data!.results!);

        // Update pagination state
        String? nextUrl = response.data?.next;
        ratingCount.value = response.data!.count.toString();

        hasMoreData = nextUrl != null && nextUrl.isNotEmpty;

        if (hasMoreData) {
          currentOffset += limit;
        }
      }

      isError.value = false;
    } catch (error, s) {
      isError.value = true;
      AppConstants.handleError(error, s: s);
      print('Error fetching reviews: $error');
    } finally {
      isLoading.value = false;
      isPaginationLoading.value = false;
    }
  }

  Future<void> loadMoreReviews() async {
    if (hasMoreData && !isPaginationLoading.value && !isLoading.value) {
      await getReviews(isInitial: false);
    }
  }

  Future<void> refreshReviews() async {
    await getReviews(isInitial: true);
  }

  Future<void> getReviewsStatus() async {
    try {
      GetReviewStatusResponseModel response =
          await ApiServices.getReviewsStatus();

      // Update the dashboard items
      acceptance.value = DashBoardItemModel(
          icon: Icon(Icons.check, color: AppColors.white),
          value: "${response.data?.acceptance ?? 0.0}",
          text: 'Acceptance');

      rating.value = DashBoardItemModel(
          icon: Icon(Icons.star, color: AppColors.white),
          value: "${response.data?.rating ?? 0.0}",
          text: 'Rating');

      cancellation.value = DashBoardItemModel(
          icon: Icon(Icons.close, color: AppColors.white),
          value: "${response.data?.cancellation ?? 0.0}",
          text: 'Cancellation');
    } catch (error, s) {
      // Handle error appropriately
      print('Error fetching review status: $error');

      // Set default values on error
      acceptance.value = DashBoardItemModel(
          icon: Icon(Icons.check, color: AppColors.white),
          value: "0.0",
          text: 'Acceptance');

      rating.value = DashBoardItemModel(
          icon: Icon(Icons.star, color: AppColors.white),
          value: "0.0",
          text: 'Rating');

      cancellation.value = DashBoardItemModel(
          icon: Icon(Icons.close, color: AppColors.white),
          value: "0.0",
          text: 'Cancellation');

      AppConstants.handleError(error, s: s);
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
