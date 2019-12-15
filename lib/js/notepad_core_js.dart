@JS()
library notepad_core;

import 'dart:typed_data';

import 'package:js/js.dart';

import 'common_js.dart';

@JS('navigator.bluetooth')
class Bluetooth {
  external static Promise<BluetoothDevice> requestDevice(ScanOptions options);
}

@JS()
@anonymous
class ScanOptions {
  external set optionalServices(List<dynamic> list);

  external bool get acceptAllDevices;

  external set acceptAllDevices(bool v);

  external factory ScanOptions({
    List<dynamic> optionalServices,
    bool acceptAllDevices,
  });
}

@JS('BluetoothUUID')
class BluetoothUUID {
  external static dynamic getService(String name);

  external static dynamic getCharacteristic(String name);
}

extension String2UUID on String {
  dynamic serviceUuid() => BluetoothUUID.getService(this);

  dynamic characteristicUuid() => BluetoothUUID.getCharacteristic(this);
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

  external Promise<BluetoothRemoteGATTService> getPrimaryService(
      dynamic bluetoothUuid);
}

@JS()
class BluetoothRemoteGATTService {
  external Promise<BluetoothRemoteGATTCharacteristic> getCharacteristic(
      dynamic bluetoothUuid);
}

@JS()
class BluetoothRemoteGATTCharacteristic {
  external dynamic get uuid;

  external ByteData get value;

  external Promise<dynamic> startNotifications();

  external void addEventListener(String type, listener(dynamic event), [bool useCapture]);

  external Promise<dynamic> writeValue(Uint8List bytes);
}