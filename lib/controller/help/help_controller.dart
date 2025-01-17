import 'package:get/get.dart';
import 'package:waiver_driver/backend/model/help/help_model.dart';



import '../../backend/api/api_services/api_services.dart';

class HelpControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HelpController());
  }
}

class HelpController extends GetxController {
  static HelpController get to => Get.find();
  @override
  void onInit() async {
    try {
      isLoading.value = true;
      await getHelpCategories();
      isError.value = false;
    } catch (error) {
      isError.value = true;
    } finally {
      isLoading.value = false;
    }
    super.onInit();
  }

  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  getHelpCategories() async {
    GetHelpCategoriesResponseModel response =
        await ApiServices.getHelpCategories();
    helpCategories = response.data ?? [];
  }

  List<HelpCategory> helpCategories = <HelpCategory>[];
}
