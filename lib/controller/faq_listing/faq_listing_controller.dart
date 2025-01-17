import 'package:get/get.dart';

import '../../backend/model/faq_topics/faq_topic_model.dart';



class FaqListingControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FaqListingController());
  }
}

class FaqListingController extends GetxController {
  static FaqListingController get to => Get.find();
  @override
  void onInit() {
    super.onInit();

    faqList = Get.arguments;
  }

  List<Faq> faqList = [];
}
