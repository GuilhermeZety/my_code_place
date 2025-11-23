import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:localization/localization.dart';
import 'package:my_code_place/app/core/shared/location_session.dart';
import 'package:my_code_place/app/ui/theme/app_theme.dart';
import 'package:signals/signals_flutter.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> with SignalsMixin {
  @override
  void initState() {
    // OverlayUIUtils.setOverlayStyle(barDark: AppTheme.themeMode.value.isDark);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LocalJsonLocalization.delegate.directories = ['assets/translations/'];

    return ThemeProvider(
      initTheme: AppTheme.themeMode.value.getTheme(),
      builder: (context, myTheme) {
        return MaterialApp.router(
          title: 'My Code Place',
          localizationsDelegates: LocalizationSession.delegates,
          supportedLocales: LocalizationSession.suportedLocales.map(
            (e) => Locale(e.$1, e.$2),
          ),
          locale: LocalizationSession.locale.watch(context),
          theme: myTheme,
          debugShowCheckedModeBanner: false,
          routerDelegate: Modular.routerDelegate,
          routeInformationParser: Modular.routeInformationParser,
        );
      },
    );
  }
}
