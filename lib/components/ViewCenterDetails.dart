import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';
import "../functions.dart";
import "./SessionUnit.dart";

class ViewCenterDetails extends StatelessWidget {
  final Map center;

  ViewCenterDetails(this.center);

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(
        title: Text("Vaccination center details"),
      ),
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                  child: Card(
                color: Colors.blue,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                          child: Text(
                        center["name"],
                        style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )),
                      Column(
                        children: [
                          Container(
                              padding: EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  Text(
                                    center["address"],
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              )),
                          Row(
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
                                    icon: const Icon(
                                        Icons.monetization_on_rounded),
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
                                    icon: const Icon(Icons.date_range),
                                    color: Colors.white,
                                    onPressed: () {},
                                  ),
                                  Text("${center["sessions"].length} sessions",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))
                                ],
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )),
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    ...center["sessions"].map((session) => SessionUnit(session))
                  ],
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                ),
              )
            ],
          )
        ],
      ),
    ));
  }
}
