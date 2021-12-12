import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key,
    required this.selectedDay,
    required this.createTask,
  }) : super(key: key);

  final DateTime selectedDay;
  final Function(Event) createTask;
  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _title;
  late TextEditingController _description;
  late DateTime _selectedDate = widget.selectedDay;
  late TimeOfDay _selectedTime = TimeOfDay.fromDateTime(widget.selectedDay);
  late PriorityEvent _priority = PriorityEvent.medium;
  late NotificationEvent _notiBefore = NotificationEvent.ten_minutes;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController();
    _description = TextEditingController();

  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  void _showDatePicker(BuildContext context) {
    showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: initFirstDay,
        lastDate: initLastDay
    ).then((value){
      setState(() {
        _selectedDate = value ?? _selectedDate;
      });
    });
  }

  void _showTimePicker(BuildContext context){
    showTimePicker(
        context: context,
        initialTime: _selectedTime,
        builder: (context, _) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                // Using 24-Hour format
                  alwaysUse24HourFormat: true),
              // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
              child: _!);
        }
    ).then((value){
      setState(() {
        _selectedTime = value??_selectedTime;
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Task'),
      ),
      body: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(9),
            child: Column(
              children: [
                TextFormField(
                  controller: _title,
                  decoration: const InputDecoration(
                    hintText: 'Enter Title',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _description,
                  decoration: const InputDecoration(
                    hintText: 'Enter Description',
                  ),
                ),
                Row(
                  children: [
                    const Expanded(
                        flex: 3,
                        child: Icon(Icons.calendar_today_rounded)
                    ),
                    Expanded(
                        flex: 7,
                        child: InkWell(
                          onTap: () => _showDatePicker(context),
                          child: Container(
                            padding: const EdgeInsets.all(9),
                            margin: const EdgeInsets.fromLTRB(9,9,9,0),
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1.0,
                                        color: Colors.grey
                                    )
                                )
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  DateFormat('EEE, d MMM y').format(_selectedDate).toString()
                              ),
                            ),
                          ),
                        )
                    )
                  ],
                ),
                Row(
                  children: [
                    const Expanded(
                        flex: 3,
                        child: Icon(Icons.access_time)
                    ),
                    Expanded(
                        flex: 7,
                        child: InkWell(
                          onTap: ()=>_showTimePicker(context),
                          child: Container(
                            padding: const EdgeInsets.all(9),
                            margin: const EdgeInsets.fromLTRB(9,9,9,0),
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1.0,
                                        color: Colors.grey
                                    )
                                )
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${_selectedTime.hour}:${_selectedTime.minute}'
                              ),
                            ),
                          ),
                        )
                    )
                  ],
                ),
                Row(
                  children: [
                    const Expanded(
                      flex: 3,
                        child: Icon(Icons.flag_outlined)
                    ),
                    Expanded(
                      flex:  7,
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(9,9,9,0),
                          child: DropdownButton<PriorityEvent>(
                            value: _priority,
                            elevation: 16,
                            style: const TextStyle(color: Colors.black),
                            underline: Container(
                              height: 2,
                              color: Colors.grey,
                            ),
                            onChanged: (PriorityEvent? priority){
                              setState(() {
                                _priority = priority!;
                              });
                            },
                            items: <PriorityEvent>[PriorityEvent.important,PriorityEvent.medium,PriorityEvent.unimportant]
                                .map((e){
                              return DropdownMenuItem(
                                value: e,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(getNameOfPriorityEvent(e)),
                                    getIconOfPriorityEvent(e)
                                  ],
                                )

                              );
                            }).toList(),

                          ),
                        )
                    )
                  ],
                ),
                Row(
                  children: [
                    const Expanded(
                        flex: 3,
                        child: Icon(Icons.circle_notifications_outlined)
                    ),
                    Expanded(
                        flex:  7,
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(9,9,9,0),
                          child: DropdownButton<NotificationEvent>(
                            value: _notiBefore,
                            elevation: 16,
                            style: const TextStyle(color: Colors.black),
                            underline: Container(
                              height: 2,
                              color: Colors.grey,
                            ),
                            onChanged: (NotificationEvent? notiBefore){
                              setState(() {
                                _notiBefore = notiBefore!;
                              });
                            },
                            items: <NotificationEvent>[NotificationEvent.ten_minutes,NotificationEvent.one_day,NotificationEvent.three_day]
                                .map((e){
                              return DropdownMenuItem(
                                value: e,
                                child: Text(getNameOfNotificationEvent(e)),
                              );
                            }).toList(),

                          ),
                        )
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Validate will return true if the form is valid, or false if
                      // the form is invalid.
                      if (_formKey.currentState!.validate()) {
                        // Process data.
                        String title=_title.value.text;
                        String description= _description.value.text;
                        DateTime date = _selectedDate.applied(_selectedTime);
                        PriorityEvent priority = _priority;
                        NotificationEvent notiBefore = _notiBefore;
                        Event event = Event(title, date, description, priority,notiBefore);
                        widget.createTask(event);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
