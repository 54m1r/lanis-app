import 'package:schulportal_hessen_app/models/vertretung.dart';

import 'vertretungsplanTag.dart';

class Vertretungsplan {
  List<Vertretung> vertretungen;

  final DateTime zuletztAktualisiert;

  Vertretungsplan(this.zuletztAktualisiert) {
    vertretungen = new List<Vertretung>();
  }
}