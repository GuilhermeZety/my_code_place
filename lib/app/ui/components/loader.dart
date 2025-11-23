import 'package:flutter/material.dart';
import 'package:my_code_place/app/ui/theme/app_colors.dart';

class Loader extends StatelessWidget {
  const Loader({super.key, this.size, this.strokeWidth});

  final double? size;
  final double? strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size ?? 30,
      width: size ?? 30,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        strokeCap: StrokeCap.round,
        color: AppColors.white,
        backgroundColor: AppColors.grey_100,
      ),
    );
  }
}
