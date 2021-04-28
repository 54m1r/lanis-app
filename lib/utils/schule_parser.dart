import 'dart:convert';
import 'dart:developer' as developer;

import 'package:html_character_entities/html_character_entities.dart';
import 'package:schulportal_hessen_app/models/fach.dart';
import 'package:schulportal_hessen_app/models/klasse.dart';
import 'package:schulportal_hessen_app/models/landkreis.dart';
import 'package:schulportal_hessen_app/models/lehrer.dart';
import 'package:schulportal_hessen_app/models/raum.dart';
import 'package:schulportal_hessen_app/models/schule.dart';
import 'package:schulportal_hessen_app/models/stunde.dart';
import 'package:schulportal_hessen_app/models/stundenplan.dart';

import 'package:http/http.dart' as http;

import 'package:html/parser.dart'
    as htmlParser; // Contains HTML parsers to generate a Document object
import 'package:html/dom.dart'
    as htmlDom; // Contains DOM related classes for extracting data from elements
import 'package:schulportal_hessen_app/models/tag.dart';

import 'package:schulportal_hessen_app/utils/utility.dart';

class SchuleParser {
  Future<Map<String, List<Schule>>> parsen() async {
    Map<String, List<Schule>> schulen = new Map();

    var lehrerResponse = await http.get(
        Uri.parse("https://start.schulportal.hessen.de/index.php"),
        headers: {});
    var lehrerDocument = htmlParser.parse(lehrerResponse.body);
    var kreise =
        lehrerDocument.getElementById("accordion").querySelectorAll(".panel");
    for (var kreis in kreise) {
      List<Schule> schule_list = [];
      Landkreis lk = Landkreis(HtmlCharacterEntities.decode(removeWhitespaces(kreis
          .querySelector(".panel-heading")
          .querySelector(".panel-title")
          .querySelector(".accordion-toggle")
          .text)));

      for(var schule in kreis.querySelector(".panel-collapse > .panel-body > .list-group").querySelectorAll(".list-group-item")){
        var schule_stadt = HtmlCharacterEntities.decode(schule.querySelector("small").text);
        var schule_name = HtmlCharacterEntities.decode(schule.innerHtml.replaceAll("<small>"+schule_stadt+"</small>", ""));


        Schule s = Schule(schule.attributes['data-id'], schule_name, schule_stadt, lk);
        schule_list.add(s);
      }
      schulen.putIfAbsent(lk.name, () => schule_list);
    }
    return schulen;
  }
}
