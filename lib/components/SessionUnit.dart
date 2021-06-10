import "package:flutter/material.dart";

class SessionUnit extends StatelessWidget {
  final Map session;

  SessionUnit(this.session);

  @override
  Widget build(BuildContext context) {
    return (Card(
        child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.event),
                          color: Colors.blue,
                          onPressed: () {},
                        ),
                        Text(
                          session["date"],
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        )
                      ],
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.healing),
                          color: Colors.blue,
                          onPressed: () {},
                        ),
                        Text(session["vaccine"],
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.accessibility),
                          color: Colors.blue,
                          onPressed: () {},
                        ),
                        Text(session["min_age_limit"].toString() + "+",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.supervised_user_circle),
                          color: Colors.blue,
                          onPressed: () {},
                        ),
                        Text(
                            session["available_capacity"].toString() +
                                " slots left",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 12),
                  margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                  decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.all(Radius.circular(6))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      session["available_capacity_dose1"] != null
                          ? (Column(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.done),
                                  color: Colors.white,
                                  onPressed: () {},
                                ),
                                Text(
                                    session["available_capacity_dose1"]
                                            .toString() +
                                        " Dose 1",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold))
                              ],
                            ))
                          : Text(""),
                      session["available_capacity_dose2"] != null
                          ? (Column(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.done_all),
                                  color: Colors.white,
                                  onPressed: () {},
                                ),
                                Text(
                                    session["available_capacity_dose2"]
                                            .toString() +
                                        " Dose 2",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold))
                              ],
                            ))
                          : Text("")
                    ],
                  ),
                )
              ],
            ))));
  }
}
