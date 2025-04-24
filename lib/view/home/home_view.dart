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
import 'package:waiver_driver/view/loading_animation/loading_animation.dart';

import '../left_menu_driver/left_menu_driver_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController(parser: Get.find()));
    return GetX<HomeController>(builder: (controller) {
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
                    return Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.sp, vertical: 20.sp),
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
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 30.sp,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${(HomeController.to.timeToDropOffLocation ?? 0) > 3600 ? Duration(seconds: HomeController.to.timeToDropOffLocation ?? 0).inHours.toStringAsFixed(2) : Duration(seconds: HomeController.to.timeToDropOffLocation ?? 0).inMinutes.toStringAsFixed(2)} mins",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20.sp,
                                  ),
                                  Text(
                                    "${HomeController.to.distanceToDropOffLocation} Km",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                  onPressed: () =>
                                      Get.bottomSheet(CancelOrder()),
                                  icon: Icon(Icons.close))
                            ],
                          ),
                          SizedBox(
                            height: 20.sp,
                          ),
                          Text(
                            "Picking up ${HomeController.to.passengerName ?? "Passenger"}",
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 20.sp,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 50.sp),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    HomeController.to.makePhoneCall();
                                  },
                                  child: BottomSheetWhileDrivingItem(
                                      icon: CircleWithIcon(
                                          height: 35.sp,
                                          color: AppColors.blue,
                                          padding: EdgeInsets.all(8.sp),
                                          child: Image.asset(AppIcons.phone)),
                                      text: "Call"),
                                ),
                                // BottomSheetWhileDrivingItem(
                                //     icon: CircleWithIcon(
                                //         height: 35.sp,
                                //         color: AppColors.blue,
                                //         padding: EdgeInsets.all(8.sp),
                                //         child: Image.asset(AppIcons.message)),
                                //     text: "Message"),
                                BottomSheetWhileDrivingItem(
                                  icon: CircleWithIcon(
                                      height: 35.sp,
                                      color: AppColors.blue,
                                      padding: EdgeInsets.all(8.sp),
                                      child: Image.asset(AppIcons.navigation)),
                                  text: "Navigate",
                                  onTap: () => HomeController.to.openMap(
                                      latitude:
                                          HomeController.to.startLocationLat,
                                      longitude:
                                          HomeController.to.startLocationLong),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20.sp,
                          ),
                          BlueButton(
                              text: "Arrived at Pick Up",
                              onTap: () =>
                                  HomeController.to.reachedPickUpLocation()),
                        ],
                      ),
                    );

                  case DriverState.arrivedAtPickUp:
                    return EnterOtpBottomSheet(
                        orderStatus: RideStatus.reachedPickUp);

                  case DriverState.readyToGoToDestination:
                    return Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.sp, vertical: 20.sp),
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
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${(HomeController.to.timeToDropOffLocation ?? 0) > 3600 ? Duration(seconds: HomeController.to.timeToDropOffLocation ?? 0).inHours.toStringAsFixed(2) : Duration(seconds: HomeController.to.timeToDropOffLocation ?? 0).inMinutes.toStringAsFixed(2)} mins",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20.sp,
                                ),
                              ),
                              SizedBox(
                                width: 20.sp,
                              ),
                              Text(
                                "${HomeController.to.distanceToDropOffLocation} Km",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20.sp,
                                ),
                              ),
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
                                  width: 275.sp,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        HomeController.to.pickUpLocation ?? "",
                                        style: TextStyle(fontSize: 16.sp),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Container(
                                        width: 200,
                                        color: Get.theme.indicatorColor
                                            .withOpacity(.05),
                                        height: 2.sp,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 12.sp),
                                      ),
                                      Text(
                                        HomeController.to.dropOffLocation ?? "",
                                        style: TextStyle(fontSize: 16.sp),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20.sp,
                          ),
                          BlueButton(
                              text: "Start Trip",
                              onTap: () {
                                HomeController.to.driverState.value =
                                    DriverState.goingToDestination;
                                HomeController.to.openMap(
                                    latitude: HomeController.to.endLocationLat,
                                    longitude:
                                        HomeController.to.endLocationLong);
                              }),
                        ],
                      ),
                    );

                  case DriverState.goingToDestination:
                    return Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.sp, vertical: 20.sp),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${(HomeController.to.timeToDropOffLocation ?? 0) > 3600 ? Duration(seconds: HomeController.to.timeToDropOffLocation ?? 0).inHours.toStringAsFixed(2) : Duration(seconds: HomeController.to.timeToDropOffLocation ?? 0).inMinutes.toStringAsFixed(2)} mins",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20.sp,
                                ),
                              ),
                              SizedBox(
                                width: 20.sp,
                              ),
                              Text(
                                "${HomeController.to.distanceToDropOffLocation} Km",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20.sp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.sp,
                          ),
                          Text(
                            "Dropping off ${HomeController.to.passengerName ?? "Alex John"}",
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 20.sp,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BottomSheetWhileDrivingItem(
                                icon: CircleWithIcon(
                                    height: 35.sp,
                                    color: AppColors.blue,
                                    padding: EdgeInsets.all(8.sp),
                                    child: Image.asset(AppIcons.navigation)),
                                text: "Navigate",
                                onTap: () => HomeController.to.openMap(
                                    latitude: HomeController.to.endLocationLat,
                                    longitude:
                                        HomeController.to.endLocationLong),
                              ),
                              SizedBox(
                                width: 40.sp,
                              ),
                              BottomSheetWhileDrivingItem(
                                icon: CircleWithIcon(
                                    height: 35.sp,
                                    color: AppColors.blue,
                                    // padding: EdgeInsets.all(8.sp),
                                    child: Icon(
                                      Icons.u_turn_right_rounded,
                                      color: AppColors.white,
                                    )),
                                text: "Add Stop",
                                onTap: () {
                                  Get.bottomSheet(AddStopBottomSheet());
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.sp,
                          ),
                          BlueButton(
                              text: "Arrived at Destination",
                              onTap: () =>
                                  HomeController.to.reachedDropOffLocation()),
                        ],
                      ),
                    );

                  case DriverState.reachedDestination:
                    return EnterOtpBottomSheet(
                        orderStatus: RideStatus.reachedDropOff);

                  case DriverState.paymentInitiated:
                    return box.read(BoxKeys.paymentType) == "CSH"
                        ? const PaymentConfirmationSheetCash()
                        : const PaymentConfirmationSheetOnline();
                  case DriverState.completed:
                    return HomeController.to.rideIsActive
                        ? const MakingPaymentBottomSheet()
                        : const SizedBox();
                  case DriverState.loading:
                    return Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.sp, vertical: 20.sp),
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
                      child: LoadingBarsAnimation(
                        height: 200.sp,
                      ),
                    );
                }
              }),
              body: SizedBox(
                width: Get.width,
                height: Get.height,
                child: GetX<HomeController>(builder: (controller) {
                  return Stack(
                    children: [
                      GoogleMap(
                        padding: EdgeInsets.only(
                            bottom: 100.sp, top: 600.sp, right: 10.sp),
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
                              controller.currentPosition.value?.longitude ??
                                  0.0,
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
                        onCameraIdle: () async => controller
                                .pickUpLocation1?.name.value =
                            await controller.getLocationDetails(
                                controller.currentPosition.value?.latitude ?? 0,
                                controller.currentPosition.value?.longitude ??
                                    0.0),
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            controller.currentPosition.value?.latitude ?? 0,
                            controller.currentPosition.value?.longitude ?? 0,
                          ),
                          // zoom: 15,
                        ),
                        onMapCreated:
                            (GoogleMapController googleMapController) async {
                          controller.googleMapController = googleMapController;
                          await controller.onMapCreate();
                        },
                      ),
                      Positioned(
                        right: 0,
                        top: 660.sp, // Adjust the top position as needed
                        child: const Recenter(),
                      ),
                    ],
                  );
                  // : GoogleMap(
                  //     padding: EdgeInsets.only(
                  //         bottom: 90.sp, top: 600.sp, right: 10.sp),
                  //     mapType: MapType.normal,
                  //     initialCameraPosition: CameraPosition(
                  //       target: LatLng(
                  //         9.9816,
                  //         76.2999,
                  //       ),
                  //       zoom: 15,
                  //     ),
                  //     // Disable map gestures
                  //     zoomControlsEnabled: false, // Hide zoom buttons
                  //     zoomGesturesEnabled:
                  //         false, // Disable zoom gestures
                  //     scrollGesturesEnabled:
                  //         false, // Disable panning/scrolling
                  //     rotateGesturesEnabled: false, // Disable rotation
                  //     tiltGesturesEnabled: false, // Disable tilt
                  //     compassEnabled: false, // Hide compass
                  //     // If you need to prevent ALL touch interactions
                  //     gestureRecognizers: <Factory<
                  //         OneSequenceGestureRecognizer>>{
                  //       Factory<EagerGestureRecognizer>(
                  //           () => EagerGestureRecognizer()),
                  //     },
                  //   );
                }),
              ));
    });
  }
}

