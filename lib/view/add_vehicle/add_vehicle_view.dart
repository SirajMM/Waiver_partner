import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:waiver_driver/controller/add_vehicle/add_vehicle_controller.dart';
import 'package:waiver_driver/core/widgets/app_bar/app_bar.dart';
import 'package:waiver_driver/core/widgets/app_buttons/app_buttons.dart';
import 'package:waiver_driver/core/widgets/error_page/error_page.dart';
import 'package:waiver_driver/core/widgets/test_fields/app_test_form_field_calender.dart';
import 'package:waiver_driver/core/widgets/test_fields/app_text_form_fields.dart';
import 'package:waiver_driver/helper/validator/text_input_formatter/text_input_formater.dart';
import 'package:waiver_driver/helper/validator/validators/validators.dart';
import 'package:waiver_driver/view/loading_animation/loading_animation.dart';

class AddVehicleScreen extends StatelessWidget {
  const AddVehicleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(title: "Add Vehicle Details"),
        body: GetX<AddVehicleController>(builder: (controller) {
          return controller.isLoading.value
              ? const LoadingBarsAnimation()
              : controller.isError.value
                  ? const ErrorPage()
                  : Form(
                      key: AddVehicleController.to.formKeyForAddVehicle,
                      child: ListView(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.sp, vertical: 25.sp),
                        children: [
                          AppTextFormField(
                            controller: AddVehicleController
                                .to.controllerVehicleRegistrationNumber,
                            header: "Vehicle registration number",
                            placeHolder: "e.g. AA-00-0000",
                            textCapitalization: TextCapitalization.characters,
                            inputFormatters: [
                              MaskedTextInputFormatter(
                                mask: "XX-XX-XXXXXX",
                                separator: "-",
                              ),
                              CustomCharacterFormatter(
                                  allowedPattern: r'[^a-zA-Z\-.0-9 ]')
                            ],
                            validator: (value) => Validators.vehicleNumber(
                                value: (value ?? "").replaceAll("-", "")),
                          ),
                          SizedBox(
                            height: 15.sp,
                          ),
                          AppTextFormField(
                            controller:
                                AddVehicleController.to.controllerVehicleBrand,
                            header: "Vehicle Brand",
                            placeHolder: "e.g. Toyota",
                            validator: (value) =>
                                Validators.isEmpty(value: value),
                            inputFormatters: [
                              CustomCharacterFormatter(
                                  allowedPattern: r'[^a-zA-Z\-.0-9 ]')
                            ],
                          ),
                          SizedBox(
                            height: 15.sp,
                          ),
                          AppTextFormField(
                            controller:
                                AddVehicleController.to.controllerVehicleName,
                            header: "Vehicle Name",
                            placeHolder: "e.g. Swift",
                            validator: (value) =>
                                Validators.isEmpty(value: value),
                            inputFormatters: [
                              CustomCharacterFormatter(
                                  allowedPattern: r'[^a-zA-Z\-.0-9 ]')
                            ],
                          ),
                          SizedBox(
                            height: 15.sp,
                          ),
                          AppDropDownFormField(
                              header: "Vehicle type",
                              validator: (value) =>
                                  Validators.isEmpty(value: value?.name),
                              onChange: (vehicleType) {
                                AddVehicleController.to.selectedVehicleType =
                                    vehicleType;
                              },
                              value:
                                  AddVehicleController.to.selectedVehicleType,
                              itemList: AddVehicleController.to.vehicleTypes,
                              label: (vehicleType) => vehicleType.name),
                          SizedBox(
                            height: 15.sp,
                          ),
                          AppDropDownFormField(
                              header: "Vehicle Transmission type",
                              onChange: (vehicleTransmissionType) {
                                AddVehicleController
                                        .to.selectedTransmissionType =
                                    vehicleTransmissionType;
                              },
                              validator: (value) =>
                                  Validators.isEmpty(value: value?.name),
                              value: AddVehicleController
                                  .to.selectedTransmissionType,
                              itemList:
                                  AddVehicleController.to.transmissionTypes,
                              label: (transmissionType) =>
                                  transmissionType.name),
                          SizedBox(
                            height: 15.sp,
                          ),
                          AppDatePickerFormField(
                              header: "Permit End Date",
                              validator: (value) =>
                                  Validators.isEmpty(value: value),
                              startDate:
                                  DateTime.now().add(const Duration(days: 30)),
                              lastDate: DateTime.now()
                                  .add(const Duration(days: 365 * 20)),
                              controller: AddVehicleController
                                  .to.controllerVehiclePermitEndDate),
                          SizedBox(
                            height: 15.sp,
                          ),
                          AppDatePickerFormField(
                              header: "Insurance End Date",
                              validator: (value) =>
                                  Validators.isEmpty(value: value),
                              startDate:
                                  DateTime.now().add(const Duration(days: 30)),
                              lastDate: DateTime.now()
                                  .add(const Duration(days: 365 * 20)),
                              controller: AddVehicleController
                                  .to.controllerVehicleInsuranceEndDate),
                          SizedBox(
                            height: 30.sp,
                          ),
                          GetX<AddVehicleController>(builder: (controller) {
                            return BlueButton(
                              text: "Continue",
                              isLoading: controller.isButtonLoading.value,
                              onTap: () => AddVehicleController.to.addVehicle(),
                            );
                          })
                        ],
                      ),
                    );
        }));
  }
}
