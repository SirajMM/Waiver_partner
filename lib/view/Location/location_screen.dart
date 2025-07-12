// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';

// import '../../controller/splash/splash_controller.dart';
// import '../../core/colors/app_colors.dart';
// import '../../core/themes/assets/icons.dart';
// import '../../core/widgets/app_buttons/app_buttons.dart';

// class LocationScreen extends StatelessWidget {
//   const LocationScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final SplashController splashController = Get.find();
//     return Scaffold(
//         bottomSheet: Container(
//             margin: EdgeInsets.fromLTRB(15.sp, 0, 15.sp, 30.sp),
//             height: 52.sp,
//             child: GreenButton(
//               text: "Allow Permission",
//               onTap: () => splashController.requestLocPermission(),
//             )),
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SvgPicture.asset(AppIcons.getLocationIcon),
//             SizedBox(height: 28.sp),
//             Text(
//               "Location not enabled",
//               style: TextStyle(
//                   color: AppColors.black,
//                   height: 1,
//                   fontSize: 24.sp,
//                   fontWeight: FontWeight.w600),
//             ),
//             SizedBox(height: 16.sp),
//             Padding(
//               padding: EdgeInsets.only(left: 37.sp, right: 37.sp),
//               child: Text(
//                 "Share location permission helps us improve your ride booking and pickup experience",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                     color: AppColors.grey93,
//                     fontSize: 16.sp,
//                     height: 1,
//                     fontWeight: FontWeight.w200),
//               ),
//             ),
//           ],
//         ));
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../controller/splash/splash_controller.dart';
import '../../core/colors/app_colors.dart';
import '../../core/themes/assets/icons.dart';
import '../../core/widgets/app_buttons/app_buttons.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> with WidgetsBindingObserver {
  late SplashController splashController;
  bool isLoading = false;
  
  @override
  void initState() {
    super.initState();
    splashController = Get.find<SplashController>();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Small delay to ensure settings are properly applied
      Future.delayed(const Duration(milliseconds: 500), () {
        splashController.recheckPermissions();
      });
    }
  }

  Future<void> _handlePermissionRequest() async {
    setState(() {
      isLoading = true;
    });
    
    try {
      await splashController.requestLocPermission();
    } catch (e) {
      // Handle error if needed
      print('Error requesting permission: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomSheet: Container(
            margin: EdgeInsets.fromLTRB(15.sp, 0, 15.sp, 30.sp),
            height: 52.sp,
            child: GreenButton(
              text: isLoading ? "Processing..." : "Allow Permission",
              onTap: isLoading ? null : _handlePermissionRequest,
              // You might want to add a loading indicator in your GreenButton
            )),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(AppIcons.getLocationIcon),
            SizedBox(height: 28.sp),
            Text(
              "Location not enabled",
              style: TextStyle(
                  color: AppColors.black,
                  height: 1,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16.sp),
            Padding(
              padding: EdgeInsets.only(left: 37.sp, right: 37.sp),
              child: Text(
                "Share location permission helps us improve your ride booking and pickup experience",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.grey93,
                    fontSize: 16.sp,
                    height: 1,
                    fontWeight: FontWeight.w200),
              ),
            ),
            // Optional: Add a "Skip" button for testing purposes
            // SizedBox(height: 24.sp),
            // TextButton(
            //   onPressed: () {
            //     // For testing - you might want to remove this in production
            //     Get.offAllNamed(AppRoutes1.getDriverTypeSelectionRoute());
            //   },
            //   child: Text(
            //     "Skip for now",
            //     style: TextStyle(
            //       color: AppColors.grey93,
            //       fontSize: 14.sp,
            //       fontWeight: FontWeight.w400,
            //     ),
            //   ),
            // ),
          ],
        ));
  }
}