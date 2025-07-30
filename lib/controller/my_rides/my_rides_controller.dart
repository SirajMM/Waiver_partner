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
    // try {
    //   isLoading.value = true;
    await getRides();
    isError.value = false;
    // } catch (error) {
    //   isError.value = true;
    // } finally {
    //   isLoading.value = false;
    // }
    scrollController.addListener(() {
      if (isListCompeted.value &&
          scrollController.position.maxScrollExtent ==
              scrollController.position.pixels) {
        if (isListCompeted.value) {
          getRides();
        }
      }
    });
  }

  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  RxBool isListCompeted = false.obs;
  ScrollController scrollController = ScrollController();
  getRides() async {
    GetRidesResponseModel response = await ApiServices.getRides();
    myRides.addAll(response.data?.results ?? []);
    isListCompeted.value = response.data!.next?.isEmpty ?? false;
  }

  RxList<Ride> myRides = <Ride>[].obs;

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
