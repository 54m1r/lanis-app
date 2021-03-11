import 'package:schulportal_hessen_app/models/unterricht/anhang.dart';
import 'package:schulportal_hessen_app/models/unterricht/kursstunde.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as developer;
import 'package:intl/date_symbol_data_file.dart';
import '../lehrer.dart';
import '../tag.dart';

class Kurs {
  final String id;
  final String kursname;
  final String halbjahr;
  List<Anhang> anhaenge = [];
  String letzteStunde = "";
  bool hausaufgabe = false;
  bool hausaufgabe_erledigt = false;

  void addAnhang(Anhang an) {
    this.anhaenge.add(an);
  }

  void setLetzteStunde(String s) {
    final DateFormat formatter = DateFormat('EEEE, dd.MM.yyyy');
    var sp = s.split(".");

    String formatted = formatter
        .format(DateTime(int.parse(sp[2]), int.parse(sp[1]), int.parse(sp[0])));

    this.letzteStunde = Tag.freitag.replaceTranslation(formatted);
  }

  void setHausaufgabe(bool v) {
    this.hausaufgabe = v;
  }

  void setHausaufgabeErledigt(bool v) {
    this.hausaufgabe_erledigt = v;
  }

  List<Lehrer> lehrer;

  Kurs(this.id, this.kursname, this.halbjahr, this.lehrer) {}
}
