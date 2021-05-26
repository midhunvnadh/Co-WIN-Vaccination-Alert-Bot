import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';
import "../misc/loading.dart";
import "BotActivity.dart";

class Home extends StatefulWidget {
  final String title;
  const Home({Key? key, required this.title}) : super(key: key);
  _HomeActivity createState() => _HomeActivity(title);
}

class _HomeActivity extends State<Home> {
  final title;
  _HomeActivity(this.title);

  bool appSetupNeeded = false;
  bool loaded = false;
  int districtId = 0;

  Future refeshAppConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final stateIdio = prefs.getInt('stateId') ?? 0;
    final districtIdio = prefs.getInt('districtId') ?? 0;
    districtId = districtIdio;
    bool status;
    if (stateIdio != 0 && districtIdio != 0) {
      status = false;
    } else {
      status = true;
    }
    setState(() {
      appSetupNeeded = status;
      loaded = true;
    });
  }

  @override
  void initState() {
    refeshAppConfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: loaded
            ? (appSetupNeeded
                ? BotSetup(title)
                : BotActivity(title: title, districtId: districtId))
            : Loading(),
      ),
    );
  }
}

class BotSetup extends StatelessWidget {
  final title;
  BotSetup(this.title);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          child: Text(
            "Configure below to start receiving alerts.",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          padding: EdgeInsets.fromLTRB(30, 0, 10, 50),
        ),
        Padding(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/states');
            },
            child: Padding(
              child: Text('Setup', style: TextStyle(fontSize: 26)),
              padding: EdgeInsets.all(10),
            ),
          ),
          padding: EdgeInsets.all(30),
        )
      ],
    );
  }
}
