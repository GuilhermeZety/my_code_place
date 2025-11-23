import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';
import 'package:signals/signals_flutter.dart';

class LocalizationSession {
  static late FlutterSignal<Locale> locale;

  static Future get initialize async {
    locale = signal(const Locale('pt', 'BR'), debugLabel: 'LOCALE');
  }

  static final List<(String, String)> suportedLocales = [
    ('en', 'US'),
    ('pt', 'BR'),
    ('es', 'ES'),
  ];

  static Iterable<LocalizationsDelegate<dynamic>> get delegates => [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    LocalJsonLocalization.delegate,
  ];

  static void switchLocale(dynamic session) {
    switch (locale.value.languageCode) {
      case 'pt':
        locale.value = const Locale('en', 'US');
        break;
      case 'en':
        locale.value = const Locale('es', 'ES');
        break;
      case 'es':
        locale.value = const Locale('pt', 'BR');
        break;
    }
    session.prefs.setString(
      'localization',
      locale.value.languageCode.substring(0, 2),
    );
  }
}
