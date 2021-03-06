import 'package:schulportal_hessen_app/models/unterricht/kursstunde.dart';

import '../lehrer.dart';

class Kurs {
  final String id;
  final String kursname;
  final String halbjahr;
  int anhaenge = 0;
  String letzteStunde = "";
  bool hausaufgabe = false;
  bool hausaufgabe_erledigt = false;

  void setAnhaenge(int an) {
    this.anhaenge = an;
  }
  void setLetzteStunde(String s) {
    this.letzteStunde = s;
  }
  void setHausaufgabe(bool v){
    this.hausaufgabe = v;
  }
  void setHausaufgabeErledigt(bool v){
    this.hausaufgabe_erledigt = v;
  }
  List<Lehrer> lehrer;

  Kurs(this.id, this.kursname, this.halbjahr, this.lehrer) {}
}
