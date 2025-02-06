import 'dart:math';

import 'screens.dart';


/// Juego BlackJack con cartas de poker traídas de una API, tenemos dos variables de mazos de cartas, una
/// para el jugador y otra para la casa. El jugador tiene tres opciones, pedir una carta, plantarse, o reinciar
/// - Tiene prioridad la casa, si la ambos llegan a 21, gana la casa
/// - Si la casa se pasa de 21, gana el jugador. Si el jugador se pasa, gana la casa
/// - Se gana por menor diferencia a 21. Si la casa tiene 17 y el jugador 18, gana el jugador
/// - El jugador no puede reinciar la partida hasta que termine la ronda
class Blackjack extends StatefulWidget {
  const Blackjack({super.key});

  @override
  State<Blackjack> createState() => _BlackjackState();
}

class _BlackjackState extends State<Blackjack> {
  late double screenWidth = MediaQuery.of(context).size.width;

  // Lista de cartas posibles, la API puede devolver todas ellas e incluso más
  List<String> possibleCards = ["2C", "2D", "2H", "2S", "3C", "3D", "3H", "3S", "4C", "4D", "4H", "4S",
                                "5C", "5D", "5H", "5S", "6C", "6D", "6H", "6S", "7C", "7D", "7H", "7S",
                                "8C", "8D", "8H", "8S", "9C", "9D", "9H", "9S", "0C", "0D", "0H", "0S",
                                "QC", "QD", "QH", "QS", "KC", "KD", "KH", "KS", "JC", "JD", "JH", "JS"];

  // Una variable de lista para las cartas del CPU y las del Jugador, van acontener strings de cartas,
  // por ejemplo "5C", "8H", etc.
  List<String> playerHand = [];
  List<String> cpuHand = [];

  bool playerTurn = true;
  String endMessage = "";

  @override
  void initState() {
    super.initState();
    startGame();
    setState(() {});
  }

  /// Método para obtener el valor de una carta, 4H = 4, 0S = 10, KC = 10, etc
  /// Obtiene como parametro el string de la carta
  int getCardValue(String card) {
    if (RegExp("[1-9][A-Z]").hasMatch(card)) {
      return int.parse(card.characters.first);
    } else {
      return 10;
    }
  }

  /// Damos una carta a al mazo que nos pasen por parametro. Si obtenemos el mazo del 
  /// jugador, le añadimos una carta. Si es la del CPU, igual
  void drawCardOnHand(List<String> hand) {
    Random random = Random();
    int randomIndex = random.nextInt(possibleCards.length);

    while (checkCardOnHand(possibleCards[randomIndex], playerHand) || checkCardOnHand(possibleCards[randomIndex], cpuHand)) {
      randomIndex = random.nextInt(possibleCards.length);
    }

    hand.add(possibleCards[randomIndex]);
    setState(() {});
  }

  /// Método para verificar si la carta (cardToFind) está dentro del mazo que le
  /// pasemos como parametro (hand)
  bool checkCardOnHand(String cardToFind, List<String> hand) {
    for (String cardInHand in hand) {
      if (cardInHand == cardToFind) {
        return true;
      }
    }
    return false;
  }

  /// Método principal para comenzar la partida. Comenzamos limpiando los mazos por si hay algo de la partida
  /// anterior, resteamos el mensaje de fin de partida, hacemos que sea el turno del jugador y le damos dos
  /// cartas al CPU, y una al jugador
  void startGame() {
    playerHand.clear();
    cpuHand.clear();
    endMessage = "";
    playerTurn = true;

    drawCardOnHand(playerHand);
    drawCardOnHand(cpuHand);
    drawCardOnHand(cpuHand);
    
    setState(() {});
  }

  // Método creado únicamente para que el jugador no pueda reiniciar en medio de una partida
  void restartGame() {
    if (playerTurn == false) {
      startGame();  
    }
  }

  /// Método para que el jugador pida una carta, si no es el turno del jugador, terminamos el método.
  /// Si lo es, le damos una carta al jugador. Si se pasa de 21, cambiamos el mensaje y le terminamos
  /// el turno al jugador
  void playerHit() {
    if (!playerTurn) return;
    drawCardOnHand(playerHand);

    if (calculateHandValue(playerHand) > 21) {
      setState(() {
        endMessage = "You lost, dealer wins";
        playerTurn = false;
      });
    }
  }

