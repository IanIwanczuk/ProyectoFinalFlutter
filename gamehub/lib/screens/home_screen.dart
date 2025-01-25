import 'screens.dart';

class HomeW extends StatelessWidget {
  const HomeW ({super.key});
  @override
  Widget build(BuildContext context) {
    late double screenWidth = MediaQuery.of(context).size.width;
    late double screenHeight = MediaQuery.of(context).size.height;

    final _formKey = GlobalKey<FormState>();
    final TextEditingController userController = TextEditingController(text: "");
    final TextEditingController passwordController = TextEditingController(text: "");

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
                            decoration: InputDecoration(hintText: "Ingrese su usuario",border: InputBorder.none,),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "El usuario es obligatorio";
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
                            decoration: InputDecoration(hintText: "Ingrese su contraseña",border: InputBorder.none,),
                          
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                  // ---------------------------------------------------------
                  
                  SizedBox(height: 100,),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
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
                        onPressed: () {
                          bool? isValid = _formKey.currentState?.validate();

                          if (isValid != null) {
                            if (isValid) {
                              print("Is valid");
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
                  )
                  
                ],
              ),
            )
          ),
        ),
    );
  }
}