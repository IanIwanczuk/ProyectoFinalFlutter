import 'package:gamehub/models/current_user.dart';
import 'package:gamehub/resources/liveclock.dart';

import 'screens.dart';


/// Pantalla principal donde se mostrará el nombre del usuario loggeado, y los juegos
/// de la aplicación. También tendremos un floating action button que permite al usuario
/// editar sus datos en la base de datos
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    late double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: getAppBar(context, AppRoutes.login, "logout.png"),

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
              children: [
                SizedBox(height: 30,),

                Text(currentUser?.sex == "Hombre" ? 'Bienvenido' : 'Bienvenida', 
                  style: GoogleFonts.pressStart2p(fontSize: 35, color: Color(0xFF345A7E),shadows: [Shadow(color: const Color.fromARGB(70, 0, 0, 0), blurRadius: 14, offset: Offset(0, 4),),],),),
                Text(capitalizeFirstLetter(currentUser?.user), 
                  style: GoogleFonts.rowdies(fontSize: 75,fontWeight: FontWeight.bold, color: Colors.black, shadows: [Shadow(color: const Color.fromARGB(70, 0, 0, 0), blurRadius: 14, offset: Offset(0, 4),),],),),
              
                SizedBox(height: 20,),

                Container(
                  width: screenWidth - 35,
                  decoration: BoxDecoration(
                    color: Color(0xFF16BAC5),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: const Color.fromARGB(70, 0, 0, 0), blurRadius: 1, offset: Offset(0, 4),),],
                  ),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 15,),
                      getGameContainer(screenWidth-60, "blackjack.png", "Blackjack", GoogleFonts.jomolhari(color: Colors.white, fontSize: 50,), "Blackjack", context),
                      SizedBox(height: 15,),
                      getGameContainer(screenWidth-60, "hangman.png", "Ahorcado _ _ _", GoogleFonts.jollyLodger(color: Colors.white, fontSize: 60,), "Hangman", context),
                      SizedBox(height: 15,),
                      getGameContainer(screenWidth-60, "countries.png", "Adivina la bandera", GoogleFonts.jockeyOne(color: Colors.white, fontSize: 42,), "Countries", context),
                      SizedBox(height: 15,),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [LiveClock(),],
                ),
                SizedBox(height: 20,),
              ],
            ),
          )
        )
      ),

      floatingActionButton: SizedBox(
        height: 68,
        width: 68,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, "/Updatescreen");
          },
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 255, 255, 255), 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          child: Image.asset("assets/images/contact.png", height: 40, width: 40,),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
