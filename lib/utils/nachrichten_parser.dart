import 'dart:developer' as developer;

import 'dart:io';
import 'dart:math';

import 'package:crypton/crypton.dart';
import 'package:vertretungsplan_app/models/fach.dart';
import 'package:vertretungsplan_app/models/klasse.dart';
import 'package:vertretungsplan_app/models/lehrer.dart';
import 'package:vertretungsplan_app/models/raum.dart';
import 'package:vertretungsplan_app/models/vertretung.dart';
import 'package:vertretungsplan_app/models/vertretungsplan.dart';
import 'package:vertretungsplan_app/models/vertretungsplanTag.dart';
import 'package:vertretungsplan_app/utils/cryptojs_aes_encryption_helper.dart';

import 'package:http/http.dart' as http;

import 'package:html/parser.dart'
    as htmlParser; // Contains HTML parsers to generate a Document object
import 'package:html/dom.dart'
    as htmlDom; // Contains DOM related classes for extracting data from elements

import 'dart:convert' as convert;
import 'package:intl/intl.dart';
import 'package:vertretungsplan_app/utils/utility.dart';

class NachrichtenParser {
  Map<String, String> headers;

  final String nachrichtenUrl;

  NachrichtenParser(this.headers, this.nachrichtenUrl) {

    //TODO
  }

