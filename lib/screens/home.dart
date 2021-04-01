// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:schulportal_hessen_app/screens/dashboard.dart';
import 'package:schulportal_hessen_app/screens/nachrichten.dart';
import 'package:schulportal_hessen_app/screens/settings/settings.dart';
import 'package:schulportal_hessen_app/screens/stundenplan.dart';
import 'package:schulportal_hessen_app/screens/unterricht.dart';
import 'package:schulportal_hessen_app/screens/vertretungsplan.dart';

import 'package:schulportal_hessen_app/theme/colors.dart';

import '../main.dart';

class HomeScreen extends StatefulWidget {
  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<HomeScreen> {
  int pageIndex = 2;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: background,
        body: Stack(children: [
          Positioned(
            top: 60,
            left: 20,
            right: 20,
            bottom: 0,
            child: Column(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                            text: "Gude ",
                            style: TextStyle(
                                color: white,
                                fontWeight: FontWeight.w700,
                                fontSize: 20),
                          ),
                          TextSpan(
                            text: nutzer != null
                                ? nutzer.name.split(" ")[0]
                                : nutzer,
                            style: TextStyle(
                                color: white,
                                fontWeight: FontWeight.w300,
                                fontSize: 20),
                          ),
                        ]),
                      ),
                      Column(
                        children: [
                          Text(
                            "27.03.2021",
                            style: TextStyle(color: white, fontSize: 13),
                          ),
                          //Text("1", style: TextStyle(color: white, fontSize: 10),),
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    child:
                        getBody(), //https://api.flutter.dev/flutter/material/BottomNavigationBar-class.html
                  ),
                ),
              ],
            ),
          ),
        ]),
        bottomNavigationBar: getFooter(),
      ),
    );
  }

  Widget getBody() {
    List<Widget> pages = [
      CalendarPage(),
      StundenplanScreen(),
      NachrichtenScreen(),
      Settings(),
    ];
    return IndexedStack(
      index: pageIndex,
      children: pages,
    );
  }

  Widget getAppBar() {
    if (pageIndex == 0) {
      return Container(
        child: Row(
          children: [
            RichText(
              text: TextSpan(children: <TextSpan>[
                TextSpan(
                  text: "Gude ",
                  style: TextStyle(
                      color: white, fontWeight: FontWeight.w700, fontSize: 20),
                ),
                TextSpan(
                  text: nutzer != null ? nutzer.name : nutzer,
                  style: TextStyle(
                      color: white, fontWeight: FontWeight.w300, fontSize: 20),
                ),
              ]),
            ),
          ],
        ),
      );
    } else if (pageIndex == 1) {
      return Row(
        children: [
          Text(
            "Stundenplan",
            style: TextStyle(
                color: white, fontWeight: FontWeight.w700, fontSize: 20),
          ),
        ],
      );
    } else if (pageIndex == 2) {
      return Row(
        children: [
          Text(
            "Nachrichten",
            style: TextStyle(
                color: white, fontWeight: FontWeight.w700, fontSize: 20),
          ),
        ],
      );
    } else if (pageIndex == 3) {
      return Row(
        children: [
          Text(
            "Einstellungen",
            style: TextStyle(
                color: white, fontWeight: FontWeight.w700, fontSize: 20),
          ),
        ],
      );
    }
  }

  Widget getFooter() {
    List bottomItems = [
      pageIndex == 0 ? FluentIcons.home_24_filled : FluentIcons.home_24_regular,
      pageIndex == 1
          ? FluentIcons.calendar_clock_24_filled
          : FluentIcons.calendar_clock_24_regular,
      pageIndex == 2 ? FluentIcons.chat_24_filled : FluentIcons.chat_24_regular,
      pageIndex == 3
          ? FluentIcons.settings_24_filled
          : FluentIcons.settings_24_regular,
    ];
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(color: black),
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(bottomItems.length, (index) {
            return InkWell(
              onTap: () {
                selectedTab(index);
              },
              child: Container(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Icon(
                  bottomItems[index],
                  size: 29,
                  color: Colors.white,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  selectedTab(index) {
    setState(() {
      pageIndex = index;
    });
  }
}
