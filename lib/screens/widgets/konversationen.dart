import 'package:flutter/material.dart';
import 'package:schulportal_hessen_app/models/konservation.dart';
import 'package:schulportal_hessen_app/theme/colors.dart';

import 'konversation.dart';
import 'dart:developer' as developer;

class ConversationList extends StatefulWidget {
  Konservation nachricht;

  ConversationList({@required this.nachricht});

  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        developer.log("tabbed");
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ChatDetailPage(
            nachricht: widget.nachricht,
          );
        }));
      },
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: primary,
                    child: Center(
                      child: Text(
                        widget.nachricht.kuerzel,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.nachricht.betreff.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: white,
                                fontSize: 16,
                                fontWeight: widget.nachricht.ungelesen == true
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            widget.nachricht.senderName+" ("+widget.nachricht.datum+")",
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade500,
                                fontWeight: widget.nachricht.ungelesen == true
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