  Future<Vertretungsplan> parsen() async {
    developer.log("${headers}");
    await http.get(nachrichtenUrl, headers: headers);
    await http.get('https://start.schulportal.hessen.de/js/log.js', headers: headers);
    await http.get('https://start.schulportal.hessen.de/js/log.js', headers: headers);
    await http.get('https://start.schulportal.hessen.de/css/responsive-text.css', headers: headers);
    await http.get('https://start.schulportal.hessen.de/import/fontawesome/css/all.min.css', headers: headers);
    await http.get('https://start.schulportal.hessen.de/import/fontawesome/css/solid.min.css', headers: headers);
    await http.get('https://start.schulportal.hessen.de/import/fontawesome/css/v4-shims.min.css', headers: headers);
    await http.get('https://start.schulportal.hessen.de/js/jquery-1.11.2.min.js', headers: headers);
    await http.get('https://start.schulportal.hessen.de/css/theme.css', headers: headers);
    await http.get('https://start.schulportal.hessen.de/css/jquery-ui.min.css', headers: headers);
    await http.get('https://start.schulportal.hessen.de/js/jquery-ui.min.js', headers: headers);
    await http.get('https://start.schulportal.hessen.de/js/stickynav.js', headers: headers);
    await http.get('https://start.schulportal.hessen.de/js/bootstrap.min.js', headers: headers);
    //await http.get('', headers: headers);await http.get('', headers: headers);
    await http.get('https://start.schulportal.hessen.de/css/own.20161117.css', headers: headers);
    await http.get('https://start.schulportal.hessen.de/css/bootstrap.submenue.css', headers: headers);
    await http.get('https://start.schulportal.hessen.de/css/navbar-custom-sph.css', headers: headers);
    await http.get('https://start.schulportal.hessen.de/js/jquery.cookie.js', headers: headers);
    await http.get('https://start.schulportal.hessen.de/module/startseite/js/topapps.js', headers: headers);
    await http.get('https://start.schulportal.hessen.de/js/jquery.logoutTimer.js', headers: headers);
    await http.get('https://start.schulportal.hessen.de/js/allPages.js', headers: headers);
    await http.get('https://start.schulportal.hessen.de/module/matheretter/js/matheretter.js', headers: headers);
    await http.get('https://start.schulportal.hessen.de/module/nachrichten/css/start.css', headers: headers);
    await http.get('https://start.schulportal.hessen.de/import/select2/css/select2.min.css', headers: headers);
    await http.get('https://start.schulportal.hessen.de/import/select2/js/select2.min.js', headers: headers);
    await http.get('https://start.schulportal.hessen.de/import/select2/js/select2.min.js', headers: headers);
    await http.get('https://start.schulportal.hessen.de/import/select2/js/select2.min.js', headers: headers);
    await http.get('https://start.schulportal.hessen.de/import/bootstrap-table/bootstrap-table.min.js', headers: headers);
    await http.get('https://start.schulportal.hessen.de/import/bootstrap-table/locale/bootstrap-table-de-DE.min.js', headers: headers);
    await http.get('https://start.schulportal.hessen.de/import/bootstrap-table/extensions/export/bootstrap-table-export.js', headers: headers);
    await http.get('https://start.schulportal.hessen.de/import/bootstrap-table-export/tableExport.min.js', headers: headers);
    await http.get('https://start.schulportal.hessen.de/import/FileSaver/FileSaver.min.js', headers: headers);
    await http.get('https://start.schulportal.hessen.de/import/html2canvas/html2canvas.min.js', headers: headers);
    await http.get('https://start.schulportal.hessen.de/import/jsPDF/jspdf.min.js', headers: headers);
    await http.get('https://start.schulportal.hessen.de/import/jsPDF-AutoTable/jspdf.plugin.autotable.js', headers: headers);
    await http.get('https://start.schulportal.hessen.de/import/bootstrap-table/extensions/cookie/bootstrap-table-cookie.js', headers: headers);
    await http.get('https://start.schulportal.hessen.de/js/bootbox.min.js', headers: headers);
    await http.get('https://start.schulportal.hessen.de/js/autoadmin.js', headers: headers);
    await http.get('https://start.schulportal.hessen.de/import/rowselector/rowselector.css', headers: headers);
    await http.get('https://start.schulportal.hessen.de/module/nachrichten/js/start.js?t=1610039521', headers: headers);
    await http.get('https://start.schulportal.hessen.de/import/bootstrap-table/bootstrap-table-filter-control.js', headers: headers);
    await http.get('https://start.schulportal.hessen.de/js/jquery.storageapi.min.js', headers: headers);
    await http.get('https://start.schulportal.hessen.de/libs/jcryption/jquery.jcryption.3.1.0.js', headers: headers);
    await http.get('https://start.schulportal.hessen.de/js/createAEStoken.js', headers: headers);
    await http.get('https://start.schulportal.hessen.de/js/markup.js', headers: headers);
    await http.get('https://start.schulportal.hessen.de/import/push_notification.min.js', headers: headers);
    await http.get('https://start.schulportal.hessen.de/import/jquery.doubletap.js', headers: headers);
    await http.get('https://start.schulportal.hessen.de/import/jquery.doubletap.js', headers: headers);
    await http.get('https://start.schulportal.hessen.de/module/pin/js/pagemenue.js', headers: headers);
    await http.get('https://start.schulportal.hessen.de/img/logo-schulportal-topbar.png', headers: headers);
    await http.get('https://start.schulportal.hessen.de/img/logo-schulportal-topbar.png', headers: headers);
    await http.get('https://start.schulportal.hessen.de/import/fontawesome/webfonts/fa-solid-900.woff2', headers: headers);
    await http.get('https://start.schulportal.hessen.de/fonts/glyphicons-halflings-regular.woff2', headers: headers);
    await http.get('https://start.schulportal.hessen.de/import/fontawesome/webfonts/fa-regular-400.woff2', headers: headers);
    await http.get('https://start.schulportal.hessen.de/js/bootbox.min.js', headers: headers);
    await http.get('https://start.schulportal.hessen.de/img/logo-schulportal-footer.png', headers: headers);
    //await http.get('', headers: headers);
    //await http.get('', headers: headers);

    var nachrichtenResponse = await http.post('https://start.schulportal.hessen.de/nachrichten.php?a=headers&getType=visibleOnly&last=0', headers: headers);
    developer.log("${nachrichtenResponse.body}");
    //var nachrichtenJsonResponse = convert.jsonDecode(nachrichtenResponse.body);

    developer.log("Anfragen gesendet!");
    developer.log(nachrichtenResponse.body.toString());

    return null;
  }
}
/* POST /nachrichten.php HTTP/1.1
Host: start.schulportal.hessen.de
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:85.0) Gecko/20100101 Firefox/85.0
Accept-Language: de,en-US;q=0.7,en;q=0.3
Accept-Encoding: gzip, deflate, br
Content-Type: application/x-www-form-urlencoded; charset=UTF-8
X-Requested-With: XMLHttpRequest
Content-Length: 36
Origin: https://start.schulportal.hessen.de
Connection: keep-alive
Referer: https://start.schulportal.hessen.de/nachrichten.php
Cookie: complianceCookie=on; schulportal_lastschool=6271; schulportal_logindomain=login.schulportal.hessen.de; sid=01ds645ies2h3h662liepeo6t2seesuv5mf9avqguartk0uv4jn94031uggoctav7loldmfo0uc04kq3gnap26obsiujqa1jph8kcu3
Cache-Control: max-age=0 */