class MakingPaymentBottomSheet extends StatelessWidget {
  const MakingPaymentBottomSheet({super.key});

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
                  topRight: Radius.circular(10.sp),
                  topLeft: Radius.circular(10.sp))),
          width: Get.width,
          child: ListView(
            padding: EdgeInsets.all(20.sp),
            shrinkWrap: true,
            children: [
              SizedBox(
                height: 10.sp,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 16.sp),
                color: AppColors.grey249,
                height: 1.sp,
              ),
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
              BlueButton(
                text: "Confirm",
                onTap: () {
                  // HomeController.to.completeRide();
                  HomeController.to.driverState.value = DriverState.idle;
                },
              ),
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
  String text;
  String? amount;

  InvoiceListingItem({
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
  String orderStatus;

  EnterOtpBottomSheet({required this.orderStatus});

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
          Row(
            children: [
              IconButton(
                  onPressed: () => Get.bottomSheet(CancelOrder()),
                  icon: Icon(Icons.close))
            ],
          ),
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
            height: 55.sp,
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
                HomeController.to.code = code ?? "";
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
  const PaymentConfirmationSheetOnline({super.key});

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
            "Online Payment",
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
            "Please wait until customer completes the payment",
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
  String reason;

  CancelReasonItem({super.key, required this.reason});

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

class TextInsideBox extends StatelessWidget {
  String text;
  Widget? icon;

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
              child: icon ?? const SizedBox()),
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
    return Container(
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
                    style:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
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
    );
  }
}

class ChangeOnlineStatusButton extends StatelessWidget {
  const ChangeOnlineStatusButton({super.key});

  @override
  Widget build(BuildContext context) {
    bool enable = true;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            HomeController.to.changeDriverOnlineStatus();
            // WakelockPlus.toggle(enable: enable);
            enable = !enable;
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
                        height: 20.sp,
                        width: 20.sp,
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
        ),
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
            item.value,
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
        width: 185.sp, // Increased width to accommodate the refresh icon
        decoration: BoxDecoration(
            color: AppConstants.getColor(),
            borderRadius: BorderRadius.circular(50.sp)),
        padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 30.sp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              AppIcons.wallet,
              color: Get.theme.primaryColor,
              height: 18.sp,
            ),
            SizedBox(
              width: 1.sp,
            ),
            Obx(() {
              return Text(
                " ₹ ${HomeController.to.walletBalance.value ?? 0.0}",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
              );
            }),
            SizedBox(
              width: 1.sp,
            ),
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
                  text:
                      "${((data?.duration ?? 0) / 3600).toStringAsFixed(1)} hr"),
              TextInsideBox(text: "${data?.distance} Km"),
              TextInsideBox(
                text: (data?.customerRating ?? 4.0).toString(),
                icon: Image.asset(
                  AppIcons.star,
                  color: Get.theme.primaryColor,
                  height: 16,
                ),
              ),
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
          BlueButton(
            text: "Accept",
            onTap: () => HomeController.to.acceptOrder(),
            suffixIcon: CircleWithIcon(
              padding: const EdgeInsets.all(5),
              height: 30.sp,
              color: Get.theme.primaryColor.withOpacity(.2),
              child: AppCountDown(
                style: TextStyle(color: AppColors.white),
                onEnd: () => HomeController.to.orderTimeOut(),
                endDate: DateTime.now().add(const Duration(seconds: 20)),
              ),
            ),
          )
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
