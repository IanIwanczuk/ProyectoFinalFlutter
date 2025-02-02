import 'screens.dart';

class Blackjack extends StatefulWidget {
  const Blackjack({super.key});

  @override
  State<Blackjack> createState() => _BlackjackState();
}

class _BlackjackState extends State<Blackjack> {
  /* Para hacer que las cartas de la CASA salgan según si el jugador juega o se queda:
   * - Cuando el jugador pulsa el botón de tirar una carta, *se le da una carta a la casa y al jugador*
   * - Cuando el jugador pulsa el botón de STAND, tenemos que *comprobar si la casa tiene un puntaje mayor que 16*, si
   *   tiene un valor mayor que 16, no volvemos a tirar carta. si tiene menos, tiramos hasta que tenga 16 o más.
   */
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, AppRoutes.homescreen, "backbutton.png"),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/blackjackbg.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "Reset",
            onPressed: () {},
            backgroundColor: const Color.fromARGB(255, 255, 241, 179),
            elevation: 4,
            shape: getFloatingActStyle(),
            child: Text('O', style: GoogleFonts.joan(height: -0.01 ,fontWeight: FontWeight.bold ,fontSize: 45, color: Color.fromARGB(255, 255, 174, 0)),),
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            heroTag: "Stand",
            onPressed: () {},
            backgroundColor: const Color.fromARGB(255, 255, 241, 179),
            shape: getFloatingActStyle(),
            child: Text('!', style: GoogleFonts.joan(height: -0.01 ,fontWeight: FontWeight.bold ,fontSize: 50, color: Color.fromARGB(255, 255, 174, 0)),),
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            heroTag: "Hit",
            onPressed: () {},
            backgroundColor: const Color.fromARGB(255, 255, 241, 179),
            shape: getFloatingActStyle(),
            child: Text('+', style: GoogleFonts.joan(fontWeight: FontWeight.bold ,height: -0.2,fontSize: 50, color: Color.fromARGB(255, 255, 174, 0)),),
          ),
        ],
      ),
    );
  }
}