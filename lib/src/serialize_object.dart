import 'dart:collection';
import 'dart:math';
import 'utils.dart';
import 'package:table_calendar/table_calendar.dart';

const String sEventText = '<object>';
const String sListText = '<list>';

String jsonStringDateTime(DateTime? date){
  // ngay thang nam gio phut
  // 00 00 0000 00 00
  if (date==null) return 'null';
  return (date.day*pow(10,10)+date.month*pow(10,8)+date.year*pow(10,4)+date.hour*pow(10,2)+date.minute).toString();
}

DateTime getDateTimeFromJsonString(String json){
  late int day,month,year,hour,minute;
  int code = int.parse(json);
  day = (code~/pow(10,10));
  code = code%pow(10,10).round();
  month = (code~/pow(10,8));
  code = code%pow(10,8).round();
  year = (code~/pow(10,4));
  code = code%pow(10,4).round();
  hour = (code~/pow(10,2));
  minute = code%pow(10,2).round();
  return DateTime(year,month,day,hour,minute);
}

String jsonStringPriority(PriorityEvent p){
  switch (p){
    case PriorityEvent.important:
      return '1';
    case PriorityEvent.medium:
      return '2';
    case PriorityEvent.unimportant:
      return '3';
    default:
      return '2';
  }
}
PriorityEvent getPriorityFromJsonString(String json){
  switch (json){
    case '1':
      return PriorityEvent.important;
    case '2':
      return PriorityEvent.medium;
    case '3':
      return PriorityEvent.unimportant;
    default:
      return PriorityEvent.medium;
  }
}

String jsonStringNotificationEvent(NotificationEvent noti){
  switch(noti){
    case NotificationEvent.one_day:
      return '1';
    case NotificationEvent.three_day:
      return '3';
    case NotificationEvent.ten_minutes:
      return '10';
    default:
      return '10';
  }
}

NotificationEvent getNotificationEventFromJsonString(String json){
  switch (json){
    case '1':
      return NotificationEvent.one_day;
    case '3':
      return NotificationEvent.three_day;
    case '10':
      return NotificationEvent.ten_minutes;
    default:
      return NotificationEvent.ten_minutes;
  }
}

String jsonStringListEvent(List<Event> list){
  String json='';
  for(Event e in list ){
    json+=e.toJsonString()+sListText;
  }
  json = json.substring(0,json.length-sListText.length);
  return json;
}

List<Event> getListEventFromJsonString(String json){
  List<Event> list=[];
  if (json=="") return list;
  List<String> listJsonStringEvent = json.split(sListText);
  for (String e in listJsonStringEvent){
    list.add(Event.fromJsonString(e));
  }
  return list;
}

Map<String,dynamic> jsonOfListAllEvent(LinkedHashMap<DateTime,List<Event>> list){
  Map<String,dynamic> result={};
  list.forEach((key, value) { 
    String keyItem = jsonStringDateTime(key);
    String valueItem = jsonStringListEvent(value);
    result[keyItem] = valueItem;
  });
  return result;
}

LinkedHashMap<DateTime,List<Event>> getAllListEventFromJson(Map<String,dynamic> jsonMap){
  var list = LinkedHashMap<DateTime,List<Event>>(
    equals: isSameDay,
    hashCode: getHashCode,
  );
  jsonMap.forEach((key, value) {
    DateTime keyItem = getDateTimeFromJsonString(key);
    List<Event> valueItem = getListEventFromJsonString(value);
    list[keyItem] = valueItem;
  });
  return list;
}
