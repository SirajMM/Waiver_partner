import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sms_autofill/sms_autofill.dart';

// import 'package:upgrader/upgrader.dart';
import 'package:waiver_driver/backend/model/home/home_model.dart';
import 'package:waiver_driver/controller/home/home_controller.dart';
import 'package:waiver_driver/core/colors/app_colors.dart';
import 'package:waiver_driver/core/constants/enums/enums.dart';
import 'package:waiver_driver/core/constants/get_storage_constants.dart';
import 'package:waiver_driver/core/themes/assets/icons.dart';
import 'package:waiver_driver/core/widgets/app_buttons/app_buttons.dart';
import 'package:waiver_driver/core/widgets/circle_with_gradient/circle_with_gradient.dart';
import 'package:waiver_driver/core/widgets/count_down/count_down_view.dart';
import 'package:waiver_driver/helper/router/app_routes/route.dart';
import 'package:waiver_driver/main.dart';
import 'package:waiver_driver/view/home/Widget/GoingToDestinationWidget.dart';
import 'package:waiver_driver/view/home/Widget/LoadingStateWidget.dart';
import 'package:waiver_driver/view/home/Widget/ReadyToGoToDestinationWidget.dart';
import 'package:waiver_driver/view/home/Widget/goingToPickUpWidget.dart';
import 'package:waiver_driver/view/loading_animation/loading_animation.dart';

import '../../controller/profile/profile_controller.dart';
import '../../core/widgets/snackbar/snackbar.dart';
import '../left_menu_driver/left_menu_driver_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController(parser: Get.find()));
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        HomeController homeController = Get.find();

        if (homeController.driverState.value == DriverState.paymentInitiated ||
            homeController.driverState.value == DriverState.completed) {
          Get.defaultDialog(middleText: "Confirm the payment !!!");
        } else if (homeController.driverState.value == DriverState.idle) {
          Get.defaultDialog(
              middleText: "Are you sure you want to exit",
              confirm: BlueButton(
                text: "Yes",
                width: 100.sp,
                onTap: () => exit(0),
              ),
              cancel: WhiteButton(
                width: 100.sp,
                text: "No",
                onTap: Get.back,
              ));
        } else {
          Get.defaultDialog(
            middleText: " Your can't exit the app with active ride, ",
            confirm: BlueButton(
              text: "Go back",
              width: 100.sp,
              onTap: Get.back,
            ),
          );
        }
        // else {
        //   Get.defaultDialog(
        //       middleText: " Your can't exit the app with active order, "
        //           "Are you sure you want to cancel this order ?",
        //       confirm: BlueButton(
        //         text: "Yes",
        //         width: 100.sp,
        //         onTap: () => Get.bottomSheet(CancelOrder()),
        //       ),
        //       cancel: WhiteButton(
        //         width: 100.sp,
        //         text: "No",
        //         onTap: Get.back,
        //       ));
        // }
      },
      child: GetX<HomeController>(builder: (controller) {
        return controller.isLoading.value
            ? LoadingBarsAnimation()
            : Scaffold(
                extendBodyBehindAppBar: true,
                appBar: HomePageAppBar(),
                drawer: const LeftMenuDriver(),
                bottomSheet: GetX<HomeController>(builder: (controller) {
                  switch (controller.driverState.value) {
                    case DriverState.idle:
                      return const DashBoardData();

                    case DriverState.goingToPickUp:
                      return Going_To_Pick_screen();

                    case DriverState.arrivedAtPickUp:
                      return EnterOtpBottomSheet(
                          orderStatus: RideStatus.reachedPickUp);

                    case DriverState.readyToGoToDestination:
                      return ReadyToGoToDestinationWidget();

                    case DriverState.goingToDestination:
                      return GoingToDestinationWidget();

                    case DriverState.reachedDestination:
                      return EnterOtpBottomSheet(
                          orderStatus: RideStatus.reachedDropOff);

                    case DriverState.paymentInitiated:
                    // return HomeController.to.rideIsActive
                    //     ? const MakingPaymentBottomSheet(isPay: true)
                    //     : const SizedBox();

                    /*      case DriverState.paymentInitiated:
                    //   return box.read(BoxKeys.paymentType) == "CSH"
                    //   return const PaymentConfirmationSheetOnline(titleText: "Payment",text: "Waiting for payment",);
                        return const MakingPaymentBottomSheet(isPay: false,);*/
                    case DriverState.completed:
                      return HomeController.to.rideIsActive
                          ? box.read(BoxKeys.paymentType) == "CSH"
                              ? const MakingPaymentBottomSheet(
                                  isPay: true,
                                  paymentType: "Cash payment",
                                )
                              : const MakingPaymentBottomSheet(
                                  isPay: true,
                                  paymentType: "Online payment",
                                )
                          : const SizedBox();
                    /*         case DriverState.completed:
                    return HomeController.to.rideIsActive
                        ? const MakingPaymentBottomSheet(isPay: true,)
                        : const SizedBox();*/
                    case DriverState.loading:
                      return LoadingStateWidget();
                  }
                }),
                body: SizedBox(
                  width: Get.width,
                  height: Get.height,
                  child: GetX<HomeController>(builder: (controller) {
                    return GoogleMap(
                      mapType: MapType.normal,
                      // myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      zoomControlsEnabled: false,
                      markers: {
                        Marker(
                          markerId: const MarkerId("1"),
                          icon: BitmapDescriptor.defaultMarker,
                          position: LatLng(
                            controller.currentPosition.value?.latitude ?? 0.0,
                            controller.currentPosition.value?.longitude ?? 0.0,
                          ),
                        ),
                        if (controller.startLocationLatMarker != null &&
                            controller.startLocationLongMarker != null &&
                            controller.startLocationLatMarker != 0.0 &&
                            controller.startLocationLongMarker != 0.0)
                          Marker(
                            icon: BitmapDescriptor.defaultMarker,
                            markerId: const MarkerId("User"),
                            position: LatLng(
                              controller.startLocationLatMarker!.toDouble(),
                              controller.startLocationLongMarker!.toDouble(),
                            ),
                          ),
                      },
                      onCameraIdle: () async => controller.pickUpLocation1?.name
                          .value = await controller.getLocationDetails(
                              controller.currentPosition.value?.latitude ?? 0,
                              controller.currentPosition.value?.longitude ??
                                  0.0) ??
                          "",
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          controller.currentPosition.value?.latitude ?? 0,
                          controller.currentPosition.value?.longitude ?? 0,
                        ),
                        zoom: 15,
                      ),
                      onMapCreated:
                          (GoogleMapController googleMapController) async {
                        controller.googleMapController = googleMapController;
                        await controller.onMapCreate();
                      },
                    );
                  }),
                ));
      }),
    );
  }
}

