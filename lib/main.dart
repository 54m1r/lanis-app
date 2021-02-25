
import 'package:flutter/material.dart';
import 'package:schulportal_hessen_app/screens/login.dart';

import 'models/nutzer.dart';

//SessionManager sessionManager;
Nutzer nutzer;

void main() async {
  /*SessionManager sessionManager = new SessionManager('https://start.schulportal.hessen.de/index.php?i=6271',
      'https://start.schulportal.hessen.de/ajax.php?f=rsaPublicKey',
      'https://start.schulportal.hessen.de/ajax.php?f=rsaHandshake&s='+(new Random().nextInt(90) + 10).toString(),
      'https://start.schulportal.hessen.de/ajax.php');

  String nutzername = '';
  String password = '';

  await sessionManager.login(nutzername, password);

  VertretungsplanParser vertretungsplanParser = new VertretungsplanParser(sessionManager.headers, 'https://start.schulportal.hessen.de/vertretungsplan.php');
  Vertretungsplan vertretungsplan = await vertretungsplanParser.parsen();

  developer.log(vertretungsplan.tage[2].vertretungen.length.toString()); */

  runApp(MaterialApp(home: Willkommen()));
}
