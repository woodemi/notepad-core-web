import 'package:flutter/material.dart';

import 'js/NotepadConnector.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Center(
        child: RaisedButton(
          child: Text('requestDevice'),
          onPressed: () async {
            var device = await notepadConnector.requestDevice();
            print('device ${device.id}, ${device.name}');
          },
        ),
      ),
    );
  }
}
