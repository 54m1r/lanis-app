import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_ui_toolkit/school_ui_toolkit.dart';

class AussehenSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: AussehenSettingsBody(),
    );
  }
}

class AussehenSettingsBody extends StatelessWidget {
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
