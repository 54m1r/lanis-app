import 'klasse.dart';
import 'stundenplantag.dart';

class Stundenplan {
  Stundenplan(this.klasse, this.gueltigkeit, this.tage);

  Klasse klasse;
  String gueltigkeit;
  List<Stundenplantag> tage;
}
