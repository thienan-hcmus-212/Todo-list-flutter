import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils.dart';

class ItemEvent extends StatelessWidget {
  const ItemEvent(
      {Key? key,
      required this.event,
      @required this.rightButton,
      @required this.onRightButtonPress})
      : super(key: key);

  final Event event;
  final Widget? rightButton;
  final Function(Event)? onRightButtonPress;

  Widget _getIconEvent(Event event) {
    if (event.priority == PriorityEvent.important) {
      return Icon(
        Icons.looks_one_sharp,
        color: getColorTextOfEvent(event),
        size: 36,
      );
    }
    if (event.priority == PriorityEvent.medium) {
      return Icon(
        Icons.looks_two_sharp,
        color: getColorTextOfEvent(event),
        size: 36,
      );
    }
    return Icon(
      Icons.looks_3_sharp,
      color: getColorTextOfEvent(event),
      size: 36,
    );
  }

  Widget _getRightButton(Event event) {
    if (rightButton != null) {
      return Expanded(
        child: Container(
          alignment: Alignment.centerRight,
          child: rightButton
        )
      );
    }
    return const Expanded(
        child: SizedBox(
      width: 12,
    ));
  }

  final int maxLengthTitleShow = 21;
  String showSubString(String s) {
    if (s.length < maxLengthTitleShow) {
      return s;
    } else {
      return s.substring(0, maxLengthTitleShow) + "...";
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: [
        _getIconEvent(event),
        Container(
          height: 48,
          margin: const EdgeInsets.symmetric(vertical: 9, horizontal: 12),
          decoration: BoxDecoration(
              border: Border.all(width: 1, style: BorderStyle.solid)),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              showSubString(event.title),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 21,
              ),
            ),
            const SizedBox(height: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  size: 17,
                ),
                const SizedBox(width: 3),
                Text(
                  '${event.date.hour}:${event.date.minute}',
                  style: const TextStyle(
                      fontStyle: FontStyle.italic, fontSize: 17),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.calendar_today_outlined, size: 17),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  DateFormat('EEE, MMM d').format(event.date).toString(),
                  style: const TextStyle(
                      fontSize: 17, fontStyle: FontStyle.italic),
                )
              ],
            ),
          ],
        ),
        _getRightButton(event),
      ],
    );
  }
}
