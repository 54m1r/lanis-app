enum Tag { montag, dienstag, mittwoch, donnerstag, freitag }

extension Tage on Tag {
  String get name {
    switch (this) {
      case Tag.montag:
        return "Montag";
        break;
      case Tag.dienstag:
        return "Dienstag";
        break;
      case Tag.mittwoch:
        return "Mittwoch";
        break;
      case Tag.donnerstag:
        return "Donnerstag";
        break;
      case Tag.freitag:
        return "Freitag";
        break;
      default:
        return "Kein Tag";
        break;
    }
  }
}