class MakingPaymentBottomSheet extends StatelessWidget {
  final bool isPay;
  final String paymentType;

  const MakingPaymentBottomSheet(
      {super.key, required this.isPay, required this.paymentType});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 60.sp),
          decoration: BoxDecoration(
              color: Get.theme.primaryColor,
              boxShadow: [
                BoxShadow(
                    color: AppColors.black.withOpacity(.1),
                    offset: Offset(3, 3),
                    blurRadius: 5,
                    spreadRadius: 5)
              ],
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(13.sp),
                  topLeft: Radius.circular(13.sp))),
          width: Get.width,
          child: ListView(
            padding: EdgeInsets.all(20.sp),
            shrinkWrap: true,
            children: [
              // SizedBox(
              //   height: 5.sp,
              // ),
              // box.read(BoxKeys.paymentType) == "ONL"
              //     ? Row(
              //         children: [
              //           IconButton(
              //             onPressed: () {
              //               Get.back();
              //             },
              //             icon: Icon(Icons.close),
              //           ),
              //         ],
              //       )
              //     : SizedBox(),
              Center(
                child: Text(
                  paymentType ?? "",
                  style:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w300),
                ),
              ),
              // Container(
              //   // margin: EdgeInsets.symmetric(vertical: 0.sp),
              //   color: AppColors.grey249,
              //   height: 1.sp,
              // ),
              Center(
                child: Text(
                  HomeController.to.total ?? "",
                  style:
                      TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 5.sp,
              ),
              Container(
                width: Get.width,
                color: AppColors.grey249,
                padding: EdgeInsets.symmetric(vertical: 15.sp),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "You've Earned",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16.sp),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16.sp,
              ),
              InvoiceListingItem(
                text: "Trip Fare",
                amount: HomeController.to.fare,
              ),
              SizedBox(
                height: 15.sp,
              ),
              InvoiceListingItem(
                text: "Waiver Charge",
                amount: HomeController.to.waiverCharge,
              ),
              SizedBox(
                height: 15.sp,
              ),
              InvoiceListingItem(
                text: "Tax",
                amount: HomeController.to.tax,
              ),
              SizedBox(
                height: 15.sp,
              ),
              isPay && box.read(BoxKeys.paymentType) == "CSH"
                  ? BlueButton(
                      text: "Confirm",
                      onTap: () {
                        // Get.back();
                        // HomeController.to.completeRide();
                        Get.defaultDialog(
                            middleText: "Are you sure to confirm",
                            confirm: BlueButton(
                              text: "Yes",
                              width: 100.sp,
                              onTap: () {
                                box.read(BoxKeys.paymentType) == "CSH"
                                    ? HomeController.to.confirmedPayment()
                                    : {
                                        HomeController.to.driverState.value =
                                            DriverState.idle,
                                        HomeController.to.fetchWalletBalance()
                                      };
                                // HomeController.to.isButtonLoading.value= false;
                              },
                            ),
                            cancel: WhiteButton(
                              width: 100.sp,
                              text: "No",
                              onTap: Get.back,
                            ));
                      },
                    )
                  : SizedBox(),
              SizedBox(
                height: 15.sp,
              )
            ],
          ),
        ),
      ],
    );
  }
}

