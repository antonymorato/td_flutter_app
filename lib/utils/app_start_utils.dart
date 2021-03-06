import 'package:shared_preferences/shared_preferences.dart';

class AppStartUtils {
  static Future<void> refreshFirstTimeStart() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('first_time', true);
  }

  static Future<bool> isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    var isFirstTime = prefs.getBool('first_time');
    if (isFirstTime != null && !isFirstTime) {
      prefs.setBool('first_time', false);
      return false;
    } else {
      prefs.setBool('first_time', false);
      return true;
    }
  }
}
