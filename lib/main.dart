import 'src/Services/LocalStore/list_done_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/foundation.dart';
import 'dart:collection';

import 'src/Home/home_page.dart';
import 'src/AddTask/add_task.dart';
import 'src/Upcoming/upcoming_page.dart';
import 'src/Notification/notification_page.dart';
import 'src/Done/done_page.dart';
import 'src/utils.dart';
import 'src/Services/LocalStore/notification_id_count.dart';
import 'src/Services/LocalStore/list_all_event.dart';
import 'src/Services/Notification/notification.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tig Tig',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyRootApp(),
    );
  }
}

class MyRootApp extends StatefulWidget {
  const MyRootApp({Key? key}) : super(key: key);
  @override
  State<MyRootApp> createState() => _MyRootAppState();
}

class LifecycleEventHandler extends WidgetsBindingObserver {
  LifecycleEventHandler({
    required this.suspendingCallBack,
  });

  final AsyncCallback suspendingCallBack;

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        await suspendingCallBack();
        break;
    }
  }
}

class _MyRootAppState extends State<MyRootApp> {
  int _selectedIndex = 0;

  List<Event> a = [];
  late ValueNotifier<List<Event>> _listDoneEvent = ValueNotifier(a);
  var _listAllEvent = LinkedHashMap<DateTime, List<Event>>(
      equals: isSameDay, hashCode: getHashCode)
    ..addAll({});
  late ValueNotifier<List<Event>> _selectedEvents =
      ValueNotifier(getEventsForDay(_selectedDay, _listAllEvent));
  DateTime _selectedDay = DateTime.now();

  late FlutterLocalNotificationsPlugin fltrNotification;
  late NotificationDetails generalNotificationDetails;
  late int _notiCountId;

  void notificationSelected(String? payload) async {
    if (payload != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NotificationPage(),
          ));
    }
  }

  void _deleteItemDoneList(Event event) {
    setState(() {
      _listDoneEvent.value.remove(event);
      storeListDoneEvent(_listDoneEvent.value);
    });
  }
  void _restoreItemDoneList(Event event){
    Event newEvent = Event(event.title, event.date, event.description, event.priority, event.notiBefore);
    _createTask(newEvent);
    _deleteItemDoneList(event);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // clearAllLocal();

    //init notification
    var androidInitilize = const AndroidInitializationSettings('app_icon');
    var iOSinitilize = const IOSInitializationSettings();
    var initilizationsSettings =
        InitializationSettings(android: androidInitilize, iOS: iOSinitilize);
    fltrNotification = FlutterLocalNotificationsPlugin();
    fltrNotification.initialize(initilizationsSettings,
        onSelectNotification: notificationSelected);

    var androidDetails = const AndroidNotificationDetails('id', 'hcmus', importance: Importance.max, color:Colors.black38 );
    var iosDetails = const IOSNotificationDetails();
    generalNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    //init notification

    WidgetsBinding.instance!.addObserver(LifecycleEventHandler(
      suspendingCallBack: () async => storeListToLocal(_listAllEvent),
    ));

    // get list Map
    var list = LinkedHashMap<DateTime, List<Event>>(
        equals: isSameDay, hashCode: getHashCode);
    getListFromLocal().then((localList) {
      setState(() {
        list.addAll(localList);
        _listAllEvent = list;
        _selectedEvents =
            ValueNotifier(getEventsForDay(_selectedDay, _listAllEvent));
      });
    });

    // get NotiCountID
    getNotiCountId().then((value) {
      setState(() {
        _notiCountId = value;
      });
    });

    // get List done event
    getListDoneEvent().then((value){
      setState(() {
        _listDoneEvent = ValueNotifier(value);
      });
    });
  }

  void _onDaySelected(DateTime date) {
    setState(() {
      _selectedDay = date;
      _selectedEvents.value = getEventsForDay(date, _listAllEvent);
    });
  }

  void _setDoneEvent(Event event) {
    setState(() {
      List<Event> listEventForSelectedDay = _listAllEvent[event.date] ?? [];

      int ind = -1;
      for (Event element in listEventForSelectedDay) {
        if (element.id == event.id) {
          element.setDone();
          ind = listEventForSelectedDay.indexOf(element);
        }
      }
      cancelScheduleNotification(listEventForSelectedDay[ind].idNoti,fltrNotification);
      _listDoneEvent.value.add(listEventForSelectedDay[ind]);
      storeListDoneEvent(_listDoneEvent.value);

      listEventForSelectedDay.removeAt(ind);
      if (listEventForSelectedDay.isEmpty){
        _listAllEvent.remove(event.date);
      }
      else{
        _listAllEvent[event.date] = List.from(listEventForSelectedDay);
      }

      _selectedEvents.value = getEventsForDay(_selectedDay, _listAllEvent);
      storeListToLocal(_listAllEvent);
    });
  }

  void _createTask(Event event) {
    setState(() {
      if (_listAllEvent.containsKey(event.date) == false) {
        _listAllEvent.addAll({event.date: []});
      }
      List<Event>? list = _listAllEvent[event.date];

      event.idNoti = _notiCountId;
      setState(() {
        _notiCountId += 1;
        storeNotiCountId(_notiCountId);
      });
      setScheduleNotification(event,fltrNotification,generalNotificationDetails);

      list?.add(event);
      _selectedEvents.value = getEventsForDay(_selectedDay, _listAllEvent);
      storeListToLocal(_listAllEvent);
    });
  }

  void _deleteEvent(Event event){
    _setDoneEvent(event);
    _deleteItemDoneList(event);
  }

  void _onAddEvent(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddTask(
                  selectedDay: _selectedDay,
                  createTask: _createTask,
                )));
  }

  Widget _selectedScreen(int index) {
    switch (index) {
      case 0:
        return HomePage(
          listAllEvent: _listAllEvent,
          selectedDay: _selectedDay,
          selectedEvents: _selectedEvents,
          setDoneEvent: _setDoneEvent,
          onDaySelected: _onDaySelected,
          deleteEvent: _deleteEvent,
        );
      // case 1:
      //   return const UpcomingPage();
      // case 2:
      //   return const NotificationPage();
      case 1:
        return DonePage(
          listDoneEvent: _listDoneEvent,
          deleteItem: _deleteItemDoneList,
          restoreItem: _restoreItemDoneList,
        );
      default:
        return HomePage(
          listAllEvent: _listAllEvent,
          selectedDay: _selectedDay,
          selectedEvents: _selectedEvents,
          setDoneEvent: _setDoneEvent,
          onDaySelected: _onDaySelected,
          deleteEvent: _deleteEvent,
        );
    }
  }

  void _onPageTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: _selectedScreen(_selectedIndex),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black,
            blurRadius: 10,
          ),
        ]),
        child: BottomNavigationBar(
          elevation: 10,
          type: BottomNavigationBarType.fixed,
          onTap: _onPageTap,
          currentIndex: _selectedIndex,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.view_module),
              label: 'All',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.calendar_today_rounded),
            //   label: 'Upcoming',
            // ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.circle_notifications),
            //   label: 'Notification',
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.task_alt),
              label: 'Done',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onAddEvent(context),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
