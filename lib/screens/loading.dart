import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:developer' as developer;

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Container(child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image(
                    image: AssetImage('assets/icon/icon.png'),
                    height: 72,
                    width: 72,
                  )), padding: EdgeInsets.only(top: 20),);
            }
            if (index == 1) {
              return Container(
                  child: Center(
                      child: Text(
                    "Anmelden...",
                    style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  )),
                  padding: EdgeInsets.only(top: 30));
            }

            return Container(
              child: Center(
                  child: CircularProgressIndicator(
                value: null,
              )),
              padding: EdgeInsets.only(top: 120),
            );
          }),
      color: Colors.white10,
    );
    ;
  }
}
