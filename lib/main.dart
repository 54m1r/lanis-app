import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:local_auth/local_auth.dart';

import 'package:schulportal_hessen_app/screens/home.dart';
import 'package:schulportal_hessen_app/screens/loading.dart';
import 'package:schulportal_hessen_app/screens/dashboard.dart';
import 'package:schulportal_hessen_app/screens/login.dart';

import 'dart:developer' as developer;
import 'models/nutzer.dart';

import 'package:flutter/services.dart';

//SessionManager sessionManager;
Nutzer nutzer;
final storage = new FlutterSecureStorage();
Box box;
LocalAuthentication localAuth;

void main() async {
  //SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
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
  await Hive.initFlutter();

  box = await Hive.openBox("schulportal");
 localAuth = LocalAuthentication();
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: false // optional: set false to disable printing logs to console
      );

  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: Willkommen()));
}

class SchoolManagement extends StatefulWidget {
  @override
  _SchoolManagementState createState() => _SchoolManagementState();
}

class _SchoolManagementState extends State<SchoolManagement> {
  int _selectedItemIndex = 0;
  final List pages = [
    CalendarPage(),
    null,
    null,
    CalendarPage(),
    null,
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: pages[_selectedItemIndex]),
    );
  }
}
