import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../utils.dart';
import 'package:dotted_border/dotted_border.dart';

class CalendarTable extends StatefulWidget {
  const CalendarTable(
      {Key? key,
      required this.getEventsForDay,
      required this.focusedDay,
      required this.selectedDay,
      required this.onDaySelected,
      required this.isEdit,
      required this.setDoneEvent})
      : super(key: key);

  final List<Event> Function(DateTime) getEventsForDay;
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final Function(DateTime, DateTime) onDaySelected;
  final bool isEdit;
  final Function(Event) setDoneEvent;

  @override
  State<CalendarTable> createState() => _CalendarTableState();
}

class _CalendarTableState extends State<CalendarTable> {
  bool _isDragIn = false;

  Widget tableBuilder(BuildContext context) {
    if (widget.isEdit == true) {
      return Column(
        children: [
          Container(
              margin: const EdgeInsets.all(20),
              height: 90,
              width: MediaQuery.of(context).size.width,
              color: (_isDragIn == false) ? Colors.grey : Colors.blue,
              child: DragTarget<Event>(
                onMove: (details) {
                  setState(() {
                    _isDragIn = true;
                  });
                },
                onLeave: (details) {
                  setState(() {
                    _isDragIn = false;
                  });
                },
                onAccept: (event) {
                  setState(() {
                    widget.setDoneEvent(event);
                    _isDragIn = false;
                  });
                },
                builder: (context, accepted, rejected) {
                  return DottedBorder(
                    color: Colors.black,
                    strokeWidth: 2,
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    dashPattern: const [7, 2, 4, 5],
                    child: const ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(9)),
                      child: Center(
                        child: Text('Drag And Drop Task to Complete Task'),
                      ),
                    ),
                  );
                },
              )),
          Container(
            margin: const EdgeInsets.all(12),
            child: const Icon(
              Icons.upload_file,
              size: 48,
              color: Colors.blue,
            ),
          ),
        ],
      );
    }
    return TableCalendar<Event>(
      firstDay: initFirstDay,
      lastDay: initLastDay,
      focusedDay: widget.focusedDay,
      selectedDayPredicate: (day) => isSameDay(widget.selectedDay, day),
      calendarFormat: CalendarFormat.month,
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
      },
      eventLoader: widget.getEventsForDay,
      onDaySelected: widget.onDaySelected,
      rowHeight: 45,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.all(12),
      height: (widget.isEdit == false) ? 360 : 210,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(9)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: tableBuilder(context),
    );
  }
}
