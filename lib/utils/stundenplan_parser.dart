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
    Map<int, List<List<Stunde>>> plan_map = new Map();
    for (var zeile in zeilen) {
      var spalten_selector = zeile.querySelectorAll("td");
      int stunde_c = int.parse(removeWhitespaces(
          spalten_selector[0].children[1].text.split(".")[0]));

      var counter = 0;
      List<List<Stunde>> stunden_collection_list = [];
      for (var spalte in spalten_selector) {
        if (counter != 0) {
          Tag t = Tag.values[counter - 1];

          var stunden = spalte.querySelectorAll(".stunde");
          List<Stunde> stunden_list = [];

          if (stunden.length == 0) {
            //Freistunde
            Stunde s = Stunde(
                Lehrer("Frei"),
                Fach("Frei"),
                Raum("Frei"),
                stunde_c,
                t,
                removeWhitespaces(
                    spalten_selector[0].children[0].text.split("Stunde")[1]));
            stunden_list.add(s);
          } else {
            for (var stunde in stunden) {
              Stunde s = Stunde(
                  Lehrer(removeWhitespaces(stunde.children[2].text)),
                  Fach(stunde.children[0].text),
                  Raum(removeWhitespaces(stunde.attributes['title']
                      .split("Raum ")[1]
                      .split(" ")[0])),
                  stunde_c,
                  t,
                  removeWhitespaces(
                      spalten_selector[0].children[0].text.split("Stunde")[1]));
              stunden_list.add(s);
            }
          }
          stunden_collection_list.add(stunden_list);
        }

        counter++;
      }
      if(stunden_collection_list.length == 5){
        plan_map.putIfAbsent(stunde_c, () => stunden_collection_list);

      }else{
        developer.log("Es wurden nicht alle Tage vom Stundenplan generiert!");
      }
    }

    Stundenplan plan = Stundenplan(k, gueltigkeit, plan_map);

    return plan;
  }
}
