// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:vertretungsplan_app/screens/vertretungsplan.dart';

import '../main.dart';

void main() => runApp(HomeScreen());

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
        primaryColor: Color(0xff30475e),
      ),
      themeMode: ThemeMode.dark,
      title: 'Vertretungsplan',
      theme: ThemeData(
        primaryColor: Colors.blue,
        //fontFamily: GoogleFonts.notoSans().fontFamily,
      ),
      builder: (context, child) {
        return child;
      },
      home: Scaffold(
        body: Stack(children: [
          Positioned(
            top: 60,
            left: 20,
            right: 20,
            bottom: 0,
            child: Container(
              child: Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        RichText(
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                              text: "Gude, ",
                              style: TextStyle(
                                  color: Color(0xFFececec),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20),
                            ),
                            TextSpan(
                              text: nutzer != null ? nutzer.name : nutzer,
                              style: TextStyle(
                                  color: Color(0xFFececec),
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20),
                            ),
                          ]),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                        margin: EdgeInsets.only(top: 20),
                        child: VertretungsplanScreen()
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}