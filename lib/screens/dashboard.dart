
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:schulportal_hessen_app/theme/colors.dart';

import 'package:badges/badges.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 15, bottom: 30),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildDateColumn("Mo", 7, true),
                  buildDateColumn("Di", 8, false),
                  buildDateColumn("Mi", 9, false),
                  buildDateColumn("Do", 10, false),
                  buildDateColumn("Fr", 11, false),
                  buildDateColumn("Mo", 14, false),
                  buildDateColumn("Di", 15, false),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildTaskListItem(),
                    buildTaskListItem(),
                    buildTaskListItem(),
                  ],
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  Container buildTaskListItem() {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 15,
                height: 10,
                decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(5),
                    )),
              ),
              SizedBox(
                width: 15,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: "07:00",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: white,
                        ),
                      ),
                    ),
                    Text(
                      "1 h 45 min",
                      style: TextStyle(
                        color: darkerText,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 90,
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: primary),
                borderRadius: BorderRadius.circular(20)),
            margin: EdgeInsets.only(right: 10, left: 30),
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Deutsch",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: white,
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          FluentIcons.conference_room_24_regular,
                          color: darkerText,
                          size: 15,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "1204",
                          style: TextStyle(fontSize: 13, color: darkerText),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          FluentIcons.chart_person_24_regular,
                          color: darkerText,
                          size: 15,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Birgit, Wagner",
                          style: TextStyle(fontSize: 13, color: darkerText),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Badge buildDateColumn(String weekDay, int date, bool isActive) {
    return Badge(
      animationType: BadgeAnimationType.slide,
      badgeColor: darkerText,
      badgeContent: Text(
        '4',
        style: TextStyle(fontSize: 12, color: white),
      ),
      child: Container(
        decoration: isActive
            ? BoxDecoration(
                color: primary, borderRadius: BorderRadius.circular(10))
            : BoxDecoration(),
        height: 55,
        width: 35,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              weekDay,
              style: TextStyle(color: white, fontSize: 11),
            ),
            Text(
              date.toString(),
              style: TextStyle(
                  color: isActive ? white : white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
