import 'package:flutter/material.dart';

import '../../colors/app_colors.dart';



class CircleWithIcon extends StatelessWidget {
  final Widget child;
  final double height;
  final void Function()? onTap;
  final Color color;
  final bool? enableBorder;
  final EdgeInsetsGeometry? padding;
  const CircleWithIcon({
    super.key,
    required this.height,
    required this.child,
    required this.color,
    this.enableBorder,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: height,
        padding:padding ,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(
                color: enableBorder ?? false
                    ? AppColors.grey93
                    : AppColors.white.withOpacity(0))),
        child: Center(child: child),
      ),
    );
  }
}

class CircleWithIndigoRed extends StatelessWidget {
  final Widget child;
  final double height;
  const CircleWithIndigoRed({
    super.key,
    required this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: height,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.red,
                AppColors.red176,
              ])),
      child: Center(child: child),
    );
  }
}
