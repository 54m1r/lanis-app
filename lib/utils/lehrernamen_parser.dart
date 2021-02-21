import 'dart:convert';
import 'dart:developer' as developer;

import 'package:vertretungsplan_app/models/fach.dart';
import 'package:vertretungsplan_app/models/klasse.dart';
import 'package:vertretungsplan_app/models/lehrer.dart';
import 'package:vertretungsplan_app/models/raum.dart';
import 'package:vertretungsplan_app/models/stunde.dart';
import 'package:vertretungsplan_app/models/stundenplan.dart';

import 'package:http/http.dart' as http;

import 'package:html/parser.dart'
    as htmlParser; // Contains HTML parsers to generate a Document object
import 'package:html/dom.dart'
    as htmlDom; // Contains DOM related classes for extracting data from elements
import 'package:vertretungsplan_app/models/tag.dart';

import 'package:vertretungsplan_app/utils/utility.dart';

class LehrerNamenParser {
  Map<String, String> headers;

  final String lehrerUrl;

  LehrerNamenParser(this.headers, this.lehrerUrl) {}

  Future<String> parsen() async {
    var lehrerResponse = await http.get(lehrerUrl, headers: headers);
    var res = jsonDecode(lehrerResponse.body);
    var t = res['items'][0]['text'].toString();

    return t.split("(")[0];
  }
}
