import '../screens/screens.dart';

class AppRoutes {
  static const String home = '/';
  static const String register = '/Register';


  // Mapa de rutas
  static final Map<String, WidgetBuilder> routes = {
    home: (context) => const HomeW(), 
    register: (context) => const RegisterScreen(),
  };
}
