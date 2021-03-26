import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:developer' as developer;

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

          return Container(
            child: ListView.builder(
                itemCount: 2,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Padding(
                        child: Center(child: Text("Versuche Anmelden...", style: TextStyle(color: Colors.white, decoration: TextDecoration.none, fontWeight: FontWeight.bold, fontSize: 30),)),
                        padding: EdgeInsets.only(top: 100));
                  }

                  return Padding(
                    child: Center(
                        child: CircularProgressIndicator(
                      value: null,
                    )),
                    padding: EdgeInsets.only(top: 100),
                  );
                }),
            color: Colors.white10,
          );
        ;
  }
}
