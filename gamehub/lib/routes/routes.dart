import '../screens/screens.dart';

class AppRoutes {
  static const String home = '/';


  // Mapa de rutas
  static final Map<String, WidgetBuilder> routes = {
    home: (context) => const HomeW(),
  };
}
