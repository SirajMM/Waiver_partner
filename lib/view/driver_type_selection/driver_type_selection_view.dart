import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waiver_driver/backend/api/api_services/api_services.dart';
import 'package:waiver_driver/backend/api/api_services/urls.dart';
import 'package:waiver_driver/core/colors/app_colors.dart';
import 'package:waiver_driver/core/constants/get_storage_constants.dart';
import 'package:waiver_driver/core/themes/assets/icons.dart';
import 'package:waiver_driver/core/themes/assets/images.dart';
import 'package:waiver_driver/core/widgets/app_buttons/app_buttons.dart';
import 'package:waiver_driver/helper/router/app_routes/app_routes.dart';
import 'package:waiver_driver/helper/router/app_routes/route.dart';
import 'package:waiver_driver/main.dart';

class DriverTypeSelectionScreen extends StatelessWidget {
  const DriverTypeSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ApiServices(appBaseUrl: AppUrls.base));
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              AppImages.loginBackground,
            ),
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter,
          ),
        ),
        child: Stack(
          children: [
            // Your main content
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TypeOfServices(),
              ],
            ),
            // Support icon at the top right
//             Positioned(
//               right: 16, // Adjust the distance from the right edge
//               top: 16,   // Adjust the distance from the top edge
//               child: IconButton(
//                 icon: Icon(Icons.live_help_sharp,size: 50,), // Change this to your desired icon
//                 color: Colors.white, // Change this color as needed
//                 onPressed: ()async{
//  final Uri whatsapp= Uri.parse('https://api.whatsapp.com/send?phone=918943099085&text=Hi');
// launchUrl(whatsapp);
//
//                 },
//               ),
//             ),
          ],
        ),
      ),
    );
  }
}

class TypeOfServices extends StatelessWidget {
  const TypeOfServices({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        color: Get.theme.primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.sp),
          topRight: Radius.circular(15.sp),
        ),
      ),
      padding: EdgeInsets.all(24.sp),
      child: Column(
        children: [
          SizedBox(
            height: 10.sp,
          ),
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Welcome! Opportunities await.",
                      style: TextStyle(
                        height: 1,
                        fontSize: 23.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final Uri whatsapp = Uri.parse(
                          'https://api.whatsapp.com/send?phone=918943099085&text=Hi');
                      launchUrl(whatsapp);
                    },
                    child: Container(
                      padding: EdgeInsets.all(6.0),
                      color: AppColors.blue,
                      height: 32.h,
                      child: Image.asset(
                        AppIcons.customerSupport,
                        color: AppColors.white,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          SizedBox(
            height: 14.sp,
          ),
          Text(
            "Join us as a partner, start earning with Waiver today!",
            style: TextStyle(
              fontSize: 16.sp,
              height: 1,
              fontWeight: FontWeight.w200,
            ),
          ),
          SizedBox(
            height: 25.sp,
          ),
          const TypeOfServicesListing()
        ],
      ),
    );
  }
}

class TypeOfServicesListing extends StatelessWidget {
  const TypeOfServicesListing({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Hero(
          tag: UserType.chauffeur,
          child: Material(
            child: BlueOnlyButton(
              text: "Chauffeur",
              onTap: () async {
                box.write(BoxKeys.userTypeCode, UserTypeCode.chauffeur);
                // Get.toNamed(AppRoutes.signIn, arguments: UserType.chauffeur);
                Get.toNamed(AppRoutes1.getSignInRoute(),
                    arguments: UserType.chauffeur);
              },
            ),
          ),
        ),
        SizedBox(height: 14.sp),
        Hero(
          tag: UserType.fleet,
          child: BlueOnlyButton(
            text: "Fleet",
            onTap: () {
              box.write(BoxKeys.userTypeCode, UserTypeCode.fleet);
              Get.toNamed(AppRoutes1.getSignInRoute(),
                  arguments: UserType.fleet);
            },
          ),
        ),
        SizedBox(height: 14.sp),
        Hero(
          tag: UserType.driver,
          child: BlueOnlyButton(
            text: "Driver",
            onTap: () {
              box.write(BoxKeys.userTypeCode, UserTypeCode.driver);
              Get.toNamed(AppRoutes1.getSignInRoute(),
                  arguments: UserType.driver);
            },
          ),
        )
      ],
    );
  }
}
