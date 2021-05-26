import 'package:flutter/material.dart';
import "../components/ChooseState.dart";
import "../components/ChooseDistrict.dart";
import '../components/Home.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    final name = settings.name;
    final title = "CoWIN Vaccination Bot";
    switch (name) {
      case '/':
        return MaterialPageRoute(builder: (_) => Home(title: title));
      case "/states":
        return MaterialPageRoute(builder: (_) => ChooseState(title: title));
      case "/states/districts":
        if (args is int) {
          return MaterialPageRoute(
              builder: (_) => ChooseDistrict(title: title, stateId: args));
        }
    }
    return MaterialPageRoute(builder: (_) => Home(title: title));
  }
}
