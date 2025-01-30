import '../screens/screens.dart';

class AppRoutes {
  static const String login = '/';
  static const String register = '/Register';
  static const String homescreen = '/Homescreen';
  static const String updatedata = '/Updatescreen';
  static const String blackjack = '/Blackjack';


  // Mapa de rutas
  static final Map<String, WidgetBuilder> routes = {
    login: (context) => const HomeW(), 
    register: (context) => const RegisterScreen(),
    homescreen: (context) => const HomeScreen(),
    updatedata: (context) => const UpdateData(),
    blackjack: (context) => const Blackjack(),
  };
}
