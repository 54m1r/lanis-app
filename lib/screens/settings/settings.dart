import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'aussehenSettings.dart';
import '../../../../vertretungsplan_app/lib/screens/settings/benachritigungenSettings.dart';
import '../../../../vertretungsplan_app/lib/screens/settings/chatSettings.dart';
import '../../../../vertretungsplan_app/lib/screens/settings/dashboardSettings.dart';
import '../../../../vertretungsplan_app/lib/screens/settings/datenschutzSettings.dart';
import '../../../../vertretungsplan_app/lib/screens/settings/impressum.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(35, 152, 185, 100),
        title: Row(
          children: [
            Text('Einstellungen'),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Icon(Icons.settings),
            ),
          ],
        ),
      ),
      body: SettingsBody(),
    );
  }
}

class SettingsBody extends StatelessWidget {
  void dashboard() {

  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FlatButton(
            onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardSettings()));},
            child: ListTile(
              title: Text(
                'Dashboard',
                style: TextStyle(fontSize: 20),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
            )),
        FlatButton(
            onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => AussehenSettings()));},
            child: ListTile(
              title: Text(
            'Aussehen',
            style: TextStyle(fontSize: 20),
          ),
              trailing: Icon(Icons.arrow_forward_ios),
        )),
        FlatButton(
            onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => BenachrichtigungenSettings()));},
            child: ListTile(
              title: Text(
            'Benachrichtigungen',
            style: TextStyle(fontSize: 20),
          ),
              trailing: Icon(Icons.arrow_forward_ios),
        )),
        FlatButton(
            onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => DatenschutzSettings()));},
            child: ListTile(
              title: Text(
            'Datenschutz',
            style: TextStyle(fontSize: 20),
          ),
              trailing: Icon(Icons.arrow_forward_ios),
        )),
        FlatButton(
            onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => ChatSettings()));},
            child: ListTile(
              title: Text(
            'Chat',
            style: TextStyle(fontSize: 20),
          ),
              trailing: Icon(Icons.arrow_forward_ios),
        )),
        FlatButton(
            onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => Impressum()));},
            child: ListTile(
              title: Text(
                'Impressum',
                style: TextStyle(fontSize: 20),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
            )),
      ],
    );
  }
}
