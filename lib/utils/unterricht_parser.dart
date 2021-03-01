import 'dart:developer' as developer;

import 'package:schulportal_hessen_app/models/fach.dart';
import 'package:schulportal_hessen_app/models/klasse.dart';
import 'package:schulportal_hessen_app/models/lehrer.dart';
import 'package:schulportal_hessen_app/models/raum.dart';
import 'package:schulportal_hessen_app/models/stunde.dart';
import 'package:schulportal_hessen_app/models/stundenplan.dart';

import 'package:http/http.dart' as http;

import 'package:html/parser.dart'
    as htmlParser; // Contains HTML parsers to generate a Document object
import 'package:html/dom.dart'
    as htmlDom; // Contains DOM related classes for extracting data from elements

class UnterrichtParser {
  Map<String, String> headers;

  Future<String> parsen() async {
    var stundenplanResponse = await http.get("", headers: headers);

    var stundenplanDocument = htmlParser.parse(stundenplanResponse.body); 
  }
}
