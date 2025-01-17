import 'package:get/get.dart';

import '../../backend/api/api_services/api_services.dart';
import '../../backend/model/faq_topics/faq_topic_model.dart';


class FaqTopicControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FaqController());
  }
}

class FaqController extends GetxController {
  static FaqController get to => Get.find();
  @override
  void onInit() async {
    {
      try {
        isLoading.value = true;
        faqId = Get.arguments;
        await getFaqs();
        isError.value = false;
      } catch (error) {
        isError.value = true;
      } finally {
        isLoading.value = false;
      }
    }
    super.onInit();
  }

  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  getFaqs() async {
    FaqResponseModel response =
        await ApiServices.getFaqs(queryParameter: {"category": faqId});
    faqTopics = response.data ?? [];
  }

  String faqId = "";
  List<FaqModel> faqTopics = <FaqModel>[];
}
