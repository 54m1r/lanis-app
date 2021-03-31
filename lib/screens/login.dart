//import 'dart:html';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:developer' as developer;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:schulportal_hessen_app/models/nutzer.dart';
import 'package:schulportal_hessen_app/screens/stundenplan.dart';
import 'package:schulportal_hessen_app/utils/utility.dart';

import '../utils/session_manager.dart';

import 'package:schulportal_hessen_app/main.dart';

import 'home.dart';
import 'loading.dart';

void main() async {
  runApp(MaterialApp(home: Willkommen(), debugShowCheckedModeBanner: false));
}

class Willkommen extends StatelessWidget {
  @override
  String psw = '';
  String bn = '';
  bool save_ = false;

  Widget build(BuildContext context) {
    void anmeldung() {}
    return MaterialApp(
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
          body: Anmeldung()),
      debugShowCheckedModeBanner: false,
    );
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

  static Future<void> _onSelectNotification(String json) async {
    // todo: handling clicked notification
  }
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

class _AnmeldungState extends State<Anmeldung> {
  @override
  Future<void> initState() {
    versucheAnzumelden();
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android: android, iOS: iOS);

    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: Anmeldung._onSelectNotification);
  }

  void versucheAnzumelden() async {
    //TODO: Schul-Id auswählen und einfügen

    SessionManager sessionManager = new SessionManager(
        'https://start.schulportal.hessen.de/index.php?i=6271',
        'https://start.schulportal.hessen.de/ajax.php?f=rsaPublicKey',
        'https://start.schulportal.hessen.de/ajax.php?f=rsaHandshake&s=' +
            (new Random().nextInt(90) + 10).toString(),
        'https://start.schulportal.hessen.de/ajax.php');
    String nutzername = await storage.read(key: 'bn');
    String password = await storage.read(key: 'psw');

    if (nutzername != null && password != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Loading()));
      Nutzer loginNutzer = await sessionManager.login(nutzername, password);
      // developer.debugger();

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
  bool save_ = false;

  Future<void> anmeldung() async {
    //TODO: Schulauswahl
    SessionManager sessionManager = new SessionManager(
        'https://start.schulportal.hessen.de/index.php?i=6271',
        'https://start.schulportal.hessen.de/ajax.php?f=rsaPublicKey',
        'https://start.schulportal.hessen.de/ajax.php?f=rsaHandshake&s=' +
            (new Random().nextInt(90) + 10).toString(),
        'https://start.schulportal.hessen.de/ajax.php');

    String nutzername = bn;
    String password = psw;
    developer.log(nutzername);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Loading()));
    Nutzer loginNutzer = await sessionManager.login(nutzername, password);

    if (loginNutzer != null) {
      nutzer = loginNutzer;
      if (save_) {
        await storage.write(key: 'bn', value: bn);
        await storage.write(key: 'psw', value: psw);
      }
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      Navigator.pop(context);

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

  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image(
                image: AssetImage('assets/icon/icon.png'),
                height: 72,
                width: 72,
              )),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text('Melde dich bitte mit deinen Lanis-Daten an!'),
        ),
        ListTile(
          title: TextField(
            onChanged: (benutzername) {
              bn = removeWhitespaces(benutzername);
              setState(() {});
            },
            textInputAction: TextInputAction.next,

            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Benutzername',
                prefixIcon: Icon(
                  Icons.account_circle_rounded,
                  size: 20,
                )),
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
            onSubmitted: (s){
              anmeldung();
            },
            obscureText: _isObscure,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Passwort',
                suffixIcon: IconButton(
                  icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                ),

                prefixIcon: Icon(
                  Icons.lock,
                  size: 20,
                )),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 4),
        ),
        Container(
          child: CheckboxListTile(
            value: save_,
            title: Text("Angemeldet bleiben"),
            onChanged: (check) {
              setState(() {
                save_ = check;
              });
            },
          ),
          padding: EdgeInsets.only(left: 10, bottom: 120),
        ),
        OutlineButton(
          onPressed: () {
            anmeldung();
          },
          child: Text('Anmelden'),
        )
      ],
    )));
  }
}