class InvoiceListingItem extends StatelessWidget {
  final String text;
  final String? amount;

  const InvoiceListingItem({
    super.key,
    required this.text,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(
        text,
        style: TextStyle(color: AppColors.grey93, fontSize: 14.sp),
      ),
      Text(
        "₹ ${amount ?? "0.0"}",
        style: TextStyle(color: AppColors.grey93, fontSize: 14.sp),
      )
    ]);
  }
}

class EnterOtpBottomSheet extends StatelessWidget {
  final String orderStatus;

  const EnterOtpBottomSheet({super.key, required this.orderStatus});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.sp),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: AppColors.black.withOpacity(.1),
                offset: Offset(3, 3),
                blurRadius: 5,
                spreadRadius: 5)
          ],
          color: Get.theme.primaryColor,
          borderRadius: BorderRadius.circular(8.sp)),
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          orderStatus == RideStatus.reachedPickUp
              ? Row(
                  children: [
                    IconButton(
                        onPressed: () => Get.bottomSheet(CancelOrder()),
                        icon: Icon(Icons.close))
                  ],
                )
              : SizedBox(),
          Text(
            "Enter OTP",
            style: TextStyle(
              fontSize: 20.sp,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            orderStatus == RideStatus.reachedDropOff
                ? "Get rider's OTP. Enter for ending trip."
                : "Get rider's OTP. Enter for start trip",
            style: TextStyle(
              fontSize: 14.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20.sp,
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 55.sp,
            ),
            height: 58.sp,
            child: TextFieldPinAutoFill(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.sp),
                    borderSide: BorderSide(color: AppColors.grey155)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.sp),
                    borderSide: BorderSide(color: AppColors.grey155)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.sp),
                    borderSide: BorderSide(color: AppColors.grey155)),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.sp),
                    borderSide: BorderSide(color: AppColors.grey155)),
              ),
              // currentCode: HomeController.to.code,
              currentCode: "",
              onCodeSubmitted: (code) {
                HomeController.to.code = code;
              },
              onCodeChanged: (code) {
                HomeController.to.code = code;
                HomeController.to.showIsOtpValid.value = false;
              },
              codeLength: 4,
            ),
          ),
          GetX<HomeController>(builder: (controller) {
            return controller.showIsOtpValid.value
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10.sp,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 55.sp),
                          child: Text(
                            "Please enter full Otp",
                            style: TextStyle(
                                fontSize: 14.sp, color: AppColors.red),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox();
          }),
          SizedBox(
            height: 15.sp,
          ),
          BlueButton(
            text: "Confirm",
            onTap: () {
              HomeController.to.verifyRideOtp(type: orderStatus);
            },
          )
        ],
      ),
    );
  }
}

