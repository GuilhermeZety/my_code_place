import 'package:flutter/widgets.dart';
import 'package:my_code_place/app/core/shared/location_session.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrentSession {
  late SharedPreferences prefs;

  Future getSession(BuildContext context) async {}

  Future initialize() async {
    prefs = await SharedPreferences.getInstance();
    await LocalizationSession.initialize;
  }

  bool get passApresentation => prefs.getBool('passApresentation') ?? false;
  Future setPassApresentation(bool value) => prefs.setBool('passApresentation', value);
}
