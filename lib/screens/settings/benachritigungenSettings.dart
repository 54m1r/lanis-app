import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_ui_toolkit/school_ui_toolkit.dart';

class BenachrichtigungenSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(35, 152, 185, 100),
        title: Row(
          children: [

            Text(
                'Einstellungen'
            ),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 5),
              child: Icon(Icons.settings),
            ),
          ],
        ),
      ),
      body: BenachrichtigungenSettingsBody(),
    );
  }
}

class BenachrichtigungenSettingsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FlatButton(
            child: ListTile(
              title: Text(
                'Dashboard',
                style: TextStyle(fontSize: 20),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
            )),
      ],
    );
  }
}
