import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:waiver_driver/backend/model/view_bank_account/view_bank_model.dart';
import 'package:waiver_driver/controller/bank_account/bank_account_controller.dart';
import 'package:waiver_driver/core/colors/app_colors.dart';
import 'package:waiver_driver/core/widgets/app_bar/app_bar.dart';
import 'package:waiver_driver/core/widgets/app_buttons/app_buttons.dart';
import 'package:waiver_driver/core/widgets/error_page/error_page.dart';
import 'package:waiver_driver/core/widgets/test_fields/app_text_form_fields.dart';
import 'package:waiver_driver/helper/validator/validators/validators.dart';

import '../loading_animation/loading_animation.dart';

class BankAccountScreen extends StatelessWidget {
  const BankAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: ""),
      body: GetX<BankAccountController>(builder: (controller) {
        return controller.isLoading.value
            ? const LoadingBarsAnimation()
            : controller.isError.value
                ? const ErrorPage()
                : Form(
                    key: BankAccountController.to.bankAccountDetailsFormKey,
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 15.sp),
                      children: [
                        SizedBox(
                          height: 20.sp,
                        ),
                        Text(
                          "Bank Account",
                          style: TextStyle(
                              color: AppColors.black,
                              height: 1,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 12.sp,
                        ),
                        Text(
                          "These bank details will be used to transfer funds to your account on settlement days.",
                          style: TextStyle(
                              color: AppColors.grey93,
                              fontSize: 16.sp,
                              height: 1,
                              fontWeight: FontWeight.w200),
                        ),
                        SizedBox(
                          height: 30.sp,
                        ),
                        AppDropDownFormField(
                          header: 'Bank Name',
                          placeHolder: 'Select',
                          itemList: BankAccountController.to.banks,
                          onChange: (Banks? bank) {
                            BankAccountController.to.selectedBank = bank;
                          },
                          value: BankAccountController.to.selectedBank,
                          label: (Banks bank) => bank.name,
                        ),
                        SizedBox(
                          height: 12.sp,
                        ),
                        AppTextFormField(
                          controller: BankAccountController
                              .to.controllerAccountHolderName,
                          header: 'Account Holder name',
                          placeHolder: "e.g john smith",
                          validator: (value) => Validators.isEmpty(
                            value: value,
                          ),
                          textInputType: TextInputType.emailAddress,
                        ),
                        SizedBox(
                          height: 12.sp,
                        ),
                        AppTextFormField(
                          controller: BankAccountController
                              .to.controllerBankAccountNumber,
                          obscureText: true,
                          header: 'Account Number',
                          placeHolder: "e.g 0123456789",
                          validator: (value) => Validators.isBankAccountNumber(
                            value: value,
                          ),
                          maxLength: 16,
                          textInputType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                        SizedBox(
                          height: 12.sp,
                        ),
                        AppTextFormField(
                          controller: BankAccountController
                              .to.controllerConfirmAccountNumber,
                          header: 'Confirm Account Number',
                          placeHolder: "e.g 0123456789",
                          validator: (value) => Validators.isSameAs(
                              value: value,
                              confirmText: BankAccountController
                                  .to.controllerBankAccountNumber.text,
                              errorText: "Account numbers does not match"),
                          maxLength: 16,
                          textInputType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                        SizedBox(
                          height: 12.sp,
                        ),
                        AppTextFormField(
                          controller:
                              BankAccountController.to.controllerBankIFSCNumber,
                          header: 'IFSC',
                          placeHolder: "e.g. AAAA0000000",
                          textCapitalization: TextCapitalization.characters,
                          validator: (value) => Validators.isBankISFCNumber(
                            value: value,
                          ),
                        ),
                        SizedBox(
                          height: 30.sp,
                        ),
                        GetX<BankAccountController>(builder: (controller) {
                          return BlueButton(
                            text: "Submit",
                            isLoading: controller.isLoading.value,
                            onTap: () => BankAccountController.to.submit(),
                          );
                        }),
                      ],
                    ),
                  );
      }),
    );
  }
}
