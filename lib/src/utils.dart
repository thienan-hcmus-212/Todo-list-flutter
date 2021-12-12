import 'dart:collection';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'Common/detailed_event.dart';
import 'serialize_object.dart';

const String keyListDoneEvent = 'listdoneevent';
const String keyListAllEvent = 'listallevent';
const String keyNotiCountId = 'noticountid';
enum PriorityEvent { important, medium, unimportant }
enum NotificationEvent { ten_minutes, one_day, three_day }

class Event {
  static int countEvent = 0;
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final PriorityEvent priority;
  final NotificationEvent notiBefore;
  int idNoti;
  bool isDone;
  DateTime? completeDate;
  Event._(this.id, this.title, this.description, this.date, this.priority,
      this.notiBefore, this.isDone, this.idNoti, this.completeDate);
  factory Event(String title, DateTime date, String description,
      PriorityEvent priority, NotificationEvent notiBefore) {
    String id = 'Event$countEvent';
    bool isDone = false;
    countEvent++;
    return Event._(
        id, title, description, date, priority, notiBefore, isDone, -1, null);
  }
  factory Event.fromJsonString(String json) {
    List<String> object = json.split(sEventText);
    String id = 'Event$countEvent';
    String title = object[0];
    String description = object[1];
    DateTime date = getDateTimeFromJsonString(object[2]);
    PriorityEvent priority = getPriorityFromJsonString(object[3]);
    NotificationEvent notiBefore =
        getNotificationEventFromJsonString(object[4]);
    bool isDone = (object[5]=='false')?false:true;
    int idNoti = int.parse(object[6]);
    DateTime? completeDate;
    if (object[7] != 'null') {
      completeDate = getDateTimeFromJsonString(object[7]);
    }
    countEvent++;
    return Event._(id, title, description, date, priority, notiBefore, isDone,
        idNoti, completeDate);
  }

  @override
  String toString() {
    // TODO: implement toString
    return title +
        '/' +
        description +
        "/" +
        date.toString() +
        "/" +
        priority.toString() +
        "/" +
        notiBefore.toString() +
        "/" +
        isDone.toString() +
        "/" +
        idNoti.toString();
  }

  void setDone() {
    isDone = true;
    completeDate = DateTime.now();
  }

  String toJsonString() {
    String json = '';
    json += title +
        sEventText +
        description +
        sEventText +
        jsonStringDateTime(date) +
        sEventText +
        jsonStringPriority(priority) +
        sEventText +
        jsonStringNotificationEvent(notiBefore) +
        sEventText +
        isDone.toString() +
        sEventText +
        idNoti.toString() +
        sEventText +
        jsonStringDateTime(completeDate);
    ;
    return json;
  }
}

int getHashCode(DateTime key) =>
    key.day * 1000000 + key.month * 10000 + key.year;

//
String getDescriptionOfDay(DateTime? selectedDay) {
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  late int day;
  if (selectedDay != null) {
    int hour =
        today.difference(selectedDay).inHours + 7; //begin of day is 7h AM
    day = (hour / 24).round();
  }
  if (day == 0) {
    return "Today";
  }
  if (day == 1) {
    return "Yesterday";
  }
  if (day == -1) {
    return "Tomorrow";
  }
  if (day < -1) {
    return "${-day} day left";
  }
  if (day > 1) {
    return "$day day ago";
  }
  return "None";
}

// setup for Calendar
final initToday = DateTime.now();
final initFirstDay =
    DateTime(initToday.year, initToday.month - 3, initToday.day);
final initLastDay =
    DateTime(initToday.year + 1, initToday.month, initToday.day);

extension DateTimeExtension on DateTime {
  DateTime applied(TimeOfDay time) {
    return DateTime(year, month, day, time.hour, time.minute);
  }
}

List<Event> getEventsForDay(
    DateTime day, LinkedHashMap<DateTime, List<Event>> list) {
  // Implementation example
  List<Event> listForDay = list[day] ?? [];
  List<Event> result = listForDay.where((event) => (!event.isDone)).toList();
  return result;
}

