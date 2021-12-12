import 'dart:collection';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../serialize_object.dart';
import '../../utils.dart';

Future<void> clearAllLocal() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove(keyListAllEvent);
  prefs.remove(keyNotiCountId);
  prefs.remove(keyListDoneEvent);
}

Future<bool> storeListToLocal(
    LinkedHashMap<DateTime, List<Event>> list) async {
  final prefs = await SharedPreferences.getInstance();
  Map<String, dynamic> jsonList = Map.from(jsonOfListAllEvent(list));
  String encodedList = jsonEncode(jsonList);
  bool result = await prefs.setString(keyListAllEvent, encodedList);
  return result;
}

Future<LinkedHashMap<DateTime, List<Event>>> getListFromLocal() async {
  var result = LinkedHashMap<DateTime, List<Event>>(
      equals: isSameDay, hashCode: getHashCode);
  final prefs = await SharedPreferences.getInstance();
  String? encodedList = (prefs.getString(keyListAllEvent));
  if (encodedList != null) {
    Map<String, dynamic> jsonList =
    jsonDecode(encodedList) as Map<String, dynamic>;
    result = getAllListEventFromJson(jsonList);
  }
  return result;
}