class OrderCompletedBottomSheet extends StatelessWidget {
  const OrderCompletedBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Get.theme.primaryColor,
      ),
      child: ListView(
        shrinkWrap: true,
        children: [
          Text(
            "  ${(HomeController.to.timeToDropOffLocation ?? 0) < 3600 ? Duration(seconds: HomeController.to.timeToDropOffLocation ?? 0).inHours.toStringAsFixed(2) : Duration(seconds: HomeController.to.timeToDropOffLocation ?? 0).inMinutes.toStringAsFixed(2)} mins",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20.sp),
          ),
          SizedBox(
            height: 10.sp,
          ),
          Text(
            "Order completed ${HomeController.to.passengerName ?? "Alex John"}",
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20.sp,
          ),
          Container(
            padding: EdgeInsets.all(5.sp),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.sp),
                border: Border.all(color: AppColors.grey155)),
            child: Row(
              children: [
                Image.asset(
                  AppIcons.startAndStop,
                  height: 90.sp,
                ),
                SizedBox(
                  width: 20.sp,
                ),
                SizedBox(
                  width: 275.sp,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        HomeController.to.pickUpLocation ?? "",
                        style: TextStyle(fontSize: 16.sp),
                        maxLines: 1,
                      ),
                      Container(
                        width: 200,
                        color: Get.theme.indicatorColor.withOpacity(.05),
                        height: 2.sp,
                        margin: EdgeInsets.symmetric(vertical: 12.sp),
                      ),
                      Text(
                        HomeController.to.dropOffLocation ?? "",
                        style: TextStyle(fontSize: 16.sp),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          BlueButton(
            text: "Complete Ride",
            onTap: () {
              if (HomeController.to.paymentType == "CSH") {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Collect Cash",
                              style: TextStyle(
                                  fontSize: 24.sp, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 20.sp,
                            ),
                            Text("You Must Confirm the Payment"),
                            SizedBox(
                              height: 20.sp,
                            ),
                            BlueButton(
                              text: "Confrim",
                              onTap: () {
                                HomeController.to.confirmedPayment();
                              },
                            ),
                            SizedBox(
                              height: 10.sp,
                            ),
                          ],
                        ));
                  },
                );
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                        width: 300.sp,
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Online Payment",
                              style: TextStyle(
                                  fontSize: 24.sp, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 20.sp,
                            ),
                            Text("You Must Confirm the Payment"),
                            SizedBox(
                              height: 20.sp,
                            ),
                            BlueButton(
                              text: "Confrim",
                              onTap: () {
                                HomeController.to.confirmedPayment();
                              },
                            ),
                            SizedBox(
                              height: 10.sp,
                            ),
                          ],
                        ));
                  },
                );
              }
              // HomeController.to.getPaymentType();
              // HomeController.to.finishRide();
            },
          )
        ],
      ),
    );
  }
}

class PaymentConfirmationSheetCash extends StatelessWidget {
  const PaymentConfirmationSheetCash({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 20.sp),
      decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          boxShadow: [
            BoxShadow(
                color: AppColors.black.withOpacity(.1),
                offset: Offset(3, 3),
                blurRadius: 5,
                spreadRadius: 5)
          ],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.sp),
              topRight: Radius.circular(20.sp))),
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Text(
            "Cash Payment",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.sp,
            ),
          ),
          SizedBox(
            height: 20.sp,
          ),
          BottomSheetWhileDrivingItem(
            icon: CircleWithIcon(
                height: 50.sp,
                color: AppColors.blue,
                // padding: EdgeInsets.all(8.sp),
                child: Icon(
                  Icons.payments_outlined,
                  color: AppColors.white,
                  size: 40.sp,
                )),
            text: '',
          ),
          SizedBox(
            height: 20.sp,
          ),
          Text(
            "Please confirm cash payment",
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20.sp,
          ),
          BlueButton(
              text: "Confirm Payment",
              onTap: () => HomeController.to.confirmedPayment()),
        ],
      ),
    );
  }
}

class PaymentConfirmationSheetOnline extends StatelessWidget {
  final String titleText;
  final String text;

  const PaymentConfirmationSheetOnline(
      {super.key, required this.text, required this.titleText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 20.sp),
      decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          boxShadow: [
            BoxShadow(
                color: AppColors.black.withOpacity(.1),
                offset: Offset(3, 3),
                blurRadius: 5,
                spreadRadius: 5)
          ],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.sp),
              topRight: Radius.circular(20.sp))),
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Text(
            titleText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.sp,
            ),
          ),
          SizedBox(
            height: 20.sp,
          ),
          BottomSheetWhileDrivingItem(
            icon: CircleWithIcon(
                height: 50.sp,
                color: AppColors.blue,
                // padding: EdgeInsets.all(8.sp),
                child: Icon(
                  Icons.payment,
                  color: AppColors.white,
                  size: 40.sp,
                )),
            text: '',
          ),
          SizedBox(
            height: 20.sp,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20.sp,
          ),

          // BlueButton(
          //     text: "Arrived at Destination",
          //     onTap: () =>
          //         HomeController.to.reachedDropOffLocation()),
        ],
      ),
    );
  }
}

