import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:vertretungsplan_app/models/Stundenplan.dart';

import 'package:vertretungsplan_app/utils/stundenplan_parser.dart';


import '../main.dart';


class StundenplanScreen extends StatefulWidget {
  StundenplanScreen({Key key}) : super(key: key);

  @override
  _StundenplanScreen createState() => _StundenplanScreen();
}

class _StundenplanScreen extends State<StundenplanScreen> {
  Future<List<Object>> _getStundenplan() async {


    StundenplanParser stundenplanParser = new StundenplanParser(
        nutzer.headers,
        'https://start.schulportal.hessen.de/stundenplan.php?a=detail_klasse&e=1');
    Stundenplan plan = (await stundenplanParser.parsen()) as Stundenplan;

    List<Object> objects = new List<Object>();


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
                child: Text("Lädt..."),
              ),
            );
          } else if (snapshot.data.length == 0) {
            return Container(
              child: Center(
                child: Text("Es gibt aktuell keine Vertretungen!"),
              ),
            );
          }

        });
  }

}
