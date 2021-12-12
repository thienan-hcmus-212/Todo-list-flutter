import 'package:calendar/src/Common/item_event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils.dart';
import 'package:table_calendar/table_calendar.dart';

class DonePage extends StatefulWidget {
  const DonePage({Key? key,
    required this.listDoneEvent,
    required this.deleteItem,
    required this.restoreItem

  }):super(key: key);

  final ValueNotifier<List<Event>> listDoneEvent;
  final Function(Event) deleteItem;
  final Function(Event) restoreItem;

  @override
  State<DonePage> createState() => _DonePageSate();
}

class _DonePageSate extends State<DonePage> {
  late List<SectionListItem<Event>> _listItem = [];

  String getNameOfDate(DateTime date) {
    String name = DateFormat.yMMMMd('en_US').format(date).toString();
    return (isSameDay(date,DateTime.now()))?'Today':name;
  }

  int dateCompare(DateTime? a,DateTime? b){
    if (a==null || b==null) return -1;
    int? result = a.compareTo(b);
    return -result;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List<Event> list = widget.listDoneEvent.value;
    list.sort((Event a, Event b) => dateCompare(a.completeDate, b.completeDate));

    if (list.isNotEmpty) {
      late SectionListItem<Event> item;

      DateTime present = list[0].date;
      item = SectionListItem.createHeading(getNameOfDate(present));
      _listItem.add(item);
      for (int i = 0; i < list.length; i++) {
        if (!isSameDay(present, list[i].date)) {
          present = list[i].date;
          item = SectionListItem.createHeading(getNameOfDate(present));
          _listItem.add(item);
        }
        item = SectionListItem.createItem(list[i]);
        _listItem.add(item);
      }
    }
  }

  void _rightIconPress(SectionListItem<Event> item){
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        // title: const Text('Notification'),
        content: const Text('Do you want to restore this task to the uncompleted task? '),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _listItem.remove(item);
              });
              widget.restoreItem(item.value!);
              Navigator.pop(context,'OK');
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  Widget _rightIconShow(SectionListItem<Event> item) {
    return Material(
      child: InkWell(
        onTap: () => _rightIconPress(item),
        child: const Icon(
          Icons.restore,
          size: 39,
        ),
      ),
    );
  }

  void _onLongPressItem(SectionListItem<Event> item) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        // title: const Text('Notification'),
        content: const Text('Do you want to remove this task from your app? '),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _listItem.remove(item);
              });
              widget.deleteItem(item.value!);
              Navigator.pop(context,'OK');
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _onPress(SectionListItem<Event> item,BuildContext context) {
    showDialogMoreInfoOfEvent(item.value!,context);
  }

  Widget _itemEventShow(SectionListItem<Event> item) {
    return Container(
        margin: const EdgeInsets.all(12),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 12,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(9)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Material(
          child: InkWell(
              onLongPress: () => _onLongPressItem(item),
              onTap: () => _onPress(item,context),
              child: ItemEvent(
                event: item.value!,
                rightButton: _rightIconShow(item),
              )),
        ));
  }

  Widget _itemBuilder(BuildContext context, SectionListItem<Event> item) {
    if (item.isHeadingTitle == true) {
      return Container(
        margin: const EdgeInsets.all(12),
        child: Center(
          child: Text(
            item.title!,
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.grey,
              fontSize: 17,
            ),
          ),
        ),
      );
    } else {
      return _itemEventShow(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: const Text("Done")),
      body: Container(
        child: ValueListenableBuilder<List<Event>>(
          valueListenable: widget.listDoneEvent,
          builder: (context,value,_) => ListView.builder(
            padding: const EdgeInsets.all(9),
            itemCount: _listItem.length,
            itemBuilder: (context, index) =>
                _itemBuilder(context, _listItem[index]),
          ),
        )
      ),
    );
  }
}
