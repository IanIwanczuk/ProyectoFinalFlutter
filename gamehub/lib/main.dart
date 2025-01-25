import 'package:flutter/material.dart';
import 'routes/routes.dart';

void main() => runApp(
  MaterialApp(
    theme: ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.black,
      scaffoldBackgroundColor: const Color.fromRGBO(255, 250, 210, 1),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Color.fromARGB(255, 159, 104, 0),
        iconTheme: IconThemeData(color: Color.fromARGB(255, 169, 112, 0)),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(  
            fontWeight: FontWeight.bold, color: Colors.blue),
        bodyMedium: TextStyle(color: Colors.black87),
      ),
    ),
    title: 'Rutas',
    debugShowCheckedModeBanner: false,
    initialRoute: AppRoutes.home,
    routes: AppRoutes.routes
  )
);