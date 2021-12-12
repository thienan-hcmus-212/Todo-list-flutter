import 'package:flutter/material.dart';

class UpcomingPage extends StatelessWidget{
  const UpcomingPage({Key? key}):super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
          title: const Text("Upcoming")
      ),
      body: const Center(
        child: Text('List of upcoming tasks'),
      ),
    );
  }
}