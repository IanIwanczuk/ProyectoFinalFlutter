import 'dart:convert';
import 'dart:math';
import 'package:gamehub/resources/timer.dart';
import 'package:http/http.dart' as http;

import '../screens/screens.dart';

class Countries extends StatefulWidget {
  const Countries({super.key});

  @override
  State<Countries> createState() => _CountriesState();
}

class _CountriesState extends State<Countries> {
  late double screenWidth = MediaQuery.of(context).size.width;
  late double screenHeight = MediaQuery.of(context).size.height;
  List<Map<String, dynamic>> countryList = [];
  List<Map<String, dynamic>> options = [];
  
  Map<String, dynamic>? secretCountry;
  late bool isGameOver;
  late bool isGameWon;
  late int correctAnswer;
  late int count;


  @override
  void initState() {
    super.initState();
    count = 0;
    startGame();
  }

  startNewGame() {
    if (!isGameWon) {
      count = 0;
    }
    startGame();
  }

  Future<void> startGame() async {
    if (countryList.isEmpty) {
      countryList = await getCountryList();
    }
    Random random = Random();
    int randomIndex = random.nextInt(countryList.length);

    secretCountry = countryList[randomIndex];
    int secretIndex = randomIndex;
    correctAnswer = random.nextInt(4) + 1;

    int count = 1;
    while ((randomIndex = random.nextInt(countryList.length)) != secretIndex && options.length != 4) {
      if (count == correctAnswer) {
        options.add(secretCountry!); count++;
        continue;
      }
      options.add(countryList[randomIndex]); count++;
    }
    setState(() {
      isGameOver = false; isGameWon = false;
    });
  }

  Future<List<Map<String, dynamic>>> getCountryList() async {
    final url = Uri.parse("https://flagcdn.com/en/codes.json"); 
    final response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);

      List<Map<String, dynamic>> dataList = jsonData.entries.map((entry) => {entry.key: entry.value}).toList();

      return dataList;
    } else {
      throw Exception("Failed to load countryList");
    }
  }

  void onTimerReset() {
    isGameOver = true; isGameWon = false;
    options.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, AppRoutes.homescreen, "backbutton.png"),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/countriesbg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: secretCountry == null
            ? const CircularProgressIndicator(color: Colors.green,)
            : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("$count", textAlign: TextAlign.center, style: GoogleFonts.fredoka(fontSize: 25, color: const Color.fromARGB(255, 0, 65, 2)),),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(5), 
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(78, 0, 0, 0),
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      "https://flagcdn.com/h240/${secretCountry!.keys.first}.png",
                      fit: BoxFit.cover,
                    )
                  ),
                ),
                SizedBox(height: 20,),

                if (isGameOver)
                  Column(
                    children: [
                      SizedBox(height: 20),
                      Text(secretCountry!.values.first, textAlign: TextAlign.center, style: GoogleFonts.fredoka(fontSize: secretCountry!.values.first.length > 9 ? 40 : 60, color: isGameWon ? const Color.fromARGB(255, 0, 65, 2) : const Color.fromARGB(255, 65, 4, 0)),),
                      SizedBox(height: 40,),
                    ],
                  ),
                if (isGameOver)
                  ElevatedButton(
                    onPressed: () {
                      options.clear();
                      startNewGame();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isGameWon ? Colors.green : Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      elevation: 4,
                    ),
                    child: Text(isGameWon ? "Siguiente" : "Reintentar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  ),

                if (!isGameOver)
                  SizedBox(height: 40,),
                if (!isGameOver)
                  SizedBox(
                    width: screenWidth-20,
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        mainAxisExtent: 80, 
                      ),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        final option = options[index];

                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            backgroundColor: Colors.white,
                            elevation: 2,
                            shadowColor: Color.fromARGB(255, 0, 0, 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: BorderSide(
                                color: Color(0xFF855B00),
                                width: 1,
                              ),
                            ),
                          ),
                          onPressed: () => {
                            isGameOver = true,

                            if (option.values.first == secretCountry!.values.first) {
                              isGameWon = true,
                              count++,
                            } else {
                              isGameWon = false,
                            },
                            setState(() {}),
                          },
                          child: Text(option.values.first, textAlign: TextAlign.center, style: GoogleFonts.krub(fontSize: options[index].values.first.length > 14 ? 15 : 20, fontWeight: FontWeight.w500, color: Color(0xFF855B00)),) ,
                        );
                      },
                    ),
                  ),
                if (!isGameOver)
                  SizedBox(height: 40,),
                if (!isGameOver)
                  TimerWidget(onTimerReset: onTimerReset),
                
              ]
            ),
        )
      )
    );
  }
}