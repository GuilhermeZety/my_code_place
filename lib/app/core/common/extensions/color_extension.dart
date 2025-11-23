import 'package:flutter/material.dart';

extension ColorUtils on Color {
  Color darken(double amount) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final darkenedHsl = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return darkenedHsl.toColor();
  }

  Color lighten(double amount) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final lightenedHsl = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return lightenedHsl.toColor();
  }

  Color changeOpacity(double amount) {
    return withValues(alpha: amount);
  }
}

extension ToWidgetStateProperty on Color {
  WidgetStateProperty<Color?>? toWidgetStateProperty() {
    return WidgetStateProperty.all<Color?>(this);
  }
}

extension ToMaterialColor on Color {
  MaterialColor toMaterialColor() {
    final color = this;

    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final double r = color.r, g = color.g, b = color.b;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        (r + ((ds < 0 ? r : (255 - r)) * ds)).round(),
        (g + ((ds < 0 ? g : (255 - g)) * ds)).round(),
        (b + ((ds < 0 ? b : (255 - b)) * ds)).round(),
        1,
      );
    }
    return MaterialColor(color.r.round(), swatch);
  }
}
