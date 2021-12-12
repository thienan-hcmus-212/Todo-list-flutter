import 'dart:math';

import 'package:calendar/src/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailedEvent extends StatefulWidget {
  const DetailedEvent({
    Key? key,
    required this.event,
  }) : super(key: key);
  final Event event;

  @override
  State<DetailedEvent> createState() => _DetailedEventState();
}

class _DetailedEventState extends State<DetailedEvent> {
  late final Color _colorEvent = getColorTextOfEvent(widget.event);
  late final Event _event = widget.event;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 50,
                    maxWidth: 300,
                  ),
                  child: Text(
                    '${_event.title} ',
                    style: TextStyle(
                        fontSize: 21,
                        color: _colorEvent,
                        decoration: TextDecoration.none),
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                alignment: Alignment.topRight,
                child: Icon(
                  Icons.verified,
                  size: 40,
                  color: _event.isDone ? Colors.greenAccent[700] : Colors.black,
                ),
              ))
            ],
          ),
          Row(
            children: [
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(top: 9),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 90,
                    maxWidth: 240,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 17,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        DateFormat('EEE, MMM d').format(_event.date).toString(),
                        style: TextStyle(
                            fontSize: 17,
                            fontStyle: FontStyle.italic,
                            decoration: TextDecoration.none,
                            color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 24),
                      const Icon(Icons.access_time_rounded, size: 17),
                      const SizedBox(
                        width: 3,
                      ),
                      Text(
                        '${widget.event.date.hour}:${_event.date.minute}',
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 17,
                            decoration: TextDecoration.none,
                            color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.topRight,
                  child: _event.isDone
                      ? Text(
                          "${_event.completeDate!.day}/${_event.completeDate!.month}/${_event.completeDate!.year}",
                          style: TextStyle(
                              fontSize: 12,
                              decoration: TextDecoration.none,
                              color: Colors.greenAccent[700]),
                        )
                      : const Text(
                          "",
                          style: TextStyle(
                            fontSize: 12,
                            decoration: TextDecoration.none,
                          ),
                        ),
                ),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 17),
            alignment: Alignment.centerLeft,
            child: const Text(
              "Description",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  decoration: TextDecoration.none),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(top: 9),
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(width: 1),
            ),
            // color: Colors.blue,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 120,
                maxWidth: MediaQuery.of(context).size.width,
              ),
              child: Text(
                "${getDescriptionOfEvent(_event)} ",
                style:const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    decoration: TextDecoration.none),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomLeft,
            margin: const EdgeInsets.only(top: 12),
            child: Row(
              children: [
                const Icon(
                  Icons.notifications_active_outlined,
                  size: 12,
                ),
                const SizedBox(width: 12),
                Text(
                  getNameOfNotificationEvent(_event.notiBefore),
                  style:const TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.normal,
                      decoration: TextDecoration.none,
                      color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
