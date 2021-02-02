import 'package:vertretungsplan_app/models/stunde.dart';

class Stundenplantag{
  Stundenplantag(this.stunden, this.tag);
  List<List<Stunde>> stunden;
  String tag;
}