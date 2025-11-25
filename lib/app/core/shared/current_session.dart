import 'package:my_code_place/app/core/shared/location_session.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrentSession {
  late SharedPreferences prefs;

  Future initialize() async {
    prefs = await SharedPreferences.getInstance();
    await LocalizationSession.initialize;
  }
}
