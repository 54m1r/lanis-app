// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:schulportal_hessen_app/screens/nachrichten.dart';
import 'package:schulportal_hessen_app/screens/settings/settings.dart';
import 'package:schulportal_hessen_app/screens/stundenplan.dart';
import 'package:schulportal_hessen_app/screens/unterricht.dart';
import 'package:schulportal_hessen_app/screens/vertretungsplan.dart';

import '../main.dart';

void main() => runApp(HomeScreen());

int _selectedIndex = 0;

/// This is the main application widget.
class HomeScreen extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: HomeStatefulWindget(),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class HomeStatefulWindget extends StatefulWidget {
  HomeStatefulWindget({Key key}) : super(key: key);

  @override
  _HomeStatefulWindgetState createState() => _HomeStatefulWindgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _HomeStatefulWindgetState extends State<HomeStatefulWindget> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    VertretungsplanScreen(),
    VertretungsplanScreen(),
    StundenplanScreen(),
    NachrichtenScreen(),
    UnterrichtScreen(),
    Settings()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
                        margin: EdgeInsets.only(top: 20, bottom: 20),
                        child: _widgetOptions.elementAt(_selectedIndex), //https://api.flutter.dev/flutter/material/BottomNavigationBar-class.html
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.schedule),
              label: 'Vertretungsplan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Stundenplan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'Nachrichten',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.addressBook),
              label: 'Unterricht',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Einstellungen',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
          //onTap: _onItemTapped,
        ),
      ),
    );
  }
}

