import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as dev;

const String apiURL = "https://cdn-api.co-vin.in/api";

Future<List> getStates() async {
  final response =
      await http.get(Uri.parse("$apiURL/v2/admin/location/states"));

  if (response.statusCode == 200) {
    List responseContent = json.decode(response.body)["states"];
    return responseContent;
  } else {
    await sleep(60);
    return getStates();
  }
}

Future<List> getDistricts(stateId) async {
  final response =
      await http.get(Uri.parse("$apiURL/v2/admin/location/districts/$stateId"));
  if (response.statusCode == 200) {
    List responseContent = json.decode(response.body)["districts"];
    return responseContent;
  } else {
    await sleep(60);
    return getDistricts(stateId);
  }
}

Future<List> getVaccinationCenters(districtId) async {
  final String today = getCurrentTime('dd-MM-yyyy');

  Uri uri = Uri.parse(
      "https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByDistrict?district_id=$districtId&date=$today");

  var response = await http.get(uri);
  if (response.statusCode == 200) {
    List responseContent = json.decode(response.body)["centers"];
    return responseContent;
  } else {
    await sleep(60);
    return getVaccinationCenters(districtId);
  }
}

int getIdFromList(
    String chosen, String identifierName, String idName, List list) {
  var listLen = list.length;
  for (int i = 0; i < listLen; i++) {
    if (list[i][identifierName] == chosen) {
      return list[i][idName];
    }
  }
  return -1;
}

void setSettings(stateId, districtId) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('stateId', stateId);
  prefs.setInt('districtId', districtId);
}

sleep(n) async {
  dev.log("Sleeping for $n");
  return await Future.delayed(Duration(seconds: n));
}

getInfoFromCenter(center) {
  return {
    'name': center["name"],
    'address': center["address"],
    'district': center["district_name"],
    'duration': center["from"] + " - " + center["to"],
    'fee_type': center["fee_type"],
    'sessions': center["sessions"]
  };
}

filterAsAvailableCenters(List centers, showFilled) {
  if (showFilled) return centers;

  List usable = [];
  for (int i = 0; i < centers.length; i++) {
    Map center = centers[i];
    int availableCapacity = getAvailableCapacity(center);
    if (availableCapacity > 0) {
      usable.addAll([center]);
    }
  }
  return usable;
}

getAvailableCapacity(Map center) {
  List sessions = center["sessions"];
  num available = 0;
  for (int j = 0; j < sessions.length; j++) {
    Map session = sessions[j];
    available += session["available_capacity"];
  }
  return available;
}

excerpt(String string, length) {
  String expt = string.length < length ? "" : "...";
  length = string.length < length ? string.length : length;
  return string.substring(0, length) + expt;
}

getCurrentTime(format) {
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat(format);
  final String today = formatter.format(now);
  return today;
}
