import 'dart:io';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:schulportal_hessen_app/models/unterricht/anhang.dart';
import 'package:schulportal_hessen_app/models/unterricht/kurs.dart';
import 'package:schulportal_hessen_app/models/vertretung.dart';

import 'package:schulportal_hessen_app/utils/unterricht_parser.dart';
import 'dart:developer' as developer;

import '../main.dart';
import 'login.dart';

class UnterrichtScreen extends StatefulWidget {
  UnterrichtScreen({Key key}) : super(key: key);

  @override
  _UnterrichtScreen createState() => _UnterrichtScreen();
}

class MyItem {
  MyItem({this.isExpanded: false, this.header, this.body});

  bool isExpanded;
  final String header;
  final Widget body;
}

class AnhangSelection extends StatefulWidget {
  AnhangSelection({Key key, Anhang anhang}) {
    this.anhang = anhang;
  }

  Anhang anhang;

  bool checked = false;

  @override
  State<StatefulWidget> createState() => _AnhangSelection(anhang, checked);
}

class _AnhangSelection extends State<AnhangSelection> {
  bool checked;

  _AnhangSelection(this.anhang, this.checked) {}
  Anhang anhang;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text("${anhang.filename} (${anhang.filesize})"),
      value: checked,
      onChanged: (newValue) {
        setState(() {
          if (newValue) {
            _UnterrichtScreen.selected.add(anhang);
          } else {
            _UnterrichtScreen.selected.remove(anhang);
          }
          checked = newValue;
        });
      },
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}

class _UnterrichtScreen extends State<UnterrichtScreen> {
  static List<Anhang> selected = [];

  Future<List<Object>> _getUnterricht() async {
    UnterrichtParser unterrichtParser = new UnterrichtParser(nutzer.headers);
    List<Kurs> kurse = await unterrichtParser.parsen();
    return kurse;
  }

  @override
  Widget build(BuildContext context) {
    return nachrichtenWidget();
  }

  Widget nachrichtenWidget() {
    return FutureBuilder(
        future: _getUnterricht(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(
              child: Center(
                  child: CircularProgressIndicator(
                value: null,
              )),
            );
          } else if (snapshot.data.length == 0) {
            return Container(
              child: Center(
                child: Text("Es gibt aktuell kein Unterricht!"),
              ),
            );
          } else {
            List<Object> objects = snapshot.data;

            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: objects.length,
              itemBuilder: (BuildContext context, int index) {
                Object object = objects[index];
                return _unterrichtContainer(object);
              },
            );
          }
        });
  }

  Widget _unterrichtContainer(Kurs k) {
    List<Widget> lx = [];
    lx.add(Row(
      children: [
        Text(
          k.kursname.split("(")[0],
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    ));

    for (var lehrer in k.lehrer) {
      List<Widget> l = [];
      l.add(Padding(
        child: FaIcon(
          FontAwesomeIcons.userGraduate,
          size: 15,
        ),
        padding: EdgeInsets.only(right: 5),
      ));
      l.add(Text(lehrer.name));
      lx.add(Padding(
        child: Row(children: l),
        padding: EdgeInsets.only(top: 10),
      ));
    }

    lx.add(Padding(
      child: Divider(
        thickness: 2,
        height: 2,
        color: Colors.white10,
      ),
      padding: EdgeInsets.only(top: 5, bottom: 0),
    ));
    if (k.anhaenge.length >= 1) {
      List<Widget> l = [];
      l.add(Padding(
        child: FaIcon(FontAwesomeIcons.paperclip, size: 15),
        padding: EdgeInsets.only(right: 5),
      ));
      l.add(Text(
          "${k.anhaenge.length} ${(k.anhaenge.length > 1 ? "aktuelle Anhänge" : "aktueller Anhang")}",
          style: TextStyle(
              color: Colors.blue, decoration: TextDecoration.underline)));

      List<Widget> select = [];
      var i = 0;
      for (var anhang in k.anhaenge) {
        select.add(AnhangSelection(anhang: anhang));
      }
      lx.add(Padding(
        child: GestureDetector(
            child: Row(children: l),
            onTap: () {
              showDialog<AlertDialog>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Anhänge"),
                      content: Container(
                          width: MediaQuery.of(context).size.width - 5,
                          height: 350,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: select.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(title: select[index]);
                            },
                          )),
                      actions: [
                        TextButton(
                          child: Text("Abbrechen"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton.icon(
                            textColor: Colors.blue,
                            icon: Icon(Icons.download_sharp),
                            label: Text("Herunterladen"),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              var dir = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
                              for (Anhang sel in selected) {
                                await FlutterDownloader.enqueue(
                                  url: sel.url,
                                  headers: nutzer.headers,
                                  fileName: sel.filename,
                                  savedDir: dir,
                                  showNotification: true,
                                  requiresStorageNotLow: true,
                                  openFileFromNotification: true,
                                );
                              }

                              selected.clear();
                            })
                      ],
                    );
                  });
            }),
        padding: EdgeInsets.only(top: 10),
      ));
    }
    if (k.letzteStunde != "") {
      List<Widget> l = [];
      l.add(Padding(
        child: FaIcon(FontAwesomeIcons.calendarCheck, size: 15),
        padding: EdgeInsets.only(right: 5),
      ));
      l.add(Text(
        "${k.letzteStunde}",
        key: Key("Letzte Stunde"),
      ));
      lx.add(Padding(
        child: Row(children: l),
        padding: EdgeInsets.only(top: 10),
      ));
    }

    List<Widget> l = [];
    l.add(Padding(
      child: FaIcon(FontAwesomeIcons.home, size: 15),
      padding: EdgeInsets.only(right: 5),
    ));
    l.add(Text(
      "${(k.hausaufgabe ? (k.hausaufgabe_erledigt ? "Erledigt" : "Nicht erledigt") : "keine")}",
      key: Key("Hausaufgaben"),
      style: TextStyle(
          color: (k.hausaufgabe
              ? (k.hausaufgabe_erledigt ? Colors.green : Colors.red)
              : Colors.white),
          fontWeight: FontWeight.bold),
    ));
    lx.add(Padding(
      child: Row(children: l),
      padding: EdgeInsets.only(top: 10),
    ));

    return Container(
      width: 180,
      margin: EdgeInsets.only(top: 5, bottom: 5),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Color(0xff30475e), borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: lx,
      ),
    );
  }
}
