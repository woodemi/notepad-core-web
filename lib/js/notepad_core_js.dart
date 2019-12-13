@JS()
library notepad_core;

import 'package:js/js.dart';

import 'common_js.dart';

@JS('navigator.bluetooth')
class Bluetooth {
  external static Promise<BluetoothDevice> requestDevice(ScanOptions options);
}

@JS()
@anonymous
class ScanOptions {
  external bool get acceptAllDevices;

  external set acceptAllDevices(bool v);

  external factory ScanOptions({
    bool acceptAllDevices,
  });
}

@JS()
class BluetoothDevice {
  external String get id;

  external String get name;

  external BluetoothRemoteGATTServer get gatt;
}

@JS()
class BluetoothRemoteGATTServer {
  external Promise<dynamic> connect();

  external void disconnect();
}
