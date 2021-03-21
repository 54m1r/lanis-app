//import 'dart:html';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:developer' as developer;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';
import 'package:schulportal_hessen_app/models/nutzer.dart';
import 'package:schulportal_hessen_app/screens/stundenplan.dart';
import 'package:schulportal_hessen_app/utils/utility.dart';

import '../utils/session_manager.dart';

import 'package:schulportal_hessen_app/main.dart';

import 'home.dart';
import 'loading.dart';

void main() async {
  runApp(MaterialApp(home: Willkommen()));
}

class Willkommen extends StatelessWidget {
  @override
  String psw = '';
  String bn = '';

  Widget build(BuildContext context) {
    void anmeldung() {}
    return MaterialApp(
        navigatorObservers: [NavigationHistoryObserver()],
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          /* dark theme settings */
          primaryColor: Color(0x222831),
        ),
        themeMode: ThemeMode.dark,
        title: 'Vertretungsplan',
        theme: ThemeData(
          primaryColor: Colors.blue,
          //fontFamily: GoogleFonts.notoSans().fontFamily,
        ),
        home: Scaffold(
            appBar: AppBar(
              title: Text('Anmeldung'),
            ),
            body: Anmeldung()));
  }
}

class UserInput extends StatefulWidget {
  @override
  _UserInputState createState() => _UserInputState();
}

class _UserInputState extends State<UserInput> {
  void updateUserText(String text) {
    setState(() {
      userText = text;
    });
  }

  String userText = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          onSubmitted: updateUserText,
        ),
        Text(userText)
      ],
    );
  }
}

class Anmeldung extends StatefulWidget {
  @override
  _AnmeldungState createState() => _AnmeldungState();
}

class _AnmeldungState extends State<Anmeldung> {
  @override
  Future<void> initState() {
    versucheAnzumelden();
    super.initState();
  }

  void versucheAnzumelden() async {
    SessionManager sessionManager = new SessionManager(
        'https://start.schulportal.hessen.de/index.php?i=6271',
        'https://start.schulportal.hessen.de/ajax.php?f=rsaPublicKey',
        'https://start.schulportal.hessen.de/ajax.php?f=rsaHandshake&s=' +
            (new Random().nextInt(90) + 10).toString(),
        'https://start.schulportal.hessen.de/ajax.php');

    String nutzername = await storage.read(key: 'bn');
    String password = await storage.read(key: 'psw');

    if (nutzername != null || password != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Loading()));
      Nutzer loginNutzer = await sessionManager.login(nutzername, password);
      developer.debugger();

      if (loginNutzer != null) {
        nutzer = loginNutzer;
        await Navigator.popUntil(context, (route) => false);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    } else {
      developer.log("No password in storage... Skipping");
    }
  }

  String psw = '';
  String bn = '';
  String bn2 = '';

  Future<void> anmeldung() async {
    SessionManager sessionManager = new SessionManager(
        'https://start.schulportal.hessen.de/index.php?i=6271',
        'https://start.schulportal.hessen.de/ajax.php?f=rsaPublicKey',
        'https://start.schulportal.hessen.de/ajax.php?f=rsaHandshake&s=' +
            (new Random().nextInt(90) + 10).toString(),
        'https://start.schulportal.hessen.de/ajax.php');

    String nutzername = bn;
    String password = psw;
    developer.log(nutzername);
    Nutzer loginNutzer = await sessionManager.login(nutzername, password);

    if (loginNutzer != null) {
      nutzer = loginNutzer;
      //await storage.write(key: 'bn', value: bn);
      //await storage.write(key: 'psw', value: psw);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));

    } else {
      showDialog<AlertDialog>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                  'Leider war mit den eingegebenen Daten kein Login möglich. Bitte überpruefen Sie, ob diese korrekt waren.'),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Ok"))
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 30),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 22),
          child: Text('Melde dich bitte mit deinen Lanis-Daten an!'),
        ),
        ListTile(
          title: TextField(
            onChanged: (benutzername) {
              bn = removeWhitespaces(benutzername);
              setState(() {});
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Benutzername',
                prefix: Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Icon(
                      Icons.account_circle_rounded,
                      size: 20,
                    ))),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 8),
        ),
        ListTile(
          title: TextField(
            onChanged: (passwort) {
              psw = passwort;
              setState(() {});
            },
            obscureText: true,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Passwort',
                prefix: const Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: const Icon(Icons.lock))),
          ),
        ),
        OutlineButton(
          onPressed: anmeldung,
          child: Text('Anmelden'),
        )
      ],
    )));
  }
}
