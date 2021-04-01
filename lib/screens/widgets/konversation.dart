import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'dart:developer' as developer;
import 'package:schulportal_hessen_app/models/nachricht.dart';
import 'package:schulportal_hessen_app/models/konservation.dart';
import 'package:schulportal_hessen_app/theme/colors.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    developer.log(context.toString());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: black,
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
                    FluentIcons.arrow_left_24_filled,
                    color: white,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  backgroundColor: primary,
                  child: Center(
                    child: Text(
                      widget.nachricht.kuerzel,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.nachricht.betreff.toString(),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600, color: white),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        widget.nachricht.senderName,
                        style: TextStyle(
                            color: darkerText, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                /*Icon(
                  Icons.settings,
                  color: Colors.black54,
                ), */
              ],
            ),
          ),
        ),
      ),
      body: Container(
        color: background,
        child: Stack(
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
                        child: Text("Du hast noch keine Nachrichten!"),
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
                          margin: EdgeInsets.only(right: 40),
                          padding: EdgeInsets.only(
                              left: 14, right: 14, top: 10, bottom: 10),
                          child: Align(
                            alignment: ('receiver' == "receiver"
                                ? Alignment.topLeft
                                : Alignment.topRight),
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(width: 1, color: primary),
                                  borderRadius: BorderRadius.circular(20),
                                  /*color: ('receiver' == "receiver"
                                      ? Color(0xff30455f)
                                      : Colors.blue[200]), */
                                ),
                                padding: EdgeInsets.all(16),
                                child: Html(
                                  data: message.messageContent.toString(),
                                  style: {
                                    'html': Style.fromTextStyle(TextStyle(fontSize: 15, color: white))
                                  },
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
                color: black,
                padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                height: 60,
                width: double.infinity,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: "Nachricht",
                            hintStyle: TextStyle(color: white),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    FloatingActionButton(
                      onPressed: () {},
                      child: Icon(
                        FluentIcons.send_24_filled,
                        color: white,
                        size: 24,
                      ),
                      backgroundColor: primary,
                      elevation: 0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}