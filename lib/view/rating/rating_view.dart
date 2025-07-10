import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:waiver_driver/backend/model/rating/rating_model.dart';
import 'package:waiver_driver/controller/rating/rating_controller.dart';
import 'package:waiver_driver/core/colors/app_colors.dart';
import 'package:waiver_driver/core/widgets/app_bar/app_bar.dart';
import 'package:waiver_driver/core/widgets/empty_page/empty_page.dart';
import 'package:waiver_driver/core/widgets/error_page/error_page.dart';
import 'package:waiver_driver/view/home/home_view.dart';
import 'package:waiver_driver/view/loading_animation/loading_animation.dart';

class RatingScreen extends StatelessWidget {
  const RatingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Rating"),
      body: GetX<RatingController>(
        builder: (controller) {
          if (controller.isLoading.value) {
            return const LoadingBarsAnimation();
          }

          if (controller.isError.value) {
            return const ErrorPage();
          }

          if (controller.ratingsList.isEmpty) {
            return const EmptyPage(text: "No Rating Found");
          }

          return ListView(
            controller: controller.scrollController,
            padding: EdgeInsets.symmetric(horizontal: 15.sp),
            children: [
              SizedBox(height: 30.sp),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DashBoardItem(item: controller.acceptance),
                    DashBoardItem(item: controller.rating),
                    DashBoardItem(item: controller.cancellation),
                  ],
                ),
              ),
              SizedBox(height: 20.sp),
              const Text(
                "Ratings",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10.sp),
              ...controller.ratingsList.reversed
                  .map((rating) => RatingContainer(review: rating)),
              if (controller.isListCompeted.value)
                LoadingBarsAnimation(height: 200.sp)
              else
                const SizedBox(),
            ],
          );
        },
      ),
    );
  }
}

class RatingContainer extends StatelessWidget {
  final ReviewModel review;
  const RatingContainer({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.sp),
      margin: EdgeInsets.only(bottom: 14.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StarBuilder(
            rating: review.rating ?? 0.0,
            size: 18.sp,
          ),
          SizedBox(height: 10.sp),
          Text(
            review.review ?? "",
            style: TextStyle(
              color: AppColors.grey93,
              fontSize: 12.sp,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class StarBuilder extends StatelessWidget {
  final double rating;
  final double size;
  final Color filledColor;
  final Color emptyColor;

  const StarBuilder({
    super.key,
    required this.rating,
    this.size = 20.0,
    this.filledColor = Colors.amber,
    this.emptyColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        final starValue = index + 1;
        double fillPercent;

        if (rating >= starValue) {
          fillPercent = 1.0; // full star
        } else if (rating >= starValue - 0.5) {
          fillPercent = 0.5; // half star
        } else {
          fillPercent = 0.0; // empty star
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: CustomPaint(
            size: Size.square(size),
            painter: StarPainter(
              fillPercent: fillPercent,
              filledColor: filledColor,
              emptyColor: emptyColor,
            ),
          ),
        );
      }),
    );
  }
}

class StarPainter extends CustomPainter {
  final double fillPercent;
  final Color filledColor;
  final Color emptyColor;

  StarPainter({
    required this.fillPercent,
    required this.filledColor,
    required this.emptyColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = emptyColor
      ..style = PaintingStyle.fill;

    final Path starPath = createStarPath(
        size.width / 2, size.height / 2, size.width / 2, size.width / 4, 5);

    canvas.drawPath(starPath, paint);

    if (fillPercent > 0) {
      Rect clipRect =
          Rect.fromLTWH(0, 0, size.width * fillPercent, size.height);
      canvas.save();
      canvas.clipRect(clipRect);

      paint.color = filledColor;
      canvas.drawPath(starPath, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant StarPainter oldDelegate) {
    return oldDelegate.fillPercent != fillPercent ||
        oldDelegate.filledColor != filledColor ||
        oldDelegate.emptyColor != emptyColor;
  }

  Path createStarPath(double cx, double cy, double outerRadius,
      double innerRadius, int points) {
    double angle = pi / points;
    Path path = Path();

    for (int i = 0; i < 2 * points; i++) {
      double r = i.isEven ? outerRadius : innerRadius;
      double x = cx + r * cos(i * angle - pi / 2);
      double y = cy + r * sin(i * angle - pi / 2);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }
}
