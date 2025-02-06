import '../screens/screens.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Widget que nos genera un reloj con el tiempo actual del sistema
class LiveClock extends StatefulWidget {
  const LiveClock({super.key});

  @override
  LiveClockState createState() => LiveClockState();
}

class LiveClockState extends State<LiveClock> {
  late Timer _timer;
  String _currentTime = "";

  /// Método para actualizar el reloj e iniciarlo, se llama cada vez que invocamos el reloj
  @override
  void initState() {
    super.initState();
    _updateTime();
    _startClock();
  }

  /// Este método se llama cada que se remueve el widget, o se cambia de contexto a otro, y
  /// se detiene el tiempo, y se elimina el reloj
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  /// Actualizamos el tiempo para que muestre el tiempo actual
  void _updateTime() {
    setState(() {
      _currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
    });
  }

  /// Comenzamos el timer para que se vaya actualizando con el tiempo
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