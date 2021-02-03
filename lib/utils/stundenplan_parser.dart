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

import 'package:vertretungsplan_app/models/stundenplantag.dart';
import 'package:vertretungsplan_app/utils/utility.dart';

class StundenplanParser {
  Map<String, String> headers;

  final String stundenplanUrl;

  StundenplanParser(this.headers, this.stundenplanUrl) {}

  Future<Stundenplan> parsen() async {
    var stundenplanResponse = await http.get(stundenplanUrl, headers: headers);

    var stundenplanDocument = htmlParser.parse(stundenplanResponse.body);
    var tabellen = stundenplanDocument.getElementsByTagName("table");

    var tabelle = tabellen[0];
    List<htmlDom.Element> zeilen = tabelle.querySelectorAll('tbody tr');
    Klasse k = new Klasse(
        stundenplanDocument.getElementsByTagName("h2")[0].text.split(" ")[2]);
    String gueltigkeit =
        stundenplanDocument.querySelector(".plan").attributes["data-date"];

    List<List<Stunde>> montag = [];
    List<List<Stunde>> dienstag = [];
    List<List<Stunde>> mittwoch = [];
    List<List<Stunde>> donnerstag = [];
    List<List<Stunde>> freitag = [];
    var x = 0;
    for (var zeile in zeilen) {
      var c = 0;
      x++;
      for (var td in zeile.getElementsByTagName("td")) {
        // c++;
        List<Fach> faecher = [];
        List<Lehrer> lehrer = [];
        List<Raum> raeume = [];
        if (td.attributes['rowspan'] != "1" &&
            removeWhitespaces(td.text) == "") {
          faecher.add(new Fach("frei"));
          lehrer.add(new Lehrer("frei"));
          raeume.add(new Raum("frei"));
        }

        for (var bold in td.getElementsByTagName("b")) {
          if (removeWhitespaces(bold.text) != "") {
            if (!bold.text.contains("Stunde")) faecher.add(new Fach(bold.text));
          }
        }
        for (var ln in td.getElementsByTagName("small")) {
          if (ln.parent.classes.first.toString() != "VonBis") {
            lehrer.add(new Lehrer(ln.text));
          }
        }

        for (var st in td.getElementsByClassName("stunde")) {
          raeume.add(new Raum(st.attributes['title'].split(" ")[3]));
        }
        //developer.log("Listen:");
        //developer.log("${faecher}");
        //developer.log("${lehrer}");
        //developer.log("${raeume}");
        if (faecher.isNotEmpty && lehrer.isNotEmpty && raeume.isNotEmpty) {
          c++;
          List<Stunde> stunden = [];
          for (var l = 0; l < faecher.length; l++) {
            Stunde s = new Stunde(
                lehrer.elementAt(l),
                faecher.elementAt(l),
                raeume.elementAt(l),
                x,
                zeilen
                    .elementAt(x - 1)
                    .getElementsByClassName("VonBis")
                    .first
                    .text);
            stunden.add(s);
          }

          switch (c) {
            case 1:
              montag.add(stunden);

              break;
            case 2:
              dienstag.add(stunden);
              break;
            case 3:
              mittwoch.add(stunden);
              break;
            case 4:
              donnerstag.add(stunden);
              break;
            case 5:
              freitag.add(stunden);
              c = 0;
              break;
          }
        }
      }
    }
    List<Stundenplantag> tage = [];
    tage.add(new Stundenplantag(montag, "Montag"));
    tage.add(new Stundenplantag(dienstag, "Dienstag"));
    tage.add(new Stundenplantag(mittwoch, "Mittwoch"));
    tage.add(new Stundenplantag(donnerstag, "Donnerstag"));
    tage.add(new Stundenplantag(freitag, "Freitag"));
    Stundenplan s = new Stundenplan(k, gueltigkeit, tage);

    developer.log("${s.tage}");

    return s;
  }
}
