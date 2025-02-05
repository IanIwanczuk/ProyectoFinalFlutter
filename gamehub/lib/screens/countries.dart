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
  bool isGameOver = false;
  late int correctAnswer;


  @override
  void initState() {
    super.initState();
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
    setState(() {});
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
    print("Tiempo acabado");
    isGameOver = true;
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
                if (!isGameOver)
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // ✅ 2 columns
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      final option = options[index];

                      return ElevatedButton(
                        onPressed: () => {
                          if (option.values.first == secretCountry!.values.first) {
                            print("EXITO... Opción: ${option.values.first}  Respuesta: ${secretCountry!.values.first}"),
                          } else {
                            print("ERROR!!! Opción: ${option.values.first}  Respuesta: ${secretCountry!.values.first}"),
                          }
                        },
                        child: Text(option.values.first),
                      );
                    },
                  ),
                if (!isGameOver)
                  TimerWidget(onTimerReset: onTimerReset),
              ]
            ),
        )
      )
    );
  }
}