import 'dart:async';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:js/js.dart';
import 'package:tuple/tuple.dart';

import 'common_js.dart';
import 'notepad_core_js.dart';

const _tag = 'BleType';

class BleType {
  final BluetoothRemoteGATTServer _gatt;

  BleType(this._gatt);

  Future<void> setNotifiable(Tuple2<String, String> serviceCharacteristic) async {
    print('$_tag:setNotifiable');
    var characteristic = await _gatt.getCharacteristic(serviceCharacteristic);
    await characteristic.startNotifications().toFuture();
    characteristic.addEventListener('characteristicvaluechanged', allowInterop(_onCharacteristicValueChange));
  }

  // FIXME Close
  final _characteristicValueController = StreamController<Tuple2<String, Uint8List>>.broadcast();
  Stream<Tuple2<String, Uint8List>> get inputValueStream => _characteristicValueController.stream;

  Future<void> writeValue(Tuple2<String, String> serviceCharacteristic, Uint8List value) async {
    var characteristic = await _gatt.getCharacteristic(serviceCharacteristic);
    await characteristic.writeValue(value).toFuture();
  }

  void _onCharacteristicValueChange(event) {
    BluetoothRemoteGATTCharacteristic characteristic = getProperty(event, 'target');
    var bytes = characteristic.value.buffer.asUint8List();
    print('_onCharacteristicValueChange ${characteristic.uuid} ${hex.encode(bytes)}');
    _characteristicValueController.add(Tuple2(characteristic.uuid.toString(), bytes));
  }
}

extension GattExtension on BluetoothRemoteGATTServer {
  Future<BluetoothRemoteGATTCharacteristic> getCharacteristic(Tuple2<String, String> serviceCharacteristic) async {
    var service = await getPrimaryService(serviceCharacteristic.item1.serviceUuid()).toFuture();
    return await service.getCharacteristic(serviceCharacteristic.item2.characteristicUuid()).toFuture();
  }
}