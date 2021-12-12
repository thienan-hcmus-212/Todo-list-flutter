import 'package:calendar/src/serialize_object.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils.dart';

Future<bool> storeListDoneEvent(List<Event> list) async {
  String jsonList = jsonStringListEvent(list);
  var prefs = await SharedPreferences.getInstance();
  bool result = await prefs.setString(keyListDoneEvent, jsonList);
  return result;
}

Future<List<Event>> getListDoneEvent() async {
  var prefs = await SharedPreferences.getInstance();
  String json = prefs.getString(keyListDoneEvent) ?? "";
  List<Event> result = getListEventFromJsonString(json);
  return result;
}