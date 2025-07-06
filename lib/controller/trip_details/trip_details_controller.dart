import 'package:get/get.dart';
import 'package:waiver_driver/backend/model/trip_details/trip_details_model.dart';

import '../../backend/api/api_services/api_services.dart';

class TripDetailsControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TripDetailsController());
  }
}

class TripDetailsController extends GetxController {
  static TripDetailsController get to => Get.find();

  @override
  void onInit() async {
    super.onInit();
    try {
      isLoading.value = true;
      rideId = Get.arguments;
      await getRideDetails();
      isError.value = false;
    } catch (error) {
      isError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  String? rideId;
  getRideDetails() async {
    GetRidesDetailsResponseModel response = await ApiServices.getRideDetails(
        queryParameter: {"ride": rideId ?? ""});
    tripStart = "sdfgd";
    tripEnd = "dfgdf";
    earnings = response.data?.amount;
    paymentMode = "cash";
    rideTime = response.data?.paidTime;
    service = response.data?.rideType;
    distance = response.data?.distance;

    rating = double.tryParse(response.data?.review?.rating.toString() ?? '0.0');
    tripFare = response.data?.payment?.fare;
    promo = response.data?.payment?.promo;
    tax = response.data?.payment?.tax;
    payment = response.data?.payment?.total;
    passengerId = response.data?.passenger ?? '';
  }

  String? tripStart;
  String? tripEnd;
  String? earnings;
  String? paymentMode;
  DateTime? rideTime;
  String? service;
  String? distance;
  String? passengerName;
  double? rating;
  String? tripFare;
  String? promo;
  String? tax;
  String? payment;
  String? passengerId;
}
