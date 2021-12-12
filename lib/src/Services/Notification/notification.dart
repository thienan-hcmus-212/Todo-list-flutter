import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../utils.dart';

Future setScheduleNotification(
    Event event,
    FlutterLocalNotificationsPlugin fltrNotification,
    NotificationDetails generalNotificationDetails) async {
  // var date = tz.TZDateTime.now(tz.local).add(Duration(seconds: 10));
  // fltrNotification.zonedSchedule(0, 'Task', "TestTest", date, generalNotificationDetails, androidAllowWhileIdle: true,uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);

  var rd = Random().nextInt(contentDescriptionNotification.length);

  String getDescription() {
    return (event.description == '')
        ? contentDescriptionNotification[rd]
        : event.description;
  }

  String title = event.title + " ("+getNameOfPriorityEvent(event.priority)+")";

  if (event.date.compareTo(DateTime.now()) > 0) {
    fltrNotification.schedule(
        event.idNoti,
        title,
        getDescription(),
        event.date.subtract(getDurationOfEvent(event)),
        generalNotificationDetails);
  }
}

Future cancelScheduleNotification(
    int id, FlutterLocalNotificationsPlugin fltrNotification) async {
  fltrNotification.cancel(id);
}
