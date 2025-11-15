// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:my_code_place/app/app_widget.dart';

void main() {
  usePathUrlStrategy();
  runApp(const AppWidget());
}
