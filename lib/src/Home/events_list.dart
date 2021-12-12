import 'package:flutter/material.dart';
import '../utils.dart';
import '../Common/item_event.dart';

class EventsList extends StatelessWidget {
  const EventsList({
    Key? key,
    required this.selectedEvents,
    required this.isEdit,
    required this.deleteItem
  }) : super(key: key);

  final ValueNotifier<List<Event>> selectedEvents;
  final bool isEdit;
  final Function(Event) deleteItem;

  void _rightIconPress(Event event,BuildContext context){
    if (isEdit==true){
      showDialogDeleteItem(event, context, deleteItem);
    } else {
      showDialogMoreInfoOfEvent(event, context);
    }
  }

  Widget _rightItemShow(Event event,BuildContext context){
    if (isEdit==true){
      return Material(
        child: InkWell(
          onTap: () => _rightIconPress(event,context),
          child: const Icon(
            Icons.delete,
            size: 24,
          ),
        ),
      );
    }
    return Material(
      child: InkWell(
        onTap: () => _rightIconPress(event,context),
        child: const Icon(
          Icons.info,
          size: 24,
        ),
      ),
    );
  }

  Widget _itemEventShow(Event event,BuildContext context) {
    return Container(
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
        child: ItemEvent(
              event: event,
              rightButton: _rightItemShow(event, context),
              onRightButtonPress: (event)=>_rightIconPress(event,context),
        )
    );
  }

  Widget _itemEventHide(Event event) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 12,
        ),
        decoration: const BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(9)),
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: ItemEvent(event: event));
  }

  Widget _itemEventBuilder(BuildContext context, Event event) {
    if (isEdit == false) {
      return Container(
        margin: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 3,
        ),
        child: _itemEventShow(event,context),
      );
    }
    return Draggable<Event>(
      data: event,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 3,
        ),
        child: _itemEventShow(event,context),
      ),
      feedback: Material(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
          child: _itemEventShow(event,context),
        ),
        elevation: 4.0,
      ),
      childWhenDragging: _itemEventHide(event),
    );
  }

  Widget _listEventBuilder(BuildContext context, List<Event> value, Widget? _) {
    if (value.isEmpty) {
      return const Center(
        child: Text('Không có lịch trình'),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(9),
      itemCount: value.length,
      itemBuilder: (context, index) => _itemEventBuilder(context, value[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.all(Radius.circular(9)),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey,
        //     spreadRadius: 5,
        //     blurRadius: 7,
        //     offset: Offset(0, 0), // changes position of shadow
        //   ),
        // ],
      ),
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: ValueListenableBuilder<List<Event>>(
        valueListenable: selectedEvents,
        builder: (context, value, _) => _listEventBuilder(context, value, _),
      ),
    );
  }
}
