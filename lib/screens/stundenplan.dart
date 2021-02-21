import 'package:flutter/material.dart';
import 'package:vertretungsplan_app/models/stunde.dart';
import 'package:vertretungsplan_app/models/stundenplan.dart';
import 'dart:developer' as developer;
import 'package:vertretungsplan_app/models/tag.dart';
import 'package:vertretungsplan_app/utils/lehrernamen_parser.dart';
import 'package:vertretungsplan_app/utils/stundenplan_parser.dart';
import 'package:intl/intl.dart';
import 'package:vertretungsplan_app/utils/ui/listitem.dart';

import '../main.dart';

class StundenplanScreen extends StatefulWidget {
  StundenplanScreen({Key key}) : super(key: key);

  @override
  _StundenplanScreen createState() => _StundenplanScreen();
}

class _StundenplanScreen extends State<StundenplanScreen> {
  Future<List<Object>> _getStundenplan() async {
    StundenplanParser stundenplanParser = new StundenplanParser(nutzer.headers,
        'https://start.schulportal.hessen.de/stundenplan.php?a=detail_klasse&e=1');
    Stundenplan plan = await stundenplanParser.parsen();
    List<Object> objects = [];
    objects.add(plan.klasse.name);
    objects.add(plan.gueltigkeit);
    objects.add(plan.stunden);

    return objects;
  }

  @override
  Widget build(BuildContext context) {
    return StundenplanWidget();
  }

