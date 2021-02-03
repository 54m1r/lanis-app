import 'klasse.dart';
import 'stundenplantag.dart';

class Stundenplan {
  Stundenplan(this.klasse, this.gueltigkeit, this.tage);

  Klasse klasse;
  String gueltigkeit;
  List<Stundenplantag> tage;

  Stundenplantag getTag(var tag) {
    tage.forEach((element) {
      if (element.tag == tag) return element;
    });
    return null;
  }
}
