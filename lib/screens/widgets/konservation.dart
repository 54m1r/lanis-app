import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'dart:developer' as developer;
import 'package:schulportal_hessen_app/models/nachricht.dart';
import 'package:schulportal_hessen_app/models/konservation.dart';
import 'package:schulportal_hessen_app/utils/nachrichten_parser.dart';

import '../../main.dart';

class ChatDetailPage extends StatefulWidget {
  Konservation nachricht;

  ChatDetailPage({@required this.nachricht});

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  Future<List<Nachricht>> _getNachrichtInhalt(Konservation nachricht) async {
    NachrichtenParser nachrichtenParser = new NachrichtenParser(
        nutzer.headers, 'https://start.schulportal.hessen.de/nachrichten.php');
    dynamic rawData = await nachrichtenParser.inhaltParsen(nachricht);

    var messages = new List<Nachricht>();

    messages.add(new Nachricht(
        messageContent: rawData['Inhalt'],
        messageType: 'receiver',
        messsageSender: nachricht.senderName,
        messsageDate: rawData['Datum']));

    rawData['reply'].forEach((reply) {
      messages.add(new Nachricht(
          messageContent: reply['Inhalt'],
          messageType: 'receiver',
          messsageSender: reply['SenderName'],
          messsageDate: reply['Datum']));
    });

    return messages;
    //developer.debugger();

    //developer.log(nachrichten.toString());

    /*VertretungsplanParser vertretungsplanParser = new VertretungsplanParser(
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

    return objects; */
    //developer.debugger();
    //return nachrichten;
  }

  @override
  Widget build(BuildContext context) {
    developer.log(context.toString());
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  maxRadius: 18,
                  backgroundColor: Color(0xfff2a365),
                  child: Center(
                    child: Text(
                      widget.nachricht.kuerzel,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0xff30475e),
                          fontWeight: FontWeight.w300,
                          fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.nachricht.betreff.toString(),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        widget.nachricht.senderName,
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.settings,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          FutureBuilder(
              future: _getNachrichtInhalt(widget.nachricht),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                developer.log(snapshot.toString());
                developer.log("Hi");
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
                      child: Text("Es hast noch keine Nachrichten!"),
                    ),
                  );
                } else {
                  List<Object> objects = snapshot.data;

                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: objects.length,
                    itemBuilder: (BuildContext context, int index) {
                      Nachricht message = objects[index];
                      return Container(
                        padding: EdgeInsets.only(
                            left: 14, right: 14, top: 10, bottom: 10),
                        child: Align(
                          alignment: ('receiver' == "receiver"
                              ? Alignment.topLeft
                              : Alignment.topRight),
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: ('receiver' == "receiver"
                                    ? Color(0xff30455f)
                                    : Colors.blue[200]),
                              ),
                              padding: EdgeInsets.all(16),
                              child: Html(
                                data: message.messageContent.toString(),
                                defaultTextStyle: TextStyle(fontSize: 15),
                              )),
                        ),
                      );
                    },
                  );
                }
              }),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {},
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Colors.blue,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
