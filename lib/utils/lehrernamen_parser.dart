import 'dart:convert';
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
import 'package:schulportal_hessen_app/models/tag.dart';

import 'package:schulportal_hessen_app/utils/utility.dart';

class LehrerNamenParser {
  Map<String, String> headers;

  final String lehrerUrl;
  final String kuerzel;

  LehrerNamenParser(this.headers, this.lehrerUrl, this.kuerzel) {}

  Future<String> parsen() async {
    var lehrerResponse = await http.get(Uri.parse(lehrerUrl), headers: headers);
    var res = jsonDecode(lehrerResponse.body);
    var x = 0;
    var t = "";
    var vt = "";
    while (!vt.contains("(${kuerzel.toUpperCase()})")) {
      t = res['items'][x]['text'].toString();
      vt = t;
      x++;
    }


    return t.split("(")[0];
  }
}
