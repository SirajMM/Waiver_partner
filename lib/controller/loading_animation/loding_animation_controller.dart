
import 'dart:math' as math show sin, pi;

import 'package:flutter/animation.dart';
import 'package:get/get.dart';

class LoadingBarsAnimationController extends GetxController
    with GetSingleTickerProviderStateMixin {
  @override
  void onClose() {
    offsetController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    offsetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
  }

  @override
  void dispose() {
    offsetController.dispose();
    super.dispose();
  }

  late AnimationController offsetController;
}

class LoadingDotAnimationController extends GetxController
    with GetSingleTickerProviderStateMixin {
  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000))
      ..repeat();
  }

  late AnimationController controller;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class DelayTween extends Tween<double> {
  DelayTween({double? begin, double? end, required this.delay})
      : super(begin: begin, end: end);

  final double delay;

  @override
  double lerp(double t) =>
      super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}
