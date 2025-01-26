import 'package:flutter/material.dart';
import 'package:gamehub/models/current_user.dart';
import 'screens.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("USUARIO LOGEADO", style: TextStyle(fontSize: 20, color: Colors.white),),
          Text("Correo: ${currentUser!.email}", style: TextStyle(fontSize: 20, color: Colors.white),),
          Text("Usuario: ${currentUser!.user}", style: TextStyle(fontSize: 20, color: Colors.white),),
          Text("Contraseña: ${currentUser!.pwd}", style: TextStyle(fontSize: 20, color: Colors.white),),
          Text("Sexo: ${currentUser!.sex}", style: TextStyle(fontSize: 20, color: Colors.white),),
        ],
      ),
    );
  }
}