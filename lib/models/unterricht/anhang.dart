class Anhang{
  final String id;
  final String entry;
  final String filename;

  String url;
/*
* Hausaufgaben erledigt:
*    $.post('meinunterricht.php', {a: 'sus_homeworkDone', id: "<id vom Unterricht>, entry: "<id vom Eintrag>", b: "<done|undone>"}):
* */

  Anhang(this.id, this.entry, this.filename){
    String fn =  Uri.encodeComponent(filename);
    url = "https://start.schulportal.hessen.de/meinunterricht.php?a=downloadFile&id=${id}&e=${entry}&f=${fn}";
  }
}