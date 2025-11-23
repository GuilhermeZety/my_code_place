// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:my_code_place/app/app_module.dart';
import 'package:my_code_place/app/app_widget.dart';
import 'package:my_code_place/app/core/shared/current_session.dart';

void main() async {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();

  await session.initialize();

  runApp(ModularApp(module: AppModule(), child: const AppWidget()));
}

final CurrentSession session = CurrentSession();
