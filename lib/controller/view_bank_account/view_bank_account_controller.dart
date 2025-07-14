import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waiver_driver/backend/model/view_bank_account/view_bank_model.dart';
import 'package:waiver_driver/backend/parser/ViewBankAccount/viewbanckaccount_parser.dart';
import 'package:waiver_driver/core/widgets/snackbar/snackbar.dart';

import '../../backend/api/api_services/api_services.dart';
import '../../core/constants/get_storage_constants.dart' show AppConstants;

// class ViewBankAccountControllerBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut(() => ViewBankAccountController());
//   }
// }

class ViewBankAccountController extends GetxController {
  ViewbankaccountParser parser;
  ViewBankAccountController({required this.parser});
  @override
  void onInit() async {
    super.onInit();
    try {
      isLoading.value = true;
      await getBanks();
      await getBankAccount();
      isError.value = false;
    } catch (error) {
      print(error);
      isError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getBanks() async {
    try {
      GetBanksResponseModel response = await ApiServices.getBanks();
      banks = response.data ?? [];
    } catch (error, s) {
      AppConstants.handleError(error, s: s);

      print('Error fetching banks: $error');

      banks = [];
    } finally {
      print('Banks API call completed');
    }
  }

  RxBool isLoading = false.obs;
  RxBool isButtonLoading = false.obs;
  RxBool isError = false.obs;

  Future<void> getBankAccount() async {
    try {
      var response = await ApiServices.getBankAccount();

      selectedBank = banks
          .firstWhereOrNull((element) => element.id == response.data?.bank?.id);

      controllerAccountHolderName.text = response.data?.holderName ?? "";
      controllerBankAccountNumber.text = response.data?.accountNumber ?? "";
      controllerBankIFSCNumber.text = response.data?.ifsc ?? "";
    } catch (error, s) {
      AppConstants.handleError(error, s: s);

      print('Error fetching bank account: $error');

      selectedBank = null;
      controllerAccountHolderName.text = "";
      controllerBankAccountNumber.text = "";
      controllerBankIFSCNumber.text = "";
    } finally {
      print('Bank account API call completed');
    }
  }

  static ViewBankAccountController get to => Get.find();
  List<Banks> banks = [];
  Banks? selectedBank;
  TextEditingController controllerAccountHolderName = TextEditingController();
  TextEditingController controllerBankAccountNumber = TextEditingController();
  TextEditingController controllerBankIFSCNumber = TextEditingController();
  GlobalKey<FormState> updateBankAccountDetails = GlobalKey();
  upDate() async {
    try {
      isButtonLoading.value = true;
      if (updateBankAccountDetails.currentState?.validate() ?? false) {
        UpdateBanksResponseModel response =
            await ApiServices.updateBankAccount(body: {
          "bank": selectedBank!.id!.toString(),
          "holder_name": controllerAccountHolderName.text,
          "account_number": controllerBankAccountNumber.text,
          "ifsc": controllerBankIFSCNumber.text,
        });
        Get.back();
        Get.showSnackbar(GetSnackBar(
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            messageText: AppSnackBar(text: response.message ?? "")));
      }
    } catch (error, s) {
      print(error);
      AppConstants.handleError(error, s: s);
    } finally {
      isButtonLoading.value = false;
    }
  }
}
