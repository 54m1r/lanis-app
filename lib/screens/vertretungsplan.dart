import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:schulportal_hessen_app/models/vertretung.dart';
import 'package:schulportal_hessen_app/models/vertretungsplan.dart';
import 'package:schulportal_hessen_app/models/vertretungsplanTag.dart';
import 'package:schulportal_hessen_app/utils/vertretungsplan_parser.dart';

import '../main.dart';
import '../models/vertretungsplanTag.dart';

class VertretungsplanScreen extends StatefulWidget {
  VertretungsplanScreen({Key key}) : super(key: key);

  @override
  _VertretungsplanScreen createState() => _VertretungsplanScreen();
}

class _VertretungsplanScreen extends State<VertretungsplanScreen> {
  Future<List<Object>> _getVertretungsplan() async {
    VertretungsplanParser vertretungsplanParser = new VertretungsplanParser(
        nutzer.headers,
        'https://start.schulportal.hessen.de/vertretungsplan.php');
    Vertretungsplan vertretungsplan = await vertretungsplanParser.parsen();

    List<Object> objects = new List<Object>();
    VertretungsplanTag alterVertretungsplanTag;
    vertretungsplan.vertretungen.forEach((vertretung) {
      if (alterVertretungsplanTag == null) {
        alterVertretungsplanTag = vertretung.vertretungsPlanTag;
        objects.add(alterVertretungsplanTag);
      } else if (alterVertretungsplanTag != vertretung.vertretungsPlanTag) {
        alterVertretungsplanTag = vertretung.vertretungsPlanTag;
        objects.add(alterVertretungsplanTag);
      }
      objects.add(vertretung);
    });

    return objects;
  }

  @override
  Widget build(BuildContext context) {
    return vertretungsplanWidget();
  }

  Widget vertretungsplanWidget() {
    return FutureBuilder(
        future: _getVertretungsplan(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(
              child: Center(
                child: Center(
                    child: CircularProgressIndicator(
                  value: null,
                )),
              ),
            );
          } else if (snapshot.data.length == 0) {
            return Container(
              child: Center(
                child: Text("Es gibt aktuell keine Vertretungen!"),
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

                if (object is VertretungsplanTag) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: RichText(
                      text: TextSpan(children: <TextSpan>[
                        TextSpan(
                          text: object.getFormattedDate(),
                          style: TextStyle(
                              color: Color(0xFFececec),
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ]),
                    ),
                  );
                } else {
                  return _vertretunContainer(object);
                }
              },
            );
          }
        });
  }

  Widget _vertretunContainer(Vertretung vertretung) {
    return GestureDetector(
        child: Container(
          width: 180,
          margin: EdgeInsets.only(top: 5, bottom: 5),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: (vertretung.hinweis.contains(RegExp(r"[fF]rei")) ||
                      vertretung.hinweis2.contains(RegExp(r"[fF]rei"))
                  ? Color(0xff30455f)
                  : Color(0xff30475e)),
              borderRadius: BorderRadius.circular(15)),
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: (vertretung.hinweis.contains(RegExp(r"[fF]rei")) ||
                            vertretung.hinweis2.contains(RegExp(r"[fF]rei"))
                        ? Color(0xff65f278)
                        : Color(0xfff2a365))),
                child: Center(
                  child: Text(
                    vertretung.stunde.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xff30475e),
                        fontWeight: FontWeight.w300,
                        fontSize: 18),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vertretung.hinweis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  (vertretung.hinweis2.length > 1
                      ? Text(
                          vertretung.hinweis2,
                        )
                      : Text("--")),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${vertretung.fach.kuerzel} (${vertretung.raum.name}) - ${vertretung.lehrer.kuerzel}",
                    style: TextStyle(fontSize: 13, color: Colors.blueGrey[500]),
                  ),
                ],
              ),
            ],
          ),
        ),
        onTap: () {
          developer.log("Ok");
        });
  }
}
