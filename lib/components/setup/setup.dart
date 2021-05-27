//import 'dart:convert';
import 'package:flutter/services.dart';

import "package:flutter/material.dart";
import '../../functions.dart';

import "dart:developer" as dev;

class Setup extends StatefulWidget {
  const Setup({Key? key}) : super(key: key);

  @override
  _Setup createState() => _Setup();
}

class _Setup extends State<Setup> {
  int stateId = -1;
  int districtId = -1;
  String pincode = "";
  String selectedState = "";
  String selectedDistrict = "";

  List districts = [];
  List districtsListio = [];
  bool loadingDistricts = false;

  List states = [];
  List statesListio = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Setup",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(15),
          children: [
            Text("Start by entering the details below",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
            chooseState(),
            chooseDistrict(),
            agePreferences(),
            enterPincode(),
            formErrors(),
          ],
        ),
      ),
      floatingActionButton: Container(
        height: 120,
        padding: EdgeInsets.fromLTRB(0, 0, 20, 70),
        child: floatContinue(),
      ),
    );
  }

  void initState() {
    super.initState();
    getStatesData();
  }

  void refreshStateId() {
    setState(() {
      stateId =
          getIdFromList(selectedState, "state_name", "state_id", statesListio);
    });
    getDistrictsData(stateId);
    setState(() {
      loadingDistricts = false;
    });
    refreshDistrictId();
  }

  void refreshDistrictId() {
    dev.log("Setting district ID");
    int districtIdNo = getIdFromList(
        selectedDistrict, "district_name", "district_id", districtsListio);
    dev.log(districtId.toString());
    setState(() {
      districtId = districtIdNo;
    });
  }

  Future getStatesData() async {
    List statesList = await getStates();
    setState(() {
      statesListio = statesList;
      states = [...statesList.map((e) => e["state_name"])];
      selectedState = states.first;
    });
    getDistrictsData(stateId);
    refreshStateId();
  }

  Future getDistrictsData(stateId) async {
    List districtsList = await getDistricts(stateId);
    if (districtsList.length > 0)
      setState(() {
        districtsListio = districtsList;
        districts = [...districtsList.map((e) => e["district_name"])];
        selectedDistrict = districts.first;
      });
    refreshDistrictId();
  }

  Column chooseState() {
    dev.log("");
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          child: Padding(
            child: Text(
              "Select state",
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
            padding: EdgeInsets.fromLTRB(0, 50, 0, 10),
          ),
          alignment: Alignment.topLeft,
        ),
        DropdownButton<String>(
          isExpanded: true,
          value: selectedState,
          iconSize: 24,
          elevation: 16,
          iconEnabledColor: Colors.black,
          style: const TextStyle(color: Colors.black, fontSize: 22),
          underline: Container(
            height: 0,
          ),
          onChanged: (String? newValue) {
            setState(() {
              loadingDistricts = true;
              selectedState = newValue!;
              refreshStateId();
            });
          },
          items:
              <String>[...states].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal)),
            );
          }).toList(),
          hint: Text(
            "Please choose your state",
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
          ),
        )
      ],
    );
  }

  Column chooseDistrict() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            child: Padding(
              child: Text(
                "Select district",
                style: TextStyle(
                  fontSize: 21,
                  color: loadingDistricts ? Colors.black26 : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              padding: EdgeInsets.fromLTRB(0, 50, 0, 10),
            ),
            alignment: Alignment.topLeft,
          ),
          DropdownButton<String>(
            isExpanded: true,
            value: selectedDistrict,
            iconSize: 24,
            elevation: 16,
            iconEnabledColor: Colors.black,
            style: TextStyle(
              color: loadingDistricts ? Colors.black26 : Colors.black,
              fontSize: 22,
            ),
            underline: Container(
              height: 0,
            ),
            onChanged: loadingDistricts
                ? null
                : (String? newValue) {
                    setState(() {
                      selectedDistrict = newValue!;
                      refreshDistrictId();
                    });
                  },
            items: <String>[...districts]
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value,
                    style: TextStyle(
                        color: loadingDistricts ? Colors.black26 : Colors.black,
                        fontWeight: FontWeight.normal)),
              );
            }).toList(),
            hint: Text(
              "Please choose your district",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
          )
        ]);
  }

  Column enterPincode() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            child: Padding(
              child: Text(
                "Enter pincode",
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              padding: EdgeInsets.fromLTRB(0, 50, 0, 10),
            ),
            alignment: Alignment.topLeft,
          ),
          TextField(
            decoration: InputDecoration(labelText: "Enter your pincode"),
            keyboardType: TextInputType.number,
            onChanged: (n) {
              setState(() {
                pincode = n;
              });
            },
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
          )
        ]);
  }

  int _radioValue = 0;
  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          break;
        case 1:
          break;
        case 2:
          break;
      }
    });
  }

  Container agePreferences() {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Age preference",
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
            Row(
                children: [
                  Row(children: [
                    Text("18+",
                        style: TextStyle(
                          fontSize: 18,
                        )),
                    Radio(
                      value: 0,
                      groupValue: _radioValue,
                      onChanged: (int? val) => {_handleRadioValueChange(val!)},
                    ),
                  ]),
                  Row(children: [
                    Text("45+",
                        style: TextStyle(
                          fontSize: 18,
                        )),
                    Radio(
                      value: 1,
                      groupValue: _radioValue,
                      onChanged: (int? val) => {_handleRadioValueChange(val!)},
                    ),
                  ]),
                  Row(children: [
                    Text("Both",
                        style: TextStyle(
                          fontSize: 18,
                        )),
                    Radio(
                      value: 2,
                      groupValue: _radioValue,
                      onChanged: (int? val) => {_handleRadioValueChange(val!)},
                    ),
                  ]),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center)
          ],
        ));
  }

  Column formErrors() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(stateId == -1 ? "Select your state" : "",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.red)),
          Text(districtId == -1 ? "Select your district" : "",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.red)),
          Text(pincode.length != 6 ? "Pincode must be 6 digits" : "",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.red)),
          /*Text("StateID: $stateId, districtId: $districtId",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.red)),*/
        ]);
  }

  void saveSettings() {
    Map settings = {
      "setup": true,
      "districtId": districtId,
      "stateId": stateId,
      "stateName": selectedState,
      "districtName": selectedDistrict,
      "pinCode": pincode,
      "age_preference": _radioValue
    };
    setSettings(settings);
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  FloatingActionButton floatContinue() {
    bool enable =
        (stateId != -1) && (districtId != -1) && (pincode.length == 6);
    return FloatingActionButton.extended(
      onPressed: enable ? saveSettings : () {},
      label: Text('Continue'),
      icon: enable ? Icon(Icons.arrow_forward) : Icon(Icons.cancel),
      backgroundColor: enable ? Colors.blue : Colors.red,
    );
  }
}
