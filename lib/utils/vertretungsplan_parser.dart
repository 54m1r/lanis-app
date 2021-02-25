import 'dart:developer' as developer;

import 'dart:io';
import 'dart:math';

import 'package:crypton/crypton.dart';
import 'package:schulportal_hessen_app/models/fach.dart';
import 'package:schulportal_hessen_app/models/klasse.dart';
import 'package:schulportal_hessen_app/models/lehrer.dart';
import 'package:schulportal_hessen_app/models/raum.dart';
import 'package:schulportal_hessen_app/models/vertretung.dart';
import 'package:schulportal_hessen_app/models/vertretungsplan.dart';
import 'package:schulportal_hessen_app/models/vertretungsplanTag.dart';
import 'package:schulportal_hessen_app/utils/cryptojs_aes_encryption_helper.dart';

import 'package:http/http.dart' as http;

import 'package:html/parser.dart'
as htmlParser; // Contains HTML parsers to generate a Document object
import 'package:html/dom.dart'
as htmlDom; // Contains DOM related classes for extracting data from elements

import 'dart:convert' as convert;
import 'package:intl/intl.dart';
import 'package:schulportal_hessen_app/utils/utility.dart';

class VertretungsplanParser {
  Map<String, String> headers;

  final String vertretungsplanUrl;

  VertretungsplanParser(this.headers, this.vertretungsplanUrl) {
    //TODO
  }

  Future<Vertretungsplan> parsen() async {
    developer.log("Trying to get Vertretungsplan");
    var vertretungsplanResponse =
    await http.get(vertretungsplanUrl, headers: headers);


    var vertretungsPlanDocument =
    htmlParser.parse(vertretungsplanResponse.body);
    var tabellen = vertretungsPlanDocument.getElementsByTagName('table');

    //TODO fixen
    /*var asdasd = new DateFormat("dd_MM_yyyy").format(DateTime.now());
    var zuletztAktualisiert = vertretungsPlanDocument.querySelector('#tag$asdasd > div:nth-child(2) > div:nth-child(4) > i:nth-child(1)');
    //#tag18_12_2020 > div:nth-child(2) > div:nth-child(4) > i:nth-child(1)
    //#tag16_12_2020 > div:nth-child(2) > div:nth-child(4) > i:nth-child(1)
    developer.log('#tag$asdasd > div:nth-child(2) > div:nth-child(4) > i:nth-child(1)');
    developer.log(zuletztAktualisiert.toString()); */
    //#tag16_12_2020 > div:nth-child(2) > div:nth-child(4) > i:nth-child(1)

    Vertretungsplan vertretungsplan = new Vertretungsplan(DateTime.now());

    tabellen.forEach((tabelle) {
      if (tabelle.attributes['id'] != null &&
          tabelle.attributes['id'].contains('vtable')) {
        var toParse = tabelle.attributes['id'];
        toParse = toParse.replaceFirst('vtable', '');
        DateTime tempDate =
        new DateFormat("dd_MM_yyyy").parse(toParse); //vtable18_01_2021
        var day = new DateFormat("dd.MM.yyyy").format(tempDate);

        VertretungsplanTag vertretungsplanTag =
        new VertretungsplanTag(tempDate);

        var zeilen = tabelle.querySelectorAll('tbody tr');

        zeilen.forEach((zeile) {
          var td = zeile.getElementsByTagName('td');

          if (td.length > 1) {
            int stunde = int.parse(removeWhitespaces(td[0].text));
            Klasse klasse = new Klasse(removeWhitespaces(td[1].text));
            Lehrer vertreter = new Lehrer(removeWhitespaces(td[2].text));
            Lehrer lehrer = new Lehrer(removeWhitespaces(td[3].text));
            Fach fach = new Fach(removeWhitespaces(td[4].text));
            Raum raum = new Raum(removeWhitespaces(td[5].text));
            String hinweis = removeWhitespaces(td[6].text);
            String hinweis2 = removeWhitespaces(td[7].text);
            Vertretung vertretung = new Vertretung(stunde, klasse, vertreter,
                lehrer, fach, raum, hinweis, hinweis2, vertretungsplanTag);
            vertretungsplan.vertretungen.add(vertretung);
          }

           else {
            var rng = new Random();
            for (var i = 0; i < rng.nextInt(4)+1; i++) {
              int stunde = i+1;
              Klasse klasse = new Klasse("12BG2");
              Lehrer vertreter = new Lehrer("Wan");
              Lehrer lehrer = new Lehrer("Kmi");
              Fach fach = new Fach("M");
              Raum raum = new Raum("1105");
              String hinweis = removeWhitespaces("hinweis");
              String hinweis2 = removeWhitespaces("hinweis2");

              Vertretung vertretung = new Vertretung(stunde, klasse, vertreter,
                  lehrer, fach, raum, hinweis, hinweis2, vertretungsplanTag);
              vertretungsplan.vertretungen.add(vertretung);
            }
          }
        });
      }
    });
    return vertretungsplan;
  }

  String generateAesKey() {
    //TODO generate random (aes(uuid, uuid)
    return "U2FsdGVkX1/qivbk/1nD4kJnp6Exl5vIrzG59F58/23ViKMD6B63f6II27qtCVTVLTuTVpnqYaYgv1LlSI+Fsw==";
  }
}
