import 'package:flutter/material.dart';
import 'dart:async';
import '../functions.dart';
import "../misc/loading.dart";
import "./notification.dart";
import "./ViewCenterDetails.dart";

class BotActivity extends StatefulWidget {
  final String title;
  final int districtId;
  const BotActivity({Key? key, required this.title, required this.districtId})
      : super(key: key);
  _BotActivity createState() => _BotActivity(title, districtId);
}

class _BotActivity extends State<BotActivity> {
  final title;
  int districtId;

  _BotActivity(this.title, this.districtId);

  List response = [];
  bool showFilled = false;
  bool loaded = false;
  String lastUpdated = "";
  int lastVaccinationCentersAmount = 0;
  void updateResponse(districtId, Notifications notifications) async {
    if (mounted) {
      List resp = await getVaccinationCenters(districtId);
      setState(() {
        lastUpdated = getCurrentTime("hh:mm:ss a dd-MM-yyyy");
        response = resp;
        loaded = true;
      });
      List available = filterAsAvailableCenters(response, false);
      notifications.setContext(context);
      if (available.length > 0 &&
          lastVaccinationCentersAmount != available.length) {
        notifications.showNtf("Vaccination centers available",
            "${available.length} vaccination centers available");
      }
      lastVaccinationCentersAmount = available.length;
    }
  }

  Timer _timer(Notifications notifications) {
    updateResponse(districtId, notifications);
    Timer refresh = Timer.periodic(new Duration(seconds: 15), (refresh) {
      if (mounted) updateResponse(districtId, notifications);
      if (!mounted) refresh.cancel();
    });
    return refresh;
  }

  @override
  void initState() {
    super.initState();
    Notifications notifications = Notifications(context);
    _timer(notifications);
  }

  @override
  Widget build(BuildContext context) {
    List centersList =
        showFilled ? response : filterAsAvailableCenters(response, showFilled);
    bool showShowAvailableButton =
        ((response.length - filterAsAvailableCenters(response, false).length) ==
            0);
    return (loaded)
        ? Container(
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ((showShowAvailableButton
                          ? SizedBox.shrink()
                          : showUnavailable())),
                      clearSettings(),
                    ],
                  ),
                  padding: EdgeInsets.all(15),
                ),
                botStatus(
                    filterAsAvailableCenters(response, showFilled)
                        .length
                        .toString(),
                    showFilled,
                    lastUpdated),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  height: 320,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: []..addAll(centersList
                        .map((centl) =>
                            CustomCard(center: getInfoFromCenter(centl)))
                        .toList()),
                  ),
                )
              ],
            ),
          )
        : Loading();
  }

  Column botStatus(availableCenters, showFilled, lastUpdated) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            padding: EdgeInsets.fromLTRB(0, 60, 0, 30),
            child: Text(
              (showFilled ? "All" : "Available") + " vaccination\ncenters",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            )),
        Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
            child: Text(
              availableCenters,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 100, fontWeight: FontWeight.bold),
            )),
        Container(child: Text("Last updated: $lastUpdated"))
      ],
    );
  }

  Padding clearSettings() {
    return Padding(
      child: Ink(
        decoration: const ShapeDecoration(
          color: Colors.blue,
          shape: CircleBorder(),
        ),
        child: IconButton(
          icon: const Icon(Icons.settings),
          color: Colors.white,
          onPressed: () async {
            deleteSettings();
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
          },
        ),
      ),
      padding: EdgeInsets.all(5),
    );
  }

  Padding showUnavailable() {
    return Padding(
      child: ElevatedButton.icon(
          onPressed: () {
            setState(() {
              showFilled = !showFilled;
            });
          },
          icon: Padding(
            child: Icon(
              showFilled ? Icons.close : Icons.done,
              color: Colors.white,
              size: 24.0,
            ),
            padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
          ),
          style: ElevatedButton.styleFrom(
            primary: showFilled ? Colors.red.shade300 : Colors.blue.shade700,
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(50),
            ),
          ),
          label: Padding(
            child: Text(
              (showFilled ? "Hide " : "Show ") + "Filled",
              style: TextStyle(fontSize: 21),
            ),
            padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
          )),
      padding: EdgeInsets.all(5),
    );
  }
}

class CustomCard extends StatelessWidget {
  final Map center;
  CustomCard({Key? key, required this.center}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final availableCapacity = getAvailableCapacity(center);
    return Container(
      child: Center(
        child: Card(
          color: availableCapacity > 0
              ? Colors.blue.shade700
              : Colors.blue.shade400,
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewCenterDetails(center)),
              );
            },
            child: Container(
              child: Padding(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 80,
                        child: Text(excerpt(center["name"], 25),
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                      Container(
                        child: Text(center["duration"],
                            style: TextStyle(
                                color: Colors.white60,
                                fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.location_pin),
                                  color: Colors.white,
                                  onPressed: () {},
                                  padding: EdgeInsets.all(0),
                                ),
                                Text(excerpt(center["district"], 13),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                            Column(
                              children: [
                                IconButton(
                                  icon:
                                      const Icon(Icons.monetization_on_rounded),
                                  color: Colors.white,
                                  onPressed: () {},
                                ),
                                Text(center["fee_type"],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Column(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.people),
                                  color: Colors.white,
                                  onPressed: () {},
                                ),
                                Text(availableCapacity.toString() + " left",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold))
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Text(
                            excerpt(center["address"], 58),
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  ),
                  padding: EdgeInsets.all(20)),
              width: 300,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
