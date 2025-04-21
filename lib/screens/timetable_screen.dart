import 'package:flutter/material.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen();

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Timetable')),
      body: const Center(child: Text('Timetable Screen')),
    );
  }
}
