import 'package:vertretungsplan_app/models/vertretung.dart';
import 'package:intl/intl.dart';

class VertretungsplanTag {

  final DateTime tag;

  VertretungsplanTag(this.tag) {
  }

  String getFormattedDate() {
    final DateFormat formatter = DateFormat('EEEE, dd.MM.yyyy');
    final String formatted = formatter.format(tag);
    return formatted;
  }
}
