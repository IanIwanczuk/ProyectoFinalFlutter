import 'package:flutter/services.dart';

import 'screens.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // late double screenWidth = MediaQuery.of(context).size.width;
  // late double screenHeight = MediaQuery.of(context).size.height;
  final formKey = GlobalKey<FormState>();
  String? selectedSex = "Hombre";

  final TextEditingController correoController = TextEditingController(text: "");
  final TextEditingController userController = TextEditingController(text: "");
  final TextEditingController password1Controller = TextEditingController(text: "");
  final TextEditingController password2Controller = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                Image.asset("assets/images/logo.png", height: 200),
                SizedBox(height: 5),

                // ---------------------------------------------------------
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                  decoration: BoxDecoration(
                    color: Color(0xFF5863F8),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(78, 0, 0, 0),
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),

                  child: Form(
                    key: formKey,
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Correo electrónico",style: GoogleFonts.kanit(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(5)),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "Ingrese su correo electrónico",
                            border: InputBorder.none,
                            errorStyle: TextStyle(color: const Color.fromARGB(255, 4, 0, 255)),
                          ),
                          controller: correoController,                  // CONTROLLER
                          validator: (value) {                              // VALIDATOR
                            if (value!.isEmpty) {
                              return "El correo es obligatorio";
                            }
                            if (!RegExp(r'[a-z0-9._-]+@[a-z]+\.[a-z]{2,}').hasMatch(value)) {
                              return "Formato del correo inválido";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      // ---------------------------------------------------------
                      Text("Usuario",style: GoogleFonts.kanit(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(5)),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "Ingrese su usuario",
                            border: InputBorder.none,
                            errorStyle: TextStyle(color: const Color.fromARGB(255, 4, 0, 255)),
                          ),
                          controller: userController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "El usuario es obligatorio";
                            }
                            if (!RegExp(r'^[a-zA-Z0-9]{6,}$').hasMatch(value)) {
                              return "El usuario es de 6 carácteres mínimo";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 20),

                      // -----------------------------------------------
                      Text("Contraseña",style: GoogleFonts.kanit(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(5)),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(obscuringCharacter: '⬤', obscureText: true, 
                          decoration: InputDecoration(
                            hintText: "Ingrese su contraseña",
                            border: InputBorder.none,
                            errorStyle: TextStyle(color: const Color.fromARGB(255, 4, 0, 255)),
                          ),
                          controller: password1Controller,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "La contraseña es obligatoria";
                            }
                            if (!RegExp(r'^[a-zA-Z0-9]{6,}$').hasMatch(value)) {
                              return "La contraseña es de 6 carácteres mínimo";
                            }
                            if (password1Controller.text != password2Controller.text) {
                              return "Las contraseñas deben de coincidir";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 20,),
                      // -----------------------------------------------

                      Text("Repita la contraseña",style: GoogleFonts.kanit(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(5)),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(obscuringCharacter: '⬤', obscureText: true, 
                            decoration: InputDecoration(
                              hintText: "Reingrese su contraseña",
                              border: InputBorder.none,
                              errorStyle: TextStyle(color: const Color.fromARGB(255, 4, 0, 255)),
                            ),
                            controller: password2Controller,                  // CONTROLLER
                            validator: (value) {                              // VALIDATOR
                              if (value!.isEmpty) {
                                return "La contraseña es obligatoria";
                              }
                              if (!RegExp(r'^[a-zA-Z0-9]{6,}$').hasMatch(value)) {
                                return "La contraseña es de 6 carácteres mínimo";
                              }
                              if (password1Controller.text != password2Controller.text) {
                                return "Las contraseñas deben de coincidir";
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        // ---------------------------------------------------------
                        
                        Text("Sexo",style: GoogleFonts.kanit(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold)),
                        RadioListTile<String>(
                        title: Text('Hombre', style: TextStyle(color: Colors.white)),
                        value: "Hombre",
                        groupValue: selectedSex,
                        activeColor: Colors.white, 
                        tileColor: Colors.white,
                        selectedTileColor: Colors.white,
                        fillColor: WidgetStateColor.resolveWith((Set<WidgetState> states) { return Colors.white; }),
                        onChanged: (value) {
                          setState(() {
                            selectedSex = value;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: Text('Mujer', style: TextStyle(color: Colors.white)),
                        value: 'Mujer',
                        groupValue: selectedSex,
                        activeColor: Colors.white, 
                        tileColor: Colors.white,
                        selectedTileColor: Colors.white,
                        fillColor: WidgetStateColor.resolveWith((Set<WidgetState> states) { return Colors.white; }),
                        onChanged: (value) {
                          setState(() {
                            selectedSex = value;
                          });
                        },
                      ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                
                // SizedBox(height: 100,),


                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, "/");
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        textStyle: GoogleFonts.kanit(fontSize: 20, fontWeight: FontWeight.w500),
                        backgroundColor: Color(0xFFDDF1FF),
                        shadowColor: Color(0x005FBEF9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                          side: BorderSide(
                            color: Color(0xFF5FBFF9),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text('Cancelar', style: TextStyle(color: Color(0xFF5FBFF9))),
                    ),

                    SizedBox(width: 10),

                    ElevatedButton(
                      onPressed: () {
                        bool? isValid = formKey.currentState?.validate();

                        if (isValid != null) {
                          if (isValid) {
                            print("Is valid");
                          } else {
                            print("Is NOT valid");
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        textStyle: GoogleFonts.kanit(fontSize: 20, fontWeight: FontWeight.w500),
                        backgroundColor: Color(0xFF5FBFF9),
                        shadowColor: Color(0x005FBEF9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                          side: BorderSide(
                            color: Color(0xFF2731B6),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text('Registrarse', style: TextStyle(color: Color(0xFF2731B6))),
                    ),
                    SizedBox(width: 15,),
                  ],
                ),
                SizedBox(height: 20,),
              ],
            ),
          )
        ),
      ),
    );
  }
}