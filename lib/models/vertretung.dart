import 'fach.dart';
import 'klasse.dart';
import 'lehrer.dart';
import 'raum.dart';
import 'vertretungsplanTag.dart';

class Vertretung {
  final int stunde;
  final Klasse klasse;
  final Lehrer vertreter;
  final Lehrer lehrer;
  final Fach fach;
  final Raum raum;
  final String hinweis;
  final String hinweis2;
  final VertretungsplanTag vertretungsPlanTag;

  Vertretung(this.stunde, this.klasse, this.vertreter, this.lehrer, this.fach,
      this.raum, this.hinweis, this.hinweis2, this.vertretungsPlanTag);
}
