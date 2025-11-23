import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:my_code_place/app/core/common/extensions/color_extension.dart';
import 'package:my_code_place/app/ui/theme/app_colors.dart';
import 'package:my_code_place/app/ui/theme/app_fonts.dart';
import 'package:my_code_place/main.dart';
import 'package:signals/signals_flutter.dart';

class AppTheme {
  static final Signal<ThemeMode> themeMode = signal(
    ThemeMode.system,
    debugLabel: 'THEME_MODE',
  );

  static ThemeData get initialTheme {
    ThemeData theme = AppTheme.dark;

    if (themeMode.value == ThemeMode.system) {
      theme = SchedulerBinding.instance.platformDispatcher.platformBrightness == Brightness.dark
          ? dark
          : light;
    }
    if (themeMode.value == ThemeMode.light) {
      theme = light;
    }
    return theme;
  }

  static Future get initialize async {
    try {
      var value = session.prefs.getBool('theme');

      if (value == null) return;
      themeMode.value = value ? ThemeMode.dark : ThemeMode.light;
    } catch (e) {
      themeMode.value = ThemeMode.dark;
    }
  }

  Future changeThemeMode(ThemeMode newTheme) async {
    themeMode.value = newTheme;
    if (newTheme == ThemeMode.system) {
      await session.prefs.remove('theme');
    }
    await session.prefs.setBool('theme', newTheme == ThemeMode.dark);
  }

  static ThemeData dark = ThemeData(
    fontFamily: AppFonts.defaultFont,
    primarySwatch: AppColors.white.toMaterialColor(),
    scaffoldBackgroundColor: AppColors.grey_900,
    canvasColor: AppColors.white,
    primaryColor: AppColors.white,
    cardColor: AppColors.grey_800,
    textSelectionTheme: TextSelectionThemeData(
      selectionHandleColor: AppColors.white,
      cursorColor: AppColors.white,
      selectionColor: AppColors.white.changeOpacity(0.2),
    ),
    textTheme: ThemeData.dark().textTheme.copyWith(
      headlineMedium: AppFonts.headline1,
      headlineSmall: AppFonts.headline2,
      titleMedium: AppFonts.title,
      titleLarge: AppFonts.card,
    ),
  );

  static ThemeData light = ThemeData.light();
}

extension GetThemeData on ThemeMode {
  bool get isDark => this == ThemeMode.dark;
  ThemeData getTheme() => AppTheme.dark;
}
