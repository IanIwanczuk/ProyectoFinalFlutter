import 'dart:math';

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
  List<String> possibleCards = ["2C", "2D", "2H", "2S", "3C", "3D", "3H", "3S", "4C", "4D", "4H", "4S",
                                "5C", "5D", "5H", "5S", "6C", "6D", "6H", "6S", "7C", "7D", "7H", "7S",
                                "8C", "8D", "8H", "8S", "9C", "9D", "9H", "9S", "0C", "0D", "0H", "0S",
                                "QC", "QD", "QH", "QS", "KC", "KD", "KH", "KS", "JC", "JD", "JH", "JS"];

  List<String> playerHand = [];
  List<String> cpuHand = [];

  @override
  void initState() {
    super.initState();
    print(getCardValue("9C"));
    print(getCardValue("5D"));
    print(getCardValue("6A"));
    print(getCardValue("3H"));
    print(getCardValue("8S"));
  }

  int getCardValue(String card) {
    if (RegExp("[1-9][A-Z]").hasMatch(card)) {
      return int.parse(card.characters.first);
    } else {
      return 10;
    }
  }

  void drawCardOnHand(List<String> hand) {
    Random random = Random();
    int randomIndex = random.nextInt(possibleCards.length);

    while (checkCardOnHand(possibleCards[randomIndex], playerHand) || checkCardOnHand(possibleCards[randomIndex], cpuHand)) {
      randomIndex = random.nextInt(possibleCards.length);
    }

    hand.add(possibleCards[randomIndex]);
    setState(() {});
  }

  bool checkCardOnHand(String cardToFind, List<String> hand) {
    for (String cardInHand in hand) {
      if (cardInHand == cardToFind) {
        return true;
      }
    }
    return false;
  }

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
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: possibleCards.map((card) {
                return Image.network(
                  'https://deckofcardsapi.com/static/img/$card.png',
                  height: 140,
                  fit: BoxFit.fitHeight,
                );
              }).toList(),
            ),
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