import 'package:get/get.dart';

import '../../backend/model/faq_topics/faq_topic_model.dart';


class FaqDetailsControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FaqDetailsController());
  }
}

class FaqDetailsController extends GetxController {
  static FaqDetailsController get to => Get.find();
  @override
  void onInit() {
    super.onInit();
    Faq faq = Get.arguments;
    question = faq.question ?? "";
    answer = faq.answer ?? "";
  }

  String question = "How to Log with Email";
  String answer = "";
}
