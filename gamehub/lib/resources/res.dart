import '../screens/screens.dart';

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