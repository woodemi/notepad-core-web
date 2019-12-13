import 'package:flutter/material.dart';

import 'js/NotepadConnector.dart';
import 'js/notepad_core_js.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BluetoothDevice _device;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RaisedButton(
            child: Text('requestDevice'),
            onPressed: () async {
              await notepadConnector.requestDevice();
            },
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RaisedButton(
                child: Text('connect'),
                onPressed: () async {
                  notepadConnector.connect(_device);
                },
              ),
              RaisedButton(
                child: Text('disconnect'),
                onPressed: () async {
                  notepadConnector.disconnect();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}