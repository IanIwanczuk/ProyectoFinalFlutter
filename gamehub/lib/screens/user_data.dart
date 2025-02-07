import 'package:gamehub/models/current_user.dart';
import 'package:gamehub/models/user.dart';

import 'screens.dart';

/// Pantalla de actualización de datos del usuario, tiene opción de cambiar su correo,
/// su nombre de usuario o su contraseña. Siempre se le va a pedir como requisito su
/// contraseña para poder realizar cambios
class UpdateData extends StatefulWidget {
  const UpdateData({super.key});

  @override
  State<UpdateData> createState() => _UpdateDataState();
}
class _UpdateDataState extends State<UpdateData> {
  late double screenWidth = MediaQuery.of(context).size.width;
  final formKey = GlobalKey<FormState>();

  final TextEditingController usuarioController = TextEditingController(text: currentUser!.user);
  final TextEditingController correoController = TextEditingController(text: currentUser!.email);
  final TextEditingController passwordController = TextEditingController(text: "");

  // Instancia de la clase DatabaseService que servirá para tirar consultas
  DatabaseService dbService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, AppRoutes.homescreen, "backbutton.png"),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/updatebg.png'),
            fit: BoxFit.cover,
          ),
        ),

        child: Center(

          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20,),
                Text('Actualización de datos',style: GoogleFonts.pressStart2p(height: 1, fontSize: 25,color: Color(0xFF345A7E),shadows: [Shadow(color: const Color.fromARGB(70, 0, 0, 0), blurRadius: 14, offset: Offset(0, 4),),],),textAlign: TextAlign.center,),
                const SizedBox(height: 10),
                Text(capitalizeFirstLetter(currentUser!.user), style: GoogleFonts.rowdies(fontSize: 65,fontWeight: FontWeight.bold, color: Colors.black, shadows: [Shadow(color: const Color.fromARGB(70, 0, 0, 0), blurRadius: 14, offset: Offset(0, 4),),],),),
                const SizedBox(height: 20),

                Container(
                  height: 5,
                  width: screenWidth - 20,
                  color: Colors.black,
                ),

                SizedBox(
                  width: screenWidth - 20,
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text('Ingrese los datos que desee actualizar', style: GoogleFonts.varela(fontSize: 18, color: Colors.black87,),),
                        const SizedBox(height: 15),

                        Row(mainAxisAlignment: MainAxisAlignment.start,children: [Text("Usuario",style: GoogleFonts.josefinSans(color: const Color(0xFF007E87),fontSize: 22,fontWeight: FontWeight.bold)),],), SizedBox(height: 5,),
                        Container(
                          decoration: BoxDecoration(color: Color(0xFF05D9E8),borderRadius: BorderRadius.circular(5)),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: buildInputField('Nombre de usuario', usuarioController, userValidator),
                        ),
                        const SizedBox(height: 10),

                        Row(mainAxisAlignment: MainAxisAlignment.start,children: [Text("Correo electrónico",style: GoogleFonts.josefinSans(color: const Color(0xFF007E87),fontSize: 22,fontWeight: FontWeight.bold)),],), SizedBox(height: 5,),
                        Container(
                          decoration: BoxDecoration(color: Color(0xFF05D9E8),borderRadius: BorderRadius.circular(5)),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: buildInputField('Nuevo correo electrónico', correoController, emailValidator),
                        ),
                        const SizedBox(height: 10),

                        Row(mainAxisAlignment: MainAxisAlignment.start,children: [Text("Contraseña",style: GoogleFonts.josefinSans(color: const Color(0xFF007E87),fontSize: 22,fontWeight: FontWeight.bold)),],), SizedBox(height: 5,),
                        Container(
                          decoration: BoxDecoration(color: Color(0xFF05D9E8),borderRadius: BorderRadius.circular(5)),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextFormField(
                            obscureText: true, obscuringCharacter: "⬤",
                            decoration: InputDecoration(
                              hintText: "Repita o cambie la contraseña",
                              border: InputBorder.none,
                              errorStyle: TextStyle(color: const Color.fromARGB(255, 47, 0, 255)),
                            ),
                            controller: passwordController,
                            validator: passwordValidator,
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ), 
                  ),
                ),

                SizedBox(height: 50,),
                
                ElevatedButton(
                  onPressed: () async {
                    bool? isValid = formKey.currentState?.validate();
                    if (isValid != null) {
                      if (isValid) {
                        // Creamos un usuario de copia con todos los datos del usuario loggeado actualmente
                        User usuario = currentUser!.copyWith(user: currentUser!.user, email: currentUser!.email, pwd: currentUser!.pwd, sex: currentUser!.sex);
                        // Variable para ver si algún dato cambió o no
                        bool changed = false;

                        // Verificamos cada uno de los controladores de los campos, y si un dato es diferente al del
                        // usuario loggeado actualmente, lo cambiamos, y determinamos que se han hecho cambios
                        if (usuarioController.text != usuario.user) {
                          usuario.user = usuarioController.text; changed = true;
                        }
                        if (correoController.text != usuario.email) {
                          usuario.email = correoController.text; changed = true;
                        }
                        if (passwordController.text != usuario.pwd) {
                          usuario.pwd = passwordController.text; changed = true;
                        }

                        // Si se han hecho cambios, lo subimos a la base de datos, obteniendo el ID de Firebase del
                        // usuario, y el objeto temporal de usuario que hemos creado. Además actualizamos la variable
                        // del usuario loggeado actualmente
                        if (changed) {
                          dbService.updateUser(currentId!, usuario);
                          currentUser = usuario;
                          setState(() {
                            alertDialog(context, "Modificacón", "Se han actualizado sus datos correctamente");
                          });
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
                        color: Color.fromARGB(255, 0, 17, 255),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Text('Actualizar', style: TextStyle(color: Color(0xFF2731B6))),
                ),
                SizedBox(height: 50,),
                const Text("IanIwanczuk © 2025", style: TextStyle(color: Color.fromARGB(255, 0, 89, 161)),),
                SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      )
    );
  }

  TextFormField buildInputField(String hintText, TextEditingController controller, String? Function(String?) validator) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
        border: InputBorder.none,
        errorStyle: TextStyle(color: const Color.fromARGB(255, 47, 0, 255)),
      ),
      controller: controller,
      validator: validator,
    );
  }

  String? passwordValidator(String? value) {
    if (value!.isEmpty) {
      return "La contraseña es obligatoria";
    }
    if (!RegExp(r'^[a-zA-Z0-9]{6,}$').hasMatch(value)) {
      return "La contraseña es de 6 carácteres mínimo";
    }
    return null;
  }

  String? emailValidator(String? value) {
    if (value!.isEmpty) {
      return "El correo es obligatorio";
    }
    if (!RegExp(r'[a-z0-9._-]+@[a-z]+\.[a-z]{2,}').hasMatch(value)) {
      return "Formato del correo inválido";
    }
    return null;
  }

  String? userValidator(String? value) {
    if (value!.isEmpty) {
      return "El usuario es obligatorio";
    }
    if (!RegExp(r'^[a-zA-Z0-9]{6,}$').hasMatch(value)) {
      return "El usuario es de 6 carácteres mínimo";
    }
    return null;
  }
  
}
