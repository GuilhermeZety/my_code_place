import 'dart:io';

import 'package:flutter/services.dart';

class OverlayUIUtils {
  static void setOverlayStyle({bool barDark = false}) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarIconBrightness:
            (Platform.isAndroid ? barDark : !barDark)
                ? Brightness.dark
                : Brightness.light,
        statusBarBrightness:
            (Platform.isAndroid ? barDark : !barDark)
                ? Brightness.dark
                : Brightness.light,
        systemNavigationBarIconBrightness:
            (Platform.isAndroid ? barDark : !barDark)
                ? Brightness.dark
                : Brightness.light,
      ),
    );
  }
}
