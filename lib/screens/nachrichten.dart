import 'package:flutter/material.dart';
import 'package:school_ui_toolkit/school_ui_toolkit.dart';
import 'package:schulportal_hessen_app/models/vertretung.dart';
import 'package:schulportal_hessen_app/models/vertretungsplan.dart';
import 'package:schulportal_hessen_app/models/vertretungsplanTag.dart';
import 'package:schulportal_hessen_app/screens/widgets/konversationen.dart';
import 'package:schulportal_hessen_app/utils/nachrichten_parser.dart';
import 'package:schulportal_hessen_app/utils/vertretungsplan_parser.dart';
import 'dart:developer' as developer;

import '../main.dart';
import '../models/vertretungsplanTag.dart';
import '../models/konservation.dart';
import '../models/vertretungsplanTag.dart';

class NachrichtenScreen extends StatefulWidget {
  NachrichtenScreen({Key key}) : super(key: key);

  @override
  _NachrichtenScreen createState() => _NachrichtenScreen();
}

class _NachrichtenScreen extends State<NachrichtenScreen> {
  Future<List<Object>> _getNachrichten() async {

    NachrichtenParser nachrichtenParser = new NachrichtenParser(nutzer.headers, 'https://start.schulportal.hessen.de/nachrichten.php');
    List<Konservation> nachrichten = await nachrichtenParser.parsen();
    developer.log(nachrichten.toString());

    return nachrichten;
  }

  @override
  Widget build(BuildContext context) {
    return vertretungsplanWidget();
  }

  Widget vertretungsplanWidget() {
    return FutureBuilder(
        future: _getNachrichten(),
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
                child: Text("Du hast noch keine Konservationen!"),
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
                  return ConversationList(nachricht: object);
                }
              },
            );
          }
        });
  }

}
