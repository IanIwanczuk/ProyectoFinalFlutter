import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import '../screens/screens.dart';

class Hangman extends StatefulWidget {
  const Hangman({super.key});

  @override
  State<Hangman> createState() => _HangmanState();
}

class _HangmanState extends State<Hangman> {
  // Cargamos el JSON con todas las palabras posibles, para luego poder repetir el juego sin tener que cargar esto denuevo
  List<String> words = [];
  // Palabra secreta a adivinar
  String? secretWord;
  // Set de letras que el usuario escoge para adivinar
  final Set<String> guessedLetters = {};

  // Conteo de errores, y los errores máximos que podemos tener
  int errorCount = 0;
  final int maxErrors = 6;

  // Si el juego ha terminado y si se ha ganado o perdido
  bool isGameOver = false;
  bool isGameWon = false;

  @override
  void initState() {
    super.initState();

    // Cargamos todas las palabras y comenzamos la partida
    loadWords();
  }

  // Método
  Future<void> loadWords() async {
    try {
      final String data = await rootBundle.loadString('lib/resources/words.json');
      final List<dynamic> jsonResult = json.decode(data);
      setState(() {
        words = jsonResult.cast<String>();
        startNewGame();
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      alertDialog(context, "Error cargando las palabras", "Ha ocurrido un error al cargar las palabras");
    }
  }

  void startNewGame() {
    setState(() {
      guessedLetters.clear();
      errorCount = 0;
      isGameOver = false;
      isGameWon = false;
      if (words.isNotEmpty) {
        final random = Random();
        secretWord = words[random.nextInt(words.length)].toUpperCase();
      } else {
        secretWord = null;
      }
    });
  }

  void guessLetter(String letter) {
    // Si el juego ya está terminado, o la palabra sedcreta es NULL, o si la letra que toca el
    // usuario ya la tocó anteriormente, salimos de este método y no verificamos nada. 
    if (isGameOver || secretWord == null || guessedLetters.contains(letter)) return;

    setState(() {
      guessedLetters.add(letter);

      // La palabra secreta NO contiene la palabra, aumentamos el contador de errores
      if (!secretWord!.contains(letter)) {
        errorCount++;
        // Si llegamos a la cantidad maxima de errores, terminamos
        if (errorCount == maxErrors) {
          isGameOver = true;
        }
      } else {
        bool allGuessed = true;

        /**
         * Verificamos si el array de letras adivinadas contiene TODAS las letras de
         * la palabra secreta. Si es así, terminamos el juego y lo damos como GANADO
         */
        for (int i = 0; i < secretWord!.length; i++) {
          if (!guessedLetters.contains(secretWord![i])) {
            allGuessed = false;
            break;
          }
        }
        if (allGuessed) {
          isGameWon = true;
          isGameOver = true;
        }
      }
    });
  }

  Widget buildWordDisplay() {
    if (secretWord == null) return Container();

    List<Widget> letters = [];
    for (int i = 0; i < secretWord!.length; i++) {
      String char = secretWord![i];
      letters.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: isGameOver
          ? Text(
            secretWord![i],
            style: GoogleFonts.jollyLodger(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 15),
          )
          : Text(
            guessedLetters.contains(char) ? char : '_',
            style: GoogleFonts.jollyLodger(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 15),
          ),
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: letters,
    );
  }

  Widget buildLetterButton(String letter) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ElevatedButton(
        onPressed: guessedLetters.contains(letter) || isGameOver ? null : () => guessLetter(letter),
        style: ElevatedButton.styleFrom(
          backgroundColor: guessedLetters.contains(letter) || isGameOver
              ? Colors.transparent
              : Color.fromARGB(255, 139, 0, 0),
          shadowColor: guessedLetters.contains(letter) || isGameOver
              ? Colors.transparent
              : Color(0x005FBEF9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: guessedLetters.contains(letter) || isGameOver
                  ? Colors.transparent
                  : Color.fromARGB(255, 255, 82, 82),
              width: 1,
            ),
          ),
        ),
        child: Text(letter, style: GoogleFonts.kanit(
          color: guessedLetters.contains(letter) || isGameOver ? Colors.transparent : Color.fromARGB(255, 255, 82, 82),
          fontSize: 20,
          fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  Widget buildLetterButtons() {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    return Wrap(
      alignment: WrapAlignment.center,
      children: letters.split('').map((letter) => buildLetterButton(letter)).toList(),
    );
  }

  Widget buildHangmanImage() {
    String imagePath = 'assets/images/hangman$errorCount.png';
    return Image.asset(
      imagePath,
      height: 200,
      fit: BoxFit.contain,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, AppRoutes.homescreen, "backbutton.png"),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/hangmanbg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: secretWord == null ? const CircularProgressIndicator(color: Colors.red,) : SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildHangmanImage(),
                const SizedBox(height: 20),
                buildWordDisplay(),
                const SizedBox(height: 20),
                if (isGameOver)
                  Column(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        isGameWon ? 'Congratulations, you win!' : 'Womp womp, game over!',
                        style: GoogleFonts.kanit(
                          fontSize: 28,
                          color: Colors.red
                        ),
                      ),
                      SizedBox(height: 50),
                      ElevatedButton(
                        onPressed: startNewGame,
                        style: ElevatedButton.styleFrom(
                          shadowColor: const Color.fromARGB(0, 255, 255, 255),
                          backgroundColor: const Color.fromARGB(255, 112, 7, 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(
                              color: Color.fromARGB(255, 255, 0, 0),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Text('Try again?', style: GoogleFonts.jollyLodger(fontSize: 30, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 219, 0, 0), letterSpacing: 4),),
                      ),
                      SizedBox(height: 60,)
                    ],
                  ),
                if (!isGameOver)
                  buildLetterButtons(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}