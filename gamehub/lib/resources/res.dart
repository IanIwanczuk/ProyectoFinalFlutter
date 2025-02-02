import '../screens/screens.dart';
import 'package:intl/intl.dart';

AppBar getAppBar(context, String route, String leftbutton) {
  return AppBar(
    leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, route);
        },
        child: SizedBox(
          child: Image.asset('assets/images/$leftbutton', fit: BoxFit.cover,),
        ),
      ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 6),
        child: Image.asset('assets/images/joystick.png', height: 35,),
      ),
    ],
  );
}

RoundedRectangleBorder getFloatingActStyle() {
  return RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
    side: BorderSide(
      color: const Color.fromARGB(255, 255, 174, 0),
      width: 2,
    ),
  );
}

String capitalizeFirstLetter(String? str) {
  if (str == null) {
    return "null";
  }
  return str[0].toUpperCase() + str.substring(1);
}

GestureDetector getGameContainer(double screenWidth, String image, String textLabel, TextStyle textStyle, String route, context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, "/$route");
      },
      child: Container(
        width: screenWidth,
        height: 200,
        decoration : BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/$image'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 5,
              left: 15,
              child: Text(
                textLabel,
                style: textStyle,
              ),
            ),
          ],
        ),
      ),
    );
}

Container buildTimeContainer() {
  String currentTime = DateFormat('HH:mm.ss').format(DateTime.now());

  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.blueAccent,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.black,
          blurRadius: 6,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Text(
      currentTime,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

void alertDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title, style: TextStyle(fontSize: 30, color: const Color.fromARGB(255, 0, 43, 117), fontWeight: FontWeight.bold),),
        content: Text(message, style: TextStyle(fontSize: 20),),
        backgroundColor: const Color.fromARGB(255, 196, 211, 255),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      );
    },
  );
}