  Widget StundenplanWidget() {
    return FutureBuilder(
        future: _getStundenplan(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(
              child: Center(
                  child: CircularProgressIndicator(
                value: null,
              )),
            );
          } else if (snapshot.data.length == 0) {
            return Container(
              child: Center(
                child: Text("Es gab Fehler beim Laden des Stundenplans!"),
              ),
            );
          } else {
            List<Object> plan = snapshot.data;

            return ListView.builder(
                // ignore: missing_return
                itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Container(
                    child: Padding(
                        child: Text(
                          "Stundenplan für die Klasse ${plan.elementAt(0)}",
                          style: TextStyle(fontSize: 20),
                        ),
                        padding: EdgeInsets.only(bottom: 10)));
              }
              if (index == 1) {
                DateTime d =
                    new DateFormat("yyyy-MM-dd").parse(plan.elementAt(1));
                final DateFormat formatter = DateFormat('dd.MM.yyyy');

                return Container(
                    child: Padding(
                        child: Text(
                          "Gültig ab ${formatter.format(d)}",
                          style: TextStyle(fontSize: 15),
                        ),
                        padding: EdgeInsets.only(bottom: 10)));
              }
              if (index == 2) {
                return Table(
                  border: TableBorder.all(color: Color(0xFF000000)),
                  children: getRows(plan),
                );
              }
            });
          }
        });
  }

  List<TableRow> getRows(List<Object> o) {
    List<TableRow> l = [];
    TextStyle style = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
    l.add(TableRow(children: [
      TableCell(child: Center(child: Text('Stunde', style: style))),
      TableCell(child: Center(child: Text('Mo', style: style))),
      TableCell(child: Center(child: Text('Di', style: style))),
      TableCell(child: Center(child: Text('Mi', style: style))),
      TableCell(child: Center(child: Text('Do', style: style))),
      TableCell(child: Center(child: Text('Fr', style: style))),
    ]));
    if (o[2] is Map) {
      Map<int, List<List<Stunde>>> map = o[2];

      for (var x = 0; x < map.length; x++) {
        List<TableCell> cells = [];

        var zeit = map[x + 1][0][0].zeitraum;
        var split = zeit.split("-");
        cells.add(TableCell(
            child: Padding(
                child: Column(children: <Widget>[
                  Row(
                    children: [
                      Center(
                          child: Text("${x + 1}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)))
                    ],
                  ),
                  Row(
                    children: [Divider(height: 10, color: Colors.white)],
                  ),
                  Row(children: [
                    Text("${split[0]} -",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15))
                  ]),
                  Row(children: [
                    Text("${split[1]}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15))
                  ])
                ]),
                padding: EdgeInsets.only(top: 30))));
        for (var stunden in map[x + 1]) {
          List<Widget> children = [];
          var sc = 0;
          for (var stunde in stunden) {
            sc++;

            if (stunde.fach.kuerzel == "Frei" &&
                stunde.lehrer.kuerzel == "Frei" &&
                stunde.raum.name == "Frei") {
              children.add(Center(child: Text("---", style: style)));
            } else {
              MessageItem m = MessageItem(
                  "${stunde.fach.kuerzel} (${stunde.lehrer.kuerzel})",
                  stunde.raum.name);
              //Bottom Sheet Popup: https://www.youtube.com/watch?v=pDBjEmYU0nw
              children.add(GestureDetector(
                child: Center(child: m.buildTitle(context)),
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext bc) {
                        return Container(
                            height: MediaQuery.of(context).size.height * .6,
                            child: Padding(
                              child: Column(children: <Widget>[
                                Row(children: <Widget>[
                                  Text(
                                    "${stunde.stunde}. Stunde am ${stunde.tag.name}",
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  Spacer(),
                                  IconButton(
                                      icon: Icon(Icons.arrow_downward),
                                      color: Colors.white,
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      })
                                ]),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Von ${stunde.zeitraum}",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Padding(
                                      child: Icon(Icons.access_time),
                                      padding: EdgeInsets.only(left: 5),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    FutureBuilder(
                                        future: getLehrerNamen(
                                            stunde.lehrer.kuerzel),
                                        builder: (BuildContext context,
                                            AsyncSnapshot snapshot) {
                                          if (snapshot.data == null) {
                                            return Container(
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                value: null,
                                              )),
                                            );
                                          } else if (snapshot.data.length ==
                                              0) {
                                            return Text(
                                                "Lehrer wurde nicht gefunden!");
                                          } else {
                                            return Column(children: [
                                              Row(children: [
                                                Icon(Icons
                                                    .supervisor_account_rounded),
                                                Padding(
                                                  child: Text(
                                                      "Lehrer: ${snapshot.data[0]}"),
                                                  padding:
                                                      EdgeInsets.only(left: 5),
                                                )
                                              ]),
                                              Row(children: [
                                                Icon(Icons.sensor_door),
                                                Padding(
                                                  child: Text(
                                                      "Raum: ${stunde.raum.name}"),
                                                  padding:
                                                      EdgeInsets.only(left: 5),
                                                )
                                              ]),
                                              Row(children: [
                                                Icon(Icons
                                                    .calendar_today_outlined),
                                                Padding(
                                                  child: Text(
                                                      "Fach: ${stunde.fach.kuerzel}"),
                                                  padding:
                                                      EdgeInsets.only(left: 5),
                                                )
                                              ]),
                                            ]);
                                          }
                                        })
                                  ],
                                ),
                              ]),
                              padding: const EdgeInsets.only(
                                  left: 25.0,
                                  right: 8.0,
                                  top: 8.0,
                                  bottom: 8.0),
                            ));
                      });
                },
              ));
              children.add(GestureDetector(
                  child: Center(child: m.buildSubtitle(context))));
            }
            if (stunden.length > 1 && sc < stunden.length) {
              children.add(Divider(
                height: 10,
                indent: 5,
                endIndent: 5,
                thickness: 2,
                color: Colors.white,
              ));
            }
          }
          Column c = Column(children: children);
          cells.add(TableCell(
            child: c,
          ));
        }
        l.add(TableRow(children: cells));
      }
    }

    return l;
  }

  Future<List<Object>> getLehrerNamen(String kuerzel) async {
    List<Object> o = [];
    LehrerNamenParser p = LehrerNamenParser(nutzer.headers,
        "https://start.schulportal.hessen.de/nachrichten.php?q=${kuerzel}&a=searchRecipt");
    String s = await p.parsen();
    o.add(s);
    return o;
  }
}
