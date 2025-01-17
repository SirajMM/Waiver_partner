import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:waiver_driver/backend/model/my_rides/my_rides_model.dart';

import '../../backend/api/api_services/api_services.dart';



class MyRidesControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyRidesController());
  }
}

class MyRidesController extends GetxController {
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
}