class CancelTripBottomSheet extends StatelessWidget {
  const CancelTripBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.sp),
      decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: BorderRadius.circular(8.sp)),
      child: ListView(
        shrinkWrap: true,
        children: [
          Text(
            "Cancel Trip ? ",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 15.sp,
          ),
          RedButton(
            text: "Cancel",
            onTap: () => Get.bottomSheet(const CancelReasonsBottomSheet(),
                isScrollControlled: true),
          ),
          SizedBox(
            height: 15.sp,
          ),
          RedBorderedButton(text: "No", onTap: () => Get.back()),
          SizedBox(
            height: 15.sp,
          ),
        ],
      ),
    );
  }
}

class CancelReasonsBottomSheet extends StatelessWidget {
  const CancelReasonsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
      decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: BorderRadius.circular(8.sp)),
      child: ListView(
        shrinkWrap: true,
        children: [
          Text(
            "Cancel Trip ? ",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
          ),
          Column(
            children: HomeController.to.cancelReasons
                .map((reason) => CancelReasonItem(reason: reason))
                .toList(),
          ),
          SizedBox(
            height: 15.sp,
          ),
          BlueButton(
            text: "Done",
            onTap: () => Get.back(),
          )
        ],
      ),
    );
  }
}

class CancelReasonItem extends StatelessWidget {
  final String reason;

  const CancelReasonItem({super.key, required this.reason});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (HomeController.to.selectedCancelReason.value == reason) {
          HomeController.to.selectedCancelReason.value = "";
        } else {
          HomeController.to.selectedCancelReason.value = reason;
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.sp),
        child: Row(
          children: [
            GetX<HomeController>(builder: (controller) {
              return CircleWithIcon(
                  height: 25.sp,
                  enableBorder: controller.selectedCancelReason.value != reason,
                  color: controller.selectedCancelReason.value == reason
                      ? AppColors.green33
                      : Get.theme.primaryColor,
                  child: Icon(
                    Icons.check,
                    color: Get.theme.primaryColor,
                    size: 20.sp,
                  ));
            }),
            SizedBox(
              width: 15.sp,
            ),
            Text(
              reason,
              style: TextStyle(
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomSheetWhileDrivingItem extends StatelessWidget {
  final Widget icon;
  final String text;
  final void Function()? onTap;

  const BottomSheetWhileDrivingItem(
      {super.key, required this.icon, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          icon,
          SizedBox(
            height: 5.sp,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
            ),
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class TextInsideBox extends StatelessWidget {
  String text;
  IconData? icon;

  TextInsideBox({super.key, required this.text, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.sp,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 12.sp),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey155),
          borderRadius: BorderRadius.circular(8.sp)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 5.sp),
              child: Icon(icon)),
          Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class DashBoardData extends StatelessWidget {
  const DashBoardData({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.transparent,
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              const ChangeOnlineStatusButton(),
              SizedBox(
                height: 15.sp,
              ),
              Container(
                width: Get.width,
                padding: EdgeInsets.symmetric(vertical: 16.sp),
                decoration: BoxDecoration(
                  color: Get.theme.primaryColor,
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.black.withOpacity(.1),
                        offset: Offset(3, 3),
                        blurRadius: 5,
                        spreadRadius: 5)
                  ],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.sp),
                    topRight: Radius.circular(10.sp),
                  ),
                ),
                child: Column(
                  children: [
                    GetX<HomeController>(builder: (controller) {
                      return Text(
                        controller.isOnline.value
                            ? "You’re online"
                            : "You’re offline",
                        style: TextStyle(
                            fontSize: 18.sp, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      );
                    }),
                    // SizedBox(
                    //   height: 15.sp,
                    // ),
                    // Container(
                    //   padding: EdgeInsets.symmetric(horizontal: 30.sp),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       DashBoardItem(
                    //         item: HomeController.to.acceptance,
                    //       ),
                    //       DashBoardItem(
                    //         item: HomeController.to.rating,
                    //       ),
                    //       DashBoardItem(
                    //         item: HomeController.to.cancellation,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Recenter()
      ],
    );
  }
}

class ChangeOnlineStatusButton extends StatelessWidget {
  const ChangeOnlineStatusButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GetBuilder<HomeController>(builder: (controller) {
          return GestureDetector(
            onTap: controller.isOnlineButtonLoading.value
                ? null
                : () async {
                    await ProfileController.to.getProfile();
                    controller.isAssinged.value =
                        await controller.hasAssigned();

                    String useTypeCode = box.read(BoxKeys.userTypeCode) ?? "";
                    if (controller.isAssinged.value == false &&
                        useTypeCode == UserTypeCode.driver) {
                      Get.showSnackbar(
                        const GetSnackBar(
                          duration: Duration(seconds: 3),
                          backgroundColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                          messageText: AppSnackBar(
                            text: "You have no assinged vehicles",
                          ),
                        ),
                      );
                    } else {
                      await controller.changeDriverOnlineStatus();
                    }
                  },
            child: GetX<HomeController>(builder: (controller) {
              return Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.black.withOpacity(.1),
                          offset: Offset(3, 3),
                          blurRadius: 5,
                          spreadRadius: 5)
                    ],
                    color: controller.isOnline.value
                        ? Get.theme.primaryColor
                        : AppColors.blue),
                child: Container(
                  padding: EdgeInsets.all(15.sp),
                  margin: EdgeInsets.all(5.sp),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: controller.isOnline.value
                            ? AppColors.red
                            : Get.theme.primaryColor,
                      ),
                      color: Colors.transparent),
                  child: controller.isOnlineButtonLoading.value
                      ? SizedBox(
                          height: 25.sp,
                          width: 25.sp,
                          child: CircularProgressIndicator(
                            color: controller.isOnline.value
                                ? AppColors.red
                                : Get.theme.primaryColor,
                          ),
                        )
                      : Text(
                          controller.isOnline.value ? "Stop" : "GO",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18.sp,
                            color: controller.isOnline.value
                                ? AppColors.red
                                : Get.theme.primaryColor,
                          ),
                        ),
                ),
              );
            }),
          );
        }),
      ],
    );
  }
}

