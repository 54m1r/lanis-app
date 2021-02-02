
import 'dart:developer' as developer;



import 'package:vertretungsplan_app/models/klasse.dart';
import 'package:vertretungsplan_app/models/stundenplan.dart';

import 'package:http/http.dart' as http;

import 'package:html/parser.dart'
    as htmlParser; // Contains HTML parsers to generate a Document object
import 'package:html/dom.dart'
    as htmlDom; // Contains DOM related classes for extracting data from elements

import 'dart:convert' as convert;
import 'package:intl/intl.dart';
import 'package:vertretungsplan_app/models/stundenplantag.dart';
import 'package:vertretungsplan_app/utils/utility.dart';

class StundenplanParser {
  Map<String, String> headers;

  final String stundenplanUrl;

  StundenplanParser(this.headers, this.stundenplanUrl) {
    developer.log("New Stundenplanparser initiated");
  }

  Future<Stundenplan> parsen() async {
    var stundenplanResponse = await http.get(stundenplanUrl, headers: headers);

    var stundenplanDocument = htmlParser.parse(stundenplanResponse.body);
    var tabellen = stundenplanDocument.getElementsByTagName("table");

    var tabelle = tabellen[0];
    var zeilen = tabelle.querySelectorAll('tbody tr');
    var tag_name = tabelle.querySelectorAll('thead th');
    Klasse k = new Klasse(
        stundenplanDocument.getElementsByTagName("h2")[0].text.split(" ")[2]);
    String gueltigkeit =
        stundenplanDocument.querySelector(".plan").attributes["data-date"];
    developer.log("${zeilen.length}");

    developer.log(zeilen
        .elementAt(1)
        .querySelectorAll("td")
        .elementAt(2)
        .getElementsByTagName("b")[0]
        .text);
  }
}
