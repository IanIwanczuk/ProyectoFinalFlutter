import '../screens/screens.dart';

/**
 * Clase que utilizamos para guardar recursos varios, estilos para botones o widgets específicos en cada
 * pantalla o parte del código
 */

/// Método para generar el AppBar que se repite en todas las pantallas, recibe como
/// parámetros el context, la ruta a la que nos envía el botón, y la imagen del botón
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

/// Capitalizamos la primera letra de un String
String capitalizeFirstLetter(String? str) {
  if (str == null) {
    return "null";
  }
  return str[0].toUpperCase() + str.substring(1);
}

/// Método para cenerar los contenedores en la pantalla principal, recibe comoo parametros el ancho de la
/// pantalla, el texto del juego, el estilo del juego, la ruta a la que lleva el contenedor, y el context
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

/// Método simple para lanzar un alertDialog, le pasamos el context, el título
/// y el mensaje
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

/// Método que genera los botones del BlackJack, le pasamos como parámetro el color del fondo, el color del borde,
/// el color de la fuente, la función que va a ejecutar el botón, y el texto de dentro
ElevatedButton generateBlackJackButton(Color background, Color border, Color fontColor, Function() func, String text) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: background,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: border,
          width: 2,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    onPressed: func,
    child: Text(
      text,
      style: GoogleFonts.joan(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: fontColor,
      ),
    ),
  );
}