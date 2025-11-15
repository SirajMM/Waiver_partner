import 'package:flutter/material.dart';
import 'package:flutter_custom_utils/flutter_custom_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:waiver_driver/controller/add_driver_fleet/add_driver_controller.dart';
import 'package:waiver_driver/core/widgets/app_bar/app_bar.dart';
import 'package:waiver_driver/core/widgets/app_buttons/app_buttons.dart';
import 'package:waiver_driver/core/widgets/error_page/error_page.dart';
import 'package:waiver_driver/core/widgets/test_fields/app_text_form_fields.dart';
import 'package:waiver_driver/helper/validator/validators/validators.dart';
import 'package:waiver_driver/view/loading_animation/loading_animation.dart';

class AddDriverScreen extends StatelessWidget {
  const AddDriverScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
          title: AddDriverController.to.isChangeDriver
              ? "Change Driver"
              : "Add Driver"),
      body: SafeArea(
        child: GetX<AddDriverController>(
          builder: (controller) {
            return controller.isLoading.value
                ? const LoadingBarsAnimation()
                : controller.isError.value
                    ? const ErrorPage()
                    : Form(
                        key: AddDriverController.to.formKeyForAddDriver,
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15.sp,
                                  vertical: 25.sp,
                                ),
                                children: [
                                  AppTextFormField(
                                    controller: AddDriverController
                                        .to.controllerDriverName,
                                    header: "Driver Full Name",
                                    placeHolder: "e.g. ALEX JHON",
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    validator: (value) =>
                                        Validators.isEmpty(value: value),
                                    inputFormatters: [
                                      CustomCharacterFormatter(
                                          allowedPattern: r'[^a-zA-Z\-.]')
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15.sp,
                                  ),
                                  AppTextFormField(
                                    controller: AddDriverController
                                        .to.controllerDriverId,
                                    inputFormatters: [
                                      CustomCharacterFormatter(
                                          allowedPattern: r'[^a-zA-Z0-9]')
                                    ],
                                    header: "Driver ID",
                                    placeHolder: "e.g. #25254565",
                                    validator: (value) =>
                                        Validators.isEmpty(value: value),
                                  ).cPadOnly(b: 20),
                                ],
                              ),
                            ),
                            GetX<AddDriverController>(
                              builder: (controller) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 15.0.sp),
                                  child: BlueButton(
                                          text: controller.isChangeDriver
                                              ? "Change Driver"
                                              : "Submit",
                                          isLoading:
                                              controller.isButtonLoading.value,
                                          onTap: () => controller.isChangeDriver
                                              ? controller.changeDriver()
                                              : controller.addDriver())
                                      .cPadSymmetric(h: 30),
                                );
                              },
                            ),
                          ],
                        ),
                      );
          },
        ),
      ),
    );
  }
}
