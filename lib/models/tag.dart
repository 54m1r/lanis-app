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

  String translation(String day) {
    switch (day) {
      case "Monday":
        return Tag.montag.name;
        break;
      case "Tuesday":
        return Tag.dienstag.name;
        break;
      case "Wednesday":
        return Tag.mittwoch.name;
        break;
      case "Thursday":
        return Tag.donnerstag.name;
        break;
      case "Friday":
        return Tag.freitag.name;
        break;
      default:
        return Tag.montag.name;
        break;
    }
  }

  String replaceTranslation(String s) {
    return s
        .replaceAll("Monday", "Montag")
        .replaceAll("Tuesday", "Dienstag")
        .replaceAll("Wednesday", "Mittwoch")
        .replaceAll("Thursday","Donnerstag")
        .replaceAll("Friday", "Freitag");
  }
}
