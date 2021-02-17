import 'klasse.dart';
import 'stunde.dart';

class Stundenplan {
  Stundenplan(this.klasse, this.gueltigkeit, this.stunden);

  Klasse klasse;
  String gueltigkeit;
  Map<int, List<List<Stunde>>> stunden;
}
