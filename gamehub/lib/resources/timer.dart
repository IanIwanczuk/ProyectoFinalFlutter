import 'dart:async';
import 'package:flutter/material.dart';

/// Temporizador de 15 segundos, lo usaremos para medir el tiempo en el juego de adivinar banderas y
/// cada vez que termine el tiempo llamaremos a la función "onTimerReset" en la pantalla del juego.
class TimerWidget extends StatefulWidget {
  // Con esta linea le decimos qué ejecutar cuando termine el temporizador
  final VoidCallback onTimerReset;
  const TimerWidget({super.key, required this.onTimerReset});

  @override
  TimerWidgetState createState() => TimerWidgetState();
}

class TimerWidgetState extends State<TimerWidget> {  
  int secondsRemaining = 6;
  int milliseconds = 0;
  late Timer timer;

  /// Método que inicializa el widget
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  /// Comenzamos el temporizador, y lo actualizamos cada 10 milisegundos
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

            // Con esta línea ejecutamos la función que hemos recibido
            widget.onTimerReset();
          }
        }
      });
    });
  }

  /// Método que se llama cuando eliminamos el widget
  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  /// Formato para el tiempo
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
