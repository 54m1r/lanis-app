enum Anwesenheit {
  anwesend,
  fehlend,
  entschuldigt,
  verspaetet,
  tlw_fehlend_dann_anwesend,
  tlw_entschuldigt_dann_anwesend,
  beurlaubt,
  andere_schulische_veranstaltung,
  unbekannt,
  anwesenheitspflicht_ausgesetzt,
  online_anwesend
}

extension Anwesenheit_ on Anwesenheit {

  Anwesenheit parse(String s) {
    if (s.contains("tlw. entschuldigt, dann anwesend")) {
      return Anwesenheit.tlw_entschuldigt_dann_anwesend;
    } else if (s.contains("tlw. fehlend, dann anwesend")) {
      return Anwesenheit.tlw_fehlend_dann_anwesend;
    } else if (s.contains("online anwesend")) {
      return Anwesenheit.online_anwesend;
    } else if (s.contains("Anwesenheitspflicht ausgesetzt")) {
      return Anwesenheit.anwesenheitspflicht_ausgesetzt;
    } else if (s.contains("anwesend")) {
      return Anwesenheit.anwesend;
    } else if (s.contains("fehlend")) {
      return Anwesenheit.fehlend;
    } else if (s.contains("entschuldigt")) {
      return Anwesenheit.entschuldigt;
    } else if (s.contains("verspätet")) {
      return Anwesenheit.verspaetet;
    } else if (s.contains("beurlaubt")) {
      return Anwesenheit.beurlaubt;
    } else if (s.contains("andere schulische Veranstaltung")) {
      return Anwesenheit.andere_schulische_veranstaltung;
    } else {
      return Anwesenheit.unbekannt;
    }
  }
}
