import 'dart:convert';
import 'dart:math';
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
  Map<String, dynamic>? secretCountry;


  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    List<Map<String, dynamic>> countryList = await getCountryList();

    Random random = Random();
    int randomIndex = random.nextInt(countryList.length); // Generate a random index
    secretCountry = countryList[randomIndex];
    print(secretCountry!.keys.first);
    setState(() {});
  }

  Future<List<Map<String, dynamic>>> getCountryList() async {
  final url = Uri.parse("https://flagcdn.com/en/codes.json"); // Replace with your API URL
  final response = await http.get(url);

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonData = json.decode(response.body);

    // Convert the Map into a List of key-value pairs
    List<Map<String, dynamic>> dataList = jsonData.entries
        .map((entry) => {entry.key: entry.value})
        .toList();

    return dataList;
  } else {
    throw Exception("Failed to load countryList");
  }
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
                const Text("AAAAA"),
              ]
            ),
        )
      )
    );
  }
}