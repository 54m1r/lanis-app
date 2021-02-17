import 'fach.dart';
import 'lehrer.dart';
import 'raum.dart';
import 'tag.dart';

class Stunde {
  Stunde(this.lehrer, this.fach, this.raum, this.stunde, this.tag, this.zeitraum) {}
  final Lehrer lehrer;
  final Raum raum;
  final Fach fach;
  final int stunde;
  final Tag tag;
  final String zeitraum;
}
