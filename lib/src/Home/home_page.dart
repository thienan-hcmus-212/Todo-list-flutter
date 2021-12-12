import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../utils.dart';
import 'calendar_table.dart';
import 'events_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key,
    required this.listAllEvent,
    required this.selectedDay,
    required this.selectedEvents,
    required this.setDoneEvent,
    required this.onDaySelected,
    required this.deleteEvent
  }) : super(key: key);

  final LinkedHashMap<DateTime, List<Event>> listAllEvent;

  final DateTime selectedDay;
  final ValueNotifier<List<Event>> selectedEvents;

  final Function(Event) setDoneEvent;
  final Function(DateTime) onDaySelected;

  final Function(Event) deleteEvent;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _focusedDay = DateTime.now();
  late DateTime _selectedDay = widget.selectedDay;

  bool _isEdit =false;


  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      widget.onDaySelected(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: Column(
        children: <Widget>[
          CalendarTable(
            getEventsForDay: (date)=>getEventsForDay(date,widget.listAllEvent),
            focusedDay: _focusedDay,
            selectedDay: _selectedDay,
            onDaySelected: _onDaySelected,
            isEdit: _isEdit,
            setDoneEvent: widget.setDoneEvent,
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    getDescriptionOfDay(_selectedDay),
                    style: const TextStyle(fontSize: 17, fontStyle: FontStyle.italic),
                  ),
                Container(
                  child: Row(
                    children: [
                      const Text('Edit: ',
                        style: TextStyle(fontSize: 17, fontStyle: FontStyle.italic),
                      ),
                      TextButton(
                        onPressed: (){
                          setState(() {
                            _isEdit = !_isEdit;
                          });
                        },
                        child: (_isEdit==true)? Text('Enable'): Text('Disable'),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: EventsList(
              selectedEvents: widget.selectedEvents,
              isEdit: _isEdit,
              deleteItem: widget.deleteEvent,
            ),
          ),
        ],
      ),
    );
  }
}
