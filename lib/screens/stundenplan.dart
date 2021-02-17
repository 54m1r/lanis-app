import 'package:flutter/material.dart';
import 'package:vertretungsplan_app/models/stunde.dart';
import 'package:vertretungsplan_app/models/stundenplan.dart';
import 'dart:developer' as developer;
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
      TableCell(child: Center(child:  Text('Stunde', style: style))),
      TableCell(child:  Center(child:  Text('Mo', style: style))),
      TableCell(child:  Center(child:  Text('Di', style: style))),
      TableCell(child:  Center(child:  Text('Mi', style: style))),
      TableCell(child:  Center(child:  Text('Do', style: style))),
      TableCell(child:  Center(child:  Text('Fr', style: style))),
    ]));
    if (o[2] is Map) {
      Map<int, List<List<Stunde>>> map = o[2];

      for (var x = 0; x < map.length; x++) {
        List<TableCell> cells = [];
        cells.add(TableCell(
          child: Text("${x + 1}"),
        ));
        for (var stunden in map[x + 1]) {
          List<Widget> children = [];
          var sc = 0;
          for (var stunde in stunden) {
            sc++;
            MessageItem m = MessageItem(
                "${stunde.fach.kuerzel} (${stunde.lehrer.kuerzel})",
                stunde.raum.name);
            children.add(m.buildTitle(context));
            children.add(m.buildSubtitle(context));
            if (stunden.length > 1 && sc < stunden.length) {
              children.add(Divider(height: 10, indent: 5, endIndent: 5, thickness: 2, color: Colors.white,));
            }
          }
          cells.add(TableCell(child: Column(children: children)));
        }
        l.add(TableRow(children: cells));
      }
    }

    return l;
  }
}