class DashBoardItem extends StatelessWidget {
  final DashBoardItemModel item;

  const DashBoardItem({
    super.key,
    required this.item,
  });

  String _formatValue() {
    if (item.value == null) return '0';

    String valueStr = item.value.toString();
    String textLower = item.text.toLowerCase();

    // Check if it's already formatted with % symbol
    if (valueStr.contains('%')) {
      return valueStr;
    }

    // Try to parse as double/int
    double? doubleValue = double.tryParse(valueStr);
    if (doubleValue != null) {
      // Determine format based on the text field
      if (_isPercentageType(textLower)) {
        return '${doubleValue.toStringAsFixed(1)}%';
      } else if (_isRatingType(textLower)) {
        // For ratings, show with decimal if needed, otherwise as integer
        return doubleValue % 1 == 0
            ? doubleValue.toInt().toString()
            : doubleValue.toStringAsFixed(1);
      } else {
        // For acceptance count, cancellation count, etc. - show as integer
        return doubleValue.toInt().toString();
      }
    }

    // Fallback: return original value
    return valueStr;
  }

  bool _isPercentageType(String text) {
    return text.contains('percentage') ||
        text.contains('percent') ||
        text.contains('rate') ||
        text.contains('ratio') ||
        text.contains(
            'acceptance') || // Acceptance rate is usually shown as percentage
        text.contains(
            'cancellation'); // Cancellation rate is usually shown as percentage
  }

