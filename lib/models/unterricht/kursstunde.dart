import 'package:schulportal_hessen_app/models/unterricht/anwesenheit.dart';

import 'anhang.dart';
import 'kurs.dart';

class KursStunde {
  Kurs kurs;
  String titel;
  String beschreibung;
  String datum;
  String stunde;
  Anwesenheit anwesenheit;
  List<Anhang> anhaenge;

  KursStunde(this.kurs, this.titel, this.beschreibung, this.datum, this.stunde,
      this.anwesenheit, this.anhaenge) {}
}
