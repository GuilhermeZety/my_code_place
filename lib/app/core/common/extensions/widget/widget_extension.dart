import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:my_code_place/app/core/common/extensions/color_extension.dart';
import 'package:my_code_place/app/ui/theme/app_colors.dart';

extension Expanding on Widget {
  Widget expanded({int flex = 1}) => Expanded(flex: flex, child: this);

  Widget expandedH({int flex = 1}) => Row(
    children: [Expanded(flex: flex, child: this)],
  );
}

extension Heroic on Widget {
  Widget hero(String? tag) => tag != null ? Hero(tag: tag, child: this) : this;
}

extension Shimmer on Widget {
  Widget shim() => animate(
    onPlay: (controller) => controller.repeat(),
  ).shimmer(duration: 3.seconds, color: AppColors.grey_100.changeOpacity(0.5));
}

extension BasicAnimations on Widget {
  Widget slideFade(
    bool toTop, {
    Duration duration = const Duration(milliseconds: 300),
    double fadeInit = 0,
    double range = 0.2,
    bool active = true,
    Duration delay = const Duration(milliseconds: 300),
  }) => !active
      ? this
      : animate()
            .fade(begin: fadeInit, end: 1, delay: delay, duration: duration)
            .slideY(
              begin: toTop ? range : -range,
              end: 0,
              duration: duration,
            );
}
