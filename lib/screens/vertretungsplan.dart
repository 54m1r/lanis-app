import 'package:flutter/material.dart';

import 'package:vertretungsplan_app/models/vertretung.dart';
import 'package:vertretungsplan_app/models/vertretungsplan.dart';
import 'package:vertretungsplan_app/models/vertretungsplanTag.dart';
import 'package:vertretungsplan_app/utils/vertretungsplan_parser.dart';


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
                              fontWeight: FontWeight.w300,
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
    return Container(
      width: 180,
      margin: EdgeInsets.only(top: 5, bottom: 5),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Color(0xff30475e), borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xfff2a365)),
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
                vertretung.hinweis + " " + vertretung.hinweis2,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
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
    );
  }
}
