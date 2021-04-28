//import 'dart:html';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:schulportal_hessen_app/main.dart';
import 'package:schulportal_hessen_app/models/nutzer.dart';
import 'package:schulportal_hessen_app/models/schule.dart';
import 'package:schulportal_hessen_app/utils/schule_parser.dart';
import 'package:schulportal_hessen_app/utils/utility.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

import '../utils/session_manager.dart';
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
      title: 'Schulportal Hessen App',
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

    Map<dynamic, dynamic> o = new Map<dynamic, dynamic>.from(await box.get('profile_1'));

    if (o != null) {
      developer.log("Box: ${o}");
      if (o['stay_loggedin']) {
        sid = o['schulid'];
        SessionManager sessionManager = new SessionManager(
            'https://start.schulportal.hessen.de/index.php?i=' + sid,
            'https://start.schulportal.hessen.de/ajax.php?f=rsaPublicKey',
            'https://start.schulportal.hessen.de/ajax.php?f=rsaHandshake&s=' +
                (new Random().nextInt(90) + 10).toString(),
            'https://start.schulportal.hessen.de/ajax.php');
        String nutzername = o['username'];
        String password = o['password'];

        if (nutzername != null && password != null) {
          bool canCheckBiometrics = await localAuth.canCheckBiometrics;
          if (o['biometrics'] && canCheckBiometrics) {
            bool didAuthenticate = await localAuth.authenticateWithBiometrics(
                localizedReason: 'Bestätige deine Identität');
            if (didAuthenticate) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Loading()));
              Nutzer loginNutzer =
                  await sessionManager.login(nutzername, password);
              // developer.debugger();

              if (loginNutzer != null) {
                nutzer = loginNutzer;
                await Navigator.popUntil(context, (route) => false);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              }
            } else {
              SystemNavigator.pop();
            }
          } else {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Loading()));
            Nutzer loginNutzer =
                await sessionManager.login(nutzername, password);
            // developer.debugger();

            if (loginNutzer != null) {
              nutzer = loginNutzer;
              await Navigator.popUntil(context, (route) => false);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            }
          }
        } else {
          developer.log("No passsword... skipping");
        }
      }
    } else {
      developer.log("No loggedin state... skipping");
    }
  }

  String psw = '';
  String bn = '';
  String bn2 = '';
  bool save_ = false;

  Future<void> anmeldung() async {
    //TODO: Schulauswahl

    SessionManager sessionManager = new SessionManager(
        'https://start.schulportal.hessen.de/index.php?i=' + sid,
        'https://start.schulportal.hessen.de/ajax.php?f=rsaPublicKey',
        'https://start.schulportal.hessen.de/ajax.php?f=rsaHandshake&s=' +
            (new Random().nextInt(90) + 10).toString(),
        'https://start.schulportal.hessen.de/ajax.php');

    String nutzername = bn;
    String password = psw;
    developer.log(nutzername);
    Navigator.push(context, MaterialPageRoute(builder: (context) => Loading()));
    Nutzer loginNutzer = await sessionManager.login(nutzername, password);

    if (loginNutzer != null) {
      nutzer = loginNutzer;
      Map<String, Object> standart_profile = new Map();

      standart_profile.putIfAbsent('username', () => nutzername);
      standart_profile.putIfAbsent('password', () => password);
      standart_profile.putIfAbsent('stay_loggedin', () => save_);
      standart_profile.putIfAbsent('schulid', () => sid);
      standart_profile.putIfAbsent('biometrics', () => false);

      if (save_) {
        bool canCheckBiometrics = await localAuth.canCheckBiometrics;
        if (canCheckBiometrics) {
          showDialog(
              context: context,
              builder: (BuildContext c) {
                return AlertDialog(
                  title: Text(
                      'Willst du biometrische Daten(Fingerabdruck) für den automatischen Login benutzten?'),
                  actions: [
                    FlatButton(
                        onPressed: () async {
                          bool didAuthenticate =
                              await localAuth.authenticateWithBiometrics(
                                  localizedReason: 'Bestätige deine Identität');
                          if (didAuthenticate) {
                            Map<dynamic, dynamic> m =
                                Map<dynamic, dynamic>.from(
                                    box.get("profile_1"));
                            m.update("biometrics", (value) => true);
                            await box.delete("profile_1");
                            await box.put("profile_1", m);
                            Navigator.of(c).pop();

                            CoolAlert.show(
                                context: context,
                                type: CoolAlertType.success,
                                title: "Fertig");
                          }
                        },
                        child: Text('Ja')),
                    FlatButton(onPressed: () {}, child: Text('Später')),
                    FlatButton(onPressed: () {}, child: Text('Nein')),
                  ],
                );
              });
        }
      }
      developer.log("${standart_profile['biometrics']}");
      box.put('profile_1', standart_profile);
      developer.log('profile_1: ${box.get('profile_1')}');
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
  String sel_ = 'Wähle einen Institut aus';
  String sid = "";

  Map<String, List<Schule>> m;
  List<Schule> schul = [];

  Future<List<Object>> _getSchulen() async {
    List<Object> o = [];
    SchuleParser p = SchuleParser();
    m = await p.parsen();
    schul.clear();
    for (var schulen in m.values) {
      for (var schule in schulen) {
        schul.add(schule);
      }
    }
    schul.sort((Schule a, Schule b) => a.name.compareTo(b.name));
    for (var schule in schul) {
      o.add(schule.name + "(" + schule.stadt + ")#" + schule.id);
    }

    return o;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        clipBehavior: Clip.none,
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
            FutureBuilder(
                future: _getSchulen(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Container(
                      child: Center(
                          child: CircularProgressIndicator(
                        value: null,
                      )),
                    );
                  } else if (snapshot.data.length == 0) {
                    return Container(
                      child: Center(
                        child: Text("Es gab Fehler beim Laden der Kreise!"),
                      ),
                    );
                  } else {
                    List<DropdownMenuItem<String>> items = [];

                    for (var data in snapshot.data) {
                      items.add(DropdownMenuItem(
                          value: data,
                          child: Text(
                            data,
                            overflow: TextOverflow.fade,
                          )));
                    }
                    return Container(
                      child: ListTile(
                        title: Text(
                          "Schulauswahl:",
                          style: TextStyle(fontSize: 14),
                        ),
                        subtitle: SearchableDropdown.single(
                          items: items,
                          onChanged: (value) {
                            setState(() {
                              sel_ = value;
                              if (sel_ != null) {
                                sid = sel_.split("#")[1];
                              } else {
                                sid = "";
                              }
                            });
                          },
                          hint: "Wähle ein Institut oder eine Schule aus",
                          closeButton: "Schließen",
                          value: sel_,
                          style: TextStyle(
                              decoration: TextDecoration.none, fontSize: 14),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                    );
                  }
                }),
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
                onSubmitted: (s) {
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
              padding: EdgeInsets.only(left: 10, bottom: 50),
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
