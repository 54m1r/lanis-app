import 'package:flutter/material.dart';
import 'package:vertretungsplan_app/models/nachricht.dart';

import '../chatDetailPage.dart';
import 'dart:developer' as developer;

class ConversationList extends StatefulWidget{
  Nachricht nachricht;
  ConversationList({@required this.nachricht});
  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        developer.log("tabbed");
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return ChatDetailPage();
        }));
      },
      child: Container(
        padding: EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(backgroundColor: Color(0xfff2a365),
                    child: Center(
                      child: Text(
                        widget.nachricht.kuerzel,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xff30475e),
                            fontWeight: FontWeight.w300,
                            fontSize: 18),
                      ),
                    ),),
                  SizedBox(width: 16,),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.nachricht.betreff.toString(), style: TextStyle(fontSize: 16),),
                          SizedBox(height: 6,),
                          Text(widget.nachricht.senderName,style: TextStyle(fontSize: 13,color: Colors.grey.shade600, fontWeight: widget.nachricht.ungelesen == true ? FontWeight.bold:FontWeight.normal),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(widget.nachricht.datum,style: TextStyle(fontSize: 12,fontWeight: widget.nachricht.ungelesen==true?FontWeight.bold:FontWeight.normal),),
          ],
        ),
      ),
    );
  }
}