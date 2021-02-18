import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:developer' as developer;

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(darkTheme: ThemeData(
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
        builder: (context, child){
          return Container(
            child: ListView.builder(
                itemCount: 2,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Padding(
                        child: Center(child: Text("Login...")),
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
        });

  }
}
