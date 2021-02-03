class Nachricht {
  final String betreff;
  final DateTime datum;
  final int id;
  final int Sender;
  final String SenderArt;
  final String SenderName;
  final String Uniquid;
  final String WeitereEmpfaenger;
  final String empf;
  final String kuerzel;
  final int private;
  final String username;

  Nachricht(
      this.betreff,
      this.datum,
      this.id,
      this.Sender,
      this.SenderArt,
      this.SenderName,
      this.Uniquid,
      this.WeitereEmpfaenger,
      this.empf,
      this.kuerzel,
      this.private,
      this.username);
}
