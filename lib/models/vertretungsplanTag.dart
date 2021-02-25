import 'package:schulportal_hessen_app/models/vertretung.dart';
import 'package:intl/intl.dart';
import 'tag.dart';
import 'dart:developer' as developer;
import 'package:intl/date_symbol_data_file.dart';

class VertretungsplanTag {

  final DateTime tag;

  VertretungsplanTag(this.tag);

  String getFormattedDate() {
    final DateFormat formatter = DateFormat('EEEE, dd.MM.yyyy');
    String formatted = formatter.format(tag);

    return formatted;
  }
}
