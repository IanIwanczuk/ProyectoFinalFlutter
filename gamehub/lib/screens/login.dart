import '../models/current_user.dart';
import 'screens.dart';

/// Pantalla de login, la primera que se muestra en la aplicación, mostramos el logo de la aplicación
/// con un container y un formulario dentro para que el usuario ingrese sus credenciales
class HomeW extends StatelessWidget {
  const HomeW ({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController userController = TextEditingController(text: "");
    final TextEditingController passwordController = TextEditingController(text: "");

    // Creamos una instancia de DatabaseService para hacer consultas a la base de datos
    // en FireBase
    DatabaseService dbService = DatabaseService();

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
                Image.asset("assets/images/logotext.png", height: 250),
                SizedBox(height: 50,),

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
                              controller: passwordController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "La contraseña es obligatoria";
                                }
                                if (!RegExp(r'^[a-zA-Z0-9]{6,}$').hasMatch(value)) {
                                  return "La contraseña es de 6 carácteres mínimo";
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                  // ---------------------------------------------------------
                  
                  SizedBox(height: 40,),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, "/Register");
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
                        child: Text('Registrate', style: TextStyle(color: Color(0xFF5FBFF9))),
                      ),

                      SizedBox(width: 10),

                      ElevatedButton(
                        onPressed: () async {
                          bool? isValid = formKey.currentState?.validate();

                          if (isValid != null) {
                            if (isValid) {
                              // Verificamos si las credenciales que nos proporciona el usuario realmente existe o no
                              currentUser = await dbService.isUserValid(userController.text, passwordController.text);

                              if (currentUser != null) {
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                                // ignore: use_build_context_synchronously
                                Navigator.pushNamed(context, AppRoutes.homescreen);
                              } else {
                                // ignore: use_build_context_synchronously
                                alertDialog(context, "Inexistente", "No se ha encontrado un usuario con estas credenciales");
                              }

                            } else {
                              alertDialog(context, "Error", "Hay datos ingresados incorrectamente");
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
                        child: Text('Entrar', style: TextStyle(color: Color(0xFF2731B6))),
                      ),
                      SizedBox(width: 15,),
                    ],
                  ),
                  SizedBox(height: 20,)
                ],
              ),
            )
          ),
        ),
    );
  }
}