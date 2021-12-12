import 'package:shared_preferences/shared_preferences.dart';
import '../../utils.dart';

Future<bool> storeNotiCountId(int count) async {
  var prefs = await SharedPreferences.getInstance();
  bool result = await prefs.setInt(keyNotiCountId, count);
  return result;
}

Future<int> getNotiCountId() async {
  var prefs = await SharedPreferences.getInstance();
  int result = prefs.getInt(keyNotiCountId) ?? 0;
  return result;
}