import 'package:flutter/material.dart';
import 'package:schulportal_hessen_app/models/nachricht.dart';
import 'package:schulportal_hessen_app/models/unterricht/kurs.dart';
import 'package:schulportal_hessen_app/models/vertretung.dart';

import 'package:schulportal_hessen_app/utils/unterricht_parser.dart';
import 'dart:developer' as developer;

import '../main.dart';

class NachrichtenScreen extends StatefulWidget {
  NachrichtenScreen({Key key}) : super(key: key);

  @override
  _NachrichtenScreen createState() => _NachrichtenScreen();
}

class _NachrichtenScreen extends State<NachrichtenScreen> {
  Future<List<Object>> _getnachrichten() async {
    UnterrichtParser unterrichtParser = new UnterrichtParser(nutzer.headers);
    List<Kurs> kurse = await unterrichtParser.parsen();
    return kurse;

    /*nachrichtenParser nachrichtenParser = new nachrichtenParser(
        nutzer.headers,
        'https://start.schulportal.hessen.de/nachrichten.php');
    nachrichten nachrichten = await nachrichtenParser.parsen();

    List<Object> objects = new List<Object>();
    nachrichtenTag alternachrichtenTag;
    nachrichten.vertretungen.forEach((vertretung) {
      if (alternachrichtenTag == null) {
        alternachrichtenTag = vertretung.nachrichtenTag;
        objects.add(alternachrichtenTag);
      } else if (alternachrichtenTag != vertretung.nachrichtenTag) {
        alternachrichtenTag = vertretung.nachrichtenTag;
        objects.add(alternachrichtenTag);
      }
      objects.add(vertretung);
    });

    return objects; */
  }

  @override
  Widget build(BuildContext context) {
    return nachrichtenWidget();
  }

  Widget nachrichtenWidget() {
    return FutureBuilder(
        future: _getnachrichten(),
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
                child: Text("Es gibt aktuell kein Unterricht!"),
              ),
            );
          } else {
            List<Object> objects = snapshot.data;

            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: objects.length,
              itemBuilder: (BuildContext context, int index) {
                Object object = objects[index];
                return _nachrichtenContainer(object);
              },
            );
          }
        });
  }

  Widget _nachrichtenContainer(Nachricht nachricht) {
    return Container(
      width: 180,
      margin: EdgeInsets.only(top: 5, bottom: 5),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Color(0xff30475e), borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [],
      ),
    );
  }
}
