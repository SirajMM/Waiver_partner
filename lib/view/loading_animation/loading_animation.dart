import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/loading_animation/loding_animation_controller.dart';
import '../../core/colors/app_colors.dart';



class LoadingBarsAnimation extends StatelessWidget {
  final double? height;
  final double? width;
  final bool? expanded;

  const LoadingBarsAnimation({
    super.key,
    this.width,
    this.expanded,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    LoadingBarsAnimationController loadingAnimationController =
        Get.put(LoadingBarsAnimationController());

    const double oddDotHeight = 40;
    const double evenDotHeight = 40;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: expanded ?? false ? 30 : 140),
      alignment: Alignment.center,
      width: width ?? Get.width,
      height: height ?? Get.height,
      child: Center(
        child: AnimatedBuilder(
          animation: loadingAnimationController.offsetController,
          builder: (context, child) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DotContainer(
                controller: loadingAnimationController.offsetController,
                heightInterval: const Interval(0.0, 0.1),
                offsetInterval: const Interval(0.18, 0.28),
                reverseHeightInterval: const Interval(0.28, 0.38),
                reverseOffsetInterval: const Interval(0.47, 0.57),
                maxHeight: oddDotHeight,
              ),
              DotContainer(
                controller: loadingAnimationController.offsetController,
                heightInterval: const Interval(0.09, 0.19),
                offsetInterval: const Interval(0.27, 0.37),
                reverseHeightInterval: const Interval(0.37, 0.47),
                reverseOffsetInterval: const Interval(0.56, 0.66),
                maxHeight: evenDotHeight,
              ),
              DotContainer(
                controller: loadingAnimationController.offsetController,
                heightInterval: const Interval(0.18, 0.28),
                offsetInterval: const Interval(0.36, 0.46),
                reverseHeightInterval: const Interval(0.46, 0.56),
                reverseOffsetInterval: const Interval(0.65, 0.75),
                maxHeight: oddDotHeight,
              ),
              DotContainer(
                controller: loadingAnimationController.offsetController,
                heightInterval: const Interval(0.27, 0.37),
                offsetInterval: const Interval(0.45, 0.55),
                reverseHeightInterval: const Interval(0.55, 0.65),
                reverseOffsetInterval: const Interval(0.74, 0.84),
                maxHeight: evenDotHeight,
              ),
              DotContainer(
                controller: loadingAnimationController.offsetController,
                heightInterval: const Interval(0.36, 0.46),
                offsetInterval: const Interval(0.54, 0.64),
                reverseHeightInterval: const Interval(0.64, 0.74),
                reverseOffsetInterval: const Interval(0.83, 0.93),
                maxHeight: oddDotHeight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DotContainer extends StatelessWidget {
  final Interval offsetInterval;

  final Interval reverseOffsetInterval;
  final Interval heightInterval;
  final Interval reverseHeightInterval;
  final double maxHeight;
  final AnimationController controller;

  const DotContainer({
    Key? key,
    required this.offsetInterval,
    required this.reverseOffsetInterval,
    required this.heightInterval,
    required this.reverseHeightInterval,
    required this.maxHeight,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double maxDy = -(50 * 0.20);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Opacity(
              opacity: controller.value <= offsetInterval.end ? 1 : 0,
              // opacity: 1,
              child: Transform.translate(
                offset: Tween<Offset>(
                  begin: Offset.zero,
                  end: const Offset(0, maxDy),
                )
                    .animate(
                      CurvedAnimation(
                        parent: controller,
                        curve: offsetInterval,
                      ),
                    )
                    .value,
                child: Container(
                  width: 50 * 0.13,
                  height: Tween<double>(
                    begin: 50 * 0.13,
                    end: maxHeight,
                  )
                      .animate(
                        CurvedAnimation(
                          parent: controller,
                          curve: heightInterval,
                        ),
                      )
                      .value,
                  decoration: BoxDecoration(
                    color: AppColors.grey93,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
            Opacity(
              opacity: controller.value >= offsetInterval.end ? 1 : 0,
              child: Transform.translate(
                offset: Tween<Offset>(
                  begin: const Offset(0, maxDy),
                  end: Offset.zero,
                )
                    .animate(
                      CurvedAnimation(
                        parent: controller,
                        curve: reverseOffsetInterval,
                      ),
                    )
                    .value,
                child: Container(
                  width: 50 * 0.13,
                  height: Tween<double>(
                    end: 50 * 0.13,
                    begin: maxHeight,
                  )
                      .animate(
                        CurvedAnimation(
                          parent: controller,
                          curve: reverseHeightInterval,
                        ),
                      )
                      .value,
                  decoration: BoxDecoration(
                    color: AppColors.grey93,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class LoadingAnimationDots extends StatelessWidget {
  final LoadingDotAnimationController loadingDotAnimationController =
      Get.put(LoadingDotAnimationController());
  final double? height;

  final double? width;

  LoadingAnimationDots({super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 100.sp,
      height: height ?? 30.sp,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(5, (index) {
          return ScaleTransition(
            scale: DelayTween(begin: .3, end: 1.0, delay: index * .2)
                .animate(loadingDotAnimationController.controller),
            child: SizedBox.fromSize(
                size: Size.square(10.sp),
                child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: AppColors.grey93, shape: BoxShape.circle))),
          );
        }),
      ),
    );
  }
}
