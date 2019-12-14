import 'dart:typed_data';

import 'package:tuple/tuple.dart';

import 'common_js.dart';
import 'notepad_core_js.dart';

class BleType {
  final BluetoothRemoteGATTServer _gatt;

  BleType(this._gatt);

  Future<void> setNotifiable(Tuple2<String, String> serviceCharacteristic) async {
    var characteristic = await _gatt.getCharacteristic(serviceCharacteristic);
    await characteristic.startNotifications().toFuture();
  }

  Future<void> writeValue(Tuple2<String, String> serviceCharacteristic, Uint8List value) async {
    var characteristic = await _gatt.getCharacteristic(serviceCharacteristic);
    await characteristic.writeValue(value).toFuture();
  }
}

extension GattExtension on BluetoothRemoteGATTServer {
  Future<BluetoothRemoteGATTCharacteristic> getCharacteristic(Tuple2<String, String> serviceCharacteristic) async {
    var service = await getPrimaryService(serviceCharacteristic.item1.serviceUuid()).toFuture();
    return await service.getCharacteristic(serviceCharacteristic.item2.characteristicUuid()).toFuture();
  }
}