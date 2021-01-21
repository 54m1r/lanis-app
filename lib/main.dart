import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import 'dart:io';
import 'dart:math';

import 'package:crypton/crypton.dart';
import 'package:vertretungsplan_app/models/vertretungsplan.dart';
import 'package:vertretungsplan_app/screens/login.dart';
import 'package:vertretungsplan_app/utils/cryptojs_aes_encryption_helper.dart';

import 'package:http/http.dart' as http;

import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart' as htmlDom;

import 'dart:convert' as convert;
import 'package:intl/intl.dart';
import 'package:vertretungsplan_app/utils/session_manager.dart';
import 'package:vertretungsplan_app/utils/vertretungsplan_parser.dart';

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






