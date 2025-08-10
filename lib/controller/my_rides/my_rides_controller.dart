import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waiver_driver/backend/model/my_rides/my_rides_model.dart';
import 'package:waiver_driver/backend/parser/MyRide/myridescreen_parser.dart';

import '../../backend/api/api_services/api_services.dart';

// class MyRidesControllerBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut(() => MyRidesController());
//   }
// }

class MyRidesController extends GetxController {
  MyrideScreenParser parser;
  MyRidesController({required this.parser});
  static MyRidesController get to => Get.find();

  @override
  void onInit() async {
    super.onInit();
    await getRides();
    isError.value = false;

    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        // User has reached the bottom of the list
        if (hasNextPage.value && !isLoadingMore.value) {
          loadMoreRides();
        }
      }
    });
  }

  // Observable variables
  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  RxBool isLoadingMore = false.obs; // For loading more items
  RxBool hasNextPage = true.obs; // To check if there are more pages

  ScrollController scrollController = ScrollController();
  RxList<Ride> myRides = <Ride>[].obs;
  String? nextPageUrl; // Store the next page URL

  // Initial load of rides
  Future<void> getRides() async {
    try {
      isLoading.value = true;
      isError.value = false;

      GetRidesResponseModel response = await ApiServices.getRides();

      if (response.data != null) {
        myRides.clear(); // Clear existing data for fresh load
        myRides.addAll(response.data!.results ?? []);

        // Set next page URL and hasNextPage flag
        nextPageUrl = response.data!.next;
        hasNextPage.value = nextPageUrl != null && nextPageUrl!.isNotEmpty;
      }
    } catch (error) {
      isError.value = true;
      print("Error loading rides: $error");
    } finally {
      isLoading.value = false;
    }
  }

  // Load more rides for pagination
  Future<void> loadMoreRides() async {
    if (!hasNextPage.value || isLoadingMore.value || nextPageUrl == null) {
      return;
    }

    try {
      isLoadingMore.value = true;

      // Call API with the next page URL
      GetRidesResponseModel response = await ApiServices.getRidesFromUrl(nextPageUrl!);

      if (response.data != null) {
        // Add new rides to existing list
        myRides.addAll(response.data!.results ?? []);

        // Update next page URL and hasNextPage flag
        nextPageUrl = response.data!.next;
        hasNextPage.value = nextPageUrl != null && nextPageUrl!.isNotEmpty;
      }
    } catch (error) {
      print("Error loading more rides: $error");
      // You might want to show a snackbar or toast here
    } finally {
      isLoadingMore.value = false;
    }
  }

  // Refresh the entire list
  Future<void> refreshRides() async {
    nextPageUrl = null;
    hasNextPage.value = true;
    await getRides();
  }

  // Helper method to check if we should show loading indicator
  bool get shouldShowLoadingIndicator {
    return hasNextPage.value && isLoadingMore.value;
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  String getDisplayRideStatus(String? rideStatus) {
    switch (rideStatus) {
      case "RED":
        return "Requested";
      case "ACD":
        return "Accepted";
      case "CAD":
        return "Cancelled";
      case "ONG":
        return "Ongoing";
      case "COD":
        return "Completed";
      case "PSD":
        return "Paused";
      case "RSD":
        return "Resumed";
      case "RDP":
        return "Reached Pickup";
      case "RDF":
        return "Reached Drop-off";
      case "PID":
        return "Payment Initiated";
      case "PCD":
        return "Payment Completed";
      case "FRED":
        return "Fav Ride Requested";
      case "FCAD":
        return "Fav Ride Cancelled";
      default:
        return "Status Not Available";
    }
  }

  Color getStatusTextColor(String? rideStatus) {
    switch (rideStatus) {
      case "COD": // Completed
        return Colors.green;
      case "CAD": // Cancelled
      case "FCAD": // Fav Ride Cancelled
        return Colors.red;
      default:
        return Get.theme.textTheme.bodyLarge?.color ?? Colors.black;
    }
  }

  Color getStatusContainerColor(String? rideStatus) {
    switch (rideStatus) {
      case "COD": // Completed
        return Colors.green.withOpacity(0.1);
      case "CAD": // Cancelled
      case "FCAD": // Fav Ride Cancelled
        return Colors.red.withOpacity(0.1);
      default:
        return Get.theme.indicatorColor.withOpacity(0.1);
    }
  }
}
