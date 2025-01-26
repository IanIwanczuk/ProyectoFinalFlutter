import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';
import 'routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );  
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true, 
  );
  runApp(
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
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes
    )
  );
}