  /// Para cuando el jugador no quiera pedir más cartas, si no es su turno finalizamos el método, si lo es,
  /// le sacamos el turno al jugador para que se muestren las cartas del CPU, y hacemos que le CPU juegue.
  /// Luego simplemente calculamos el total de cada mano, y cambiamos el mensaje de victoria
  void playerStand() async {
    if (!playerTurn) return;

    setState(() {
      playerTurn = false;
    });

    await cpuPlay();

    int playerTotal = calculateHandValue(playerHand);
    int cpuTotal = calculateHandValue(cpuHand);

    if (cpuTotal > 21) {
      endMessage = "Dealer lost, you win!";
    } else if (cpuTotal >= playerTotal) {
      endMessage = "Dealer wins";
    } else {
      endMessage = "You win!";
    }

    setState(() {
    });
  }

  /// Método que calcula el valor de toda la mano de un jugador
  int calculateHandValue(List<String> hand) {
    int sum = 0;
    for (var card in hand) {
      sum += getCardValue(card);
    }
    return sum;
  }

  /// Hacemos que el CPU juegue, lo hacemos asíncrono para que las cartas se demoren 1 segundo
  /// en aparecer, así da un efecto de espera. Vamos añadiéndole cartas al CPU mientras que tenga
  /// menos de 16 puntos
  Future<void> cpuPlay() async {
    while (calculateHandValue(cpuHand) < 17) {
      await Future.delayed(const Duration(seconds: 1));
      drawCardOnHand(cpuHand);
    }
  }

  /// Widget que representa la carta que aparece en el juego, con la API https://deckofcardsapi.com
  /// obtenemos todas las imagenes de las cartas
  Widget cardWidget(String card) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Image.network(
        'https://deckofcardsapi.com/static/img/$card.png',
        height: 100,
        fit: BoxFit.fitHeight,
      ),
    );
  }

  /// Método que nos crea las cartas del CPU, si es el turno del jugador, solo mostramos la primera carta, y
  /// tapamos la segunda carta. Si es el caso contrario, mostramos todas las cartas
  List<Widget> buildDealerCards() {
    List<Widget> cards = [];
    if (playerTurn && cpuHand.isNotEmpty) {
      cards.add(cardWidget(cpuHand.first));
      for (int i = 1; i < cpuHand.length; i++) {
        cards.add(cardWidget("back"));
      }
    } else {
      cards = cpuHand.map((card) => cardWidget(card)).toList();
    }
    return cards;
  }

  /// Obtenemos el puntaje total del CPU, si es el turno del jugador, tomamos el primer valor de su 
  /// mano. Si ya no es el turno del jugador, podemos revelar el valor de su segunda carta y todas
  /// las otras
  String getDealerTotal() {
    if (playerTurn && cpuHand.isNotEmpty) {
      return getCardValue(cpuHand.first).toString();
    } else {
      return calculateHandValue(cpuHand).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, AppRoutes.homescreen, "backbutton.png"),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/blackjackbg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Dealer",
                  style: GoogleFonts.montaguSlab(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Color(0xFFA5FFAF),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  getDealerTotal(),
                  style: GoogleFonts.luckiestGuy(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100,
                        width: screenWidth-50,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: buildDealerCards(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 140,
                  child: Center(
                    child: endMessage.isNotEmpty
                    ? Text(
                      endMessage, textAlign: TextAlign.center,
                      style: GoogleFonts.joan(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    )
                    : SizedBox(),
                  )
                ),
                SizedBox(
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100,
                        width: screenWidth-50, 
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: playerHand.map((card) => cardWidget(card)).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "${calculateHandValue(playerHand)}",
                  style: GoogleFonts.luckiestGuy(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "You",
                  style: GoogleFonts.montaguSlab(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.yellow,
                  ),
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    generateBlackJackButton(Color.fromARGB(255, 14, 14, 14), Color.fromARGB(255, 66, 66, 66), Color.fromARGB(255, 133, 133, 133), restartGame, "Reset"),
                    const SizedBox(width: 20),
                    generateBlackJackButton(Color.fromARGB(255, 14, 14, 14), Color.fromARGB(255, 0, 194, 0), Color.fromARGB(255, 0, 170, 9), playerStand, "Stand"),
                    const SizedBox(width: 20),
                    generateBlackJackButton(Color.fromARGB(255, 14, 14, 14), Color.fromARGB(255, 194, 0, 0), Color.fromARGB(255, 255, 0, 0), playerHit, "Hit"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}