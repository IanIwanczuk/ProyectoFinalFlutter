import 'dart:math';

import 'screens.dart';

class Blackjack extends StatefulWidget {
  const Blackjack({super.key});

  @override
  State<Blackjack> createState() => _BlackjackState();
}

class _BlackjackState extends State<Blackjack> {
  late double screenWidth = MediaQuery.of(context).size.width;

  List<String> possibleCards = ["2C", "2D", "2H", "2S", "3C", "3D", "3H", "3S", "4C", "4D", "4H", "4S",
                                "5C", "5D", "5H", "5S", "6C", "6D", "6H", "6S", "7C", "7D", "7H", "7S",
                                "8C", "8D", "8H", "8S", "9C", "9D", "9H", "9S", "0C", "0D", "0H", "0S",
                                "QC", "QD", "QH", "QS", "KC", "KD", "KH", "KS", "JC", "JD", "JH", "JS"];

  List<String> playerHand = [];
  List<String> cpuHand = [];

  bool playerTurn = true;
  String gameMessage = "";

  @override
  void initState() {
    super.initState();
    startGame();
    setState(() {});
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

  void startGame() {
    playerHand.clear();
    cpuHand.clear();
    gameMessage = "";
    playerTurn = true;

    drawCardOnHand(playerHand);
    drawCardOnHand(cpuHand);
    drawCardOnHand(cpuHand);
    
    setState(() {});
  }

  void playerHit() {
    if (!playerTurn) return;
    drawCardOnHand(playerHand);

    if (calculateHandValue(playerHand) > 21) {
      setState(() {
        gameMessage = "You lost, dealer wins";
        playerTurn = false;
      });
    }
  }

  void playerStand() async {
    if (!playerTurn) return;

    setState(() {
      playerTurn = false;
    });

    await cpuPlay();

    int playerTotal = calculateHandValue(playerHand);
    int cpuTotal = calculateHandValue(cpuHand);

    String result;
    if (cpuTotal > 21) {
      result = "Dealer lost, you win!";
    } else if (cpuTotal >= playerTotal) {
      result = "Dealer wins";
    } else {
      result = "You win!";
    }

    setState(() {
      gameMessage = result;
    });
  }

  int calculateHandValue(List<String> hand) {
    int sum = 0;
    for (var card in hand) {
      sum += getCardValue(card);
    }
    return sum;
  }

  Future<void> cpuPlay() async {
    while (calculateHandValue(cpuHand) < 17) {
      await Future.delayed(const Duration(seconds: 1));
      drawCardOnHand(cpuHand);
    }
  }

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
                    child: gameMessage.isNotEmpty
                    ? Text(
                      gameMessage, textAlign: TextAlign.center,
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
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "Reset",
            onPressed: startGame,
            backgroundColor: const Color.fromARGB(255, 255, 241, 179),
            elevation: 4,
            shape: getFloatingActStyle(),
            child: Text(
              'O',
              style: GoogleFonts.joan(
                height: -0.01,
                fontWeight: FontWeight.bold,
                fontSize: 45,
                color: const Color.fromARGB(255, 255, 174, 0),
              ),
            ),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            heroTag: "Stand",
            onPressed: playerStand,
            backgroundColor: const Color.fromARGB(255, 255, 241, 179),
            shape: getFloatingActStyle(),
            child: Text(
              '!',
              style: GoogleFonts.joan(
                height: -0.01,
                fontWeight: FontWeight.bold,
                fontSize: 50,
                color: const Color.fromARGB(255, 255, 174, 0),
              ),
            ),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            heroTag: "Hit",
            onPressed: playerHit,
            backgroundColor: const Color.fromARGB(255, 255, 241, 179),
            shape: getFloatingActStyle(),
            child: Text(
              '+',
              style: GoogleFonts.joan(
                fontWeight: FontWeight.bold,
                height: -0.2,
                fontSize: 50,
                color: const Color.fromARGB(255, 255, 174, 0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}