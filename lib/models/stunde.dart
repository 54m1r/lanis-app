import 'fach.dart';
import 'lehrer.dart';
import 'raum.dart';

class Stunde {
  Stunde(this.lehrer, this.fach, this.raum, this.stunde, this.zeitraum) {}
  final Lehrer lehrer;
  final Raum raum;
  final Fach fach;
  final int stunde;
  final String zeitraum;
}