  bool _isRatingType(String text) {
    return text.contains('rating') ||
        text.contains('score') ||
        text.contains('star');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * .25,
      padding: EdgeInsets.symmetric(vertical: 16.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.sp),
        border: Border.all(
          width: 1.5.sp,
          color: Get.theme.indicatorColor.withOpacity(.05),
        ),
      ),
      child: Column(
        children: [
          CircleWithIcon(
            height: 30.sp,
            color: AppColors.blue,
            child: item.icon,
          ),
          SizedBox(
            height: 10.sp,
          ),
          Text(
            _formatValue(),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            item.text,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// class HomePageAppBar extends StatelessWidget implements PreferredSizeWidget {
//   const HomePageAppBar({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       systemOverlayStyle: const SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: Brightness.dark,
//         statusBarBrightness: Brightness.dark,
//       ),
//       elevation: 0,
//       automaticallyImplyLeading: false,
//       backgroundColor: Colors.transparent,
//       titleSpacing: 0,
//       leadingWidth: 60.sp,
//       leading: GestureDetector(
//         onTap: () => Scaffold.of(context).openDrawer(),
//         child: Container(
//             padding: EdgeInsets.all(5.sp),
//             margin: EdgeInsets.only(left: 15.sp, top: 10.sp),
//             decoration: BoxDecoration(
//                 color: Get.theme.primaryColor,
//                 borderRadius: BorderRadius.circular(12.sp),
//                 boxShadow: [
//                   BoxShadow(
//                       color: Get.theme.indicatorColor.withOpacity(.05),
//                       offset: const Offset(0, 0),
//                       blurRadius: 15)
//                 ]),
//             child: SvgPicture.asset(
//               AppIcons.menu,
//               color: Get.theme.indicatorColor,
//               height: 30.sp,
//             )),
//       ),
//       centerTitle: true,
//       title: Container(
//         width: 150.sp,
//         decoration: BoxDecoration(
//             color: AppColors.blue, borderRadius: BorderRadius.circular(50.sp)),
//         padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 30.sp),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               AppIcons.wallet,
//               color: Get.theme.primaryColor,
//               height: 18.sp,
//             ),
//             SizedBox(
//               width: 10.sp,
//             ),
//             Text(
//               " ₹ ${HomeController.to.walletBalance.value}",
//               style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Size get preferredSize => Size.fromHeight(60.sp);
// }

class HomePageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomePageAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      titleSpacing: 0,
      leadingWidth: 60.sp,
      leading: GestureDetector(
        onTap: () => Scaffold.of(context).openDrawer(),
        child: Container(
            padding: EdgeInsets.all(5.sp),
            margin: EdgeInsets.only(left: 15.sp, top: 10.sp),
            decoration: BoxDecoration(
                color: Get.theme.primaryColor,
                borderRadius: BorderRadius.circular(12.sp),
                boxShadow: [
                  BoxShadow(
                      color: Get.theme.indicatorColor.withOpacity(.05),
                      offset: const Offset(0, 0),
                      blurRadius: 15)
                ]),
            child: SvgPicture.asset(
              AppIcons.menu,
              color: Get.theme.indicatorColor,
              height: 30.sp,
            )),
      ),
      centerTitle: true,
      title: Container(
        decoration: BoxDecoration(
            color: AppConstants.getColor(),
            borderRadius: BorderRadius.circular(50.sp)),
        padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 30.sp),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AppIcons.wallet,
              color: Get.theme.primaryColor,
              height: 18.sp,
            ),
            SizedBox(width: 2.w),
            Obx(() {
              return Text(
                " ₹ ${HomeController.to.walletBalance.value ?? 0.0}",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
              );
            }),
            SizedBox(width: 2.w),
            Obx(() => GestureDetector(
                  onTap: () {
                    if (!HomeController.to.isRefreshingWallet.value) {
                      HomeController.to.refreshWalletBalance();
                    }
                  },
                  child: AnimatedRotation(
                    turns:
                        HomeController.to.isRefreshingWallet.value ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.linear,
                    child: Icon(
                      Icons.refresh,
                      color: Get.theme.primaryColor,
                      size: 18.sp,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60.sp);
}

class IncomingOrderBottomSheet extends StatelessWidget {
  final OrderDetails? data;

  const IncomingOrderBottomSheet({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Get.theme.primaryColor,
      ),
      child: ListView(
        shrinkWrap: true,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 20,
              ),
              Text(
                "₹ ${data?.amount ?? " "}",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
              ),
              IconButton(
                  onPressed: () {
                    HomeController.to.orderTimeOut();
                  },
                  icon: const Icon(Icons.close))
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextInsideBox(
                  text: AppConstants.formatSecondsToHrAndMin(
                      data?.duration ?? 0)),
              TextInsideBox(text: "${data?.distance} Km"),
              TextInsideBox(
                  text: (data?.customerRating ?? 0.0).toString(),
                  icon: Icons.star),
            ],
          ),
          SizedBox(
            height: 20.sp,
          ),
          Container(
            padding: EdgeInsets.all(5.sp),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.sp),
                border: Border.all(color: AppColors.grey155)),
            child: Row(
              children: [
                Image.asset(
                  AppIcons.startAndStop,
                  height: 90.sp,
                ),
                SizedBox(
                  width: 20.sp,
                ),
                SizedBox(
                  width: 260.sp,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data?.startLocation ?? "",
                        style: TextStyle(fontSize: 16.sp),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Container(
                        width: 200,
                        color: Get.theme.indicatorColor.withOpacity(.05),
                        height: 2.sp,
                        margin: EdgeInsets.symmetric(vertical: 12.sp),
                      ),
                      Text(
                        data?.endLocation ?? "",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16.sp),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Obx(() => BlueButton(
                isLoading: HomeController.to.isButtonLoading.value,
                text: "Accept",
                onTap: () {
                  // Check if already loading before calling acceptOrder
                  if (!HomeController.to.isButtonLoading.value) {
                    HomeController.to.acceptOrder();
                  }
                },
                suffixIcon: CircleWithIcon(
                  padding: const EdgeInsets.all(5),
                  height: 30.sp,
                  color: Get.theme.primaryColor.withOpacity(.2),
                  child: AppCountDown(
                    style: TextStyle(color: AppColors.white),
                    onEnd: () => HomeController.to.orderTimeOut(),
                    endDate: DateTime.now().add(const Duration(seconds: 14)),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}

class AcceptButton extends StatelessWidget {
  final void Function()? onEnd;
  final void Function()? onTap;

  const AcceptButton({super.key, required this.onEnd, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.sp),
        height: 50.sp,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.sp),
          color: AppColors.blue,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 30.sp,
            ),
            Text(
              "Accept",
              style: TextStyle(fontSize: 16.sp, color: AppColors.white),
            ),
            CircleWithIcon(
                height: 30.sp,
                color: Get.theme.primaryColor.withOpacity(.2),
                child: TweenAnimationBuilder(
                    onEnd: onEnd,
                    tween: Tween(
                        begin: DateTime.now()
                            .add(const Duration(seconds: 15))
                            .difference(DateTime.now()),
                        end: Duration.zero),
                    duration: DateTime.now()
                        .add(const Duration(seconds: 15))
                        .difference(DateTime.now()),
                    builder: (context, Duration date, child) {
                      return Text(
                        "${date.inSeconds}",
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(color: AppColors.white, fontSize: 15.sp),
                      );
                    }))
          ],
        ),
      ),
    );
  }
}

class CancelOrder extends StatelessWidget {
  const CancelOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.sp),
        color: Get.theme.primaryColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Cancel trip?",
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 20.sp,
          ),
          RedButton(
            text: "Yes, Cancel",
            onTap: () => Get.toNamed(
              AppRoutes1.getreasonForCancelInRoute(),
              arguments: HomeController.to.rideId,
            ),
          ),
          SizedBox(
            height: 20.sp,
          ),
          RedBorderedButton(text: "No", onTap: () => Get.back()),
        ],
      ),
    );
  }
}

