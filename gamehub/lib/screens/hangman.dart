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
  List<String> _words = [];
  String? _secretWord;
  final Set<String> _guessedLetters = {};
  int _errorCount = 0;
  final int _maxErrors = 6;
  bool _isGameOver = false;
  bool _isGameWon = false;

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  Future<void> _loadWords() async {
    try {
      final String data = await rootBundle.loadString('lib/resources/words.json');
      final List<dynamic> jsonResult = json.decode(data);
      setState(() {
        _words = jsonResult.cast<String>();
        _startNewGame();
      });
    } catch (e) {
      debugPrint("Error loading words: $e");
    }
  }

  void _startNewGame() {
    setState(() {
      _guessedLetters.clear();
      _errorCount = 0;
      _isGameOver = false;
      _isGameWon = false;
      if (_words.isNotEmpty) {
        final random = Random();
        _secretWord = _words[random.nextInt(_words.length)].toUpperCase();
      } else {
        _secretWord = null;
      }
    });
  }

  void _guessLetter(String letter) {
    if (_isGameOver || _secretWord == null || _guessedLetters.contains(letter)) return;

    setState(() {
      _guessedLetters.add(letter);

      if (!_secretWord!.contains(letter)) {
        _errorCount++;
        if (_errorCount >= _maxErrors) {
          _isGameOver = true;
        }
      } else {
        bool allGuessed = true;
        for (int i = 0; i < _secretWord!.length; i++) {
          if (!_guessedLetters.contains(_secretWord![i])) {
            allGuessed = false;
            break;
          }
        }
        if (allGuessed) {
          _isGameWon = true;
          _isGameOver = true;
        }
      }
    });
  }

  Widget _buildWordDisplay() {
    if (_secretWord == null) return Container();

    List<Widget> letters = [];
    for (int i = 0; i < _secretWord!.length; i++) {
      String char = _secretWord![i];
      letters.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            _guessedLetters.contains(char) ? char : '_',
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

  Widget _buildLetterButton(String letter) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ElevatedButton(
        onPressed: _guessedLetters.contains(letter) || _isGameOver ? null : () => _guessLetter(letter),
        style: ElevatedButton.styleFrom(
          backgroundColor: _guessedLetters.contains(letter) || _isGameOver
              ? Colors.transparent
              : Color.fromARGB(255, 139, 0, 0),
          shadowColor: _guessedLetters.contains(letter) || _isGameOver
              ? Colors.transparent
              : Color(0x005FBEF9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: _guessedLetters.contains(letter) || _isGameOver
                  ? Colors.transparent
                  : Color.fromARGB(255, 255, 82, 82),
              width: 1,
            ),
          ),
        ),
        child: Text(letter, style: GoogleFonts.kanit(
          color: _guessedLetters.contains(letter) || _isGameOver ? Colors.transparent : Color.fromARGB(255, 255, 82, 82),
          fontSize: 20,
          fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  Widget _buildLetterButtons() {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    return Wrap(
      alignment: WrapAlignment.center,
      children: letters.split('').map((letter) => _buildLetterButton(letter)).toList(),
    );
  }

  Widget _buildHangmanImage() {
    String imagePath = 'assets/images/hangman$_errorCount.png';
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
        // The game UI starts here.
        child: Center(
          child: _secretWord == null ? const CircularProgressIndicator() : SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildHangmanImage(),
              const SizedBox(height: 20),
              _buildWordDisplay(),
              const SizedBox(height: 20),
              _buildLetterButtons(),
              const SizedBox(height: 20),
              // Show game over or win messages.
              if (_isGameOver)
                Column(
                  children: [
                    Text(
                      _isGameWon ? 'Ganaste' : 'Perdiste',
                      style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'The word was: ${_secretWord!}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _startNewGame,
                      child: const Text('Restart Game'),
                    ),
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