String getNameOfPriorityEvent(PriorityEvent priorityEvent) {
  switch (priorityEvent) {
    case PriorityEvent.important:
      return 'IMPORTANT';
    case PriorityEvent.unimportant:
      return 'UNIMPORTANT';
    default:
      return 'MEDIUM';
  }
}

String getNameOfNotificationEvent(NotificationEvent noti) {
  switch (noti) {
    case NotificationEvent.one_day:
      return "Notify 1 day earlier";
    case NotificationEvent.ten_minutes:
      return "Notify 10 minutes earlier";
    case NotificationEvent.three_day:
      return "Notify 3 days earlier";
    default:
      return "Notify 10 minutes earlier";
  }
}

Widget getIconOfPriorityEvent(PriorityEvent priorityEvent) {
  switch (priorityEvent) {
    case PriorityEvent.important:
      return const Icon(
        Icons.looks_one_sharp,
        color: Colors.red,
      );
    case PriorityEvent.medium:
      return const Icon(
        Icons.looks_two_sharp,
        color: Colors.orange,
      );
    case PriorityEvent.unimportant:
      return const Icon(
        Icons.looks_3_sharp,
        color: Colors.blue,
      );
    default:
      return const Icon(
        Icons.looks_two_sharp,
        color: Colors.orange,
      );
  }
}

Duration getDurationOfEvent(Event e) {
  switch (e.notiBefore) {
    case NotificationEvent.one_day:
      return const Duration(days: 1);
    case NotificationEvent.ten_minutes:
      return const Duration(minutes: 10);
    case NotificationEvent.three_day:
      return const Duration(days: 3);
    default:
      return const Duration(minutes: 10);
  }
}

List<String> contentDescriptionNotification = [
  "Mưu cao chẳng bằng chí dày",
  "Thiên tài 1% là cảm hứng và 99% là mồ hôi",
  "Cơ hội không tự xảy đến, bạn tạo ra chúng",
  "Trên con đường thành công, không có dấu chân của kẻ lười biếng",
  "Tương lai được mua bằng hiện tại",
  "Vấn đề ở chỗ bạn nghĩ rằng bạn có thời gian",
  "Việc hôm nay chớ để ngày mai",
  "Cố gắng và hối hận, cái nào đau đớn hơn?"
];

class SectionListItem<T> {
  final bool isHeadingTitle;
  String? title;
  T? value;
  SectionListItem._(this.isHeadingTitle, this.title, this.value);
  factory SectionListItem.createHeading(String title) {
    return SectionListItem._(true, title, null);
  }
  factory SectionListItem.createItem(T value) {
    return SectionListItem._(false, null, value);
  }
}

void showDialogMoreInfoOfEvent(Event event, BuildContext context) {
  showGeneralDialog(
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 500),
    context: context,
    pageBuilder: (_, __, ___) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 327,
          width: MediaQuery.of(context).size.width-30,
          child: DetailedEvent(
            event: event,
          ),
          margin: EdgeInsets.only(bottom: 54, left: 12, right: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(27),
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return SlideTransition(
        position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
        child: child,
      );
    },
  );
}

void showDialogDeleteItem(
    Event event, BuildContext context, Function(Event) func) {
  showDialog<String>(
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    context: context,
    builder: (BuildContext context) => AlertDialog(
      // title: const Text('Notification'),
      content: const Text('Do you want to delete this task from your app? '),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () {
            func(event);
            Navigator.pop(context, 'OK');
          },
          child: const Text('Yes'),
        ),
      ],
    ),
  );
}

Color getColorTextOfEvent(Event event){
  switch (event.priority){
    case PriorityEvent.important:
      return Colors.red;
    case PriorityEvent.medium:
      return Colors.orange;
    case PriorityEvent.unimportant:
      return Colors.blue;
    default:
      return Colors.black;
  }
}

String getDescriptionOfEvent(Event event){
  var rd = Random().nextInt(contentDescriptionNotification.length);
  return (event.description == '')
      ? contentDescriptionNotification[rd]
      : event.description;
}
