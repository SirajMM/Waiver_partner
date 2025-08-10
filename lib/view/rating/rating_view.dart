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
          if (controller.isLoading.value && controller.ratingsList.isEmpty) {
            return const LoadingBarsAnimation();
          }

          if (controller.isError.value && controller.ratingsList.isEmpty) {
            return ErrorPage(
              // onRetry: () => controller.refreshReviews(),
            );
          }

          if (controller.ratingsList.isEmpty && !controller.isLoading.value) {
            return const EmptyPage(text: "No Rating Found");
          }

          return RefreshIndicator(
            onRefresh: () => controller.refreshReviews(),
            child: ListView(
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
                Text(
                  "Ratings (${controller.ratingsList.length})",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: 10.sp),
                ...controller.ratingsList
                    .map((rating) => RatingContainer(review: rating)),

                // Pagination loading indicator
                if (controller.isPaginationLoading.value)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.sp),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),

                // End of list indicator
                if (!controller.hasMoreData && controller.ratingsList.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.sp),
                    child: Center(
                      child: Text(
                        "No more ratings to load",
                        style: TextStyle(
                          color: AppColors.grey93,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ),

                // Add some bottom padding
                SizedBox(height: 20.sp),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Alternative manual load more button approach
class LoadMoreButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const LoadMoreButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.sp, horizontal: 20.sp),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 12.sp),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.sp),
            ),
          ),
          child: isLoading
              ? SizedBox(
            height: 20.sp,
            width: 20.sp,
            child: const CircularProgressIndicator(
              strokeWidth: 2,
            ),
          )
              : Text(
            "Load More",
            style: TextStyle(fontSize: 14.sp),
          ),
        ),
      ),
    );
  }
}

// Usage with manual button (if you prefer this approach):
/*
// Add this after the ratings list in RatingScreen:
if (controller.hasMoreData && !controller.isPaginationLoading.value)
  LoadMoreButton(
    onPressed: () => controller.loadMoreReviews(),
    isLoading: controller.isPaginationLoading.value,
  ),
*/

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
          // Add user info section
          Row(
            children: [
              // CircleAvatar(
              //   radius: 16.sp,
              //   backgroundColor: AppColors.grey93.withOpacity(0.2),
              //   child: Icon(
              //     Icons.person,
              //     size: 18.sp,
              //     color: AppColors.grey93,
              //   ),
              // ),
              SizedBox(width: 10.sp),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   "Passenger", // You can get passenger name from API if available
                    //   style: TextStyle(
                    //     fontSize: 14.sp,
                    //     fontWeight: FontWeight.w500,
                    //     color: AppColors.black,
                    //   ),
                    // ),
                    // Text(
                    //   _formatDate(review.createdAt.toString() ?? ""),
                    //   style: TextStyle(
                    //     fontSize: 11.sp,
                    //     color: AppColors.grey93,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.sp),
          StarBuilder(
            rating: review.rating ?? 0.0,
            size: 18.sp,
          ),
          SizedBox(height: 10.sp),
          if (review.review?.isNotEmpty == true)
            Text(
              review.review!,
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

  String _formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return "${date.day}/${date.month}/${date.year}";
    } catch (e) {
      return dateString;
    }
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
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        double fillPercent;

        if (rating >= starValue) {
          fillPercent = 1.0; // full star
        } else if (rating > starValue - 1) {
          // Calculate partial fill for fractional ratings
          fillPercent = rating - (starValue - 1);
        } else {
          fillPercent = 0.0; // empty star
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.sp),
          child: CustomPaint(
            size: Size.square(size),
            painter: StarPainter(
              fillPercent: fillPercent,
              filledColor: filledColor,
              emptyColor: emptyColor.withOpacity(0.3),
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

    // Draw empty star
    canvas.drawPath(starPath, paint);

    // Draw filled portion
    if (fillPercent > 0) {
      canvas.save();
      // Clip to the filled percentage
      Rect clipRect = Rect.fromLTWH(0, 0, size.width * fillPercent, size.height);
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