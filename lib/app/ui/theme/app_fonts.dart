import 'package:flutter/material.dart';
import 'package:my_code_place/app/ui/theme/app_colors.dart';

class AppFonts {
  static String defaultFont = 'Outfit';

  static const FontWeight extraLight = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semibold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extrabold = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;

  static const TextStyle headline1 = TextStyle(
    color: AppColors.white,
    fontWeight: semibold,
    fontSize: 24,
  );
  static const TextStyle headline2 = TextStyle(
    color: AppColors.white,
    fontWeight: light,
    fontSize: 24,
  );
  static const TextStyle title = TextStyle(
    color: AppColors.white,
    fontWeight: medium,
    letterSpacing: 0.3,
    fontSize: 16,
  );
  static const TextStyle card = TextStyle(
    color: AppColors.white,
    fontWeight: semibold,
    fontSize: 20,
  );
}
