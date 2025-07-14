import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waiver_driver/backend/api/api_services/api_services.dart';
import 'package:waiver_driver/backend/model/bank_account/bank_account_model.dart';
import 'package:waiver_driver/backend/parser/BankAccount/bankaccount_parser.dart';
import 'package:waiver_driver/controller/chauffeur_proof/chauffeur_proof_controller.dart';
import 'package:waiver_driver/core/constants/enums/enums.dart';
import 'package:waiver_driver/core/widgets/snackbar/snackbar.dart';

import '../../backend/model/view_bank_account/view_bank_model.dart';
import '../../core/constants/get_storage_constants.dart' show AppConstants;

// class BankAccountControllerBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut(() => BankAccountController());
//   }
// }

class BankAccountController extends GetxController {
  BankaccountParser parser;

  BankAccountController({required this.parser});
  static BankAccountController get to => Get.find();

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
      // Code that always executes (cleanup, loading states, etc.)
      // isBanksLoading.value = false;
      print('Banks API call completed');
    }
  }

  RxBool isLoading = false.obs;
  RxBool isButtonLoading = false.obs;
  RxBool isError = false.obs;
  GlobalKey<FormState> bankAccountDetailsFormKey = GlobalKey();
  Future<void> getBankAccount() async {
    try {
      var response = await ApiServices.getBankAccount();

      selectedBank = banks.firstWhereOrNull(
        (element) => element.id == response.data?.bank?.id,
      );

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

  List<Banks> banks = [];
  Banks? selectedBank;
  TextEditingController controllerAccountHolderName = TextEditingController();
  TextEditingController controllerBankAccountNumber = TextEditingController();
  TextEditingController controllerConfirmAccountNumber =
      TextEditingController();
  TextEditingController controllerBankIFSCNumber = TextEditingController();
  GlobalKey<FormState> addBankAccountDetails = GlobalKey();

  submit() async {
    try {
      isButtonLoading.value = true;
      if (bankAccountDetailsFormKey.currentState?.validate() ?? false) {
        AddBankAccountResponseModel response =
            await ApiServices.addBankAccount(body: {
          "bank": selectedBank!.id!.toString(),
          "holder_name": controllerAccountHolderName.text,
          "account_number": controllerBankAccountNumber.text,
          "ifsc": controllerBankIFSCNumber.text,
        });
        ChauffeurProofController.to.bankAccount.status.value =
            ApprovalStatus.waitingForApproval;
        Get.back();
        Get.showSnackbar(
          GetSnackBar(
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            messageText: AppSnackBar(
              text: response.message ?? "",
            ),
          ),
        );
      }
    } catch (error, s) {
      print(error);
      AppConstants.handleError(error, s: s);
    } finally {
      isButtonLoading.value = false;
    }
  }
}
