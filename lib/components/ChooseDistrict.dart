import "package:flutter/material.dart";
import '../functions.dart';
import '../misc/loading.dart';

//import "dart:developer" as dev;
//import "dart:convert";

class ChooseDistrict extends StatefulWidget {
  final int stateId;
  final String title;
  const ChooseDistrict({Key? key, required this.stateId, required this.title})
      : super(key: key);
  _Districts createState() => _Districts(stateId, title);
}

class _Districts extends State<ChooseDistrict> {
  int stateId;
  String title = "";
  String selected = "";
  List districtsListio = [];
  List districts = [];

  bool loaded = false;

  _Districts(this.stateId, this.title);

  Future getDistrictsData(stateId) async {
    List districtsList = await getDistricts(stateId);
    setState(() {
      districtsListio = districtsList;
      districts = [...districtsList.map((e) => e["district_name"])];
      selected = districts.first;
      loaded = true;
    });
  }

  @override
  void initState() {
    getDistrictsData(stateId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List districtsList = districts;
    int districtId = getIdFromList(
        selected, "district_name", "district_id", districtsListio);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          this.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
          child: loaded
              ? Column(
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
                              Text("Select your district",
                                  style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold)),
                              Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 50, 0, 50),
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
                                    items: <String>[...districtsList]
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal)),
                                      );
                                    }).toList(),
                                    hint: Text(
                                      "Please choose your district",
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
                                setSettings(stateId, districtId);
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/', (Route<dynamic> route) => false);
                              },
                              child: Icon(
                                Icons.save,
                                color: Colors.white,
                                size: 24.0,
                                semanticLabel: 'Go Next',
                              ),
                              backgroundColor: Colors.blue,
                            )))
                  ],
                )
              : Loading()),
    );
  }
}
