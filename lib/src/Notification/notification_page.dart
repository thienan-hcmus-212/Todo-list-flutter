import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget{
  const NotificationPage({Key? key}):super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
          title: const Text("Notification")
      ),
      body: const Center(
        child: Text('List of tasks that have been notified'),
      ),
    );
  }
}