import '../screens/screens.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LiveClock extends StatefulWidget {
  const LiveClock({super.key});

  @override
  LiveClockState createState() => LiveClockState();
}

class LiveClockState extends State<LiveClock> {
  late Timer _timer;
  String _currentTime = "";

  @override
  void initState() {
    super.initState();
    _updateTime();
    _startClock();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    setState(() {
      _currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
    });
  }

  void _startClock() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _updateTime());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
      decoration: BoxDecoration(
        color: Color(0xFF2F2F2F),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Color(0xFF818181),
          width: 2,
        )
      ),
      child: Center(
        child: Text(
          _currentTime,
          style: TextStyle(
            height: 0,
            fontFamily: "OpenDisplay",
            color: Color(0xFF00FF00),
            fontSize: 40,
          ),
        ),
      )
    );
  }
}