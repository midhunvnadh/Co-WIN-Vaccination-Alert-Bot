import 'package:flutter/material.dart';
import "route/RouteGen.dart";

void main() {
  runApp(CoWINbot());
}

class CoWINbot extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoWIN Vaccination Bot',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: "/",
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
