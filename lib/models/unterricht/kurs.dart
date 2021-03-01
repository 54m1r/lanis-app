import 'package:schulportal_hessen_app/models/unterricht/kursstunde.dart';

import '../lehrer.dart';

class Kurs {
  final String id;
  final String kursname;
  final String halbjahr;

  List<KursStunde> stunden;
  List<Lehrer> lehrer;

  Kurs(this.id, this.kursname, this.halbjahr, this.stunden, this.lehrer) {}
}
