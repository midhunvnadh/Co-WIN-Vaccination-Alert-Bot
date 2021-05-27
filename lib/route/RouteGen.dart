import 'package:flutter/material.dart';
import '../components/setup/setup.dart';
import '../components/Home.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //final args = settings.arguments;
    final name = settings.name;
    final title = "CoWIN Vaccination Bot";
    switch (name) {
      case '/':
        return MaterialPageRoute(builder: (_) => Home(title: title));
      case "/setup":
        return MaterialPageRoute(builder: (_) => Setup());
    }
    return MaterialPageRoute(builder: (_) => Home(title: title));
  }
}
