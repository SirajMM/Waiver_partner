import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:waiver_driver/backend/api/api_services/api_services.dart';
import 'package:waiver_driver/backend/model/notification/notification_model.dart';
import 'package:waiver_driver/view/notification/notification_view.dart';

import '../../backend/parser/Notification/notification_parser.dart';

// class NotificationControllerBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut(() => NotificationController());
//   }
// }

class NotificationController extends GetxController {
  NotificationParser parser;
  NotificationController({required this.parser});

  @override
  void onInit() async {
    super.onInit();
    try {
      isLoading.value = true;
      await getNotifications();
      isError.value = false;
    } catch (error) {
      isError.value = true;
    } finally {
      isLoading.value = false;
    }
    scrollController.addListener(() {
      if (isListCompeted.value &&
          scrollController.position.maxScrollExtent ==
              scrollController.position.pixels) {
        getNotifications();
      }
    });
  }

  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  RxBool isListCompeted = false.obs;
  ScrollController scrollController = ScrollController();
  getNotifications() async {
    GetNotificationsResponseModel response =
        await ApiServices.getNotifications();
    notification.addAll(response.data?.results ?? []);
    isListCompeted.value = response.data?.next ?? false;
  }

  static NotificationController get to => Get.find();
  RxList<NotificationModel> notification = <NotificationModel>[].obs;
}
