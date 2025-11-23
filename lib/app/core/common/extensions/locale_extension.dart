import 'dart:ui';

import 'package:localization/localization.dart';

extension LocaleStringExtension on String {
  String get t => i18n();

  String translate(List<String> args) => i18n(args);
}

extension LocaleExtension on Locale {
  String getLanguageName() {
    switch (languageCode) {
      case 'pt':
        return 'Português';
      case 'es':
        return 'Español';
      case 'en':
        return 'English';
      default:
        return 'Unknown';
    }
  }
}
