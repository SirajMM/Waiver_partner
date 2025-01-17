import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppCountDown extends StatelessWidget {
  final DateTime endDate;
  final String? text;
  final TextStyle? style;
  final void Function()? onEnd;
  const AppCountDown(
      {super.key, required this.endDate, this.onEnd, this.style, this.text});
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
        onEnd: onEnd,
        tween: Tween(
          begin: endDate.difference(DateTime.now()),
          end: Duration.zero,
        ),
        duration: endDate.difference(DateTime.now()),
        builder: (context, Duration date, child) {
          return Text(
            "${text ?? ""}${date.inSeconds}",
            textAlign: TextAlign.center,
            style: style ??
                TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
          );
        });
  }
}
