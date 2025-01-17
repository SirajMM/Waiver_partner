import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../colors/app_colors.dart';
import '../app_network_image/app_network_image.dart';
import '../circle_with_gradient/circle_with_gradient.dart';

class UpLoadImageTemplate extends StatelessWidget {
  final double height;
  final double width;
  final double? radius;
  final String image;
  final String? placeHolder;
  final bool? isRectangle;
  final Function(ImageSource source) onTap;
  final void Function()? closeOnTap;
  const UpLoadImageTemplate(
      {super.key,
      required this.width,
      required this.height,
      this.placeHolder,
      this.isRectangle,
      this.closeOnTap,
      this.radius,
      required this.image,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(ImageSelectionBottomSheet(
          onTap: (ImageSource source) => onTap(source),
        ));
      },
      child: Container(
        width: width +
            (image.isEmpty ? 0 : ((isRectangle ?? false) ? -10 : 10.sp)),
        height: height,
        margin: EdgeInsets.only(
            top: image.isEmpty ? 15.sp : 0, right: image.isEmpty ? 15.sp : 0),
        decoration: BoxDecoration(
            color: AppColors.grey155.withOpacity(image.isEmpty ? 1 : 0),
            borderRadius: BorderRadius.circular(8.sp)),
        child: image.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo_outlined,
                    color: AppColors.white,
                    size: height * .5,
                  ),
                  (placeHolder ?? "").isEmpty
                      ? const SizedBox()
                      : Container(
                          padding: EdgeInsets.only(top: 30.sp),
                          child: Text(
                            placeHolder ?? "",
                            style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w900,
                                color: AppColors.grey93),
                          ),
                        )
                ],
              )
            : Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 15.sp, right: 15.sp),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.sp),
                      child: AppNetworkImage(
                        imageUrl: image,
                        radius: radius,
                        dontUseBaseUrl: true,
                        height: height,
                        width: width,
                      ),
                    ),
                  ),
                  Positioned(
                      top: 5,
                      right: 5,
                      child: GestureDetector(
                        onTap: closeOnTap,
                        child: CircleWithIcon(
                          height: 30.sp,
                          color: AppColors.red,
                          child: Icon(
                            Icons.clear,
                            color: AppColors.white,
                          ),
                        ),
                      )),
                ],
              ),
      ),
    );
  }
}

class ImageSelectionBottomSheet extends StatelessWidget {
  final Function(ImageSource) onTap;
  const ImageSelectionBottomSheet({super.key, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.white, borderRadius: BorderRadius.circular(8.sp)),
      padding: EdgeInsets.all(20.sp),
      child: ListView(
        shrinkWrap: true,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => onTap(ImageSource.camera),
                child: Column(
                  children: [
                    CircleWithIcon(
                      height: 55.sp,
                      color: AppColors.black.withOpacity(0.9),
                      child: Icon(
                        Icons.camera_alt_outlined,
                        size: 30.sp,
                        color: AppColors.white,
                      ),
                    ),
                    Text(
                      "Camera",
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w900),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 20.sp,
              ),
              GestureDetector(
                onTap: () => onTap(ImageSource.gallery),
                child: Column(
                  children: [
                    CircleWithIcon(
                      height: 55.sp,
                      color: AppColors.black.withOpacity(0.9),
                      child: Icon(
                        Icons.photo,
                        size: 30.sp,
                        color: AppColors.white,
                      ),
                    ),
                    Text(
                      "Gallery",
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w900),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
