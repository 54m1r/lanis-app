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
import 'package:html/dom.dart' as htmlDom;
import 'package:schulportal_hessen_app/models/unterricht/anhang.dart';
import 'package:schulportal_hessen_app/models/unterricht/kurs.dart';
import 'package:schulportal_hessen_app/utils/utility.dart'; // Contains DOM related classes for extracting data from elements

class UnterrichtParser {
  Map<String, String> headers;

  UnterrichtParser(this.headers) {}

  Future<List<Kurs>> parsen() async {
    var unterrichtResponse = await http.get(
        "https://start.schulportal.hessen.de/meinunterricht.php",
        headers: headers);

    var unterrichtDocument = htmlParser.parse(unterrichtResponse.body);
    var tabellen = unterrichtDocument.querySelectorAll("table");
    var tabelle = tabellen[1];
    List<Kurs> kurse = [];
    var spalten = tabelle.querySelectorAll("tbody > tr");

    for (var spalte in spalten) {
      var columns = spalte.querySelectorAll("td");
      var kurs = columns[0].querySelectorAll("a")[0];
      var link = kurs.attributes['href'].split("&");
      var id = link[1].replaceAll("id=", "");
      var lastEntry = tabellen[0]
          .querySelector("tbody > tr[data-book='${id}']")
          .attributes['data-entry'];
      var halbjahr = link[2].replaceAll("halb=", "");
      List<Lehrer> lehrer_list = [];

      for (var lehrer in columns[1].querySelectorAll("span")) {
        Lehrer l = Lehrer(removeWhitespaces(lehrer.text));
        l.name = lehrer.attributes['title'].split("(")[0];
        lehrer_list.add(l);
      }

      Kurs k = Kurs(id, kurs.text, halbjahr, lehrer_list);
      var anhang = tabellen[0].querySelectorAll(
          "tr[data-book='${id}'] > td:last-child > .btn-group-vertical > .files");
      if (anhang.length >= 1) {
        var anhaenge = anhang[0].querySelectorAll("ul > li");
        for (var al in anhaenge) {
          if (!al.classes.contains("divider") &&
              al.firstChild.attributes['href'] == "#") {
            var size = al.firstChild.text.split("(")[1];

            Anhang a = Anhang(
                id,
                lastEntry,
                al.firstChild.attributes['data-file'],
                size.substring(0, size.length - 1));

            k.addAnhang(a);
          }
        }
      }
      var stunde = tabellen[0]
          .querySelectorAll("tbody > tr[data-book='${id}'] > td > small");
      k.setLetzteStunde(removeWhitespaces(stunde[0].text));

      var hausaufgabe = tabellen[0]
          .querySelectorAll("tbody > tr[data-book='${id}'] > td > .homework");
      if (hausaufgabe.length == 1) {
        k.setHausaufgabe(true);
        k.setHausaufgabeErledigt(
            hausaufgabe[0].getElementsByClassName("undone").length == 0);
      }

      kurse.add(k);
    }
    return kurse;
  }
}