class AddStopBottomSheet extends StatelessWidget {
  const AddStopBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.sp),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.sp),
            topRight: Radius.circular(8.sp),
          )),
      child: ListView(
        shrinkWrap: true,
        children: [
          Text(
            "Add Stop ?",
            style: TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.w600,
                fontSize: 20.sp),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 5.sp,
          ),
          Text(
            "Are you sure you want to add a stop?",
            style: TextStyle(color: AppColors.grey93, fontSize: 14.sp),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20.sp,
          ),
          BlueButton(
            text: "Add Stop",
            onTap: () {
              HomeController.to.addStop(context);
            },
          ),
          SizedBox(
            height: 20.sp,
          ),
          WhiteButton(
            text: "Go Back",
            onTap: () => Get.back(),
          ),
        ],
      ),
    );
  }
}

class Recenter extends StatelessWidget {
  const Recenter({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(
      builder: (controller) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            controller.recenterLoading.value
                ? TooltipContainer()
                : SizedBox.shrink(),
            GestureDetector(
              onTap: controller.recenter,
              child: Container(
                  padding: EdgeInsets.all(5.sp),
                  margin: EdgeInsets.all(10.sp),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.theme.primaryColor,
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.black.withValues(alpha: .1),
                          offset: Offset(3, 3),
                          blurRadius: 5,
                          spreadRadius: 5)
                    ],
                  ),
                  child: controller.recenterLoading.value
                      ? CupertinoActivityIndicator(radius: 12)
                      : Icon(Icons.location_searching)),
            )
          ],
        );
      },
    );
  }
}

class TooltipContainer extends StatelessWidget {
  const TooltipContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.grey249,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 6,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Text(
            'Fetching current location',
            style: TextStyle(color: AppColors.grey93),
          ),
        ),
        CustomPaint(
          size: Size(10, 20), // Triangle size
          painter: RightTrianglePainter(),
        ),
      ],
    );
  }
}

class RightTrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final shadowPaint = Paint()..color = Colors.black54;
    final trianglePaint = Paint()..color = AppColors.grey249;

    final shadowPath = Path()
      ..moveTo(1, 1)
      ..lineTo(size.width + 3, size.height / 2 + 2)
      ..lineTo(1, size.height + 2)
      ..close();

    final trianglePath = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(shadowPath, shadowPaint);
    canvas.drawPath(trianglePath, trianglePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
