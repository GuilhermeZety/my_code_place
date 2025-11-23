import 'package:flutter/material.dart';

extension ContextUtils on BuildContext {
  Size get _size => MediaQuery.sizeOf(this);
  double get width => _size.width;
  double get height => _size.height;

  bool get isMobile => _size.shortestSide < 600;
  bool get isTablet => _size.shortestSide >= 600 && _size.shortestSide < 900;
  bool get isDesktop => _size.shortestSide >= 900;

  MediaQueryData get mq => MediaQuery.of(this);
  EdgeInsets get safeArea => MediaQuery.paddingOf(this);
  bool get isLandscape => mq.orientation == Orientation.landscape;

  /// Returns fraction (0-1) of screen width
  double widthFraction(double fraction) => fraction * width;

  /// Returns fraction (0-1) of screen height
  double heightFraction(double fraction) => fraction * height;
}

extension ThemeUtils on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;

  bool get isDark => colorScheme.brightness == Brightness.dark;
}

extension KeyboardExtension on BuildContext {
  bool get isKeyboardOpen => MediaQuery.viewInsetsOf(this).bottom > 0;
  double get bottomHeight => MediaQuery.viewInsetsOf(this).bottom;
}
