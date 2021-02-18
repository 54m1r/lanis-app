import 'package:http/http.dart' as http;

import 'package:html/parser.dart'
    as htmlParser; // Contains HTML parsers to generate a Document object
import 'package:html/dom.dart'
    as htmlDom; // Contains DOM related classes for extracting data from elements

class Lehrer {
  final String kuerzel;

  Lehrer(this.kuerzel);
  Future<String> getLehrerInformationen(Map<String, String> header) async {
    //https://start.schulportal.hessen.de/nachrichten.php?a=searchRecipt&q="name/kuerzel"

    var lehrerInfoResponse = await http.get(
        "https://start.schulportal.hessen.de/nachrichten.php?q=${kuerzel}&a=searchRecipt",
        headers: header);

    return lehrerInfoResponse.body;
  }

  String get name{
    return "";
  }
  String get nachname{
    return "";
  }
}

