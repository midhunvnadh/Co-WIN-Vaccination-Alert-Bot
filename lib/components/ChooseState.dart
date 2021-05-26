import 'package:cowin_vaccination_bot/functions.dart';
import "package:flutter/material.dart";
import '../functions.dart';
import "../misc/loading.dart";

//import "dart:developer" as dev;
//import "dart:convert";

class ChooseState extends StatefulWidget {
  final String title;
  const ChooseState({Key? key, required this.title}) : super(key: key);
  _States createState() => _States(title);
}

class _States extends State<ChooseState> {
  void setStateFunc;
  late String title;
  List states = [];
  List statesListio = [];
  String selected = "";
  bool loaded = false;
  _States(this.title);

  Future getStatesData() async {
    List statesList = await getStates();
    setState(() {
      statesListio = statesList;
      states = [...statesList.map((e) => e["state_name"])];
      selected = states.first;
      loaded = true;
    });
  }

  void initState() {
    getStatesData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List statesList = states;
    int stateId =
        getIdFromList(selected, "state_name", "state_id", statesListio);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: loaded
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Select your state",
                              style: TextStyle(
                                  fontSize: 26, fontWeight: FontWeight.bold)),
                          Container(
                              padding: const EdgeInsets.fromLTRB(0, 50, 0, 50),
                              child: DropdownButton<String>(
                                value: selected,
                                iconSize: 24,
                                elevation: 16,
                                iconEnabledColor: Colors.black,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 22),
                                underline: Container(
                                  height: 0,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selected = newValue!;
                                  });
                                },
                                items: <String>[
                                  ...statesList
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal)),
                                  );
                                }).toList(),
                                hint: Text(
                                  "Please choose your state",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              )),
                        ],
                      )),
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: FloatingActionButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/states/districts',
                                arguments: stateId);
                          },
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 24.0,
                            semanticLabel: 'Go Next',
                          ),
                          backgroundColor: Colors.blue,
                        )))
              ],
            ))
          : Loading(),
    );
  }
}
