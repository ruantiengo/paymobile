import 'package:shared_preferences/shared_preferences.dart';

Future<bool> isTokenValid() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final expirationDateStr = prefs.getString('expirationDate');

  if (token == null || expirationDateStr == null) {
    return false;
  }

  final expirationDate = DateTime.parse(expirationDateStr);
  if (DateTime.now().isAfter(expirationDate)) {
    return false;
  }

  return true;
}
