import 'dart:async';
import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  final VoidCallback onTimerReset;
  const TimerWidget({super.key, required this.onTimerReset});

  @override
  TimerWidgetState createState() => TimerWidgetState();
}

class TimerWidgetState extends State<TimerWidget> {
  int secondsRemaining = 6;
  int milliseconds = 0;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        if (milliseconds > 0) {
          milliseconds -= 10;
        } else {
          if (secondsRemaining > 0) {
            secondsRemaining--;
            milliseconds = 990;
          } else {
            secondsRemaining = 6;
            milliseconds = 0;
            widget.onTimerReset();
          }
        }
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String formatTime(int seconds, int milliseconds) {
    String millis = milliseconds.toString().padLeft(3, '0');
    return '$seconds.$millis';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
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
          formatTime(secondsRemaining, milliseconds),
          style: TextStyle(
            height: 0,
            fontFamily: "OpenDisplay",
            color: Colors.red,
            fontSize: 40,
          ),
        ),
      )
    );
  }
}
