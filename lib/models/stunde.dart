import 'fach.dart';
import 'lehrer.dart';
import 'raum.dart';

class Stunde {
  Stunde(this.lehrer, this.fach, this.raum, this.stunde, this.zeitraum) {}
  Lehrer lehrer;
  Raum raum;
  Fach fach;
  int stunde;
  String zeitraum;
}
